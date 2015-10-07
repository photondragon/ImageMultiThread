//
//  BreviaryCell.h
//  ImageMultiThread
//
//  Created by mahongjian on 14-7-13.
//  Copyright (c) 2014年 mahongjian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BreviaryCell : UICollectionViewCell
{
	NSString* currentImageFile;//当前要加载的图像文件的全路径
}
@property (nonatomic,weak) IBOutlet UIImageView* imageView;
-(void) setImage:(NSString*)imagefile;//设置cell要加载的图像文件
-(void) setImage:(NSString*)imagefile placeHolder:(UIImage*)placeHolder;//设置cell要加载的图像文件，placeHolder占位图，在图像加载过程中显示
@end
