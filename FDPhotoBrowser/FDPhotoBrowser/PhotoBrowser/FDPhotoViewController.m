//
//  FDPhotoViewController.m
//  FDPhotoBroswer
//
//  Created by fergusding on 15/7/10.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//

#import "FDPhotoViewController.h"

#import <AssetsLibrary/AssetsLibrary.h>

@interface FDPhotoViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
//@property (strong, nonatomic) UIScrollView *scrollView;

@property (assign, nonatomic) BOOL isFullScreenShowing;
@property (strong, nonatomic) UIImageView *leftImageView;
@property (strong, nonatomic) UIImageView *centerImageView;
@property (strong, nonatomic) UIImageView *rightImageView;

@end

@implementation FDPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initScrollView];
    [self initImageViews];
    [self setCurrentImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (void)initView {
    self.isFullScreenShowing = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"选择" style:UIBarButtonItemStylePlain target:self action:@selector(selected:)];
    
    [self setNavigationTitle];
}

// 初始化scrollView的一些属性。遇到一问题，本来想在storyboard里面做适配，结果加了约束后scrollView可以上下滑动，不知原因。另外不设置navigationBar的translucent属性为NO也会出现此问题。
- (void)initScrollView {
    self.scrollView.frame = self.view.bounds;
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame) * 3, CGRectGetHeight(self.scrollView.frame));
    self.scrollView.delegate = self;
    
    [self setScrollViewOffset];
}

// 设置navigationBar的title，显示当前显示图片和总数
- (void)setNavigationTitle {
    self.navigationItem.title = [NSString stringWithFormat:@"%ld/%lu", (long)self.currentIndex + 1, (unsigned long)[self.photos count]];
}

// 根据当前要显示的图片设置scrollView的contentOffset，第一张就不能向左滑动，最后一张不能向右滑动
- (void)setScrollViewOffset {
    if (self.currentIndex == 0) {
        self.scrollView.contentOffset = CGPointMake(0, 0);
    } else if (self.currentIndex == [self.photos count] - 1) {
        self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame) * 2, 0);
    } else {
        self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame), 0);
    }
}

// 为了内存优化，使用三个imageview进行滑动
- (void)initImageViews {
    self.leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame))];
    self.leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.scrollView addSubview:self.leftImageView];
    
    self.centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.scrollView.frame), 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame))];
    self.centerImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.scrollView addSubview:self.centerImageView];
    
    self.rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.scrollView.frame) * 2, 0, CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame))];
    self.rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.scrollView addSubview:self.rightImageView];
}

// 根据当前要显示的图片设置相应imageView的image值
- (void)setCurrentImage {
    if (self.currentIndex == 0) {
        self.leftImageView.image = [self imageAtIndex:self.currentIndex];
        self.centerImageView.image = [self imageAtIndex:self.currentIndex + 1];
        self.rightImageView.image = [self imageAtIndex:self.currentIndex + 2];
    } else if (self.currentIndex == [self.photos count] - 1) {
        self.leftImageView.image = [self imageAtIndex:self.currentIndex - 2];
        self.centerImageView.image = [self imageAtIndex:self.currentIndex - 1];
        self.rightImageView.image = [self imageAtIndex:self.currentIndex];
    } else {
        self.leftImageView.image = [self imageAtIndex:self.currentIndex - 1];
        self.centerImageView.image = [self imageAtIndex:self.currentIndex];
        self.rightImageView.image = [self imageAtIndex:self.currentIndex + 1];
    }
}

// 滑动减速后执行重新加载图片
- (void)reloadImages {
    CGPoint offset = self.scrollView.contentOffset;
    
    if (self.currentIndex == 0) {
        if (offset.x > 0) {
            self.currentIndex += 1;
        } else {
            return;
        }
    } else if (self.currentIndex == [self.photos count] - 1) {
        if (offset.x < CGRectGetWidth(self.scrollView.frame) * 2) {
            self.currentIndex -= 1;
        } else {
            return;
        }
    } else {
        if (offset.x > CGRectGetWidth(self.scrollView.frame)) {
            self.currentIndex += 1;
        } else {
            self.currentIndex -= 1;
        }
    }
    
    [self setCurrentImage];
    [self setNavigationTitle];
}

// 取得index位置上的image
- (UIImage *)imageAtIndex:(NSInteger)index {
    // 获取全屏图片
    ALAsset *asset = self.photos[index];
    UIImage *image = [UIImage imageWithCGImage:[asset defaultRepresentation].fullScreenImage];
    return image;
}

#pragma mark - SEL

- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)selected:(id)sender {
    // do something
}

#pragma makr - IBActions

// 处理是否全屏显示
- (IBAction)viewWithTap:(id)sender {
    if (self.isFullScreenShowing) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        self.navigationController.navigationBarHidden = NO;
        self.scrollView.backgroundColor = [UIColor whiteColor];
    } else {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        self.navigationController.navigationBarHidden = YES;
        self.scrollView.backgroundColor = [UIColor blackColor];
    }
    self.isFullScreenShowing = !self.isFullScreenShowing;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self reloadImages];
    [self setScrollViewOffset];
}

@end
