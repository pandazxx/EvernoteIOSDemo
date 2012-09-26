//
//  EVENMLParser.m
//  EVTest
//
//  Created by zhengxx on 12-9-26.
//  Copyright (c) 2012年 zhengxx. All rights reserved.
//

#import "EVPlainENMLParser.h"

@interface EVPlainENMLParser () <NSXMLParserDelegate>
@property (nonatomic, retain) NSMutableString *tempBuffer;
@property (nonatomic, retain) NSXMLParser *parser;
@property (nonatomic, retain) NSString *plainTextContent;
@end


@implementation EVPlainENMLParser
@synthesize tempBuffer = _tempBuffer;
@synthesize parser = _parser;
@synthesize plainTextContent = _plainTextContent;

- (id)initWithXMLContent:(NSString *)content
{
    if (self = [super init])
    {
        self.parser = [[[NSXMLParser alloc] initWithData:[content dataUsingEncoding:NSUTF8StringEncoding]] autorelease];
        self.parser.delegate = self;

    }

    return self;
}

- (void)dealloc
{
    self.parser.delegate = nil;
    
    [_tempBuffer release];
    [_plainTextContent release];
    [_parser release];

    [super dealloc];
}

- (void)parse
{
    [self.parser parse];
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName compare:@"en-note" options:NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        self.tempBuffer = [NSMutableString string];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [self.tempBuffer appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName compare:@"en-note" options:NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        self.plainTextContent = self.tempBuffer;
        self.tempBuffer = nil;
    }
}


@end
