//
//  NBLFileInfo.h
//  NBLFileExplorer
//
//  Created by snb on 16/12/20.
//  Copyright © 2016年 neebel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NBLFileTypeManager.h"

@interface NBLFileInfo : NSObject

@property (nonatomic, copy)   NSString    *fileName;
@property (nonatomic, copy)   NSString    *filePath;
@property (nonatomic, assign) BOOL        isFolder;
@property (nonatomic, assign) NBLFileType fileType;

@end
