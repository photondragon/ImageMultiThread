//
//  ImagesController.h
//  ImageMultiThread
//
//  Created by mahongjian on 14-7-12.
//  Copyright (c) 2014年 mahongjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagesController : UICollectionViewController
<UICollectionViewDataSource,
UICollectionViewDelegate>
{
	NSString* imagesPath; //图像目录（应用的Documents目录）
	NSArray* arrayImageFiles; //所有图像文件的文件名数组
	UIImage* imageLoading; //显示“正在加载。。。”的图像
}
@end
