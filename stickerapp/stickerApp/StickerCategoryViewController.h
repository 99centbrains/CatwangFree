//
//  StickerCategoryViewController.h
//  Freedomizer
//
//  Created by Franky Aguilar on 5/19/15.
//
//

#import "ViewController.h"

@class StickerCategoryViewController;

@protocol StickerCategoryViewControllerDelegate <NSObject>

-(void) selectStickerPackQuickViewController:(StickerCategoryViewController *)controller  didFinishPickingStickerImage:(UIImage *)image;
@end


@interface StickerCategoryViewController : ViewController

@property (nonatomic, unsafe_unretained) id <StickerCategoryViewControllerDelegate> delegate;
@end
