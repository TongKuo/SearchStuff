/*=============================================================================┐
|    _______           _     _              ______               ___    ___    |  
|   (_______)         | |   (_)            / _____) _           / __)  / __)   |██
|    _____ _   _  ____| |  _ _ ____   ____( (____ _| |_ _   _ _| |__ _| |__    |██
|   |  ___) | | |/ ___) |_/ ) |  _ \ / _  |\____ (_   _) | | (_   __|_   __)   |██
|   | |   | |_| ( (___|  _ (| | | | ( (_| |_____) )| |_| |_| | | |    | |      |██
|   |_|   |____/ \____)_| \_)_|_| |_|\___ (______/  \__)____/  |_|    |_|      |██
|                                   (_____|                                    |██
|                                                                              |██
|      _ ______                        _      ______               ___    ___  |██
|     | / _____)                      | |    / _____) _           / __)  / __) |██
|    / ( (____  _____ _____  ____ ____| |__ ( (____ _| |_ _   _ _| |__ _| |__  |██
|   / / \____ \| ___ (____ |/ ___) ___)  _ \ \____ (_   _) | | (_   __|_   __) |██
|  / /  _____) ) ____/ ___ | |  ( (___| | | |_____) )| |_| |_| | | |    | |    |██
| |_|  (______/|_____)_____|_|   \____)_| |_(______/  \__)____/  |_|    |_|    |██
|                                                                              |██
|                                                                              |██
|                         Copyright (c) 2015 Tong Kuo                          |██
|                                                                              |██
|                             ALL RIGHTS RESERVED.                             |██
|                                                                              |██
└==============================================================================┘██
  ████████████████████████████████████████████████████████████████████████████████
  ██████████████████████████████████████████████████████████████████████████████*/

#import "__SSWidgetsPallet.h"
#import "__SSBar.h"
#import "__SSWidget.h"
#import "__SSConstants.h"

// Private Interfaces
@interface __SSWidgetsPallet ()
- ( void ) __cleanUpSSWidgetsConstraints;
@end // Private Interfaces

// __SSWidgetsPallet class
@implementation __SSWidgetsPallet

@dynamic ssHostingBar;
@dynamic ssType;
@dynamic ssWidgets;

- ( void ) drawRect: ( NSRect )_DirtyRect
    {
    [ super drawRect: _DirtyRect ];

    #if 0 // DEBUG
    srand( ( unsigned int )time( NULL ) );

    CGFloat r = ( CGFloat )( ( random() % 255 ) / 255.f );
    CGFloat g = ( CGFloat )( ( random() % 255 ) / 255.f );
    CGFloat b = ( CGFloat )( ( random() % 255 ) / 255.f );

    NSColor* color = [ NSColor colorWithSRGBRed: r green: g blue: b alpha: 1.f ];
    [ color set ];
    NSRectFill( _DirtyRect );
    #endif // DEBUG
    }

#pragma mark - Initializations

- ( instancetype ) initWithHostingBar: ( __SSBar* )_HostingBar
                                 type: ( __SSWidgetsPalletType )_Type
    {
    if ( !_HostingBar )
        return nil;

    if ( self = [ super initWithFrame: NSZeroRect ] )
        {
        self->__hostingBar = _HostingBar;
        self->__ssType = _Type;
        [ self->__hostingBar addSubview: self ];

        self->__widthConstraint = [ NSLayoutConstraint
            constraintWithItem: self
                     attribute: NSLayoutAttributeWidth
                     relatedBy: ( _Type == __SSWidgetsPalletTypeTitle ) ? NSLayoutRelationGreaterThanOrEqual
                                                                        : NSLayoutRelationEqual
                        toItem: nil
                     attribute: NSLayoutAttributeNotAnAttribute
                    multiplier: 0
                      constant: NSWidth( self.bounds ) /* 0.f */ ];

        [ self addConstraints: @[ self->__widthConstraint ] ];

        self->__ssWidgetsConstraints = [ NSMutableArray array ];

        [ self setTranslatesAutoresizingMaskIntoConstraints: NO ];
        }

    return self;
    }

#pragma mark - Dynamic Properties

- ( NSArray <__kindof __SSWidget*>* ) ssWidgets
    {
    return self.subviews;
    }

- ( void ) setSsWidgets: ( NSArray <__kindof __SSWidget*>* )_Widgets
    {
    [ self __cleanUpSSWidgetsConstraints ];
    [ self setSubviews: _Widgets ];

    CGFloat horGap = 3.5f;
    CGFloat verGap = 3.6f;
    NSDictionary* metrics = @{ @"horGap" : @( horGap )
                             , @"verGap" : @( verGap )
                             };

    NSMutableDictionary* viewsDict = [ NSMutableDictionary dictionary ];
    for ( int _Index = 0; _Index < _Widgets.count; _Index++ )
        {
        [ _Widgets[ _Index ] setTranslatesAutoresizingMaskIntoConstraints: NO ];

        NSString* viewName = [ @"widget" stringByAppendingString: @( _Index ).stringValue ];
        [ viewsDict addEntriesFromDictionary: @{ viewName : _Widgets[ _Index ] } ];
        }

    NSMutableString* horVisualFormat = [ NSMutableString stringWithString: @"H:|" ];

    NSMutableArray* horLayoutConstraints = [ NSMutableArray array ];
    NSMutableArray* verLayoutConstraints = [ NSMutableArray array ];
    switch ( self->__ssType )
        {
        case __SSWidgetsPalletTypeTitle:
            {
            // TODO:
            } break;

        default:
            {
            NSString* headComponent = @"";
            NSString* bodyComponent = @"";
            NSString* tailComponent = @"";

            if ( self->__ssType == __SSWidgetsPalletTypeLeftAnchored
                    || self->__ssType == __SSWidgetsPalletTypeLeftFloat )
                {
                bodyComponent = @"-(==horGap)-[%@(==%@)]";
                tailComponent = @"-(>=0)-|";
                }
            else if ( self->__ssType == __SSWidgetsPalletTypeRightAnchored
                    || self->__ssType == __SSWidgetsPalletTypeRightFloat )
                {
                headComponent = @"-(>=0)";
                bodyComponent = @"-[%@(==%@)]-(==horGap)";
                tailComponent = @"-|";
                }

            // Assembling the head component
            [ horVisualFormat appendString: headComponent ];

            // Assembling the body components
            for ( NSString* _ViewName in viewsDict )
                [ horVisualFormat appendString: [ NSString stringWithFormat: bodyComponent, _ViewName, @( NSWidth( [ viewsDict[ _ViewName ] frame ] ) ) ] ];

            // Assembling the tail component
            [ horVisualFormat appendString: tailComponent ];

            [ horLayoutConstraints addObjectsFromArray:
                [ NSLayoutConstraint constraintsWithVisualFormat: horVisualFormat options: 0 metrics: metrics views: viewsDict ] ];
            } break;
        }

    for ( NSString* _ViewName in viewsDict )
        {
        NSArray* constraints = [ NSLayoutConstraint
            constraintsWithVisualFormat: [ NSString stringWithFormat: @"V:|-(==verGap)-[%@(==%@)]-(>=0)-|", _ViewName, @( NSHeight( [ viewsDict[ _ViewName ] frame ] ) ) ]
                                options: 0
                                metrics: metrics
                                  views: @{ _ViewName : viewsDict[ _ViewName ] } ];

        [ verLayoutConstraints addObjectsFromArray: constraints ];
        }

    [ self->__ssWidgetsConstraints addObjectsFromArray: horLayoutConstraints ];
    [ self->__ssWidgetsConstraints addObjectsFromArray: verLayoutConstraints ];
    [ self addConstraints: self->__ssWidgetsConstraints ];

    self->__widthConstraint.constant = _Widgets.count * ( SS_WIDGETS_FIX_WIDTH + horGap ) + horGap;
    }

- ( __SSBar* ) ssHostingBar
    {
    return self->__hostingBar;
    }

- ( __SSWidgetsPalletType ) ssType
    {
    return self->__ssType;
    }

#pragma mark Private Interfaces

- ( void ) __cleanUpSSWidgetsConstraints
    {
    [ self removeConstraints: self->__ssWidgetsConstraints ];
    [ self->__ssWidgetsConstraints removeAllObjects ];
    }

@end // __SSWidgetsPallet class

/*===============================================================================┐
|                                                                                |
|                           The MIT License (MIT)                                |
|                                                                                |
|                        Copyright (c) 2015 Tong Kuo                             |
|                                                                                |
| Permission is hereby granted, free of charge, to any person obtaining a copy   |
| of this software and associated documentation files (the "Software"), to deal  |
| in the Software without restriction, including without limitation the rights   |
| to use, copy, modify, merge, publish, distribute, sublicense, and/or sell      |
|   copies of the Software, and to permit persons to whom the Software is        |
|         furnished to do so, subject to the following conditions:               |
|                                                                                |
| The above copyright notice and this permission notice shall be included in all |
|              copies or substantial portions of the Software.                   |
|                                                                                |
| THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR     |
| IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,       |
| FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE    |
|  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER        |
| LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,  |
| OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE  |
|                                 SOFTWARE.                                      |
|                                                                                |
└===============================================================================*/