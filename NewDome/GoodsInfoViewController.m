//
//  GoodsInfoViewController.m
//  NewDome
//
//  Created by Anson on 15/6/12.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import "GoodsInfoViewController.h"
#import "MyDomeProductModel.h" // 这里和我的都美公用同一个model
#import "MyDomeTableViewCell.h"
#import "UMSocialSnsService.h"
#import "UMSocialWechatHandler.h"
#import "UMSocial.h"
#import "WXApi.h"
#import "ProductViewController.h"
@interface GoodsInfoViewController ()<UITableViewDataSource,UITableViewDelegate,MyDomeTableViewCellDelegate,UMSocialUIDelegate>
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UITableView *myDomeTableView;

@end
#define kCellIdentifier @"ProductCell"

@implementation GoodsInfoViewController{
    
    
    UserInfoModel * _userInfo;
    NSString * _valueid;
    NSInteger  _page;
    NSString * _sort;
    NSString * _sequence;
    NSMutableArray * _productModelArray;
    NSMutableArray * _selectedModelArray;
}



#pragma mark ----   Life Cycle
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
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
    _valueid = @"";
    _sort = @"price";
    
    //
    
    [self.myDomeTableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    
    
    [self getData];
}


#pragma mark ---- HTTP Methods

- (void)getData
{
    
    
    
    NSDictionary * postDict = @{@"uid":@"",
                                @"pagesize":@24,
                                @"categoryid":self.categoryId,
                                @"isshow":@1,
                                @"sort":_sort,
                                @"sequence":@"asc",
                                @"pageindex":@(_page),
                                @"valueids":@"",
                                @"uisshow":@2
                                };
    NSString * postJSON = [postDict jsonStringWithPrettyPrint:YES];
    NSString * link = [[NSString stringWithFormat:Getbycategoryandvalueid,postJSON] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    

    
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在获取数据";
    
    @weakify(self);
    [HTTPRequestManager getURL:link andParameter:nil onCompletion:^(id responseObject, NSError *error) {
        @strongify(self);
        NSArray * response = [responseObject copy];
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


#pragma mark UITableView Delegate

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


#pragma mark  ---UMSocial

- (void)TouchCopyForTag:(long)tag
{
    MyDomeProductModel * model = _productModelArray[tag];
    NSString * link = [NSString stringWithFormat:@"http://weixin.dome123.com/AllBeauty/ProudtDetail.html?productID=%@&id=%@",model.productId,_userInfo.userID];
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    pasteboard.string = link;
    
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
        
    }else{
        UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"你的设备尚未安装微信" message:@"暂时无法使用分享功能" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往下载", nil];
        av.tag = 999;
        [av show];
    }
    
    
}
#pragma mark ---- Private Methods
- (IBAction)beginOnSale:(id)sender {
    
    
    
    if (_selectedModelArray.count == 0){
        
        [UIAlertView bk_alertViewWithTitle:@"请至少选择一件商品"];
        return;
        
    }else{
        
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"正在上架商品";
        NSMutableString * selectedProductString = [NSMutableString stringWithString:@""];
        NSMutableArray * selectedIndexPathes = [NSMutableArray array];
        for (MyDomeProductModel * model in _selectedModelArray){
            [selectedProductString appendFormat:@"%@,",model.productId];
            [selectedIndexPathes addObject:model.indexPath];
        }
        
        //删除最后一个逗号
        NSString * deletedProductString = [selectedProductString substringToIndex:(selectedProductString.length -1)];
        
        
        NSDictionary * postDict = @{@"uid":_userInfo.userID,
                                    @"pidlist":deletedProductString,
                                    @"isshow":@1};
        NSString * jsonData = [postDict jsonStringWithPrettyPrint:YES];
        NSString * link = [[NSString stringWithFormat:OnOffSaleAPI,jsonData] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        @weakify(self);
        [HTTPRequestManager getURL:link andParameter:nil onCompletion:^(id responseObject, NSError *error) {
            @strongify(self)
            if (responseObject[@"status"]){
                
                UIAlertView * alertView = [[UIAlertView alloc]init];
                alertView.message = @"上架成功";
                [alertView addButtonWithTitle:@"确定"];
                [alertView show];
                
                
            }
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            
        }];
        
        
    }

    
    
}


-(void)TouchDownForTag:(long)tag{
    
    
    MyDomeProductModel * model = _productModelArray[tag];
    
    model.isSelected = !model.isSelected;
    
    [_selectedModelArray containsObject:model] ? [_selectedModelArray removeObject:model] : [_selectedModelArray addObject: model];
    
    
    _selectedModelArray.count == 0 ? [self.confirmButton setTitle:@"上架" forState:UIControlStateNormal] : [self.confirmButton setTitle:[NSString stringWithFormat:@"上架(%lu)",_selectedModelArray.count] forState:UIControlStateNormal];
    
    [self.myDomeTableView reloadData];
}






-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
        
        UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"分享成功" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [av show];
        
        //Because November is luck month
    }
}


-(void)footerRefresh{
    _page++;
    [self getData];
    
}




@end
