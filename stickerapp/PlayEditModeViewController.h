//  I'ma Unicorn
//
//  Created by Franky Aguilar on 7/27/12.
//  Copyright (c) 2012 99centbrains Inc. All rights reserved.
//  @99centbrains - http://99centbrains.com
//  ALL ARTWORK AND DESIGN OWNED BY 99centbrains, not for reproduction or redistribution
//

#import <UIKit/UIKit.h>
@class PlayEditModeViewController;

@protocol PlayEditModeViewControllerDelegate <NSObject>

- (void) editModeLayerMoveUp:(PlayEditModeViewController *)controller;
- (void) editModeLayerMoveDown:(PlayEditModeViewController *)controller;
- (void) editModeStickerDone:(PlayEditModeViewController *)controller;
- (void) editModeStickerCopy:(PlayEditModeViewController*)controller;
- (void) editModeStickerFlip:(PlayEditModeViewController*)controller;

- (void) editModeStickerTrash:(PlayEditModeViewController*)controller;

@end

@interface PlayEditModeViewController : UIViewController

@property (nonatomic, unsafe_unretained) id <PlayEditModeViewControllerDelegate> delegate;

@end
