//
//  RushOrdersViewController.m
//  Dome
//
//  Created by BTW on 14/12/23.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "RushOrdersViewController.h"
#import "RushOrdersTableViewCell.h"

#import "RushOrderInfoViewController.h"
#import "RushOrderModel.h"
#import "OrderInfoViewController.h"
#import "OrderDetailModel.h"
@interface RushOrdersViewController ()
<
    UITableViewDataSource,
    UITableViewDelegate,
    RushOrdersDelegate

>
{
    MBProgressHUD * HUD;
    UserInfoModel * _userInfo;
    int intTag;
    
    //刷新
    
    int page;

    
    int totalCount;
    NSOperationQueue *queue;
}

@property(nonatomic)int times;
@property(nonatomic,weak)NSTimer * timer;

@property (weak, nonatomic) IBOutlet UITableView *MyTableView;

@property (nonatomic,strong)NSMutableArray * myData;
@end

@implementation RushOrdersViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.title = @"抢单广场";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    
    self.navigationItem.backBarButtonItem = backItem;
    
    
    
    
}
//#pragma mark - 刷新的代理方法---进入下拉刷新\上拉加载更多都有可能调用这个方法
//- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
//{
//    
//    if (refreshView == _footer) { // 上拉加载更多
//        
//        
//        
//        
//        page++;
//        
//        [self performSelector:@selector(GetOrderListData) withObject:nil afterDelay:0.5];
//        
//    }else{
//        page = 1;
////        self.myData = [NSMutableArray array];
//        [self performSelector:@selector(GetOrderListData) withObject:nil afterDelay:0.5];
//    }
//}
//- (void)endRefreshing:(NSNumber *)value
//{
//    // 结束刷新状态
//    [_footer endRefreshing];
//    if ([value boolValue]) {
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//    }
//}


- (void)GetOrderListData
{

    NSNumber * number = [NSNumber numberWithInt:page];
    NSNumber * pagesize = [NSNumber numberWithInt:10];
    NSMutableDictionary * data = [[NSMutableDictionary alloc]initWithObjects:@[number,pagesize] forKeys:@[@"page",@"pagesize"]];
    NSString * jsonData = [data jsonStringWithPrettyPrint:YES];
    NSLog(@"jsonData:%@",jsonData);
    NSString * link =[[NSString stringWithFormat:GetOrderList,jsonData] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"正在获取数据";
    [HTTPRequestManager getURL:link andParameter:nil onCompletion:^(id responseObject, NSError *error) {
        
        NSMutableDictionary * response = [responseObject copy];
        [self GetOrderListData:response];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        });
        
    }];

}
- (void)GetOrderListData:(NSMutableDictionary*)dict
{
    NSString * text = [dict objectForKey:@"text"];
    NSString * status = [dict objectForKey:@"status"];
    int isStatus = [status intValue];
    if (isStatus == 0)
    {
        [self showAlertViewForTitle:text AndMessage:nil];
    }else{
        NSMutableArray * array = [NSMutableArray array];
        NSMutableArray * data = [dict objectForKey:@"data"];
        
        
        
        for (NSMutableDictionary * dataDict in data)
        {
            RushOrderModel * model = [[RushOrderModel alloc]init];
            model.orderId = [dataDict objectForKey:@"id"];
            model.date = [dataDict objectForKey:@"date"];
            [array addObject:model];
        }
        
        if(page == 1)
        {
            self.myData = [NSMutableArray array];
        }
        
        if(array.count!=0)
        {
            for (RushOrderModel * model  in array)
            {
                [self.myData addObject:model];
            }
        }
        
//        
//        
//        [_header endRefreshing];
//        [_footer endRefreshing];
//        [Tools showPromptToView:self.view atPoint:self.view.center withText:@"加载完毕" duration:0.7];
    
        
        self.MyTableView.delegate = self;
        self.MyTableView.dataSource = self;
        [self.MyTableView registerNib:[UINib nibWithNibName:@"RushOrdersTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
        [self.MyTableView reloadData];
    
//        if (self.myData.count == 0)
//        {
//
//            UIAlertView * av =[[UIAlertView alloc]initWithTitle:@"暂时没有相关订单" message:nil delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
////            av.tag = 777;
//            [av show];
//        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 777)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.myData = [NSMutableArray array];
    page = 1;
    [self GetOrderListData];

    // Do any additional setup after loading the view.
    self.MyTableView.delegate = self;
    self.MyTableView.dataSource = self;
    
    [self.MyTableView registerNib:[UINib nibWithNibName:@"RushOrdersTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    [self.MyTableView reloadData];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.myData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell" ;
    
    RushOrderModel * model = [self.myData objectAtIndex:indexPath.row];
    
    RushOrdersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.OrdersTitle.text = [NSString stringWithFormat:@"订单号:%@",model.orderId];
    cell.OrdersInfo.text = [NSString stringWithFormat:@"最后下单时间:%@",model.date];
//    cell.OrdersIntegral.text = [NSString stringWithFormat:@"我的美分:00%ld分",(long)indexPath.row];
    cell.OrdersIntegral.text = @"";
    cell.selectionStyle =UITableViewCellAccessoryNone;
    cell.delegate = self;
    cell.tag = indexPath.row;
    cell.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.layer.shadowOffset = CGSizeMake(1, 1);
    cell.layer.shadowOpacity = 0.2;
    return cell;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}
-(void)TouchButtonForTag:(long int)tag
{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"正在抢单.请稍等";
    self.times = 30;
    intTag = tag;
    self.timer =[NSTimer scheduledTimerWithTimeInterval:0.1
                                                 target:self
                                               selector:@selector(animate:)
                                               userInfo:nil
                                                repeats:YES];
}
-(void)animate:(id)sender
{
    self.times --;

    if (self.times==0)
     {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        _userInfo = [UserInfoModel shareUserInfo];
        RushOrderModel * model = [self.myData objectAtIndex:intTag];
        NSLog(@"model:%@",model.orderId);
        NSMutableDictionary * data = [[NSMutableDictionary alloc]initWithObjects:@[_userInfo.shopid,model.orderId] forKeys:@[@"shopid",@"orderid"]];
        
        NSString * jsonData = [data jsonStringWithPrettyPrint:YES];
        NSLog(@"jasonData:%@",jsonData);
        NSString * link = [[NSString stringWithFormat:SetOrderList,jsonData] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
         HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
         HUD.labelText = @"正在获取数据";
         [HTTPRequestManager getURL:link andParameter:nil onCompletion:^(id responseObject, NSError *error) {
             
             NSMutableDictionary * response = [responseObject copy];
             [self SetOrderData:response];
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 
             });
             
         }];
     }
}

-(void)SetOrderData:(NSMutableDictionary*)dict
{
    NSString * text = [dict objectForKey:@"text"];
    NSString * status = [dict objectForKey:@"status"];
    NSLog(@"text:%@  status:%@",text,status);
    
    [self showAlertViewForTitle:text AndMessage:nil];
    page = 1;
    self.myData = [NSMutableArray array];
    [self GetOrderListData];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
- (void)UpGetOrderDetailData:(NSMutableDictionary*)detailData
{
    NSString * status =[detailData objectForKey:@"status"];
    int statusInt = [status intValue];
    if (statusInt == false)
    {
        NSString * text = [detailData objectForKey:@"text"];
        [self showAlertViewForTitle:text AndMessage:nil];
    }else{
        
        OrderDetailModel * model = [OrderDetailModel alloc];
        
        NSMutableArray * array = [detailData objectForKey:@"data"];
        NSMutableDictionary * dict = array[0];
        
        model.suborderid = [dict objectForKey:@"suborderid"];
        model.productid = [dict objectForKey:@"productid"];
        model.count = [dict objectForKey:@"count"];
        model.price = [dict objectForKey:@"price"];
        model.picture = [dict objectForKey:@"picture"];
        model.status = [dict objectForKey:@"status"];
        model.name = [dict objectForKey:@"name"];
        model.createtime = [dict objectForKey:@"createtime"];
        
        
        NSMutableDictionary * addressDic = [dict objectForKey:@"address"];
        model.linkname = [addressDic objectForKey:@"linkname"];
        model.phone = [addressDic objectForKey:@"phone"];
        model.zipcode = [addressDic objectForKey:@"zipcode"];
        model.addresstext = [addressDic objectForKey:@"addresstext"];
        
        
        model.allattr = [NSMutableArray array];
        NSArray * attributes = [dict objectForKey:@"attribute"];
        NSArray * allattrs = [dict objectForKey:@"allattr"];
        
        for (NSDictionary * attributesDict in attributes)
        {
            NSString * paid = [attributesDict objectForKey:@"paid"];
            
            for (NSDictionary * allattrsDict in allattrs)
            {
                NSString * idStr = [allattrsDict objectForKey:@"id"];
                if ([idStr isEqualToString:paid])
                {
                    NSString * value = [allattrsDict objectForKey:@"value"];
                    [model.allattr addObject:value];
                }
            }
        }
        
        for (NSString * str in model.allattr)
        {
            NSLog(@"%@",str);
        }
        
        OrderInfoViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderInfoViewController"];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ShowAlertView
-(void)showAlertViewForTitle:(NSString*)title AndMessage:(NSString*)message
{
    UIAlertView * av = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    [av show];
}



@end
