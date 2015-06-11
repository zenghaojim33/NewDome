//
//  SettingViewController.m
//  NewDome
//
//  Created by Anson on 15/6/11.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController


#pragma mark ----- Life Cycle 
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.title = @"设置";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    
    self.navigationItem.backBarButtonItem = backItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    
    
}



- (IBAction)beginLogout:(id)sender {
    
    UIActionSheet * logoutSheet = [UIActionSheet bk_actionSheetWithTitle:@"确认退出登陆"];
    
    @weakify(self);
    [logoutSheet bk_addButtonWithTitle:@"登出" handler:^{
        @strongify(self);
        [self dismissViewControllerAnimated:YES completion:nil];

    }];
    
    [logoutSheet bk_setCancelButtonWithTitle:@"取消" handler:nil];
    [logoutSheet showInView:self.view];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
