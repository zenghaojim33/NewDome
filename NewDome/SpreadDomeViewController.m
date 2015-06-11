//
//  SpreadDomeViewController.m
//  NewDome
//
//  Created by Anson on 15/6/11.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import "SpreadDomeViewController.h"

@interface SpreadDomeViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *QRCodeSwitch;
@property (weak, nonatomic) IBOutlet UIView *sellerContainerView;
@property (weak, nonatomic) IBOutlet UIView *buyerContainerView;
@end

@implementation SpreadDomeViewController

#pragma mark 弹出列表方法presentSnsIconSheetView需要设置delegate为self
-(BOOL)isDirectShareInIconActionSheet
{
    return YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.title = @"我要推广";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    
    self.navigationItem.backBarButtonItem = backItem;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.sellerContainerView.hidden = NO;
    self.buyerContainerView.hidden = YES;
    
    
    
    
}

- (IBAction)switchContainerView:(id)sender {
    
    
    switch (self.QRCodeSwitch.selectedSegmentIndex) {
        case 0:
            self.buyerContainerView.hidden = YES;
            self.sellerContainerView.hidden = NO;
            break;
        case 1:
            self.buyerContainerView.hidden = NO;
            self.sellerContainerView.hidden = YES;
            break;
        default:
            break;
    }
    
    
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
