//
//  StickerTitleCollectionReusableView.m
//  CatwangFree
//
//  Created by Fonky on 3/2/15.
//
//

#import "StickerTitleCollectionReusableView.h"

@implementation StickerTitleCollectionReusableView
@synthesize delegate;

- (IBAction)iba_clickCybr:(id)sender{

    [self.delegate stickerTitleClicked];
}

@end
