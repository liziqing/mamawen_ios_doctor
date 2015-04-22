//
//  NSString+psd.h
//  妈妈问1
//
//  Created by netshow on 15/3/31.
//  Copyright (c) 2015年 netshow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (psd)

- (NSString *)base64Encrypt;

-(NSString *)sha256Encrypt;
@end
