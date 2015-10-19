//
//  __SSSearchButton.m
//  Playground
//
//  Created by Tong G. on 10/19/15.
//  Copyright © 2015 Tong Kuo. All rights reserved.
//

#import "__SSSearchButton.h"

@implementation __SSSearchButton

#pragma mark - Pure Virtual Properties

+ ( NSImage* ) defaultImage
    {
    return [ NSImage imageNamed: @"search-stuff-search" ];
    }

+ ( NSImage* ) defaultAlternativeImage
    {
    return [ NSImage imageNamed: @"search-stuff-search-highlighted" ];
    }

@end
