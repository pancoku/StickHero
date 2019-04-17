//
//  ViewController.h
//  StickHero
//
//  Created by OurEDA on 15/5/4.
//  Copyright (c) 2015年 com.OurEDA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Stick.h"
#import "Hero.h"
#import "StageBlock.h"

@interface ViewController : UIViewController{
    long touchBeginTime;
    long touchEndTime;
    CGFloat width,height;
    Stick *stick;
    Hero *hero;
    StageBlock *stage1;
    StageBlock *stage2;
    
    int best;
    int score;
    UILabel *bestScore;
    UILabel *bestScoreLabel;
    UILabel *curScore;
    UILabel *curScoreLabel;
    UIButton *restart;
    UILabel *myScore;
    UIButton *myScore_;
    UILabel *help;
    
}


@end

