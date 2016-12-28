//
//  NBLFileTypeManager.h
//  NBLFileExplorer
//
//  Created by snb on 16/12/21.
//  Copyright © 2016年 neebel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NBLFileType) {
    kNBLFileTypeJPG, //JPG
    kNBLFileTypeJPEG,//JPEG
    kNBLFileTypePNG, //PNG
    kNBLFileTypeGIF, //GIF
    kNBLFileTypeBMP, //BMP
    
    kNBLFileTypeRAR, //RAR
    kNBLFileTypeZIP, //ZIP
    
    kNBLFileTypeXML, //XML
    kNBLFileTypeHTML,//HTML
    kNBLFileTypeASPX,//ASPX
    kNBLFileTypeCSS, //CSS
    kNBLFileTypeJS,  //JS
    
    kNBLFileTypeTXT, //TXT
    kNBLFileTypePDF, //PDF
    kNBLFileTypeDOC, //DOC
    
    kNBLFileTypeMP3, //MP3
    kNBLFileTypeWMA, //WMA
    kNBLFileTypeAAC, //AAC
    kNBLFileTypeM4A, //M4A
    
    kNBLFileTypeM4V, //M4V
    kNBLFileTypeMP4, //MP4
    kNBLFileTypeMOV, //MOV
    kNBLFileTypeWMV, //WMV
    kNBLFileTypeAVI, //AVI
    
    kNBLFileTypeUnknown,
    
};

@interface NBLFileTypeManager : NSObject

+ (NBLFileType)parseFileType:(NSString *)extension;

+ (UIImage *)searchFileLogoWithFileType:(NBLFileType)fileType;

@end
