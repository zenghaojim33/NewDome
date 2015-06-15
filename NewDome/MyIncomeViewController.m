//
//  MyIncomeViewController.m
//  NewDome
//
//  Created by Anson on 15/6/13.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import "MyIncomeViewController.h"
#import "MyIncomeModel.h"
#import "UICountingLabel.h"
#import "ChangeInfoViewController.h"
@interface MyIncomeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myIncomeTableView;
@property (weak, nonatomic) IBOutlet UICountingLabel *incomeOfOwnLabel;
@property (weak, nonatomic) IBOutlet UICountingLabel *incomeOfFirstLevelLabel;
@property (weak, nonatomic) IBOutlet UICountingLabel *incomeOfSecondLevelLabel;
@property (weak, nonatomic) IBOutlet UICountingLabel *incomeOfTotalLabel;


@end
#define kCellidentifier @"Cell"
@implementation MyIncomeViewController{
    
    UserInfoModel * _userInfo;
    MyIncomeModel * _incomeModel;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.title = @"我的财富";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    
    self.navigationItem.backBarButtonItem = backItem;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _userInfo = [UserInfoModel shareUserInfo];

    self.myIncomeTableView.tableFooterView = [[UIView alloc]init];
    
    
    [self getData];
    
    
}

#pragma mark ----HTTP Methods

-(void)getData
{
    NSString * userID = _userInfo.userID;
    userID = @"dome88888888";
    
    NSDictionary * postDict = @{@"uid":userID};
    
    NSString * jsonData = [postDict jsonStringWithPrettyPrint:YES];
    NSString * link = [[NSString stringWithFormat:GetIncome,jsonData] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在获取数据";
    [HTTPRequestManager getURL:link andParameter:nil onCompletion:^(id responseObject, NSError *error) {
        

        _incomeModel = [MyIncomeModel initWithDict:responseObject];
        
        [self updateIncomeData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
        
    }];
    
    
    
}


#pragma mark ---- Private Method

-(void)updateIncomeData
{
    NSNumber * incomeOfOwn = _incomeModel.incomeArray[0];
    NSNumber * incomeOfFirstLevel = _incomeModel.incomeArray[1];
    NSNumber * incomeOfSecondLevel = _incomeModel.incomeArray[2];
   // NSNumber * incomeOfTotal = _incomeModel.incomeArray[3];
    
    
    // self.Price1.text = [NSString stringWithFormat:@"¥%.2f",price1];
    self.incomeOfOwnLabel.format = @"￥%.2f";
    self.incomeOfOwnLabel.method = UILabelCountingMethodEaseOut;
    [self.incomeOfOwnLabel countFrom:0.0 to:incomeOfOwn.floatValue withDuration:1.5];
    
    self.incomeOfFirstLevelLabel.format = @"￥%.2f";
    self.incomeOfFirstLevelLabel.method = UILabelCountingMethodEaseOut;
    [self.incomeOfFirstLevelLabel countFrom:0.0 to:incomeOfFirstLevel.floatValue withDuration:1.5];
    
    self.incomeOfSecondLevelLabel.format = @"￥%.2f";
    self.incomeOfSecondLevelLabel.method = UILabelCountingMethodEaseOut;
    [self.incomeOfSecondLevelLabel countFrom:0.0 to:incomeOfSecondLevel.floatValue withDuration:1.5];
    
    self.incomeOfTotalLabel.format = @"￥%.2f";
    self.incomeOfTotalLabel.method = UILabelCountingMethodEaseOut;
    [self.incomeOfTotalLabel countFrom:0.0 to:incomeOfOwn.floatValue + incomeOfFirstLevel.floatValue + incomeOfSecondLevel.floatValue withDuration:1.5];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---- UITableView Delegate


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:kCellidentifier];
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"pushToWithDraw"]){
        
        
    }
    
    
    
}
- (IBAction)enterMyAccount:(id)sender {
    
    ChangeInfoViewController * vc =[[UIStoryboard storyboardWithName:@"Setting&QRCode" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ChangeInfoViewController"];
    [self.navigationController pushViewController:vc animated:YES];
    
    
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
