//
//  LoginViewController.m
//  NewDome
//
//  Created by Anson on 15/6/10.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import "LoginViewController.h"
#import "NSDictionary+JsonString.h"
#import "UserInfoModel.h"
#import "HomeViewController.h"
#import "UpGradeViewController.h"
#import <SSKeychain.h>
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;

@end

#define DomePasswordService @"DomePasswordService"
@implementation LoginViewController{
    
    UserInfoModel * _userInfo;
    
}



#pragma mark ---- Life Cycle 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    BOOL firstLogin = [USER_DEFAULT boolForKey:@"firstLogin"];
    
    if (!firstLogin){
        [USER_DEFAULT setBool:YES forKey:@"firstLogin"];
    }
    
    NSString * phone = [USER_DEFAULT objectForKey:@"phone"];
    NSString * password = [SSKeychain passwordForService:DomePasswordService account:phone];
    if (phone && password){
    
        self.userNameTextfield.text = phone;
        self.passwordTextfield.text = password;
    }
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initNavigationBar];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}


#pragma mark  ---- Private Methods

-(void)initNavigationBar
{

    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    
    backItem.title = @"";

    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
    
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1];
        self.navigationController.navigationBar.translucent = NO;
    }
    else
    {
        
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1];
    }

    [self.navigationController setNavigationBarHidden:YES animated:YES];

}

- (IBAction)beginLogin:(id)sender {
    
    
    NSDictionary * postDict = @{@"phone":self.userNameTextfield.text,
                                @"password":self.passwordTextfield.text
                                };
    
    NSString * jsonString = [postDict jsonStringWithPrettyPrint:YES];
    
    NSString * link = [[NSString stringWithFormat:Login,jsonString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在登陆...";
    
    @weakify(self);
    
    [HTTPRequestManager getURL:link andParameter:nil onCompletion:^(id responseObject, NSError *error) {
        
        @strongify(self);
        NSDictionary * dict = responseObject;
        [self updateData:dict];
        
    }];
}


-(void)updateData:(NSDictionary *)dict{
    
    [USER_DEFAULT setObject:self.userNameTextfield.text forKey:@"phone"];
   // [USER_DEFAULT setObject:self.passwordTextfield.text forKey:@"password"];
    [SSKeychain setPassword:self.passwordTextfield.text forService:DomePasswordService account:self.userNameTextfield.text];
    
    
    _userInfo = [UserInfoModel shareUserInfo];
    _userInfo.userID = dict[@"id"];
    _userInfo.shopid = dict[@"shopid"];
    _userInfo.phone = self.userNameTextfield.text;
    
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    NSString * usertype = [dict objectForKey:@"usertype"];
    if ([usertype isEqualToString:@"4"])
    {

        UINavigationController * homeViewNav = [[UIStoryboard storyboardWithName:@"HomeView" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"HomeViewNavigationController"];
        [self.navigationController presentViewController:homeViewNav animated:YES completion:nil];
        
        
        
    }else if ([usertype isEqualToString:@"5"])
    {
        //买家
        UpGradeViewController * vc = [self.storyboard instantiateViewControllerWithIdentifier:@"UpGradeViewController"];
        vc.shopid  = _userInfo.shopid;
        [self.navigationController pushViewController:vc animated:YES];
    }
    

    
}



- (IBAction)goRegistrate:(id)sender {
    
    
}


@end
