//  I'ma Unicorn
//
//  Created by Franky Aguilar on 7/27/12.
//  Copyright (c) 2012 99centbrains Inc. All rights reserved.
//  @99centbrains - http://99centbrains.com
//  ALL ARTWORK AND DESIGN OWNED BY 99centbrains, not for reproduction or redistribution
//

#import <UIKit/UIKit.h>

@interface PaintView : UIView {
    void *cacheBitmap;
    CGContextRef cacheContext;
    float hue;
    
    CGPoint point0;
    CGPoint point1;
    CGPoint point2;
    CGPoint point3;
    NSString *colorType;
    BOOL eraser;
}
- (BOOL) initContext:(CGSize)size;

- (void) clearAll;
- (void) drawToCache;
@property (nonatomic) BOOL eraser;
@property (nonatomic) NSString *colorType;
@property (nonatomic) int strokeSize;
@end
