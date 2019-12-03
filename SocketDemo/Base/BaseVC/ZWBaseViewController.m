//
//  ZWBaseViewController.m
//  Kuaizhu2
//
//  Created by step_zhang on 2019/11/28.
//  Copyright © 2019 step_zhang. All rights reserved.
//

#import "ZWBaseViewController.h"
#import "UIColor+ZWColor.h"
#import "UIFont+ZWFont.h"
@interface ZWBaseViewController ()
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
@property (nonatomic, assign) BOOL changeStatusBarAnimated;
@end

@implementation ZWBaseViewController
+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    ZWBaseViewController*viewController = [super allocWithZone:zone];
    ZWWWeakSelf(viewController)
    [[viewController rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
        ZWWStrongSelf(viewController);
        [viewController zw_addSubviews];
        [viewController zw_bindViewModel];
    }];
    [[viewController rac_signalForSelector:@selector(viewWillAppear:)] subscribeNext:^(id x) {
        ZWWStrongSelf(viewController);
        [viewController zw_layoutNavigation];
        [viewController zw_getNewData];
    }];
    return viewController;
}
- (instancetype)initWithViewModel:(id<ZWBaseViewModelProtocol>)viewModel {
    self = [super init];
    if (self) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F7F8F7"];//统一主题颜色
    self.statusBarStyle = UIStatusBarStyleLightContent;
    //适配iOS11
    if (@available(ios 11.0,*)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        UITableView.appearance.estimatedRowHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
    }else{
        if([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)])
        {
            self.automaticallyAdjustsScrollViewInsets=NO;
        }
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            //通过设置此属性，你可以指定view的边（上、下、左、右）延伸到整个屏幕。
        }
    }
    [self setNavView];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}
- (BOOL)prefersHomeIndicatorAutoHidden {
    return self.isHidenHomeLine;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //键盘消失===在界面即将消失的时候,让键盘下去
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.statusBarStyle) {
        return self.statusBarStyle;
    } else {
        return UIStatusBarStyleDefault;
    }
}
- (BOOL)prefersStatusBarHidden {
    return self.statusBarHidden;
}
- (void)changeStatusBarStyle:(UIStatusBarStyle)statusBarStyle
             statusBarHidden:(BOOL)statusBarHidden
     changeStatusBarAnimated:(BOOL)animated {
    self.statusBarStyle=statusBarStyle;
    self.statusBarHidden=statusBarHidden;
    if (animated) {
        [UIView animateWithDuration:0.25 animations:^{
            [self setNeedsStatusBarAppearanceUpdate];
        }];
    }
    else{
        [self setNeedsStatusBarAppearanceUpdate];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self zw_removeNavgationBarLine];
}
/**
 *  去除nav 上的line
 */
- (void)zw_removeNavgationBarLine {
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        NSArray *list=self.navigationController.navigationBar.subviews;
        for (id obj in list) {
            if ([obj isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView=(UIImageView *)obj;
                imageView.hidden=YES;
            }
        }
    }
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
}
#pragma mark - 屏幕旋转
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {

    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {

    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {

    return UIInterfaceOrientationPortrait;
}
/**
 *  添加控件
 */
- (void)zw_addSubviews {}

/**
 *  绑定
 */
- (void)zw_bindViewModel {}

/**
 *  设置navation
 */
- (void)zw_layoutNavigation {}

/**
 *  初次获取数据
 */
- (void)zw_getNewData {}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //ZWWLog(@"%@--释放了",NSStringFromClass([self class]));
}
- (void)viewDidLayoutSubviews
{
    [self.view bringSubviewToFront:_navigationView];//始终放在最上层
}
- (void)setNavView
{
    _navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, ZWStatusAndNavHeight)];
    _navigationView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_navigationView];
    _navigationBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, ZWStatusAndNavHeight)];
    _navigationBgView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [_navigationView addSubview:_navigationBgView];
}
- (void)setTitle:(NSString *)title
{
    [_navigationView addSubview:self.titleLabel];
    _titleLabel.text = title;
}
- (UILabel *)titleLabel
{
    if (!_titleLabel) {

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_navigationView.mj_w/2 - 100, _navigationView.mj_h - 30, 200, 20)];
        _titleLabel.font = [UIFont zwwNormalFont:16];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#1E2327"];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }

    return _titleLabel;
}
- (void)showLeftBackButton
{
    _leftButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _leftButton.frame = CGRectMake(15, ZWStatusBarHeight + 5, 45, 35);
    [_leftButton setImage:[UIImage imageNamed:@"back_black"] forState:(UIControlStateNormal)];
    [_leftButton addTarget:self action:@selector(backAction) forControlEvents:(UIControlEventTouchUpInside)];
    [_navigationView addSubview:_leftButton];
}

- (void)backAction
{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
