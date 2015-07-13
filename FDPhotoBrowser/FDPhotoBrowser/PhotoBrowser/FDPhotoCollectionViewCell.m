//
//  FDPhotoCollectionViewCell.m
//  FDPhotoBroswer
//
//  Created by fergusding on 15/7/7.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//

#import "FDPhotoCollectionViewCell.h"

@interface FDPhotoCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation FDPhotoCollectionViewCell

- (void)setImage:(UIImage *)image {
    _image = image;
    self.imageView.image = _image;
}

@end
