//
//  EDAMNote+RawTextContent.h
//  EVTest
//
//  Created by zhengxx on 12-9-26.
//  Copyright (c) 2012年 zhengxx. All rights reserved.
//

#import "EDAMTypes.h"

@interface EDAMNote (RawTextContent)
- (void)setRawTextContent:(NSString *)content;

- (NSString *)stringPresentationFromTags;
- (void)setTagsUsingStringPresentation:(NSString *)stringOfTags;
@end
