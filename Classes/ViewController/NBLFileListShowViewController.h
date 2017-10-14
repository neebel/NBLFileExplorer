//
//  NBLFileListShowViewController.h
//  NBLFileExplorer
//
//  Created by snb on 2017/2/17.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBLFileTypeManager.h"

@protocol NBLFileListShowViewControllerDelegate<NSObject>

- (void)pasteWithEditType:(NBLEditType)editType destPath:(NSString *)destPath;

@end

@interface NBLFileListShowViewController : UIViewController

@property (nonatomic, weak) id<NBLFileListShowViewControllerDelegate> delegate;

@property (nonatomic, copy) NSString *currentLocation;

@property (nonatomic, assign) NBLEditType editType;

@end
