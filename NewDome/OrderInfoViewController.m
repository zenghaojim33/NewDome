//
//  OrderInfoViewController.m
//  Dome
//
//  Created by BTW on 14/12/24.
//  Copyright (c) 2014年 jenk. All rights reserved.
//

#import "OrderInfoViewController.h"
#import "SDWebImage/SDWebImageManager.h"
#import "SHLUILabel.h"
#import "UIImageView+FadeInEffect.h"
#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH self.view.feame.size.wicth
#define CELL_CONTENT_MARGIN 10.0f

@interface OrderInfoViewController ()


@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;
@property (weak, nonatomic) IBOutlet UIView *BGView1;
@property (weak, nonatomic) IBOutlet UIView *BGView2;
@property (weak, nonatomic) IBOutlet UIView *BGView3;
@property (weak, nonatomic) IBOutlet UILabel *suborderid;
@property (weak, nonatomic) IBOutlet UILabel *createtime;
@property (weak, nonatomic) IBOutlet UILabel *status;

@property (weak, nonatomic) IBOutlet UILabel *linkname;
@property (weak, nonatomic) IBOutlet UIButton *phone;
@property (weak, nonatomic) IBOutlet UILabel *zipcode;
@property (weak, nonatomic) IBOutlet UILabel *addresstext;
@property (strong, nonatomic) IBOutlet UIButton *snBth;

@property (weak, nonatomic) IBOutlet SHLUILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *allattr;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIImageView * imageView;
@end

@implementation OrderInfoViewController


#pragma mark ------Life Cycle

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = @"订单详情";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    
    self.navigationItem.backBarButtonItem = backItem;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.BGView1.layer.shadowColor = [UIColor blackColor].CGColor;
    self.BGView1.layer.shadowOffset = CGSizeMake(1, 1);
    self.BGView1.layer.shadowOpacity = 0.2;
    
    self.BGView2.layer.shadowColor = [UIColor blackColor].CGColor;
    self.BGView2.layer.shadowOffset = CGSizeMake(1, 1);
    self.BGView2.layer.shadowOpacity = 0.2;
    
    self.BGView3.layer.shadowColor = [UIColor blackColor].CGColor;
    self.BGView3.layer.shadowOffset = CGSizeMake(1, 1);
    self.BGView3.layer.shadowOpacity = 0.2;
    // Do any additional setup after loading the view.
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"订单详情";
    
    self.navigationItem.backBarButtonItem = backItem;
    
    
    self.suborderid.text = self.model.suborderid;
    self.createtime.text = self.model.createtime;
    NSLog(@"status:%@",self.model.status);
    int statusInt = [self.model.status intValue];
    if (statusInt==0)
    {
        self.status.text = @"待付款";
    }else if (statusInt==1){
        self.status.text = @"待发货";
    }else if (statusInt==2){
        self.status.text = @"代签收";
    }else if (statusInt==3){
        self.status.text = @"签收中";
    }else if (statusInt==4){
        self.status.text = @"申请退货";
    }else if (statusInt==5){
        self.status.text = @"同意退货";
    }else if (statusInt==6){
        self.status.text = @"不同意退货";
    }else if (statusInt==7){
        self.status.text = @"退货成功";
    }else if (statusInt==8){
        self.status.text = @"已完成";
    }else if (statusInt==9){
        self.status.text = @"退货中";
    }
    self.linkname.text = self.model.linkname;
    [self.phone setTitle:self.model.phone forState:UIControlStateNormal];
    self.zipcode.text = self.model.zipcode;
    self.addresstext.text = self.model.addresstext;
    
    int labelHeight;
    CGRect frame = self.name.frame;

    self.name.text = self.model.name;
    self.name.lineBreakMode = NSLineBreakByWordWrapping;
    self.name.numberOfLines = 0;
    //根据字符串长度和Label显示的宽度计算出contentLab的高
    labelHeight = [self.name getAttributedStringHeightWidthValue:290];
    frame.size.height = labelHeight;
    self.name.frame = frame;
    
    
    
    
    
    NSString * allattr = @"";
    for (NSString * str in self.model.allattr)
    {
        allattr = [NSString stringWithFormat:@"%@ %@",allattr,str];
    }
    self.allattr.text = allattr;
    float price = [self.model.price floatValue];
    self.price.text = [NSString stringWithFormat:@"¥ %.2f x %@",price,self.model.count];
    
    
    
    NSString * path = self.model.picture;
    
    [self.imageView setImageUrlWithFadeInEffect:path];
    
    CGRect BGViewFame = self.BGView3.frame;
    BGViewFame.size.height += labelHeight;
    self.BGView3.frame = BGViewFame;

    [self.myScrollView setContentSize:CGSizeMake(self.view.frame.size.width, 500+labelHeight)];
    
    
    if (self.model.sn.length == 0)
    {
        NSLog(@"没有物流");
        self.snBth.userInteractionEnabled = NO;
    }else{
        NSLog(@"sn:%@",self.model.sn);
        self.snBth.userInteractionEnabled = YES;
        [self.snBth setBackgroundColor:[UIColor colorWithHue:179/255.0 saturation:9/255.0 brightness:9/255.0 alpha:1]];
    }

}
- (IBAction)TouchPhone:(UIButton*)sender {
    
    if (sender.titleLabel.text.length != 0)
    {
        UIAlertView * av = [[UIAlertView alloc]initWithTitle:@"拨打电话" message:sender.titleLabel.text delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        av.tag = 99;
        [av show];
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 99&&buttonIndex ==1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",alertView.message]]];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)TouchSnBth:(id)sender
{
    
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