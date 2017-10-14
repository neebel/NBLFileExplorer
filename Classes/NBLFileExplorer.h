//
//  NBLFileExplorer.h
//  NBLFileExplorer
//
//  Created by snb on 16/12/20.
//  Copyright © 2016年 neebel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NBLFileExplorer : NSObject

+ (instancetype)sharedExplorer;

- (void)presentedByViewController:(UIViewController *)viewController;

@end
