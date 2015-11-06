/*=============================================================================┐
|             _  _  _       _                                                  |  
|            (_)(_)(_)     | |                            _                    |██
|             _  _  _ _____| | ____ ___  ____  _____    _| |_ ___              |██
|            | || || | ___ | |/ ___) _ \|    \| ___ |  (_   _) _ \             |██
|            | || || | ____| ( (__| |_| | | | | ____|    | || |_| |            |██
|             \_____/|_____)\_)____)___/|_|_|_|_____)     \__)___/             |██
|                                                                              |██
|                 ______                   _  _  _ _ _     _ _                 |██
|                (_____ \                 (_)(_)(_|_) |   (_) |                |██
|                 _____) )   _  ____ _____ _  _  _ _| |  _ _| |                |██
|                |  ____/ | | |/ ___) ___ | || || | | |_/ ) |_|                |██
|                | |    | |_| | |   | ____| || || | |  _ (| |_                 |██
|                |_|    |____/|_|   |_____)\_____/|_|_| \_)_|_|                |██
|                                                                              |██
|                                                                              |██
|                         Copyright (c) 2015 Tong Kuo                          |██
|                                                                              |██
|                             ALL RIGHTS RESERVED.                             |██
|                                                                              |██
└==============================================================================┘██
  ██████████████████████████████████████████████████████████████████████████████*/

#import "__SSAttachPanelController.h"
#import "__SSAttachPanel.h"

// Private Interfaces
@interface __SSAttachPanelController ()
@end // Private Interfaces

// __SSAttachPanelController class
@implementation __SSAttachPanelController

@dynamic searchResultsAttachPanel;

@dynamic relativeView;

#pragma mark - Initializations

+ ( instancetype ) controllerWithRelativeView: ( NSView* )_RelativeView
    {
    return [ [ self alloc ] initWithRelativeView: _RelativeView ];
    }

- ( instancetype ) initWithRelativeView: ( NSView* )_RelativeView
    {
    if ( self = [ super initWithWindowNibName: @"__SSAttachPanel" owner: self ] )
        self.relativeView = _RelativeView;

    return self;
    }

- ( void ) windowDidLoad
    {
    [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                selector: @selector( _applicationDidResignActive: )
                                                    name: NSApplicationDidResignActiveNotification
                                                  object: nil ];

    [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                selector: @selector( _applicationDidBecomeActive: )
                                                    name: NSApplicationDidBecomeActiveNotification
                                                  object: nil ];
    }

#pragma mark - Controlling The Attach Panel

- ( void ) popUpAttachPanel
    {
    if ( self.relativeView )
        {
        NSRect windowFrameOfRelativeView = [ self.relativeView convertRect: self.relativeView.frame toView: nil ];
        NSRect screenFrameOfRelativeView = [ self.relativeView.window convertRectToScreen: windowFrameOfRelativeView ];

        NSPoint attachPanelOrigin = screenFrameOfRelativeView.origin;
        attachPanelOrigin.x -= 3.5f;
        attachPanelOrigin.y -= NSHeight( self.searchResultsAttachPanel.frame ) - 4.f;

        [ self popUpAttachPanelOnWindow: self.relativeView.window at: attachPanelOrigin ];
        }

    // TODO: Error Handling
    }

- ( void ) popUpAttachPanelOnWindow: ( NSWindow* )_ParentWindow
                                  at: ( NSPoint )_PointInScreen
    {
    if ( _ParentWindow )
        {
        NSParameterAssert( _ParentWindow != self.searchResultsAttachPanel );
        [ self.searchResultsAttachPanel setFrameOrigin: _PointInScreen ];
        [ _ParentWindow addChildWindow: self.searchResultsAttachPanel ordered: NSWindowAbove ];
        [ self.searchResultsAttachPanel makeKeyAndOrderFront: nil ];
        }
    }

- ( void ) closeAttachPanel
    {
    [ self.searchResultsAttachPanel.parentWindow removeChildWindow: self.searchResultsAttachPanel ];
    [ self.searchResultsAttachPanel orderOut: self ];
    }

- ( void ) closeAttachPanelAndClearResults
    {
    [ self closeAttachPanel ];
    }

#pragma mark - Dynamic Properties

- ( __SSAttachPanel* ) searchResultsAttachPanel
    {
    return ( __SSAttachPanel* )( self.window );
    }

- ( void ) setRelativeView: ( NSView* __nullable )_RelativeView
    {
    NSWindow* relativeWindow = self->_relativeView.window;
    if ( self->_relativeView )
        {
        [ [ NSNotificationCenter defaultCenter ] removeObserver: self
                                                           name: NSWindowWillStartLiveResizeNotification
                                                         object: relativeWindow ];

        [ [ NSNotificationCenter defaultCenter ] removeObserver: self
                                                           name: NSWindowDidEndLiveResizeNotification
                                                         object: relativeWindow ];
        }

    self->_relativeView = _RelativeView;
    [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                selector: @selector( _relativeWindowStartLiveResize: )
                                                    name: NSWindowWillStartLiveResizeNotification
                                                  object: relativeWindow ];

    [ [ NSNotificationCenter defaultCenter ] addObserver: self
                                                selector: @selector( _relativeWindowDidEndResize: )
                                                    name: NSWindowDidEndLiveResizeNotification
                                                  object: relativeWindow ];
    }

- ( NSView* ) relativeView
    {
    return self->_relativeView;
    }

#pragma mark - Private Interfaces

- ( void ) _didEmptySearchContent: ( NSNotification* )_Notif
    {
    [ self closeAttachPanelAndClearResults ];
    }

- ( void ) _applicationDidResignActive: ( NSNotification* )_Notif
    {
    #if DEBUG
    NSLog( @">>> (Log) Application did resign active: \n{\n    %@\n    Observer:%@\n}", _Notif, self );
    #endif

    [ self closeAttachPanel ];
    }

- ( void ) _applicationDidBecomeActive: ( NSNotification* )_Notif
    {
    if ( self.isInUse )
        [ self popUpAttachPanel ];
    }

- ( void ) _relativeWindowStartLiveResize: ( NSNotification* )_Notif
    {
    #if DEBUG
    NSLog( @">>> (Log) Relative window of attach panel starts live resize: \n{\n%@\n}", _Notif );
    #endif

    [ self closeAttachPanel ];
    }

- ( void ) _relativeWindowDidEndResize: ( NSNotification* )_Notif
    {
    #if DEBUG
    NSLog( @">>> (Log) Relative window of attach panel ends live resize: \n{\n%@\n}", _Notif );
    #endif

    if ( self.isInUse )
        [ self popUpAttachPanel ];
    }

@end // __SSAttachPanelController class

/*===============================================================================┐
|                                                                                | 
|                      ++++++     =++++~     +++=     =+++                       | 
|                        +++,       +++      =+        ++                        | 
|                        =+++       ~+++     +        =+                         | 
|                         +++=       =++=   +=        +                          | 
|                          +++        +++= +=        +=                          | 
|                          =+++        ++++=        =+                           | 
|                           +++=       =+++         +                            | 
|                            +++~       +++=       +=                            | 
|                            ,+++      ~++++=     ==                             | 
|                             ++++     +  +++     +                              | 
|                              +++=   +   ~+++   +,                              | 
|                               +++  +:    =+++ ==                               | 
|                               =++++=      +++++                                | 
|                                +++=        +++                                 | 
|                                 ++          +=                                 | 
|                                                                                | 
└===============================================================================*/