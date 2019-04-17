//
//  Hero.m
//  StickHero
//
//  Created by OurEDA on 15/5/5.
//  Copyright (c) 2015年 com.OurEDA. All rights reserved.
//

#import "Hero.h"

@implementation Hero
@synthesize isAlive;
@synthesize isWalking;

-(Hero*) initWithPositionInView:(CGPoint) point :(UIView*) aView{
    
    isAlive = YES;
    isWalking = NO;
    
    center = point;
    //让hero左脚尖对齐stage左上角，在图片左下角点向右宽度的1/7（图片没切好，这里一点一点试的，说多了都是泪）
    position = CGPointMake(point.x-point.y/28.0, point.y-point.y/8.0);
    //在ViewController中将point的纵坐标设为屏幕高度的2/3，所以这里hero的宽高都是屏幕高度的2/3*1/8=1/12
    heroView = [[UIImageView alloc] initWithFrame:CGRectMake(position.x, position.y, position.y/7.0, position.y/7.0)];
    [heroView setImage:[UIImage imageNamed:@"hero"]];
    //heroView.backgroundColor = [UIColor greenColor];
    [aView addSubview:heroView];
    return self;
}

-(void) goForwardFrom:(StageBlock*) stage1 :(StageBlock*) stage2 :(CGFloat)distance :(CGFloat)maxDistanceCanGo {
    CGFloat dist = distance > maxDistanceCanGo? maxDistanceCanGo : distance;//实际距离
   // NSLog(@"distance=%f",dist);
    
    //走到棍子右端
    [UIView animateWithDuration:1.0 //时长
    delay:1.0 //延迟时间
    options:UIViewAnimationOptionTransitionFlipFromLeft//动画效果
    animations:^{
        //NSLog(@"stage1.left position:%f",[stage1 start].x);
        //NSLog(@"before center:%f",center.x);
        isWalking = YES;
        position.x += dist;
        center.x += dist;
    heroView.frame=CGRectMake(position.x, position.y, heroView.frame.size.width, heroView.frame.size.height);
        //NSLog(@"stage2.left position:%f",[stage2 start].x);
        //NSLog(@"after center:%f",center.x);

    } completion:^(BOOL finish){
        NSLog(@"***  hero went to destination");
        //position.x+=dist;
        isWalking = NO;
        
        //NSLog(@"\n------------\ncenter.x=%f",center.x);
        //NSLog(@"stage2.left=%f",[stage2 start].x);
        //NSLog(@"stage2.right=%f\n-----------",[stage2 start].x+[stage2 width]);
        if(center.x< [stage1 start].x+[stage1 width]){//没走出stage1，die但不掉落
            isAlive = NO;
        }
        else if(center.x<[stage2 start].x){//没走到stag2，掉落
            [self fall];
            isAlive = NO;
        }
        else if(center.x < [stage2 start].x+[stage2 width]){
            //走到stage2
            
        }
        else if(center.x < maxDistanceCanGo){//走过了stage2，但没到屏幕边缘
            isAlive = NO;
            [self fall];
        }
        else{//走到屏幕边缘，再走就出屏幕了
            isAlive = NO;
        }
    }];
    
}

-(void) go:(CGFloat)distance{
    isWalking = YES;
    [UIView animateWithDuration:1.0 //时长
                          delay:0.0 //延迟时间
                        options:UIViewAnimationOptionTransitionFlipFromLeft//动画效果
                     animations:^{
                         position.x -= distance;
                         center.x -= distance;
                         heroView.frame=CGRectMake(position.x, position.y, heroView.frame.size.width, heroView.frame.size.height);
                         //heroView.frame=CGRectMake(position.x, position.y, position.y/7.0, position.y/7.0);
                         
                     } completion:^(BOOL finish){
                         isWalking = NO;
                         NSLog(@"go finish");
                     }
     ];

}

-(void) fall{
    NSLog(@"hero falls");
    [UIView animateWithDuration:0.5 //时长
                          delay:0.0 //延迟时间
                        options:UIViewAnimationOptionTransitionFlipFromTop//动画效果
                     animations:^{
                         
                         position.y+=150;
                         center.y+=150;
                         heroView.frame=CGRectMake(position.x, position.y, heroView.frame.size.width, heroView.frame.size.height);
                         
                     } completion:^(BOOL finish){
                         
                     }];

}

-(CGPoint) center{
    
    return center;
}

-(void) destory{
    [heroView removeFromSuperview];
}
@end
