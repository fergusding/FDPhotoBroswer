//
//  FDPhotosCollectionViewController.m
//  FDPhotoBroswer
//
//  Created by fergusding on 15/7/10.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//

#import "FDPhotosCollectionViewController.h"
#import "FDPhotoViewController.h"
#import "FDPhotoCollectionViewCell.h"

#import <AssetsLibrary/AssetsLibrary.h>

@interface FDPhotosCollectionViewController ()

@end

@implementation FDPhotosCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView allowsMultipleSelection];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.photos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"PhotoCell";
    FDPhotoCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    ALAsset *asset = self.photos[indexPath.row];
    
    // 获取缩略图
    UIImage *thumbnailImage = [UIImage imageWithCGImage:[asset thumbnail]];
    cell.image = thumbnailImage;
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FDPhotoViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"FDPhotoViewController"];
    viewController.photos = self.photos;
    viewController.currentIndex = indexPath.row;
    [self.navigationController pushViewController:viewController animated:NO];
}

@end
