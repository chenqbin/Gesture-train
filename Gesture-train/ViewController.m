//
//  ViewController.m
//  Gesture-train
//
//  Created by chenquanbin on 2020/9/16.
//  Copyright © 2020 chenquanbin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView = [[UIView alloc]init];
    self.imageView.backgroundColor = [UIColor blackColor];
    self.imageView.bounds = CGRectMake(0, 0, 200, 200);
    [self.view addSubview:self.imageView];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.imageView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
    [self.imageView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.imageView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
    [self.imageView.heightAnchor constraintEqualToAnchor:self.view.widthAnchor].active = YES;
}


@end
