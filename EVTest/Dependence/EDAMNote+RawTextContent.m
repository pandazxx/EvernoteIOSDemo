//
//  EDAMNote+RawTextContent.m
//  EVTest
//
//  Created by zhengxx on 12-9-26.
//  Copyright (c) 2012年 zhengxx. All rights reserved.
//

#import "EDAMNote+RawTextContent.h"

@implementation EDAMNote (RawTextContent)
- (void)setRawTextContent:(NSString *)content
{
    NSString *template = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?> \
            <!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml2.dtd\"> \
            <en-note>%@</en-note>";

    self.content = [NSString stringWithFormat:template, content];
}

@end
