//  I'ma Unicorn
//
//  Created by Franky Aguilar on 7/27/12.
//  Copyright (c) 2012 99centbrains Inc. All rights reserved.
//  @99centbrains - http://99centbrains.com
//  ALL ARTWORK AND DESIGN OWNED BY 99centbrains, not for reproduction or redistribution
//

#import "StickyImageView.h"

#define MAXZOOM 1.50f
#define MINZOOM .05f

@implementation StickyImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.exclusiveTouch = YES;
        //self.userInteractionEnabled = YES;
        
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
        
    
    
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
   //NSLog(@"TOUCHING ENDED");
    
    [[NSNotificationCenter defaultCenter] 
    postNotificationName:@"SetCurrentStickerNotification" 
    object:self];
    

}
- (void)flipSticker{

    
    UIImage * flippedImage;
    if (self.image.imageOrientation == UIImageOrientationUpMirrored) {
        flippedImage = [UIImage imageWithCGImage:self.image.CGImage scale:self.image.scale orientation:UIImageOrientationUp];
    } else {
        flippedImage = [UIImage imageWithCGImage:self.image.CGImage scale:self.image.scale orientation:UIImageOrientationUpMirrored];
    }
    self.image = flippedImage;



    flippedImage = nil;


}

    -(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;


    }



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
