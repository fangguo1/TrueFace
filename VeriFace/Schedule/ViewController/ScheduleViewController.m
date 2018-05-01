//
//  ScheduleViewController.m
//  VeriFace
//
//  Created by chenshaoqiu on 2018/4/18.
//  Copyright © 2018年 lazy_boy. All rights reserved.
//

#import "ScheduleViewController.h"
#import "MPSkewedCell.h"
#import "MPSkewedParallaxLayout.h"
#import "WHC_ModelSqlite.h"
#import "DailyModel.h"
#import "DailyViewController.h"
#import "YoungSphere.h"
#import "Masonry.h"
#import "AlbumCollectionViewCell.h"

//static NSString* const kCellId = @"cellId";
#define HEX_TABLE_LINE                 0xe8e9eb //分割线的颜色
#define  DEVICE_WIDTH   [[UIScreen mainScreen] bounds].size.width
#define  DEVICE_HEIGHT  [[UIScreen mainScreen] bounds].size.height
#define RGB(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]
#define GRAY_SEPARATOR_COLOR     UIColorFromRGB(HEX_TABLE_LINE)

static CGFloat const spaceDistance = 10;

static NSString * const identifier = @"AlbumCollectionViewCellIdentifier";
static NSString * const headerViewIdentifier = @"headerViewIdentifier";

@interface ScheduleViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>


@property (nonatomic, strong) UICollectionView *collectionView;

//@property (nonatomic, strong) UICollectionView *collectionView;
//@property (nonatomic, strong) NSArray *dateArray;
@property (nonatomic, strong) NSArray *dailyModelArray;
//@property (nonatomic, strong) NSArray *dataArray;

//@property (weak, nonatomic) IBOutlet YoungSphere *sphereView;
//
//@property (nonatomic, strong) UIButton *imageButton;


@end

@implementation ScheduleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"History";
     [self initUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self initData];
}

- (void)initData
{
    _dailyModelArray = [WHCSqlite query:[DailyModel class] order:@"by dailyId desc"];
    [_collectionView reloadData];
}


- (void)initUI
{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
     _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT- 44) collectionViewLayout:layout];
        
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
    // 注册cell
    [self.collectionView registerClass:[AlbumCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    // 注册头视图
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerViewIdentifier];
    
}

#pragma mark UICollectionViewDataSource & UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _dailyModelArray.count;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.collectionView.frame.size.width, 45);
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerViewIdentifier forIndexPath:indexPath];
        [self loadHeaderView:header indexSection:indexPath.section];
        return header;
    }
    return [UICollectionReusableView alloc];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AlbumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[AlbumCollectionViewCell alloc] init];
    }
    DailyModel *model = [_dailyModelArray objectAtIndex:indexPath.section];
    [cell setImageUrl:model.imageData];
    return cell;
}

// 设置每一个item的尺寸
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((DEVICE_WIDTH - spaceDistance * 5) / 4, (DEVICE_WIDTH - spaceDistance * 5) / 4);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    DailyModel *model = _dailyModelArray[indexPath.section];
    UIStoryboard *stroyBoard = [UIStoryboard storyboardWithName:@"Album" bundle:nil];
    DailyViewController *viewController = (DailyViewController *)[stroyBoard instantiateViewControllerWithIdentifier:@"DailyViewController"];
    viewController.model = model;
    self.tabBarController.tabBar.hidden = YES;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];

}

#pragma mark - headView
-(void)loadHeaderView:(UICollectionReusableView *)header indexSection:(NSUInteger)indexSection{
    
    // 移除所有子试图重绘
    [header.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    DailyModel *model = [_dailyModelArray objectAtIndex:indexSection];
    
    UILabel *numLabel = [[UILabel alloc] init];
    numLabel.text = [NSString stringWithFormat:@"%@",model.date];
    numLabel.textColor = RGB(133, 133, 133);
    numLabel.font = [UIFont systemFontOfSize:12.0f];
    [header addSubview:numLabel];
    
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header.mas_top).offset(15);
        make.left.equalTo(header.mas_left).offset(10);
        make.right.mas_equalTo(@0);
    }];
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = [UIColor colorWithRed:232/255.0f green:233/255.0f blue:235/255.0f alpha:1.0f];
    [header addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(header);
        make.top.mas_equalTo(44.5);
        make.height.mas_equalTo(0.5f);
    }];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.hidesBottomBarWhenPushed = NO;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
