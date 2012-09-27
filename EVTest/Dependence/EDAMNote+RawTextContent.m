//
//  EDAMNote+RawTextContent.m
//  EVTest
//
//  Created by zhengxx on 12-9-26.
//  Copyright (c) 2012年 zhengxx. All rights reserved.
//

#import "EDAMNote+RawTextContent.h"
#import "EVTagParser.h"
#import "EvernoteSDK.h"

@implementation EDAMNote (RawTextContent)
- (void)setRawTextContent:(NSString *)content
{
    NSString *template = @"<?xml version=\"1.0\" encoding=\"UTF-8\"?> \
            <!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml2.dtd\"> \
            <en-note>%@</en-note>";

    self.content = [NSString stringWithFormat:template, content];
}

- (NSString *)stringPresentationFromTags
{
    if (self.tagNames)
    {
        return [EVTagParser stringFromTagNames:self.tagNames];
    }
    else
    {
        NSMutableArray *tagNames = [NSMutableArray arrayWithCapacity:self.tagGuids.count];
        for (NSString *guid in self.tagGuids)
        {
            [[EvernoteNoteStore noteStore] getTagWithGuid:guid
                                                  success:^(EDAMTag *tag) {
                                                      [tagNames addObject:tag.name];
                                                  }
                                                  failure:^(NSError *e) {
                                                      // FIXME:zxx 2012-9-27 should notify user
                                                      NSLog(@"Cannot get tagname: %@", e);
                                                  }];
        }

        return [EVTagParser stringFromTagNames:tagNames];
    }
}

- (void)setTagsUsingStringPresentation:(NSString *)stringOfTags
{
    self.tagNames = [EVTagParser tagNamesFromString:stringOfTags];
}

@end
