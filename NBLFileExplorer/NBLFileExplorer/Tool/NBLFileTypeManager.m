//
//  NBLFileTypeManager.m
//  NBLFileExplorer
//
//  Created by snb on 16/12/21.
//  Copyright © 2016年 neebel. All rights reserved.
//

#import "NBLFileTypeManager.h"

@implementation NBLFileTypeManager

+ (NBLFileType)parseFileType:(NSString *)extension
{
    NBLFileType fileType;
    if ([extension isEqualToString:@"jpg"]) {
        fileType = kNBLFileTypeJPG;
    } else if ([extension isEqualToString:@"jpeg"]) {
        fileType = kNBLFileTypeJPEG;
    } else if ([extension isEqualToString:@"png"]) {
        fileType = kNBLFileTypePNG;
    } else if ([extension isEqualToString:@"gif"]) {
        fileType = kNBLFileTypeGIF;
    } else if ([extension isEqualToString:@"bmp"]) {
        fileType = kNBLFileTypeBMP;
    } else if ([extension isEqualToString:@"rar"]) {
        fileType = kNBLFileTypeRAR;
    } else if ([extension isEqualToString:@"zip"]) {
        fileType = kNBLFileTypeZIP;
    } else if ([extension isEqualToString:@"xml"]) {
        fileType = kNBLFileTypeXML;
    } else if ([extension isEqualToString:@"html"]) {
        fileType = kNBLFileTypeHTML;
    } else if ([extension isEqualToString:@"aspx"]) {
        fileType = kNBLFileTypeASPX;
    } else if ([extension isEqualToString:@"css"]) {
        fileType = kNBLFileTypeCSS;
    } else if ([extension isEqualToString:@"js"]) {
        fileType = kNBLFileTypeJS;
    } else if ([extension isEqualToString:@"txt"]) {
        fileType = kNBLFileTypeTXT;
    } else if ([extension isEqualToString:@"pdf"]) {
        fileType = kNBLFileTypePDF;
    } else if ([extension isEqualToString:@"doc"]) {
        fileType = kNBLFileTypeDOC;
    } else if ([extension isEqualToString:@"mp3"]) {
        fileType = kNBLFileTypeMP3;
    } else if ([extension isEqualToString:@"wma"]) {
        fileType = kNBLFileTypeWMA;
    } else if ([extension isEqualToString:@"aac"]) {
        fileType = kNBLFileTypeAAC;
    } else if ([extension isEqualToString:@"m4a"]) {
        fileType = kNBLFileTypeM4A;
    } else if ([extension isEqualToString:@"m4v"]) {
        fileType = kNBLFileTypeM4V;
    } else if ([extension isEqualToString:@"mp4"]) {
        fileType = kNBLFileTypeMP4;
    } else if ([extension isEqualToString:@"mov"]) {
        fileType = kNBLFileTypeMOV;
    } else if ([extension isEqualToString:@"wmv"]) {
        fileType = kNBLFileTypeWMV;
    } else if ([extension isEqualToString:@"avi"]) {
        fileType = kNBLFileTypeAVI;
    } else {
        fileType = kNBLFileTypeUnknown;
    }

    return fileType;
}


+ (UIImage *)searchFileLogoWithFileType:(NBLFileType)fileType
{
    NSString *fileTypeStr = nil;
    switch (fileType) {
        case kNBLFileTypeJPG:
            fileTypeStr = @"jpg";
            break;
            
        case kNBLFileTypeJPEG:
            fileTypeStr = @"jpeg";
            break;
            
        case kNBLFileTypePNG:
            fileTypeStr = @"png";
            break;
            
        case kNBLFileTypeGIF:
            fileTypeStr = @"gif";
            break;
            
        case kNBLFileTypeBMP:
            fileTypeStr = @"bmp";
            break;
            
        case kNBLFileTypeRAR:
            fileTypeStr = @"rar";
            break;
            
        case kNBLFileTypeZIP:
            fileTypeStr = @"zip";
            break;
            
        case kNBLFileTypeXML:
            fileTypeStr = @"xml";
            break;
            
        case kNBLFileTypeHTML:
            fileTypeStr = @"html";
            break;
            
        case kNBLFileTypeASPX:
            fileTypeStr = @"aspx";
            break;
            
        case kNBLFileTypeCSS:
            fileTypeStr = @"css";
            break;
            
        case kNBLFileTypeJS:
            fileTypeStr = @"js";
            break;
            
        case kNBLFileTypeTXT:
            fileTypeStr = @"txt";
            break;
            
        case kNBLFileTypePDF:
            fileTypeStr = @"pdf";
            break;
            
        case kNBLFileTypeDOC:
            fileTypeStr = @"doc";
            break;
            
        case kNBLFileTypeMP3:
            fileTypeStr = @"mp3";
            break;
            
        case kNBLFileTypeWMA:
            fileTypeStr = @"wma";
            break;
            
        case kNBLFileTypeAAC:
            fileTypeStr = @"aac";
            break;
            
        case kNBLFileTypeM4A:
            fileTypeStr = @"m4a";
            break;
            
        case kNBLFileTypeM4V:
            fileTypeStr = @"m4v";
            break;
            
        case kNBLFileTypeMP4:
            fileTypeStr = @"mp4";
            break;
            
        case kNBLFileTypeMOV:
            fileTypeStr = @"mov";
            break;
            
        case kNBLFileTypeWMV:
            fileTypeStr = @"wmv";
            break;
            
        case kNBLFileTypeAVI:
            fileTypeStr = @"avi";
            break;
            
        case kNBLFileTypeUnknown:
            fileTypeStr = @"file";
            break;
            
        default:
            break;
    }
    NSString *tmpStr = [NSString stringWithFormat:@"icon.bundle/%@", fileTypeStr];
    return [UIImage imageNamed:tmpStr];
}

@end
