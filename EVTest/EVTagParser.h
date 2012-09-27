//
//  EVTagParser.h
//  EVTest
//
//  Created by zhengxx on 12-9-27.
//  Copyright (c) 2012年 zhengxx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EVTagParser : NSObject

+ (NSArray *)tagNamesFromString:(NSString *)tagString;

+ (NSString *)stringFromTagNames:(NSArray *)tags;

@end
