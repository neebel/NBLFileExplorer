//
//  NBLFileInfo.m
//  NBLFileExplorer
//
//  Created by snb on 16/12/20.
//  Copyright © 2016年 neebel. All rights reserved.
//

#import "NBLFileInfo.h"

@implementation NBLFileInfo

- (void)setFilePath:(NSString *)filePath
{
    _filePath = filePath;
    _fileType = [NBLFileTypeManager parseFileType:filePath.pathExtension];
}

@end
