//
//  GoodsViewController.m
//  NewDome
//
//  Created by Anson on 15/6/12.
//  Copyright (c) 2015年 Anson Tsang. All rights reserved.
//

#import "GoodsViewController.h"
#import "CategoryModel.h"
#import "CollectionViewCell.h"
#import "GoodsInfoViewController.h"
@interface GoodsViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *subclassTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *productClassCollecionView;

@end
#define kTableViewCellIdentifier @"Cell";
#define kCollectionViewCellIdentifier @"Cell";

@implementation GoodsViewController{
    
    UserInfoModel * _userInfo;
    NSMutableArray * _rootArray;
    NSMutableArray * _subclassArray;
    NSMutableArray * _productClassArray;
    NSString * _categoryId;
    NSInteger indexrow;
    
}
#pragma mark ------Life Cycle

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
    indexrow = 0;
    self.subclassTableView.tableFooterView = self.subclassTableView.tableHeaderView = [[UIView alloc]init];
    [self getCategoryData];
}


#pragma mark  ----- HTTP Methods



-(void)getCategoryData
{
    NSDictionary * postDict = @{@"categoryid":@"root"};
    NSString * jsonData = [postDict jsonStringWithPrettyPrint:YES];
    NSString * link = [[NSString stringWithFormat:GetByName,jsonData] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"正在获取数据";
    [HTTPRequestManager getURL:link andParameter:nil onCompletion:^(id responseObject, NSError *error) {
        
        NSMutableArray * response = [responseObject copy];
        [self GetRootModel:response];

        [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        
    }];
    
    
}

#pragma marl -----   Private Methods

-(void)GetRootModel:(NSMutableArray*)array
{
    _rootArray = [NSMutableArray array];
    _subclassArray = [NSMutableArray array];
    _productClassArray = [NSMutableArray array];
    
    for (NSMutableDictionary * dict in array)
    {
        CategoryModel * model = [[CategoryModel alloc]init];
        model.path = [dict objectForKey:@"path"];
        model.categoryName = [dict objectForKey:@"categoryName"];
        model.categoryId = [dict objectForKey:@"categoryId"];
        [_rootArray addObject:model];
        
        if ([model.path isEqualToString:@"root"])
        {
            
            
            NSString * title = self.title;
            if ([self.title isEqualToString:@"货品上架"])
            {
                title = @"服装";
            }
            
            if ([model.categoryName isEqualToString:title])
            {
                NSLog(@"model.name :%@ model.id :%@",model.categoryName,model.categoryId);
                
                _categoryId = [NSString stringWithFormat:@"root,%@",model.categoryId];
                
            }
            
            
        }
    }
    
    
    for (CategoryModel * model in _rootArray)
    {
        if ([model.path isEqualToString:_categoryId])
        {
            [_subclassArray addObject:model];
        }
        [self.subclassTableView reloadData];
    }
    if (_subclassArray.count != 0)
    {
        CategoryModel * first = [_subclassArray objectAtIndex:0];
        [self GetCollectionForID:first.categoryId];
    }
}
- (void)GetCollectionForID:(NSString*)idstr
{
    NSString * path = [NSString stringWithFormat:@"%@,%@",_categoryId,idstr];
    for (CategoryModel * model in _rootArray)
    {
        if ([model.path isEqualToString:path])
        {
            [_productClassArray addObject:model];
        }
        
        [self.productClassCollecionView reloadData];
    }
}

#pragma mark ---- UITableView Delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _subclassArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    CategoryModel * model =  [_subclassArray objectAtIndex:indexPath.row];
    cell.textLabel.text = model.categoryName;
    cell.selectionStyle = UITableViewCellAccessoryNone;
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row == indexrow)
    {
        cell.textLabel.textColor = [UIColor colorWithRed:199/255.0 green:69/255.0 blue:67/255.0 alpha:1];
    }else{
        cell.textLabel.textColor = [UIColor blackColor];
    }
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    // Configure the cell...
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    indexrow = indexPath.row;
    CategoryModel * model = [_subclassArray objectAtIndex:indexPath.row];
    _productClassArray = [NSMutableArray array];
    [self GetCollectionForID:model.categoryId];
    [self.subclassTableView reloadData];
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

#pragma mark ----UICollectionView


- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _productClassArray.count;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"Cell";
    CollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    CategoryModel * model = [_productClassArray objectAtIndex:indexPath.row];
    [cell updateCellWithModel:model];
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsInfoViewController * vc= [self.storyboard instantiateViewControllerWithIdentifier:@"GoodsInfoViewController"];
    CategoryModel * model = [_productClassArray objectAtIndex:indexPath.row];
    vc.title = model.categoryName;
    vc.categoryId = model.categoryId;
    [self.navigationController pushViewController:vc animated:YES];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.view.bounds.size.width-130)/3, (self.view.bounds.size.width-130)/3+40);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1, 1, 1, 1);
}

#pragma mark ----- Button Events of Banner

- (IBAction)TouchCategory:(UIButton *)sender
{
    NSString * title;
    switch (sender.tag)
    {
        case 0:
            title = @"服装";
            break;
        case 1:
            title = @"美妆";
            break;
        case 2:
            title = @"包袋";
            break;
        case 3:
            title = @"配饰";
            break;
        default:
            title = @"鞋履";
            break;
    }
    self.title = title;
    indexrow = 0;
    [self getCategoryData];
}



@end
