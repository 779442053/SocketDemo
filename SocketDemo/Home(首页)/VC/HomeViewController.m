//
//  HomeViewController.m
//  Kuaizhu2
//
//  Created by step_zhang on 2019/11/28.
//  Copyright © 2019 step_zhang. All rights reserved.
//

#import "HomeViewController.h"
#import "NLSliderSwitch.h"
#import "HomeListCollectionViewController.h"
#import "AnnouncementsModel.h"
#import "ZWHomeViewModel.h"
#import "AnnouncementsView.h"
#import "CustomIOS7AlertView.h"
#import <WebKit/WebKit.h>
@interface HomeViewController ()<UIScrollViewDelegate,AnnouncementsViewDelegate,NLSliderSwitchDelegate>
//滚动页面，左右滑动切换页面
@property (nonatomic, strong) UIScrollView * backScrollV;
//滑条
@property (nonatomic, strong) NLSliderSwitch *sliderSwitch;
@property(nonatomic,strong)ZWHomeViewModel *ViewModel;
@property(nonatomic,strong)WKWebView *wkwebView;
@property(nonatomic,strong) WKUserContentController * userContentController;
//公告数据
@property(nonatomic,  copy) NSArray<AnnouncementsModel *> *arrNotice;
//公告视图
@property(nonatomic,strong) AnnouncementsView *noticeView;
@property(nonatomic,strong) CustomIOS7AlertView *alertView;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
-(void)zw_bindViewModel{
    NSString *Url = [[NSUserDefaults standardUserDefaults] objectForKey:@"html"];
    //ZWWLog(@"tongjiapiAPI = %@",Url)

    WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc]init];//先实例化配置类 以前UIWebView的属性有的放到了这里
    _userContentController =[[WKUserContentController alloc]init];
    configuration.userContentController = _userContentController;
    configuration.preferences.javaScriptEnabled = NO;//打开js交互
    _wkwebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) configuration:configuration];
    [self.view addSubview:_wkwebView];
    _wkwebView.backgroundColor = [UIColor clearColor];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:Url]];
    [_wkwebView loadRequest:request];
    [[NSNotificationCenter defaultCenter] addObserver:self
    selector:@selector(showNoticeView)
        name:K_APP_BOX_SHOW_NOTICE object:nil];
    //获取版本 和 公告
    [[self.ViewModel.RequestVersionCommand execute:nil] subscribeNext:^(id  _Nullable x) {
        if ([x[@"code"] intValue] == 0) {
            NSString *version = x[@"version"];
            NSString *Currentversion = x[@"Currentversion"];
            NSString *app_build = x[@"app_build"];
            NSString *info = x[@"info"];
            if ([app_build floatValue] < [version floatValue]){
                NSString *strInfo = [NSString stringWithFormat:@"当前版本：%@，最新版本：%@,请点击更新",Currentversion,info];
                NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:strInfo];
                                           NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
                                           paragraph.alignment = NSTextAlignmentLeft;
                                           [alertControllerMessageStr setAttributes:@{NSParagraphStyleAttributeName:paragraph} range:NSMakeRange(0, alertControllerMessageStr.length)];
                 UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"发现新版本" message:@""
                                                            preferredStyle:UIAlertControllerStyleAlert];
                                            [alert setValue:alertControllerMessageStr forKey:@"attributedMessage"];
                                            UIAlertAction *download = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                NSString *str = x[@"url"];
                                                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:str]]) {
                                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:^(BOOL success) {
                                                        if (!success) {
                                                            [YJProgressHUD showError:@"URL 无效"];
                                                        }
                                                    }];
                                                }
                                            }];
                                            //强制更新，没有取消按钮
                                            UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                                            [alert addAction:download];
                                            [alert addAction:cancle];
                                            [self presentViewController:alert animated:YES completion:nil];
            }
                                   
        }
    }];
    [[self.ViewModel.RequestNoticeCommand execute:nil] subscribeNext:^(id  _Nullable x) {
        if ([x[@"code"] intValue] == 0) {
            self.arrNotice = x[@"res"];
        }
    }];
    
}
-(void)zw_addSubviews{
    NSArray *titarr = @[@"关注", @"最热", @"最新"];
    self.backScrollV = [[UIScrollView alloc]initWithFrame:CGRectMake(0, ZWStatusAndNavHeight, KScreenWidth,KScreenHeight - ZWStatusAndNavHeight)];
    self.backScrollV.pagingEnabled = YES;
    self.backScrollV.delegate = (id)self;
    self.backScrollV.showsVerticalScrollIndicator = NO;
    self.backScrollV.showsHorizontalScrollIndicator = NO;
    self.backScrollV.bounces = NO;
    self.backScrollV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backScrollV];
    self.backScrollV.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 3, 1);//禁止竖向滚动
    NSMutableArray *viewARR = [[NSMutableArray alloc] init];
    for (int i = 0; i< titarr.count; i++) {
        NSString *type = titarr[i];
        HomeListCollectionViewController *viewVC = [[HomeListCollectionViewController alloc]initWithType:type];
        [viewARR addObject:viewVC];
        [viewVC.view setFrame:CGRectMake(i*KScreenWidth, 0, KScreenWidth, self.backScrollV.frame.size.height)];
        viewVC.delegateVC = self;
        [viewVC.collectionView.mj_header beginRefreshing];
        [self.backScrollV addSubview:viewVC.view];
        [self addChildViewController:viewVC];
    }
    self.sliderSwitch = [[NLSliderSwitch alloc]initWithFrame:CGRectMake((KScreenWidth - 159)/2, ZWStatusBarHeight, 159, ZWStatusAndNavHeight - ZWStatusBarHeight) buttonSize:CGSizeMake(53, 30)];
    self.sliderSwitch.titleArray = titarr;
    self.sliderSwitch.normalTitleColor = [UIColor colorWithHexString:@"#666666"];
    self.sliderSwitch.selectedTitleColor = [UIColor colorWithHexString:@"#000000"];
    self.sliderSwitch.selectedButtonColor = [UIColor colorWithHexString:@"#FF1493"];
    self.sliderSwitch.titleFont = [UIFont systemFontOfSize:15];
    self.sliderSwitch.backgroundColor = [UIColor clearColor];
    self.sliderSwitch.delegate = (id)self;
    self.sliderSwitch.viewControllers = viewARR;
    [self.navigationView addSubview:self.sliderSwitch];
   
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.backScrollV) {
        float xx = scrollView.contentOffset.x;
        int rate = round(xx/KScreenWidth);
        if (rate != self.sliderSwitch.selectedIndex) {
            [self.sliderSwitch slideToIndex:rate];
//            HomeListCollectionViewController *vc =  self.childViewControllers[rate];
//            [vc.collectionView.mj_header beginRefreshing];
        }
    }
}
-(void)sliderSwitch:(NLSliderSwitch *)sliderSwitch didSelectedIndex:(NSInteger)selectedIndex{
    [self.backScrollV scrollRectToVisible:CGRectMake(selectedIndex*KScreenWidth,0, KScreenWidth, 1) animated:YES];
}
-(ZWHomeViewModel *)ViewModel{
    if (_ViewModel == nil) {
        _ViewModel = [[ZWHomeViewModel alloc]init];
    }
    return _ViewModel;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
    name:K_APP_BOX_SHOW_NOTICE object:nil];
}
-(AnnouncementsView *)noticeView{
    if (!_noticeView) {
        _noticeView = [[AnnouncementsView alloc] init];
        _noticeView.delegate = self;
    }
    return _noticeView;
}

-(CustomIOS7AlertView *)alertView{
    if (!_alertView) {
        _alertView = [[CustomIOS7AlertView alloc] init];
        [_alertView setButtonTitles:nil];
        [_alertView setUseMotionEffects:YES];
    }
    return _alertView;
}
-(void)showNoticeView{
    if (self.arrNotice && [self.arrNotice count] > 0) {
        [self showNoticeViewIndex:0 withButtonString:@"下一个"];
        [self.alertView setContainerView:self.noticeView];
        [self.alertView show];
    }
}
-(void)showNoticeViewIndex:(NSInteger)index withButtonString:(NSString *)strbtn{
    
    if (!self.arrNotice || [self.arrNotice count] <= index) {
        ZWWLog(@"数据不存在，或索引越界");
        return;
    }
    
    AnnouncementsModel *model;
    id tmp = self.arrNotice[index];
    if ([tmp isKindOfClass:[AnnouncementsModel class]]) {
        model = tmp;
    }
    else{
        model = [AnnouncementsModel mj_objectWithKeyValues:tmp];
    }
    
    CGRect rect = self.noticeView.frame;
    //计算高度
    CGFloat h = [Utils getHeightForString:model.content andFontSize:self.noticeView.labContent.font andWidth:self.noticeView.labContent.frame.size.width];
    rect.size = CGSizeMake(KScreenWidth - 80, h + [AnnouncementsView minViewHeight]);
    self.noticeView.frame = rect;
    [self.noticeView initUpdateView:model
                      AndButtonInfo:strbtn
                           AndIndex:index
                        WithOffsetH:h];
}
-(void)announcementsViewDelegateNextIndex:(NSInteger)index{
    if (self.arrNotice) {
        if ([self.arrNotice count] > index + 1) {
            [self showNoticeViewIndex:index+1
                     withButtonString:([self.arrNotice count] - 1 > index + 1)?@"下一个":@"关闭"];
            
            [self.alertView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self.alertView show];
        }
        else{
             [self.alertView close];
        }
    }
}
-(void)announcementsViewDelegateClose{
    [self.alertView close];
}
@end
