//
//  SSSearchStuffToolbarItem.h
//  Playground
//
//  Created by Tong G. on 10/4/15.
//  Copyright © 2015 Tong Kuo. All rights reserved.
//

@import Cocoa;

@class SSSearchStuffBar;

@protocol SearchStuffDelegate;

// SSSearchStuffToolbarItem class
@interface SSSearchStuffToolbarItem : NSToolbarItem
    {
@private
    SSSearchStuffBar* __searchBar;
    }

@property ( weak ) IBOutlet id <SearchStuffDelegate> delegate;

@end // SSSearchStuffToolbarItem class

// SSSearchStuffDelegate protocol
@protocol SearchStuffDelegate <NSObject>

@end // SSSearchStuffDelegate protocol