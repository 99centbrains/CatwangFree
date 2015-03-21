//
//  StickerCollectionViewCell.m
//  CatwangFree
//
//  Created by Fonky on 2/24/15.
//
//

#import "StickerCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"


@implementation StickerCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setStaticURL:(NSURL *)staticURL
{
    if (_staticURL == staticURL) return;
    
    [_ibo_cellView setImageWithURLRequest:[NSURLRequest requestWithURL:staticURL] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
       
        _ibo_cellView.image = image;
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
        NSLog(@"Failed Image");
        
    }];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [_ibo_cellView setImageWithURL:nil];
    [_ibo_cellView setImage:nil];
}

@end
