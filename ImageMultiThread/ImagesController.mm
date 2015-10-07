//
//  ImagesController.m
//  ImageMultiThread
//
//  Created by mahongjian on 14-7-12.
//  Copyright (c) 2014年 mahongjian. All rights reserved.
//

#import "ImagesController.h"
#import "AppDelegate.h"
#import "MyCommon.h"
#import "BreviaryCell.h"

#define CountPerRow 4 //一行显示几张图片

@interface ImagesController ()

@end

@implementation ImagesController

- (void)viewDidLoad
{
    [super viewDidLoad];

	imageLoading = [UIImage imageNamed:@"loading.jpg"];
	imagesPath = [NSString stringWithFormat:@"%@/Documents",NSHomeDirectory()];//将应用的Documents目录设置为图像目录
	arrayImageFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:imagesPath error:nil];//获取图像目录下的文件名列表
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
	return FALSE;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
	[(BreviaryCell*)cell setImage:nil];
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return CountPerRow;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return (arrayImageFiles.count+CountPerRow-1)/CountPerRow;
}

#define UseMultiThread 1 //是否使用多线程加载图片

#if UseMultiThread == 0
#pragma mark 单线程版本
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	BreviaryCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];

	NSInteger index = [indexPath section]*CountPerRow+[indexPath row];//第几个图像
	NSString* imgName = [arrayImageFiles objectAtIndex:index];//图像文件名
	NSString* imgPath = [imagesPath stringByAppendingFormat:@"/%@", imgName];//图像全路径

	NSTimeInterval time = [NSDate timeIntervalSinceReferenceDate];
	cell.imageView.image = [UIImage imageWithContentsOfFile:imgPath];//读取图像文件
	NSLog(@"%@, time = %f",imgName, [NSDate timeIntervalSinceReferenceDate]-time);

	return cell;
}

#else
#pragma mark 多线程版本
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	BreviaryCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCell" forIndexPath:indexPath];

	NSInteger index = [indexPath section]*CountPerRow+[indexPath row];//第几个图像
	if(index>=arrayImageFiles.count)
	{
		[cell setImage:nil];
		return cell;
	}

	NSString* imgName = [arrayImageFiles objectAtIndex:index];//图像文件名
	NSString* imgPath = [imagesPath stringByAppendingFormat:@"/%@", imgName];//图像全路径

	[cell setImage:imgPath placeHolder:imageLoading];//设置cell要加载的图像文件

	return cell;
}
#endif
@end
