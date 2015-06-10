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
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;

@end

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
    NSString * password = [USER_DEFAULT objectForKey:@"password"];
    
    self.userNameTextfield.text = phone;
    self.passwordTextfield.text = password;
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
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
    
    NSString * link = [NSString stringWithFormat:Login,jsonString];

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
    
    _userInfo = [UserInfoModel shareUserInfo];
    
    
    
}



- (IBAction)goRegistrate:(id)sender {
    
    
}


@end
