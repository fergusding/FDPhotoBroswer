//
//  FDPhotoGroupCollectionViewCell.m
//  FDPhotoBroswer
//
//  Created by fergusding on 15/7/10.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//

#import "FDPhotoGroupCollectionViewCell.h"

@interface FDPhotoGroupCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterImageView;

@end

@implementation FDPhotoGroupCollectionViewCell

- (void)setName:(NSString *)name {
    _name = name;
    self.nameLabel.text = self.name;
}

- (void)setPosterImage:(UIImage *)posterImage {
    _posterImage = posterImage;
    self.posterImageView.image = self.posterImage;
}

@end
