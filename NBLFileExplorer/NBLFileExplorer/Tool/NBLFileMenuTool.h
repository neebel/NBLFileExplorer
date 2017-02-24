//
//  NBLFileMenuTool.h
//  NBLFileExplorer
//
//  Created by snb on 16/12/30.
//  Copyright © 2016年 neebel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NBLFileOperationMenu.h"

@protocol NBLFileMenuToolDelegate <NSObject>

- (void)choseMenuType:(NBLFileOperationType)type;

@end

@interface NBLFileMenuTool : NSObject

+ (instancetype)sharedTool;
- (void)showWithDelegate:(id<NBLFileMenuToolDelegate>)delegate;
- (void)destoryMenu;

@end
