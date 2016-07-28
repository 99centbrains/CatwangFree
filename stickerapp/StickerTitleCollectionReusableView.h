//
//  StickerTitleCollectionReusableView.h
//  CatwangFree
//
//  Created by Fonky on 3/2/15.
//
//

#import <UIKit/UIKit.h>

@class StickerTitleCollectionReusableView;

@protocol StickerTitleCollectionReusableViewDelegate <NSObject>

-(void) stickerTitleClicked;

@end

@interface StickerTitleCollectionReusableView : UICollectionReusableView


@property (nonatomic, unsafe_unretained) id <StickerTitleCollectionReusableViewDelegate> delegate;
@property (nonatomic, weak) IBOutlet UILabel *ibo_title;
@property (nonatomic, weak) IBOutlet UIButton *ibo_buyBtn;

@end
