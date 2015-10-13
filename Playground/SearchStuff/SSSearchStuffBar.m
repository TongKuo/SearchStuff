//
//  SSSearchStuffBar.m
//  Playground
//
//  Created by Tong G. on 10/4/15.
//  Copyright © 2015 Tong Kuo. All rights reserved.
//

#import "SSSearchStuffBar.h"

#import "__SSSearchStuffBackingCell.h"

// Private Interfaces
@interface SSSearchStuffBar()

@property ( strong ) __SSSearchStuffBackingCell* __backingCell;
@property ( strong ) NSTextField* __inputField;
@property ( assign ) BOOL __isInputting;

- ( void ) __init;

@end // Private Interfaces

// SSSearchStuffBar class
@implementation SSSearchStuffBar

@synthesize __backingCell;
@synthesize __inputField;
@dynamic __isInputting;

#pragma mark - Initializations

- ( instancetype ) initWithCoder: ( NSCoder* )_Coder
    {
    if ( self = [ super initWithCoder: _Coder ] )
        [ self __init ];

    return self;
    }

- ( instancetype ) initWithFrame: ( NSRect )_FrameRect
    {
    if ( self = [ super initWithFrame: _FrameRect ] )
        [ self __init ];

    return self;
    }

#pragma Drawing

- ( void ) drawRect: ( NSRect )_DirtyRect
    {
    [ super drawRect: _DirtyRect ];
    [ self.__backingCell drawWithFrame: self.bounds inView: self ];
    }

- ( NSRect ) focusRingMaskBounds
    {
    return [ self bounds ];
    }

- ( void ) drawFocusRingMask
    {
    NSRectFill( self.bounds );
    }

#pragma mark - Events

- ( void ) mouseDown: ( NSEvent* )_Event
    {
    [ super mouseDown: _Event ];

    [ self.__inputField setFrame: self.bounds ];
    [ self addSubview: self.__inputField ];
    [ self.window makeFirstResponder: self.__inputField ];

    self.__isInputting = YES;
    }

#pragma mark - Conforms to <NSTextFieldDelegate>

- ( void ) controlTextDidEndEditing: ( NSNotification* )_Notif
    {
    [ self.__inputField removeFromSuperview ];
    self.__isInputting = NO;

    // TODO: Waiting for animations
    }

#pragma mark - Dynamic Properties
- ( void ) set__isInputting: ( BOOL )_Flag
    {
    self->__isInputting = _Flag;
    [ self noteFocusRingMaskChanged ];
    }

- ( BOOL ) __isInputting
    {
    return self->__isInputting;
    }

#pragma mark - Private Interfaces

- ( void ) __init
    {
    [ self setWantsLayer: YES ];
    [ self.layer setMasksToBounds: NO ];

    self.__backingCell = [ [ __SSSearchStuffBackingCell alloc ] init ];

    self.__inputField = [ [ NSTextField alloc ] initWithFrame: NSZeroRect ];
    [ self.__inputField setDrawsBackground: NO ];
    [ self.__inputField setBordered: NO ];
    [ self.__inputField setPlaceholderString: NSLocalizedString( @"Search", nil ) ];
    [ self.__inputField setDelegate: self ];

    self.__isInputting = NO;

    [ self setFocusRingType: NSFocusRingTypeExterior ];
    }

@end // SSSearchStuffBar class
