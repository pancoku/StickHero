//
//  Hero.h
//  StickHero
//
//  Created by OurEDA on 15/5/5.
//  Copyright (c) 2015年 com.OurEDA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "StageBlock.h"

@interface Hero : NSObject{
    
    UIImageView *heroView;
    CGPoint center;//hero的中心点，实际是hero的左脚尖
    CGPoint position;
    // BOOL isAlive;
}

@property BOOL isAlive;
@property BOOL isWalking;

-(Hero*) initWithPositionInView:(CGPoint) point :(UIView*) aView;
-(void) go:(CGFloat)distance;
-(void) goForwardFrom:(StageBlock*) stage1 :(StageBlock*) stage2 :(CGFloat)distance :(CGFloat)maxDistanceCanGo ;
-(void) fall;
-(void) wait;
-(CGPoint) center;
-(void) destory;
@end
