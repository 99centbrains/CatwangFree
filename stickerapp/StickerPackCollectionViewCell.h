//
//  StickerPackCollectionViewCell.h
//  Freedomizer
//
//  Created by Franky Aguilar on 5/25/15.
//
//

#import <UIKit/UIKit.h>

@class StickerPackCollectionViewCell;

@protocol StickerPackCollectionViewCellDelegate <NSObject>

-(void) didFinishPickingStickerImage:(UIImage *)image;

@end



@interface StickerPackCollectionViewCell : UICollectionViewCell  <UICollectionViewDataSource, UICollectionViewDelegate>


@property (nonatomic, strong)  NSMutableArray *stickerPackDirectory;
@property (nonatomic, strong)  NSString *stickerPackName;
@property (nonatomic, strong)  NSString *stickerPackID;
@property (nonatomic)  BOOL pack_locked;

@property (nonatomic, weak) IBOutlet UICollectionView *ibo_collectionView;
@property (nonatomic, unsafe_unretained) id <StickerPackCollectionViewCellDelegate> delegate;

- (void)reload;

@end
