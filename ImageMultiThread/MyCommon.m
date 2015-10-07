//
//  MyCommon.m
//  ImageMultiThread
//
//  Created by mahongjian on 14-7-13.
//  Copyright (c) 2014年 mahongjian. All rights reserved.
//

#import "MyCommon.h"

static NSOperationQueue* g_appQueue	= nil;

@implementation MyCommon
+ (void)initialize
{
	if(g_appQueue==nil)
	{
		@synchronized(self)
		{
			if(g_appQueue==nil)
			{
				g_appQueue = [[NSOperationQueue alloc] init];
				[g_appQueue setMaxConcurrentOperationCount:2];
			}
		}
	}
}

+ (UIImage*)getBitmapImageFromFileImage:(UIImage*)imgFromFile
{
	return [self resizeImage:imgFromFile newSize:imgFromFile.size];
}

+ (UIImage *)resizeImage:(UIImage*)originImage newSize:(CGSize)newSize
{
	if(originImage==nil)
		return nil;
	newSize.width	= (int)newSize.width;
	newSize.height	= (int)newSize.height;
	int bytesPerRow	= 4*newSize.width;
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

	//创建Bitmap Context，也就是图像缓冲区
	CGContextRef context = CGBitmapContextCreate(NULL,
												 newSize.width,newSize.height,//缓冲区的尺寸
												 8,//RGBA每个通道8位
												 bytesPerRow,//每行像素占用的总字节数
												 colorSpace,
												 kCGBitmapByteOrderDefault|kCGImageAlphaPremultipliedLast);

	CGColorSpaceRelease(colorSpace);
	if(context==0)
		return nil;

	CGRect rect	= CGRectMake(0, 0, newSize.width, newSize.height);//绘制的目标区域
    CGContextDrawImage(context, rect, originImage.CGImage);//将原始图像绘制到图像缓冲区中（其中包含了图像解码的过程）

    CGImageRef imgRef = CGBitmapContextCreateImage(context);//根据图像缓冲区中的内容创建一个新的图像（CGImageRef类型）
    CGContextRelease(context);
	if(imgRef==nil)
		return nil;
    UIImage *img = [[UIImage alloc] initWithCGImage:imgRef];//将新图像包装成UIImage类型
    CGImageRelease(imgRef);

    return img;
}

#define blurRadius 3
#define blurRadius2 9
float gaussianBlurMatrix[] = {
	0.0947416, 0.118318, 0.0947416,
	0.118318, 0.147761, 0.118318,
	0.0947416, 0.118318, 0.0947416
};
+ (UIImage *)resizeImageWithBlur:(UIImage*)originImage newSize:(CGSize)newSize
{
	if(originImage==nil)
		return nil;
	newSize.width	= (int)newSize.width;
	newSize.height	= (int)newSize.height;
	int bytesPerRow	= 4*newSize.width;
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

	unsigned char* rgb = malloc(bytesPerRow*newSize.height);
	unsigned char* rgb2 = malloc(bytesPerRow*newSize.height);
	//创建Bitmap Context，也就是图像缓冲区
	CGContextRef context = CGBitmapContextCreate(rgb,
												 newSize.width,newSize.height,//缓冲区的尺寸
												 8,//RGBA每个通道8位
												 bytesPerRow,//每行像素占用的总字节数
												 colorSpace,
												 kCGBitmapByteOrderDefault|kCGImageAlphaPremultipliedLast);

	CGColorSpaceRelease(colorSpace);
	if(context==0)
		return nil;

	CGRect rect	= CGRectMake(0, 0, newSize.width, newSize.height);//绘制的目标区域
	CGContextDrawImage(context, rect, originImage.CGImage);//将原始图像绘制到图像缓冲区中（其中包含了图像解码的过程）

	for(int n=0;n<0;n++)
	{
		unsigned char* p = rgb;
		rgb = rgb2;
		rgb2 = p;
		for(int y = 0;y<newSize.height; y++)
		{
			for (int x = 0; x<newSize.width; x++) {
				int offset = bytesPerRow*(y)+(x)*4;
				int x1 = x + (rand()>>28)-4;
				int y1 = y + (rand()>>28)-4;
				if(x1<0)
					x1 = 0;
				else if(x1>=newSize.width)
					x1 = newSize.width-1;
				if(y1<0)
					y1 = 0;
				else if(y1>=newSize.height)
					y1 = newSize.height-1;
				int offset2 = bytesPerRow*y1+x1*4;
				*(int*)(rgb+offset)= *(int*)(rgb2+offset2);
			}
		}
	}

	for(int n=0;n<0;n++)
	{
		unsigned char* p = rgb;
		rgb = rgb2;
		rgb2 = p;
		for(int y = 0;y<newSize.height; y++)
		{
			for (int x = 0; x<newSize.width; x++) {
				int offset = bytesPerRow*(y)+(x)*4;
				int r = 0;
				int g = 0;
				int b = 0;
				for (int dy = -blurRadius; dy <= blurRadius; dy++) {
					for (int dx = -blurRadius; dx <= blurRadius; dx++) {
						int x1 = x+dx;
						int y1 = y+dy;
						if(x1<0)
							x1 = 0;
						else if(x1>=newSize.width)
							x1 = newSize.width-1;
						if(y1<0)
							y1 = 0;
						else if(y1>=newSize.height)
							y1 = newSize.height-1;
						int offset = bytesPerRow*y1+x1*4;
						r += rgb2[offset];
						g += rgb2[offset+1];
						b += rgb2[offset+2];
					}
				}
				r /= blurRadius2;
				g /=blurRadius2;
				b /=blurRadius2;
				rgb[offset] = r;
				rgb[offset+1] = g;
				rgb[offset+2] = b;
			}
		}
	}
	free(rgb2);


	CGImageRef imgRef = CGBitmapContextCreateImage(context);//根据图像缓冲区中的内容创建一个新的图像（CGImageRef类型）
	CGContextRelease(context);
	if(imgRef==nil)
		return nil;
	UIImage *img = [[UIImage alloc] initWithCGImage:imgRef];//将新图像包装成UIImage类型
	CGImageRelease(imgRef);

	return img;
}

+(NSOperationQueue*) AppQueue
{
	if(g_appQueue==nil)
		[self initialize];
	return g_appQueue;
}

@end
