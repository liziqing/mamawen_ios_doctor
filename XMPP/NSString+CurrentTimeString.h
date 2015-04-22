//
//  NSString+CurrentTimeString.h
//  妈妈问
//
//  Created by kin on 15/4/1.
//  Copyright (c) 2015年 lixuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CurrentTimeString)
+ (NSString*)getCurrentTimeString;
+ (NSString*)getDocumentPathWithSuffixCompoment:(NSString*)suffix;
@end
