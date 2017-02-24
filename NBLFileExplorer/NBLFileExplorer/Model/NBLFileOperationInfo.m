//
//  NBLFileOperationInfo.m
//  NBLFileExplorer
//
//  Created by snb on 16/12/30.
//  Copyright © 2016年 neebel. All rights reserved.
//

#import "NBLFileOperationInfo.h"

@implementation NBLFileOperationInfo

- (void)setOperationType:(NBLFileOperationType)operationType
{
    _operationType = operationType;

    switch (operationType) {
        case kNBLFileOperationTypeShowList:
            _operationIcon = [UIImage imageNamed:@"list"];
            _operationName = @"List";
            break;
            
        case kNBLFileOperationTypeShowGallery:
            _operationIcon = [UIImage imageNamed:@"gallery"];
            _operationName = @"Gallery";
            break;
        
        case kNBLFileOperationTypeEdit:
            _operationIcon = [UIImage imageNamed:@"edit"];
            _operationName = @"Edit";
            break;
            
        case kNBLFileOperationTypeSort:
            _operationIcon = [UIImage imageNamed:@"sort"];
            _operationName = @"Sort";
            break;
            
        default:
            break;
    }
}

@end
