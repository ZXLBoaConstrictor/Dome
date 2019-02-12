//
//  UIPopBackgroundView.m
//  UINavigationBarDome
//
//  Created by 张小龙 on 2019/2/12.
//  Copyright © 2019 张小龙. All rights reserved.
//

#import "UIPopBackgroundView.h"

@interface UIPopBackgroundView()
@property (nonatomic, assign) CGFloat fArrowOffset;
@property (nonatomic, assign) UIPopoverArrowDirection direction;
@end

@implementation UIPopBackgroundView
+(BOOL)wantsDefaultContentAppearance{
    return NO;
}

//这个方法返回箭头宽度
+ (CGFloat)arrowBase{
    return 12;
}
//这个方法中返回内容视图的偏移
+(UIEdgeInsets)contentViewInsets{
    return UIEdgeInsetsMake(10, 0, 0, 0);
}
//这个方法返回箭头高度
+(CGFloat)arrowHeight{
    return 5;
}

//这个方法返回箭头的方向
-(UIPopoverArrowDirection)arrowDirection{
    return self.direction;
}
//这个在设置箭头方向时被调用 可以监听做处理
-(void)setArrowDirection:(UIPopoverArrowDirection)arrowDirection{
    self.direction = arrowDirection;
}
////这个方法在设置箭头偏移量时被调用 可以监听做处理
-(void)setArrowOffset:(CGFloat)arrowOffset{
    self.fArrowOffset = arrowOffset;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

//重写layout方法来来定义箭头样式
- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.layer.shadowOpacity = 0.2f;
    self.layer.cornerRadius = 2.0f;
    CGSize arrowSize = CGSizeMake([[self class] arrowBase], [[self class] arrowHeight]);
    UIImage * image  = [self drawArrowImage:arrowSize];
    CGRect rect = CGRectMake((self.frame.size.width - arrowSize.width)/2 + self.fArrowOffset, 11, arrowSize.width, arrowSize.height);
    if (self.arrowDirection == UIPopoverArrowDirectionDown) {
        rect.origin.y = self.frame.size.height - rect.size.height;
    }
    
    UIImageView * imageView = [[UIImageView alloc]initWithImage:image];
    imageView.frame = rect;
    [self addSubview:imageView];
}

//画箭头方法
- (UIImage *)drawArrowImage:(CGSize)size{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor clearColor] setFill];
    CGContextFillRect(ctx, CGRectMake(0.0f, 0.0f, size.width, size.height));
    CGMutablePathRef arrowPath = CGPathCreateMutable();
    if (self.arrowDirection == UIPopoverArrowDirectionDown) {
        CGPathMoveToPoint(arrowPath, NULL, 0.0f, 0.0f);
        CGPathAddLineToPoint(arrowPath, NULL, size.width, 0.0f);
        CGPathAddLineToPoint(arrowPath, NULL, (size.width/2.0f), size.height);
    }else{
        CGPathMoveToPoint(arrowPath, NULL, (size.width/2.0f), 0.0f);
        CGPathAddLineToPoint(arrowPath, NULL, size.width, size.height);
        CGPathAddLineToPoint(arrowPath, NULL, 0.0f, size.height);
    }
    CGPathCloseSubpath(arrowPath);
    CGContextAddPath(ctx, arrowPath);
    CGPathRelease(arrowPath);
    UIColor *fillColor = [UIColor colorWithWhite:0 alpha:0.8];
    CGContextSetFillColorWithColor(ctx, fillColor.CGColor);
    CGContextDrawPath(ctx, kCGPathFill);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
