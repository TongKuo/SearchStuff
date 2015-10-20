//
//  __SSPreReloadButton.m
//  Playground
//
//  Created by Tong G. on 10/20/15.
//  Copyright © 2015 Tong Kuo. All rights reserved.
//

#import "__SSPreReloadButton.h"

// __SSPreReloadButton class
@implementation __SSPreReloadButton

#pragma mark - Initializations

- ( instancetype ) initWithFrame: ( NSRect )_Frame
    {
    if ( self = [ super initWithFrame: _Frame ] )
        {
        self.ssImage = [ NSImage imageNamed: @"search-stuff-reload" ];
        self.ssAlternativeImage = [ NSImage imageNamed: @"search-stuff-reload-highlighted" ];
        }

    return self;
    }

@end // __SSPreReloadButton class
