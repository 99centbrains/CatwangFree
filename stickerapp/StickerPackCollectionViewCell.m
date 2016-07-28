//
//  StickerPackCollectionViewCell.m
//  Freedomizer
//
//  Created by Franky Aguilar on 5/25/15.
//
//

#import "StickerPackCollectionViewCell.h"
#import "StickerCollectionViewCell.h"
#import "StickerTitleCollectionReusableView.h"
#import "CWInAppHelper.h"
#import "SVProgressHUD.h"
@implementation StickerPackCollectionViewCell
@synthesize delegate;

- (void)setUp{

    
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSLog(@"Sticker Count %lu", (unsigned long)[_stickerPackDirectory count]);
    NSLog(@"ID %@", _stickerPackID);
    return [_stickerPackDirectory count];
    
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    StickerCollectionViewCell *cell = (StickerCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ibo_cell" forIndexPath:indexPath];

    
    NSString *stickerName = [_stickerPackDirectory objectAtIndex:indexPath.item];
    //NSLog(@"Sticker: %@", stickerName);
    

    stickerName = [stickerName stringByReplacingOccurrencesOfString:@".png" withString:@""];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
        NSData *imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle]
                                                            pathForResource:stickerName ofType:@"png"]];
        dispatch_async(dispatch_get_main_queue(), ^{ // 2
            
            cell.ibo_cellView.image = nil;
            cell.ibo_cellView.image = [UIImage imageWithData:imageData];
            cell.ibo_lockIcon.hidden = _pack_locked;
        
        });
    });
    
   
    
    return cell;
}

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    StickerTitleCollectionReusableView *title = (StickerTitleCollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"packTitle" forIndexPath:indexPath];
    title.ibo_title.text = _stickerPackName;
    title.ibo_buyBtn.hidden = _pack_locked;
    if (!_pack_locked){
        
        [title.ibo_buyBtn setTitle:[[CWInAppHelper sharedHelper] getProductPrice:_stickerPackID] forState:UIControlStateNormal];
    }
    
    return title;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    StickerCollectionViewCell *cell = (StickerCollectionViewCell *)[collectionView
                                                                    cellForItemAtIndexPath:indexPath];
    
    if (!_pack_locked){
        [self buyStickerPack];
        return;
    }
    [self.delegate didFinishPickingStickerImage:cell.ibo_cellView.image];
    
}

- (void) buyStickerPack{
    
    NSLog(@"BUY");
    [SVProgressHUD showWithStatus:@"Unlocking.."];
    [[CWInAppHelper sharedHelper] buyProductWithProductIdentifier:_stickerPackID singleItem:YES];

}

- (void)reload{
    
    [_ibo_collectionView reloadData];
}




@end
