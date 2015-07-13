//
//  FDPhotoGroupCollectionViewController.m
//  FDPhotoBroswer
//
//  Created by fergusding on 15/7/10.
//  Copyright (c) 2015年 fergusding. All rights reserved.
//

#import "FDPhotoGroupsCollectionViewController.h"
#import "FDPhotosCollectionViewController.h"
#import "FDPhotoGroupCollectionViewCell.h"

#import <AssetsLibrary/AssetsLibrary.h>

@interface FDPhotoGroupsCollectionViewController ()

@property (strong, nonatomic) ALAssetsLibrary *assetsLibrary;

@property (strong, nonatomic) NSMutableArray *photoGroups;

@end

@implementation FDPhotoGroupsCollectionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.assetsLibrary = [[ALAssetsLibrary alloc] init];
    self.photoGroups = [NSMutableArray array];
    [self allPhotoGroups];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

// 获取所有相册 注意block为异步
- (void)allPhotoGroups {
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group != nil) {
            [self.photoGroups addObject:group];
        }
        if (stop) {
            [self.collectionView reloadData];
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
}

// 获取所有相册的所有图片
- (NSArray *)allPhotos {
    NSMutableArray *photos = [NSMutableArray array];
    for (ALAssetsGroup *group in self.photoGroups) {
        NSArray *array = [self allPhotosOfGroup:group];
        [photos addObjectsFromArray:array];
    }
    
    return photos;
}

// 获取指定相册的所有图片  block为同步
- (NSArray *)allPhotosOfGroup:(ALAssetsGroup *)group {
    NSMutableArray *photos = [NSMutableArray array];
    [group setAssetsFilter:[ALAssetsFilter allPhotos]];
    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result != nil) {
            [photos addObject:result];
        }
    }];
    
    return [photos copy];
}

// 获取该相册的名字
- (NSString *)nameOfGroup:(ALAssetsGroup *)group {
    NSString *groupString = [NSString stringWithFormat:@"%@", group];
    NSString *groupInfoString = [groupString substringFromIndex:16];
    NSArray *groupInfoArray = [groupInfoString componentsSeparatedByString:@","];
    NSString *name = [groupInfoArray[0] substringFromIndex:5];
    return name;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.photoGroups count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"PhotoGroupCell";
    FDPhotoGroupCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    ALAssetsGroup *group = self.photoGroups[indexPath.row];
    
    // 生成相册名称  名字+数量
    cell.name = [NSString stringWithFormat:@"%@  %ld张", [self nameOfGroup:group], (long)group.numberOfAssets];
    
    // 取得封面图片
    cell.posterImage = [UIImage imageWithCGImage:group.posterImage];
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (![segue.identifier isEqualToString:@"PhotoGroupToDetail"]) {
        return;
    }
    FDPhotoGroupCollectionViewCell *cell = (FDPhotoGroupCollectionViewCell *)sender;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    ALAssetsGroup *group = self.photoGroups[indexPath.row];
    
    FDPhotosCollectionViewController *viewController = [segue destinationViewController];
    viewController.photos = [self allPhotosOfGroup:group];
}

@end
