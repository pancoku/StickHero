//
//  ViewController.m
//  StickHero
//
//  Created by OurEDA on 15/5/4.
//  Copyright (c) 2015年 com.OurEDA. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //frame width and height
    width = self.view.frame.size.width;
    height = self.view.frame.size.height;
    [self initUI];
    NSString* path = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    best = [[dict objectForKey:@"bestScore"] intValue];
    NSLog(@"bestScore %d",best);
    
    help = [[UILabel alloc] initWithFrame:CGRectMake(0, height*0.1, width, height*0.1)];
    help.text = @"press screen,strength stick";
    help.alpha = 0.8;
    [help setTextAlignment:NSTextAlignmentCenter];
    help.textColor = [UIColor whiteColor];
    [help.layer setCornerRadius:10.0];
    //[help addTarget:self action:@selector(restartGame:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:help];
    
    curScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(width*0.35, height*0.2, width*0.2, width*0.05)];
    curScoreLabel.text = @"\x20 Score:";
    [curScoreLabel setTextAlignment:NSTextAlignmentCenter];
    curScoreLabel.textColor = [UIColor whiteColor];
    //[self.view addSubview:curScoreLabel];
    
    curScore = [[UILabel alloc] initWithFrame:CGRectMake(width*0.55, height*0.2, width*0.1, width*0.05)];
    curScore.text = [NSString stringWithFormat:@"%d",score];
    curScore.textColor = [UIColor whiteColor];
    //[self.view addSubview:curScore];
    
    bestScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(width*0.35, height*0.3, width*0.2, width*0.05)];
    bestScoreLabel.text = @"\x20 Best \x20:";
    [bestScoreLabel setTextAlignment:NSTextAlignmentCenter];
    bestScoreLabel.textColor = [UIColor whiteColor];
    //[self.view addSubview:bestScoreLabel];
    
    bestScore = [[UILabel alloc] initWithFrame:CGRectMake(width*0.55, height*0.3, width*0.1, width*0.05)];
    bestScore.text = [NSString stringWithFormat:@"%d",best];
    bestScore.textColor = [UIColor whiteColor];
    //[self.view addSubview:bestScore];
    
    restart = [[UIButton alloc] initWithFrame:CGRectMake(width*0.35, height*0.4, width*0.3, height*0.1)];
    [restart setTitle:@"try again" forState:UIControlStateNormal];
    restart.alpha = 0.8;
    restart.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:10.0/255.0 blue:0.0/255.0 alpha:0.6];
    [restart.layer setCornerRadius:10.0];
    [restart addTarget:self action:@selector(restartGame:) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:restart];
    
    myScore_= [[UIButton alloc] initWithFrame:CGRectMake(width*0.35, height*0.2, width*0.3, width*0.2)];
    myScore_.backgroundColor = [UIColor grayColor];
    myScore_.alpha = 0.2;
    [myScore_.layer setCornerRadius:10.0];
    myScore = [[UILabel alloc] initWithFrame:CGRectMake(width*0.35, height*0.2, width*0.3, width*0.2)];
    myScore.text = [NSString stringWithFormat:@"%d",score];
    //myScore.backgroundColor = [UIColor grayColor];//[UIColor colorWithRed:255.0/255.0 green:10.0/255.0 blue:0.0/255.0 alpha:0.6];
    [myScore setTextAlignment:NSTextAlignmentCenter];
    myScore.textColor = [UIColor whiteColor];
    myScore.font =  [UIFont boldSystemFontOfSize:50.0];
    [self.view addSubview:myScore_];
    [self.view addSubview:myScore];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark touches

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    touchBeginTime = [self getCurrentMillisecond];
    //[stick switchIncreaseStatus];
    [stick increaseLength];
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    touchEndTime = [self getCurrentMillisecond];
    [stick stopIncreaseLength];
    [self updateUI];
    //NSLog(@"touch time:%ld",touchEndTime-touchBeginTime);
}

#pragma -mark progress

-(void) initUI{
    
    CGPoint point = CGPointMake(width*0.1, height*2/3.0);
    hero = [[Hero alloc] initWithPositionInView:point :self.view];
    stage1 = [[StageBlock alloc] initWithPositionInView:point :self.view];
    stick = [[Stick alloc] initWithPointInView:CGPointMake(point.x+[stage1 width], point.y) :self.view];
    CGFloat randomWidth = (CGFloat)(arc4random()%(int)(100)+[stage1 width]+100);
    point.x+=randomWidth;
    stage2 = [[StageBlock alloc] initWithPositionInView:point :self.view];
    
}

-(void) updateUI{
   // dispatch_queue_t queue = dispatch_queue_create("updateUI", DISPATCH_QUEUE_SERIAL);
    StageBlock *stage3;
    [stick fallDown];
    [stick disappear];
    [hero goForwardFrom:stage1 :stage2 :[stick length]+[stage1 width]-([hero center].x-[stage1 start].x) :width-[hero center].x];
    while(hero.isWalking) {//等待英雄走完
        NSLog(@"hero walking... ");
        [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    if (hero.isAlive) {
        score ++;
        myScore.text = [NSString stringWithFormat:@"%d",score];
        CGFloat distance = [stage2 start].x - [stage1 start].x;
        CGFloat randomWidth = (CGFloat)(arc4random()%200);
        stage3 = [[StageBlock alloc] initWithPositionInView:CGPointMake(width+randomWidth, height*2/3.0) :self.view];
        while ([stage3 start].x-distance>width||[stage3 start].x+[stage3 width]>width+distance||[stage3 start].x-[stage2 start].x<0.1*width) {
            randomWidth = (CGFloat)(arc4random()%200);
            stage3 =nil;
            stage3 = [[StageBlock alloc] initWithPositionInView:CGPointMake(width+randomWidth, height*2/3.0) :self.view];
        }
        
        [hero go:distance];
        [stage1 move:distance];
        [stage2 move:distance];
        [stage3 move:distance];
    
        while(stage1.isMoving) {//等待视图移动
            NSLog(@"view moving");
            [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        stage1 = nil;
        stage1 = stage2;
        stage2 = nil;
        stage2 = stage3;
        stick = nil;
        CGPoint point = CGPointMake(width*0.1, height*2/3.0);
        stick = [[Stick alloc] initWithPointInView:CGPointMake(point.x+[stage1 width], point.y) :self.view];
    }
    else{
 //       int i=2;
//        while (i--) {
//             [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//        }
        curScore.text = [NSString stringWithFormat:@"%d",score];
        if (score > best) {//更新最佳成绩，写入plist
            best = score ;
            bestScore.text = [NSString stringWithFormat:@"%d",best];
            
            NSString* path = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
            NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
            [dict setObject:[NSString stringWithFormat:@"%d",best] forKey:@"bestScore"];
            [dict writeToFile:path atomically:YES];

        }
        
        score = 0;
        [self.view addSubview:curScore];
        [self.view addSubview:curScoreLabel];
        [self.view addSubview:bestScoreLabel];
        [self.view addSubview:bestScore];
        [self.view addSubview:restart];
        [myScore removeFromSuperview];
        [myScore_ removeFromSuperview];
    }
    
}

-(void) restartGame:(id)sender{
    [stick destory];
    [stage1 destory];
    [stage2 destory];
    [hero destory];
    stick = nil;
    stage1 = nil;
    stage2 = nil;
    hero = nil;
    [self initUI];
    myScore.text = [NSString stringWithFormat:@"%d",score];
    [self.view addSubview:myScore_];
    [self.view addSubview:myScore];
    [curScore removeFromSuperview];
    [curScoreLabel removeFromSuperview];
    [bestScore removeFromSuperview];
    [bestScoreLabel removeFromSuperview];
    [restart removeFromSuperview];
}
#pragma -mark tools

-(void)waitUntil:(BOOL*)flag{
    if (flag) {
        [self waitUntil:flag ];
    }
}

-(long) getCurrentMillisecond{
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    return (long)recordTime;
}

@end
