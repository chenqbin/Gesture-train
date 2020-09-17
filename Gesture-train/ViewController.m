//
//  ViewController.m
//  Gesture-train
//
//  Created by chenquanbin on 2020/9/16.
//  Copyright © 2020 chenquanbin. All rights reserved.
//

#import "ViewController.h"
#import "BDSAddTextView.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BDSAddTextView *textView = [[BDSAddTextView alloc]init];
    textView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:textView];
    textView.translatesAutoresizingMaskIntoConstraints = NO;
    [textView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
    [textView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [textView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
    [textView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor].active = YES;
}


@end
