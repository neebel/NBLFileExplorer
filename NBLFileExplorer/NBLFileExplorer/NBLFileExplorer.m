//
//  NBLFileExplorer.m
//  NBLFileExplorer
//
//  Created by snb on 16/12/20.
//  Copyright © 2016年 neebel. All rights reserved.
//

#import "NBLFileExplorer.h"
#import "NBLFileListViewController.h"

@implementation NBLFileExplorer

+ (instancetype)sharedExplorer
{
    static NBLFileExplorer *fileExplorer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fileExplorer = [[self alloc] init];
    });

    return fileExplorer;
}


- (void)showFromViewController:(UIViewController *)viewController
{
    NSAssert(viewController.navigationController, @"navigationController can't be nil");
    NBLFileListViewController *fileListVC = [[NBLFileListViewController alloc] init];
    fileListVC.currentLocation = NSHomeDirectory();
    [viewController.navigationController pushViewController:fileListVC animated:YES];
}

@end
