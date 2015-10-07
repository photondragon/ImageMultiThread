//
//  BreviaryCell.m
//  ImageMultiThread
//
//  Created by mahongjian on 14-7-13.
//  Copyright (c) 2014年 mahongjian. All rights reserved.
//

#import "BreviaryCell.h"
#import "MyCommon.h"

#define BreviaryWidth 128
#define BreviaryHeight 72

@implementation BreviaryCell
@synthesize imageView;

//后台加载指定图像。此方法在后台线程运行
-(void)loadImage:(NSString*)imgfile
{
	NSString* current;
	@synchronized(self)
	{
		current = currentImageFile;
	}

	if([current isEqualToString:imgfile]==false)//当前图像已经改变，所以不用加载原来的文件
		return;
	NSTimeInterval startTime = [NSDate timeIntervalSinceReferenceDate];//加载开始时间

	UIImage* img = [UIImage imageWithContentsOfFile:imgfile];//从磁盘读取图像
	//img = [MyCommon getBitmapImageFromFileImage:img];//强制图像解码（原始大小）
	img = [MyCommon resizeImage:img newSize:CGSizeMake(BreviaryWidth, BreviaryHeight)];//强制图像解码（128x72)

	NSTimeInterval endTime = [NSDate timeIntervalSinceReferenceDate];//加载结束时间

	NSLog(@"%@, time = %f",[imgfile lastPathComponent], endTime-startTime);//输出文件名和加载所消耗的时间

	@synchronized(self)
	{
		current = currentImageFile;
	}

	if([current isEqualToString:imgfile]==false)//当前图像已经改变，所以不用加载原来的文件
		return;

	//利用GCD，将@selector(imageLoaded:forFile:)方法提交到主线程去执行
	dispatch_async(dispatch_get_main_queue(), ^{
		[self imageLoaded:img forFile:imgfile];
	});
}

//将加载好的图像显示到imageView中
-(void) imageLoaded:(UIImage*)img forFile:(NSString*)imgfile
{//在主线程运行
//	@synchronized(self)
//	{
		if([currentImageFile isEqualToString:imgfile]==false)//当前图像已经改变，之前加载的图像无效
			return;
//	}

	self.imageView.image = img;
}

-(void) setImage:(NSString*)imgfile
{
	[self setImage:imgfile placeHolder:nil];
}
-(void) setImage:(NSString*)imgfile placeHolder:(UIImage*)placeHolder
{//在主线程运行
	if(imgfile && imgfile.length==0)//如果是空串""
		imgfile = nil;
	@synchronized(self)
	{
		currentImageFile = imgfile;
	}
	self.imageView.image = placeHolder;
	if(imgfile==nil)
		return;
	NSOperation* operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadImage:) object:imgfile];
	[[MyCommon AppQueue] addOperation:operation];
}

@end
