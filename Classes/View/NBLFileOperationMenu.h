//
//  NBLFileOperationMenu.h
//  NBLFileExplorer
//
//  Created by snb on 16/12/30.
//  Copyright © 2016年 neebel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBLFileTypeManager.h"

@protocol NBLFileOperationMenuDelegate <NSObject>

- (void)choseOperationType:(NBLFileOperationType)type;

@end


@interface NBLFileOperationMenu : UIView

@property (nonatomic, weak) id<NBLFileOperationMenuDelegate> delegate;

@end
