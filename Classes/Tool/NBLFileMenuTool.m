//
//  NBLFileMenuTool.m
//  NBLFileExplorer
//
//  Created by snb on 16/12/30.
//  Copyright © 2016年 neebel. All rights reserved.
//

#import "NBLFileMenuTool.h"
#import <UIKit/UIKit.h>

@interface NBLFileMenuTool()<UIGestureRecognizerDelegate, NBLFileOperationMenuDelegate>

@property (nonatomic, weak)   id<NBLFileMenuToolDelegate> delegate;
@property (nonatomic, strong) UIWindow *bgWindow;
@property (nonatomic, strong) NBLFileOperationMenu *menu;

@end

@implementation NBLFileMenuTool

#pragma mark - Public

+ (instancetype)sharedTool
{
    static NBLFileMenuTool *tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[self alloc] init];
    });

    return tool;
}


- (void)showWithDelegate:(id<NBLFileMenuToolDelegate>)delegate
{
    self.delegate = delegate;
    self.bgWindow = [[UIWindow alloc] initWithFrame:[UIApplication sharedApplication].delegate.window.bounds];
    self.bgWindow.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.bgWindow setWindowLevel:UIWindowLevelAlert];
    [self.bgWindow setBackgroundColor:[UIColor clearColor]];
    [self.bgWindow addSubview:self.menu];
    self.bgWindow.userInteractionEnabled  = YES;
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeMenu:)];
    gestureRecognizer.delegate = self;
    [self.bgWindow addGestureRecognizer:gestureRecognizer];
    [self.bgWindow makeKeyAndVisible];
    
    self.menu.transform = CGAffineTransformMakeScale(0.3f, 0.3f);
    [UIView beginAnimations:nil context:UIGraphicsGetCurrentContext()];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.1f];
    self.menu.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    [UIView commitAnimations];
}


- (void)destoryMenu
{
    self.menu = nil;
}

#pragma mark - Getter

- (NBLFileOperationMenu *)menu
{
    if (!_menu) {
        NBLFileOperationMenu *menu = [[NBLFileOperationMenu alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 5 - 90, 69, 90, 90)];
        menu.delegate = self;
        _menu = menu;
    }

    return _menu;
}

#pragma mark - Private

- (void)closeMenuAnimation
{
    [UIView animateWithDuration:0.1f animations:^{
        self.menu.transform = CGAffineTransformMakeScale(0.3f, 0.3f);
    } completion:^(BOOL finished) {
        self.menu.transform = CGAffineTransformIdentity;
        [self.menu removeFromSuperview];
        [self.bgWindow resignKeyWindow];
        self.bgWindow = nil;
    }];
}

#pragma mark - Action

- (void)closeMenu:(UIGestureRecognizer *)gestureRecognizer
{
    if (nil == gestureRecognizer) {
        if (![NSStringFromClass([gestureRecognizer.view class]) isEqualToString:@"UITableViewCellContentView"]) {
            [self closeMenuAnimation];
        }
    } else {
        [self closeMenuAnimation];
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    
    return YES;
}

#pragma mark - NBLFileOperationMenuDelegate

- (void)choseOperationType:(NBLFileOperationType)type
{
    [self closeMenu:nil];
    if (self.delegate && [self.delegate respondsToSelector:@selector(choseMenuType:)]) {
        [self.delegate choseMenuType:type];
    }
}

@end
