//
//  CybrFMStickrViewController.h
//  CatwangFree
//
//  Created by Fonky on 3/2/15.
//
//

#import <UIKit/UIKit.h>

@class CybrFMStickrViewController;

@protocol CybrFMStickrViewControllerDelegate <NSObject>

-(void) selectStickerPackQuickViewController:(CybrFMStickrViewController *)controller
                didFinishPickingStickerImage:(UIImage *)image;

@end

@interface CybrFMStickrViewController : UIViewController



@property (nonatomic, unsafe_unretained) id <CybrFMStickrViewControllerDelegate> delegate;

@end
