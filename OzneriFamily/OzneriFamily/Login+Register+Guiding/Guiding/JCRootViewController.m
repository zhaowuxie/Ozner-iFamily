//
//  JCRootViewController.m
//  sd
//
//  Created by JC_R on 16/1/11.
//  Copyright © 2016年 JC_R. All rights reserved.
//

#import "JCRootViewController.h"
#import "ModelController.h"

@interface JCRootViewController ()

@property (readonly, strong, nonatomic) ModelController *modelController;

@property (nonatomic,strong) NSArray *guideControllers;

@end

@implementation JCRootViewController

@synthesize modelController = _modelController;

- (instancetype)initWithLastController:(UIViewController *)viewControll{

    if (self = [super init]) {
        NSMutableArray *tempArr = [NSMutableArray array];
        NSArray * guideControllersImages=[[NSArray alloc] initWithObjects:@"new_help_0",@"new_help_1",@"new_help_2", nil];
        for (int i = 0; i<guideControllersImages.count; i++) {
            
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            imageView.image = [UIImage imageNamed:guideControllersImages[i]];
            
            UIViewController *VC = [[UIViewController alloc] init];
            [VC.view addSubview:imageView];
            [tempArr addObject:VC];
        }
        [tempArr addObject:viewControll];
        _guideControllers = [tempArr copy];
    }
    return self;
}

- (void)viewDidLayoutSubviews{

    [super viewDidLayoutSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建pageViewController
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];

    self.pageViewController.delegate = self.modelController;
    self.pageViewController.dataSource = self.modelController;
    
    // 设置pageViewController默认展示第几页
    [self.pageViewController setViewControllers:@[_guideControllers[0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

    // 管理控制器
    [self addChildViewController:self.pageViewController];
    
    // 管理pageViewController的view
    [self.view addSubview:self.pageViewController.view];

    // 如果是iPad，往里缩进
    CGRect pageViewRect = self.view.bounds;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        pageViewRect = CGRectInset(pageViewRect, 40.0, 40.0);
    }
    // 设置这本书的rect
    self.pageViewController.view.frame = pageViewRect;

}
#pragma mark - lazy
- (ModelController *)modelController {
    if (!_modelController) {
        _modelController = [[ModelController alloc] initWithPageViewController:_pageViewController andGuideControllers:_guideControllers];
    }
    return _modelController;
}
@end