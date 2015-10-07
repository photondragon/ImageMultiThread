//
//  MyCommon.h
//  ImageMultiThread
//
//  Created by mahongjian on 14-7-13.
//  Copyright (c) 2014年 mahongjian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCommon : NSObject

/// 根据从文件中得到的图像生成一幅一样的新的BITMAP图像
/**
 * 如果读取jpg或png等压缩格式的图像文件，生成UIImage对象，
 * 默认这个对象内部的图像数据是未解码的，只有在第一次显示的时候才会解码。
 * 本函数可以将压缩的图像数据解码，生成一个解码后的UIImage对象。
 * @param imgFromFile 从文件中得到的图像
 * @return 返回新图像
 */
+ (UIImage*)getBitmapImageFromFileImage:(UIImage*)imgFromFile;

/// 改变图像大小
/**
 * @param originImage 原始图像
 * @param newSize 新的大小
 * @return 返回大小改变后的新图像
 */
+ (UIImage*)resizeImage:(UIImage*)originImage newSize:(CGSize)newSize;
+ (UIImage*)resizeImageWithBlur:(UIImage*)originImage newSize:(CGSize)newSize;

+(NSOperationQueue*) AppQueue;//全局的Operation队列
@end
