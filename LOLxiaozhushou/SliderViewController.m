//
//  SliderViewController.m
//  左拉菜单升级
//
//  Created by lanou on 15/10/30.
//  Copyright (c) 2015年 lanou. All rights reserved.
//

#import "SliderViewController.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEGIHT [UIScreen mainScreen].bounds.size.height

#define OFFSET_X (SCREEN_WIDTH - 150)
#define FINAL_MAINVIEW_HEGIHT [UIScreen mainScreen].bounds.size.height/667*570
#define OFFSET_Y ((SCREEN_HEGIHT - self.MainLastHegiht) / 2)

@interface SliderViewController () <UIGestureRecognizerDelegate>

// 定义一个根视图控制器
@property (nonatomic, strong) UIViewController *rootVC;

// 记录开始拖拽的位置
@property (nonatomic, assign) CGPoint startPoint;

// 左拖拽手势
@property (nonatomic, strong) UIPanGestureRecognizer *leftPan;

// 右拖拽手势
@property (nonatomic, strong) UIPanGestureRecognizer *rigthPan;

// 是否可以推出左视图
@property (nonatomic, assign) BOOL isShow;

// 点击手势
@property (nonatomic, strong) UITapGestureRecognizer *tap;

@end

@implementation SliderViewController

- (UIImageView *)bgImageView
{
    if (!_bgImageView) {
        self.bgImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
        self.bgImageView.image = [UIImage imageNamed:@"longxia.jpg"];
        self.bgImageView.userInteractionEnabled = YES;
        [self.view addSubview:self.bgImageView];
    }
    return _bgImageView;
}



// 自定义初始化方法, 给一个根视图控制器
- (instancetype)initWithRootVC:(UIViewController *)rootVC
{
    self = [super init];
    if (self) {
        self.rootVC = rootVC;
    }
    return self;
}

// 重写根视图的setting方法
- (void)setRootVC:(UIViewController *)rootVC
{
    if (_rootVC) {
        [_rootVC.view removeFromSuperview];
        _rootVC = nil;
    }
    _rootVC = rootVC;
    UIView *view = rootVC.view;
    view.frame = self.view.frame;
    [self.bgImageView addSubview:view];
    [self.rootVC.view addGestureRecognizer:self.leftPan];
    [self.rootVC.view addGestureRecognizer:self.rigthPan];
    [self.rootVC.view addGestureRecognizer:self.tap];
    self.tap.enabled = NO;
    self.leftPan.enabled = NO;
    self.rigthPan.enabled = YES;
    
}

// 懒加载左拖拽手势
- (UIPanGestureRecognizer *)leftPan
{
    if (!_leftPan) {
        self.leftPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(leftPanAction:)];
        self.leftPan.delegate = self;
    }
    return _leftPan;
}

// 懒加载右拖拽手势
- (UIPanGestureRecognizer *)rigthPan
{
    if (!_rigthPan) {
        self.rigthPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rigthPanAction:)];
        self.rigthPan.delegate = self;
    }
    return _rigthPan;
}


// 懒加载点击手势
- (UITapGestureRecognizer *)tap
{
    if (!_tap) {
        self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapAction:)];
    }
    return _tap;
    
}


// 左拖拽的方法
- (void)leftPanAction:(UIPanGestureRecognizer *)pan
{
    if (self.offsetX == 0 || self.MainLastHegiht == 0) {
        self.offsetX = OFFSET_X;
        self.MainLastHegiht = FINAL_MAINVIEW_HEGIHT;
    }
    UIView *view = pan.view;
    CGPoint point = [pan translationInView:view];
    CGFloat offsetX = point.x;
    if (pan.state == UIGestureRecognizerStateChanged) {
        if (offsetX - self.startPoint.x <= 0) {
            if (self.rootVC.view.frame.origin.x <= 0) {
                self.rootVC.view.frame = self.view.frame;
            }
            else{
                self.rootVC.view.frame = CGRectMake(self.offsetX + offsetX,  OFFSET_Y + OFFSET_Y * (offsetX / self.offsetX), SCREEN_WIDTH, (self.MainLastHegiht - (OFFSET_Y * (offsetX / self.offsetX) * 2)));
                self.LeftVC.view.alpha = 1 + offsetX / self.offsetX;
            }
            if (self.rootVC.view.frame.origin.x >= self.offsetX) {
                self.rootVC.view.frame = CGRectMake(self.offsetX, OFFSET_Y, SCREEN_WIDTH, self.MainLastHegiht);
            }
        }
    }
    if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
        if (offsetX <= ([UIScreen mainScreen].bounds.size.width / 2) * (-1)) {
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                self.rootVC.view.frame = self.view.bounds;
            } completion:^(BOOL finished) {
                self.tap.enabled = NO;
                self.leftPan.enabled = NO;
                self.rigthPan.enabled = YES;
            }];
        }
        else{
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                self.rootVC.view.frame = CGRectMake(self.offsetX, OFFSET_Y, SCREEN_WIDTH, self.MainLastHegiht);
            } completion:^(BOOL finished) {
                self.tap.enabled = YES;
                self.leftPan.enabled = YES;
                self.rigthPan.enabled = NO;
            }];
        }
    }
    
}

// 右拖拽的方法
- (void)rigthPanAction:(UIPanGestureRecognizer *)pan
{
    if (self.offsetX == 0 || self.MainLastHegiht == 0) {
        self.offsetX = OFFSET_X;
        self.MainLastHegiht = FINAL_MAINVIEW_HEGIHT;
    }
    UIView *view = pan.view;
    CGPoint point = [pan translationInView:view];
    CGFloat offsetX = point.x;
    if (pan.state == UIGestureRecognizerStateChanged) {
        //距离边缘多少可以拖拽
        if (offsetX - self.startPoint.x >= -30) {
            self.rootVC.view.frame = CGRectMake(offsetX, offsetX / self.offsetX * ((SCREEN_HEGIHT - self.MainLastHegiht) / 2), SCREEN_WIDTH, SCREEN_HEGIHT - 2 * (offsetX / self.offsetX * ((SCREEN_HEGIHT - self.MainLastHegiht) / 2)));
            self.LeftVC.view.alpha = offsetX / (SCREEN_HEGIHT - self.offsetX);
        }
        else{
            return;
        }
        if (offsetX >= self.offsetX) {
            pan.enabled = NO;
        }
    }
    if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
        //超过屏幕一般判定为右拉成功
        if (offsetX >= SCREEN_WIDTH / 2) {
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                self.rootVC.view.frame = CGRectMake(self.offsetX, (SCREEN_HEGIHT - self.MainLastHegiht) / 2.0, SCREEN_WIDTH, self.MainLastHegiht);
                self.LeftVC.view.alpha = 1;
            } completion:^(BOOL finished) {
                self.tap.enabled = YES;
                self.rigthPan.enabled = NO;
                self.leftPan.enabled = YES;
            }];
        }
        else{
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                self.rootVC.view.frame = self.view.bounds;
            } completion:^(BOOL finished) {
                self.tap.enabled = NO;
                self.rigthPan.enabled = YES;
                self.leftPan.enabled = NO;
            }];
        }
    }
}

// 设置左视图控制器
- (void)setLeftVC:(UIViewController *)LeftVC
{
    if (self.offsetX == 0 || self.MainLastHegiht == 0) {
        self.offsetX = OFFSET_X;
        self.MainLastHegiht = FINAL_MAINVIEW_HEGIHT;
    }
    _LeftVC = LeftVC;
    CGRect rect = CGRectMake(0, SCREEN_HEGIHT - (SCREEN_HEGIHT - self.MainLastHegiht) / 2 - self.MainLastHegiht, self.offsetX, self.MainLastHegiht);
    _LeftVC.view.frame = rect;
    _LeftVC.view.alpha = 0;
    [self.bgImageView insertSubview:_LeftVC.view atIndex:0];
}

// 点击推出左视图按钮方法
- (void)handleLeftButton:(UIBarButtonItem *)button
{
    if (self.offsetX == 0 || self.MainLastHegiht == 0) {
        self.offsetX = OFFSET_X;
        self.MainLastHegiht = FINAL_MAINVIEW_HEGIHT;
    }
    if (self.LeftVC) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            self.rootVC.view.frame = CGRectMake(self.offsetX, (SCREEN_HEGIHT - self.MainLastHegiht) / 2.0, SCREEN_WIDTH, self.MainLastHegiht);
            self.LeftVC.view.alpha = 1;
        } completion:^(BOOL finished) {
            self.tap.enabled = YES;
            self.rigthPan.enabled = NO;
            self.leftPan.enabled = YES;
        }];
    }
}

// 点击手势方法
- (void)handleTapAction:(UITapGestureRecognizer *)tap
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        self.rootVC.view.frame = self.view.frame;
        self.LeftVC.view.alpha = 0;
    } completion:^(BOOL finished) {
        self.rigthPan.enabled = YES;
        self.tap.enabled = NO;
        self.leftPan.enabled = NO;
    }];
}


// 开始拖拽的坐标
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    self.startPoint = [gestureRecognizer locationInView:self.view];
    return YES;
}

// 设置推出左视图控制器按钮的文字的方法
- (void)setPushLeftViewButtonWithString:(NSString *)string
{
//    UIViewController *mainVC = nil;
//    if ([self.rootVC isKindOfClass:[UITabBarController class]]) {
//        UINavigationController *nav = (UINavigationController *)self.rootVC;
//        mainVC = nav.viewControllers.firstObject;
//    }
//    mainVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:string style:UIBarButtonItemStylePlain target:self action:@selector(handleLeftButton:)];
}

// 设置推出左视图控制器按钮的图片
- (void)setPushLeftViewButtonWithImage:(UIImage *)image
{
    UIViewController *mainVC = nil;
    NSArray *mainarr =[NSArray array];
    NSArray *arr =[NSArray array];
    if ([self.rootVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *nav = (UITabBarController *)self.rootVC;
        mainarr = nav.viewControllers;
    }
    for (int i=0; i<mainarr.count; i++) {
        UINavigationController *navv =mainarr[i];
        arr = navv.viewControllers;
        mainVC=arr[0];
        mainVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(handleLeftButton:)];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setPushLeftViewButtonWithImage:[[UIImage imageNamed:@"setting.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
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
