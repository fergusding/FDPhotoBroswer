//
//  FDPhotoViewController.h
//  FDPhotoBroswer
//
//  Created by fergusding on 15/7/10.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FDPhotoViewController : UIViewController

@property (copy, nonatomic) NSArray *photos;
@property (assign, nonatomic) NSInteger currentIndex;

@end
