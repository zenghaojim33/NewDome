//
//  LoginViewController.m
//  NewDome
//
//  Created by Anson on 15/6/10.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController


#pragma mark ---- Life Cycle 

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}


#pragma mark  ---- Private Methods



@end
