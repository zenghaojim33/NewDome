//
//  MyDomeViewController.m
//  NewDome
//
//  Created by Anson on 15/6/11.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import "MyDomeViewController.h"
#import "DMBaseModel.h"
#import "MyDomeTableViewCell.h"
#import "MyDomeProductModel.h"
#import "UMSocialSnsService.h"
#import "UMSocialWechatHandler.h"
#import "UMSocial.h"
#import "WXApi.h"
#import "ProductViewController.h"
@interface MyDomeViewController ()<UITableViewDataSource,UITableViewDelegate,MyDomeTableViewCellDelegate,UMSocialUIDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myDomeTableView;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@end

#define kCellIdentifier @"MyDomeCell"
@implementation MyDomeViewController{
    
    UserInfoModel * _userInfo;
    NSString * _categoryid;
    NSString * _valueid;
    NSInteger  _page;
    NSString * _sort;
    NSString * _sequence;
    NSMutableArray * _productModelArray;
    NSMutableArray * _selectedModelArray;
    
}



#pragma mark ---- Life Cycle

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.title = @"我的店铺";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    
    self.navigationItem.backBarButtonItem = backItem;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _userInfo = [UserInfoModel shareUserInfo];
    _productModelArray = [[NSMutableArray alloc]init];
    _selectedModelArray = [[NSMutableArray alloc]init];
    
    //初始化请求参数
    _page = 1;
    _valueid = _categoryid = @"";
    _sort = @"price";
    
    //
    
    [self.myDomeTableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    
    
    [self getData];
    
}

#pragma mark ---- Private Methods




-(void)getData{
    
    NSString * uid = _userInfo.userID;
    
    NSDictionary * postDict = @{@"uid":[NSString stringWithFormat:@"'%@'",uid],
                                @"pagesize":@24,
                                @"categoryid":_categoryid,
                                @"isshow":@1,
                                @"sort":_sort,
                                @"sequence":@"asc",
                                @"pageindex":@(_page),
                                @"valueids":@"",
                                @"uisshow":@1
                                };
    NSString * postJSON = [postDict jsonStringWithPrettyPrint:YES];
    NSString * link = [[NSString stringWithFormat:Getbycategoryandvalueid,postJSON] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    MBProgressHUD * hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载商品中...";
    
    @weakify(self);
    [HTTPRequestManager getURL:link andParameter:nil onCompletion:^(id responseObject, NSError *error) {
        @strongify(self);

        NSMutableArray * response = [responseObject copy];
        for (NSInteger i=0;i < response.count;i++){
            
            MyDomeProductModel * model = [MyDomeProductModel initWithDict:response[i]];
            
            [_productModelArray addObject:model];
            
        }
        
        [self.myDomeTableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.myDomeTableView.footer endRefreshing];
        if (response.count == 0){
            [self.myDomeTableView.footer noticeNoMoreData];
        }
        
    }];
    
    
}




#pragma mark -----UITableView Delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyDomeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    cell.tag = indexPath.row;
    cell.delegate = self;
    [cell updateCellWithModel:_productModelArray[indexPath.row] withIndexPath:indexPath];
    
    
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    return _productModelArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyDomeProductModel * model = _productModelArray[indexPath.row];
    ProductViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductViewController"];
    
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
    
}



#pragma mark ----UMSocial
-(void)TouchCopyForTag:(long)tag{
    
    
    MyDomeProductModel * model = _productModelArray[tag];
    
    
    NSString * link = [NSString stringWithFormat:CopyProduct,model.productId,_userInfo.userID];
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    pasteboard.string = link;
    
    UIAlertView * alert = [UIAlertView bk_alertViewWithTitle:@"复制成功"];
    [alert show];
    
    
}



-(void)TouchShareForTag:(long)tag{
    
    
    
    BOOL isInstalledWeixin = [WXApi isWXAppInstalled];
    
    if (isInstalledWeixin){
        
        
        MyDomeProductModel * model = _productModelArray[tag];
        
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
        NSString *shareText = model.productName;             //分享内嵌文字
        NSString * path = model.TitleImages[0][@"path"];
        NSString * Link;
        NSString * http = [path substringToIndex:4];
        if ([http isEqualToString:@"http"]) {
            Link = path;
        }else{
            Link = [NSString stringWithFormat:@"http://dome123.com%@",path];
        }
        UIImage * shareImage =  [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:Link];
        
        NSString * link = [NSString stringWithFormat:CopyProduct,model.productId,_userInfo.userID];
        
        [UMSocialData defaultData].extConfig.wechatSessionData.url = link;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = link;
        
        //如果得到分享完成回调，需要设置delegate为self
        [UMSocialSnsService presentSnsIconSheetView:self appKey:@"54a350bffd98c51f0900012d" shareText:shareText shareImage:shareImage shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline] delegate:self];
        
    }
    
    
}



-(void)TouchDownForTag:(long)tag{
    
    
    MyDomeProductModel * model = _productModelArray[tag];
    
    model.isSelected = !model.isSelected;
    
    [_selectedModelArray containsObject:model] ? [_selectedModelArray removeObject:model] : [_selectedModelArray addObject: model];


    _selectedModelArray.count == 0 ? [self.confirmButton setTitle:@"下架" forState:UIControlStateNormal] : [self.confirmButton setTitle:[NSString stringWithFormat:@"下架(%lu)",_selectedModelArray.count] forState:UIControlStateNormal];
    
    [self.myDomeTableView reloadData];
}

#pragma mark 点击店铺复制
- (IBAction)TouchCopyButton:(UIButton*)button
{
    NSString * link = [NSString stringWithFormat:CopyShop,_userInfo.shopid];
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    pasteboard.string = link;
    
    UIAlertView * alert = [UIAlertView bk_alertViewWithTitle:@"复制成功"];
    [alert addButtonWithTitle:@"确认"];
    [alert show];
}

- (IBAction)TouchShareButton:(UIButton*)button
{
    //微信网页类型
    
    BOOL isInstalledWeixin = [WXApi isWXAppInstalled];
    
    if (isInstalledWeixin){
        
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
        NSString *shareText = @"我的都美";             //分享内嵌文字
        UIImage *shareImage =[UIImage imageNamed:@"dome123.png"];  //分享内嵌图片
        
        
        NSString * link = [NSString stringWithFormat:CopyShop,_userInfo.shopid];
        NSLog(@"link:%@",link);
        [UMSocialData defaultData].extConfig.wechatSessionData.url = link;
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = link;
        
        //如果得到分享完成回调，需要设置delegate为self
        [UMSocialSnsService presentSnsIconSheetView:self appKey:@"54a350bffd98c51f0900012d" shareText:shareText shareImage:shareImage shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline] delegate:self];
        
    }else{
        UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"你的设备尚未安装微信" message:@"暂时无法使用分享功能" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往下载", nil];
        av.tag = 999;
        [av show];
    }
}


- (IBAction)beginOffsale:(id)sender {
    
    if (_selectedModelArray.count == 0){
        
        [UIAlertView bk_alertViewWithTitle:@"请至少选择一件商品"];
        return;
        
    }else{
        
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"正在下架商品";
        NSMutableString * selectedProductString = [NSMutableString stringWithString:@""];
        NSMutableArray * selectedIndexPathes = [NSMutableArray array];
        for (MyDomeProductModel * model in _selectedModelArray){
            [selectedProductString appendFormat:@"%@,",model.productId];
            [selectedIndexPathes addObject:model.indexPath];
        }
        
        //删除最后一个逗号
        NSString * deletedProductString = [selectedProductString substringToIndex:(selectedProductString.length -1)];
        
        //不知道为嘛要给uid加单引号
        
        NSDictionary * postDict = @{@"uid":_userInfo.userID,
                                    @"pidlist":deletedProductString,
                                    @"isshow":@0};
        NSString * jsonData = [postDict jsonStringWithPrettyPrint:YES];
        NSString * link = [[NSString stringWithFormat:OnOffSaleAPI,jsonData] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        @weakify(self);
        [HTTPRequestManager getURL:link andParameter:nil onCompletion:^(id responseObject, NSError *error) {
            @strongify(self)
            if (responseObject[@"status"]){
                
                UIAlertView * alertView = [[UIAlertView alloc]init];
                alertView.message = @"下架成功";
                [alertView addButtonWithTitle:@"确定"];
                [alertView show];
                
                
            }
            //批量删除操作需要记录所有选中的cell的indexPath
            NSMutableIndexSet * indexPathNumbers = [[NSMutableIndexSet alloc]init];
            
            for (NSIndexPath * indexPath in selectedIndexPathes)
            {
                [indexPathNumbers addIndex:indexPath.row];
            }
            [_productModelArray removeObjectsAtIndexes:indexPathNumbers];
            [self.myDomeTableView beginUpdates];
            [self.myDomeTableView deleteRowsAtIndexPaths:selectedIndexPathes withRowAnimation:UITableViewRowAnimationFade];
            [self.myDomeTableView endUpdates];
            [_selectedModelArray removeAllObjects];
            [self.myDomeTableView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];

            
        }];
        
        
    }
    

    
}
#pragma mark ---- MJRefresh
-(void)footerRefresh{
    _page ++;
    [self getData];
}

@end
