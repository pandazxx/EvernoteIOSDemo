//
//  EVTagParser.m
//  EVTest
//
//  Created by zhengxx on 12-9-27.
//  Copyright (c) 2012年 zhengxx. All rights reserved.
//

#import "EVTagParser.h"
#import "EvernoteSDK.h"

@implementation EVTagParser

+ (NSArray *)tagNamesFromString:(NSString *)tagString
{
    NSArray *tagNames = [tagString componentsSeparatedByString:@" "];
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:tagNames.count];

    for (NSString *tagName in tagNames)
    {
        [ret addObject:tagName];
    }

    return ret;
}

+ (NSString *)stringFromTagNames:(NSArray *)tags
{
    NSMutableString *ret = [NSMutableString string];
    for (NSString *tag in tags)
    {
        [ret appendFormat:@"%@ ", tag];
    }

    return [ret stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
}

@end
