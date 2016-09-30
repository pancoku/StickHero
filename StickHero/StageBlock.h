//
//  StageBlock.h
//  StickHero
//
//  Created by OurEDA on 15/5/5.
//  Copyright (c) 2015年 com.OurEDA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface StageBlock : NSObject{
    CGPoint start;
    CGFloat width;
    UIView *stageView;
}

@property BOOL isMoving;

-(StageBlock*) initWithPositionInView:(CGPoint)point :(UIView *)aView;
-(void) move:(CGFloat) distance;
-(CGPoint) start;
-(CGFloat) width;
-(void) resetWidth:(StageBlock*)stage;
-(void) destory;
@end
