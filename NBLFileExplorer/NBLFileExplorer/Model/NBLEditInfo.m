//
//  NBLEditInfo.m
//  NBLFileExplorer
//
//  Created by snb on 2017/2/8.
//  Copyright © 2017年 neebel. All rights reserved.
//

#import "NBLEditInfo.h"

@implementation NBLEditInfo

- (void)setEditType:(NBLEditType)editType
{
    _editType = editType;
    
    switch (editType) {
        case kNBLEditTypeCopy:
            _editIcon = [UIImage imageNamed:@"copy"];
            _editName = @"Copy";
            break;
            
        case kNBLEditTypeCut:
            _editIcon = [UIImage imageNamed:@"cut"];
            _editName = @"Cut";
            break;
            
        case kNBLEditTypeRename:
            _editIcon = [UIImage imageNamed:@"rename"];
            _editName = @"Rename";
            break;
            
        case kNBLEditTypeDelete:
            _editIcon = [UIImage imageNamed:@"delete"];
            _editName = @"Delete";
            break;
            
        default:
            break;
    }
}

@end
