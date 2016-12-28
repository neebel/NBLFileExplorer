//
//  ViewController.m
//  NBLFileExplorer
//
//  Created by snb on 16/12/20.
//  Copyright © 2016年 neebel. All rights reserved.
//

#import "ViewController.h"
#import "NBLFileExplorer.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *openButton;

@end

@implementation ViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.openButton];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Getter

- (UIButton *)openButton
{
    if (!_openButton) {
        UIButton *openButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 160, 60)];
        openButton.center = self.view.center;
        [openButton setTitle:@"Open FileExplorer" forState:UIControlStateNormal];
        [openButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [openButton setBackgroundColor:[UIColor blueColor]];
        [openButton addTarget:self
                       action:@selector(openFileExplorer)
             forControlEvents:UIControlEventTouchUpInside];
        _openButton = openButton;
    }
    
    return _openButton;
}

#pragma mark - Action

- (void)openFileExplorer
{
    [[NBLFileExplorer sharedExplorer] showFromViewController:self];
}

@end
