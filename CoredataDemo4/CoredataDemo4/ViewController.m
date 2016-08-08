//
//  ViewController.m
//  CoredataDemo4
//
//  Created by Anke on 15/2/8.
//  Copyright (c) 2015年 Anke. All rights reserved.
//

#import "ViewController.h"
#import "MyDatabase.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"%@",NSHomeDirectory());
    [MyDatabase shareMyDatabase];
    [[MyDatabase shareMyDatabase] addPersonWithModel:nil];
    [[MyDatabase shareMyDatabase] removePersonWithModel:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
