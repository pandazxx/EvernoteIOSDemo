//
//  EVENMLParser.h
//  EVTest
//
//  Created by zhengxx on 12-9-26.
//  Copyright (c) 2012年 zhengxx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EVPlainENMLParser : NSObject

@property (nonatomic, readonly, retain) NSString *plainTextContent;

- (id)initWithXMLContent:(NSString *)content;

- (void)parse;
@end