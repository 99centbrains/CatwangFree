//
//  PaintToolSetViewController.h
//  CatwangFree
//
//  Created by Fonky on 2/24/15.
//
//

#import <UIKit/UIKit.h>
@class PaintToolSetViewController;

@protocol PaintToolSetViewControllerDelegate <NSObject>


- (void) editModePaintSetPaint:(PaintToolSetViewController*)controller;
- (void) editModePaintSetEraser:(PaintToolSetViewController*)controller;
- (void) editModePaintSetDone:(PaintToolSetViewController*)controller;
- (void) editModePaintSetSize:(PaintToolSetViewController*)controller withValue:(int)value;
@end

@interface PaintToolSetViewController : UIViewController


@property (nonatomic, unsafe_unretained) id <PaintToolSetViewControllerDelegate> delegate;

@end
