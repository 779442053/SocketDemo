//
//  Advertisements.m
//  Kuaizhu2
//
//  Created by step_zhang on 2019/11/29.
//  Copyright © 2019 step_zhang. All rights reserved.
//

#import "Advertisements.h"

@implementation Advertisements
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"advId" : @"id"};
}
-(CGFloat)height{
    //if (_height) return _height;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:self.cover]) {
        id height = [[NSUserDefaults standardUserDefaults] objectForKey:self.cover];
        //ZWWLog(@"缓存取出来的尺寸===%@",height)
        _height = [height floatValue];
    }else{
        CGSize size = [self GetImageSizeWithURL:self.cover];
        CGFloat CurrentWith = (KScreenWidth - 30)/2;
        if (size.height < size.width) {
            //正方形
            //size.height = CurrentWith - 10 *0.5 ;
            size.height =  kRealValueHeight_H(CurrentWith);
        }else if (size.height > 232.0){
            //长方形
            //return CurrentWith - 10 *0.5 - 30 * 0.5;
            //size.height =CurrentWith - 10 *0.5 - 30 * 0.5;
            size.height = kRealValueHeight_S(CurrentWith);
        }else{
            //size.height =CurrentWith - 10 *0.5 - 30 * 0.5;
            size.height =  kRealValueHeight_S(CurrentWith);
        }
        //计算出来之后,需要对图片进行压缩..宽度一定的情况下进行压缩  开辟分线程
        dispatch_group_t group = dispatch_group_create();
        dispatch_queue_t queue = dispatch_queue_create("dispatchGroupMetho", DISPATCH_QUEUE_CONCURRENT);
        dispatch_group_async(group, queue, ^{
            dispatch_async(queue, ^{
                [[NSUserDefaults standardUserDefaults] setObject:@(size.height) forKey:self.cover];
                [[NSUserDefaults standardUserDefaults] synchronize];
            });
        });

        _height = size.height;
    }

    return _height;
}
-(CGSize)GetImageSizeWithURL:(id)imageURL{
    NSURL* URL = nil;
    if([imageURL isKindOfClass:[NSURL class]]){
        URL = imageURL;
    }
    if([imageURL isKindOfClass:[NSString class]]){
        URL = [NSURL URLWithString:imageURL];
    }
    NSData *data = [NSData dataWithContentsOfURL:URL];
    UIImage *imageOrigin = [UIImage imageWithData:data];
    CGFloat CurrentWith = (KScreenWidth - 30)/2;
    UIImage *image = [self imageCompressForWidth:imageOrigin targetWidth:CurrentWith];
    ZWWLog(@"计算出来的c图片尺寸的大小=\n %@",image)
    return CGSizeMake(image.size.width, image.size.height);
}
-(CGFloat)width{
    CGFloat CurrentWith = (KScreenWidth - 30)/2;
    _width = CurrentWith;
    return _width;
}
//根据特定宽度 进行缩放图片
-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
}

@end


@implementation Advs

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"advId" : @"id"};
}
@end
