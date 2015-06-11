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
@interface MyDomeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myDomeTableView;

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
    
    //初始化请求参数
    _page = 1;
    _valueid = _categoryid = @"";
    _sort = @"price";
    
    //
    
    
    
    
    [self getData];
    
}

#pragma mark ---- Private Methods




-(void)getData{
    
    NSString * uid = _userInfo.userID;
    NSString * link = [[NSString stringWithFormat:Getbycategoryandvalueid,_valueid,_categoryid,_page,_sort,_sequence,uid,@1] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    MBProgressHUD * hud =[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载商品中...";
    @weakify(self);
    [HTTPRequestManager getURL:link andParameter:nil onCompletion:^(id responseObject, NSError *error) {
        @strongify(self);

        NSMutableArray * response = [responseObject copy];
        for (NSInteger i=0;i < response.count;i++){
            
            MyDomeProductModel * model = [DMBaseModel initWithArray:response];
            [_productModelArray addObject:model];
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myDomeTableView reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
        
    }];
    
    
}




#pragma mark -----UITableView Delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyDomeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    return _productModelArray.count;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
