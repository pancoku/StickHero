//
//  Stick.m
//  StickHero
//
//  Created by OurEDA on 15/5/5.
//  Copyright (c) 2015年 com.OurEDA. All rights reserved.
//

#import "Stick.h"

@implementation Stick
@synthesize start;
@synthesize visiablity;

-(Stick*) initWithPointInView:(CGPoint)point :(UIView *) aView{
    start = point;  //棍子顶部点
    length = 0;
    canIncrease = YES;
    visiablity = YES;
    stickView = [[UIView alloc] initWithFrame:CGRectMake(start.x, start.y, 2, length)];
    stickView.backgroundColor = [UIColor blackColor];
    [aView addSubview:stickView];
    return self;
}

-(void) increaseLength{
    
    if (canIncrease) {
        start.y -= 2.0;
        length += 2.0;
        //stickView.frame=CGRectMake(start.x, start.y, 1, length);
        [UIView animateWithDuration:0.0 //时长
                              delay:0 //延迟时间
                            options:UIViewAnimationOptionTransitionFlipFromLeft//动画效果
                         animations:^{
                             stickView.frame=CGRectMake(start.x, start.y, 2, length);
                             
                         } completion:^(BOOL finish){
                             [self increaseLength];
                             //NSLog(@"###  x=%f,y=%f,length=%f",start.x,start.y,length);
        }];
    }
    stickView.layer.anchorPoint = CGPointMake(0,1); //设置锚点,方便旋转    
    return;
}

-(void) stopIncreaseLength{
    canIncrease = NO;
}

-(void) fallDown{
    //NSLog(@"%f",[[NSDate date] timeIntervalSince1970]*1000);
    NSLog(@"stick falls down");
    
    CABasicAnimation* rotationAnimation= [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];//z变换
    rotationAnimation.toValue = [NSNumber numberWithFloat:  M_PI*0.5 ];
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    rotationAnimation.duration = 1;
    rotationAnimation.RepeatCount = 1;
    rotationAnimation.cumulative = NO;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    [stickView.layer addAnimation:rotationAnimation forKey:@"Rotation"];
    //NSLog(@"stick falls down finished");
    
}

-(void) disappear{
    NSLog(@"stick disappear");
    [UIView animateWithDuration:0.0
                          delay:2.0
                        options:UIViewAnimationOptionTransitionFlipFromLeft
                     animations:^{
                       
                         stickView.frame = CGRectMake( start.x , start.y+length, 2, 0);
                     }completion:^(BOOL finish){
                         start.y = start.y+length;
                         length = 0;
                         //NSLog(@"stick start (%f,%f)",start.x , start.y);
                        [self switchIncreaseStatus];
                         visiablity = NO;
                         NSLog(@"remove stickView");
                        //[stickView removeFromSuperview];
                     }];
}

-(void) switchIncreaseStatus{
    canIncrease = ~canIncrease;
}

-(CGFloat) length{
    return length;
}

-(void) destory{
    [stickView removeFromSuperview];
}
@end
