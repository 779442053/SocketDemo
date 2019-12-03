//
//  HomeListCollectionViewController.m
//  Kuaizhu2
//
//  Created by step_zhang on 2019/11/29.
//  Copyright © 2019 step_zhang. All rights reserved.
//

#import "HomeListCollectionViewController.h"
#import "VideoModel.h"
#import "ZWMainVideosCell.h"
#import "VideosAdCell.h"
#import "Advertisements.h"
#import "WaterfallLayout.h"
#import "MovieDetailModel.h"
#import "ZWMoviseDetailsVC.h"
#import "ZWHomeViewModel.h"
#import "NLSliderSwitchProtocol.h"
@interface HomeListCollectionViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,WaterfallLayoutDelegate,MoviesDetailsVCDelegate,NLSliderSwitchProtocol>{
    NSString *_strLayouType;
}
@property(nonatomic, strong) WaterfallLayout *wlayout;
@property(nonatomic, strong) NSMutableArray *totalArray;
@property(nonatomic,strong)ZWHomeViewModel *ViewModel;
@end

@implementation HomeListCollectionViewController

static NSString * const newsCellIdentifier = @"ZWMainVideosCell";
static NSString * const newsAdCellIdentifier = @"VideosAdCell";
- (instancetype)initWithType:(NSString *)strType{
    _strLayouType = strType;
    if(self = [super initWithCollectionViewLayout:self.wlayout]){
        [self registerClass];
        if (@available(iOS 11.0, *)) {
            self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return self;
}
-(void)viewDidScrollToVisiableArea{
    NSLog(@"当前滑动到了‘%@’页面",self.title);
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor clearColor];
    [self.collectionView.mj_header beginRefreshing];
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [[self.ViewModel.RequestCommand execute:_strLayouType] subscribeNext:^(id  _Nullable x) {
            if ([x[@"code"] intValue] == 0) {
                [self.totalArray removeAllObjects];
                self.totalArray = x[@"res"];
                [self.collectionView reloadData];
            }
        }completed:^{
            [self.collectionView.mj_header endRefreshing];
        }];
    }];
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [[self.ViewModel.RequestMoreCommand execute:_strLayouType] subscribeNext:^(id  _Nullable x) {
            if ([x[@"code"] intValue] == 0) {
                NSArray *arr = x[@"res"];
                [self.totalArray addObjectsFromArray:arr];
                [self.collectionView reloadData];
            }
        }completed:^{
            [self.collectionView.mj_footer endRefreshing];
        }];
    }];
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cover;
    if (self.totalArray && [self.totalArray count] > indexPath.row) {
        id cellData;
        Videos *videoModel;
        Advertisements *adModel;
        //MARK:广告
        cellData = [_totalArray objectAtIndex:indexPath.row];
        if ([cellData isKindOfClass:[Advertisements class]]){
            adModel = (Advertisements *)cellData;
            VideosAdCell *adCell = [collectionView dequeueReusableCellWithReuseIdentifier:newsAdCellIdentifier forIndexPath:indexPath];
            cover = adModel.cover;
            
            adCell.labTitle.text = adModel.title;
            return adCell;
        }
        //MARK:内容
        else{
            ZWMainVideosCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:newsCellIdentifier forIndexPath:indexPath];
            videoModel = (Videos *)cellData;
            cell.DesLb.text = videoModel.title;
            cover = videoModel.cover;
            cover = [cover stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
            
            
            cell.NameLB.text = videoModel.userName;
            cell.heardLB.text = [NSString stringWithFormat:@"%lD",(long)videoModel.heartCount];
            return cell;
        }
    }
    return nil;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (self.totalArray && [self.totalArray count] > 0) {
        return [self.totalArray count];
    }
    return 0;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0, 0);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(0, 0);
}
-(void)registerClass{
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZWMainVideosCell" bundle:nil] forCellWithReuseIdentifier:newsCellIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:@"VideosAdCell" bundle:nil] forCellWithReuseIdentifier:newsAdCellIdentifier];
}
-(WaterfallLayout *)wlayout{
    if (!_wlayout) {
        _wlayout = [WaterfallLayout waterFallLayoutWithColumnCount:2];
        [_wlayout setColumnSpacing:cell_margin
                        rowSpacing:cell_margin
                      sectionInset:UIEdgeInsetsMake(0, cell_margin, cell_margin, cell_margin)];
        _wlayout.delegate = self;
    }
    return _wlayout;
}
- (CGFloat)waterfallLayout:(WaterfallLayout *)waterfallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath{
    id cellData;
    CGFloat _h = 165;
    CGFloat _w = (KScreenWidth - 3 * cell_margin) * 0.5;//宽度不变
    if (self.totalArray && [self.totalArray count] > indexPath.row) {
        Videos *videoModel;
        Advertisements *adModel;
        cellData = [_totalArray objectAtIndex:indexPath.row];
        if ([cellData isKindOfClass:[Advertisements class]]){
            adModel = (Advertisements *)cellData;
            _w = adModel.width;
            _h = adModel.height;
        }
        else{
            videoModel = (Videos *)cellData;
            _w = videoModel.ItemWidth;
            _h = videoModel.ItemHeight;
        }
    }
    return _h ;
}
-(void)moviesDetailsHeartUpdateActionForValue:(NSInteger)_cvalue AndIndexPath:(NSIndexPath *)_indexPath{
    if (self.totalArray && [self.totalArray count] > _indexPath.row) {
        Videos *videoModel = (Videos *)self.totalArray[_indexPath.row];
        videoModel.heartCount = _cvalue;
        [self.collectionView reloadItemsAtIndexPaths:@[_indexPath]];
    }
}
-(ZWHomeViewModel *)ViewModel{
    if (_ViewModel == nil) {
        _ViewModel = [[ZWHomeViewModel alloc]init];
    }
    return _ViewModel;
}
-(NSMutableArray *)totalArray{
    if (_totalArray == nil) {
        _totalArray = [[NSMutableArray alloc]init];
    }
    return _totalArray;
}
@end
