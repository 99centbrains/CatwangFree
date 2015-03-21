//  I'ma Unicorn
//
//  Created by Franky Aguilar on 7/27/12.
//  Copyright (c) 2012 99centbrains Inc. All rights reserved.
//  @99centbrains - http://99centbrains.com
//  ALL ARTWORK AND DESIGN OWNED BY 99centbrains, not for reproduction or redistribution
//

#import "PaintView.h"

@implementation PaintView

@synthesize eraser;
@synthesize colorType;
@synthesize  strokeSize;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        hue = 0.0;
        [self initContext:frame.size];
        point0 = CGPointMake(0, 0);
		point1 = CGPointMake(50, 100);
		point2 = CGPointMake(100, 50);
		point3 = CGPointMake(150, 100);
        colorType = @"rainbow";
        eraser = NO;
        //[self drawToCache];
    }
    return self;
}

- (BOOL) initContext:(CGSize)size {
	
    float scale = [[UIScreen mainScreen] scale];

    
	int bitmapByteCount;
	int	bitmapBytesPerRow;
	
	// Declare the number of bytes per row. Each pixel in the bitmap in this
	// example is represented by 4 bytes; 8 bits each of red, green, blue, and
	// alpha.
	bitmapBytesPerRow = (size.width * 4 *scale );
	bitmapByteCount = (bitmapBytesPerRow * size.height);
	
	// Allocate memory for image data. This is the destination in memory
	// where any drawing to the bitmap context will be rendered.
	cacheBitmap = malloc( bitmapByteCount );
	if (cacheBitmap == NULL){
		return NO;
	}
	cacheContext = CGBitmapContextCreate (NULL, size.width * scale, size.height * scale, 8, bitmapBytesPerRow, CGColorSpaceCreateDeviceRGB(), kCGImageAlphaPremultipliedFirst);
    
    CGContextScaleCTM(cacheContext, scale, scale);// <- DOES NOTHING
    CGContextSetRGBFillColor(cacheContext, 1.0, 1.0, 1.0, 0);
    CGContextFillRect(cacheContext, CGRectMake(0, 0, size.width, size.height));
    strokeSize = 5;
	return YES;
    //WSUP JOEY
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    point0 = CGPointMake(-1, -1);
    point1 = CGPointMake(-1, -1); // previous previous point
    point2 = CGPointMake(-1, -1); // previous touch point
    point3 = [touch locationInView:self]; // current touch point
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    point0 = point1;
    point1 = point2;
    point2 = point3;
    point3 = [touch locationInView:self];
    
    if (eraser){
        [self eraseToCache];
    }else {
        [self drawToCache];
        
    }
}

- (void) eraseToCache {
    if(point1.x > -1){
        
       CGContextSetStrokeColorWithColor(cacheContext, [[UIColor blackColor] CGColor]);
        CGContextSetLineCap(cacheContext, kCGLineCapRound);
        CGContextSetLineJoin(cacheContext, kCGLineJoinRound);
        CGContextSetLineWidth(cacheContext, strokeSize);
        CGContextSetBlendMode(cacheContext, kCGBlendModeClear);
        
        
        double x0 = (point0.x > -1) ? point0.x : point1.x; //after 4 touches we should have a back anchor point, if not, use the current anchor point
        double y0 = (point0.y > -1) ? point0.y : point1.y; //after 4 touches we should have a back anchor point, if not, use the current anchor point
        double x1 = point1.x;
        double y1 = point1.y;
        double x2 = point2.x;
        double y2 = point2.y;
        double x3 = point3.x;
        double y3 = point3.y;
        // Assume we need to calculate the control
        // points between (x1,y1) and (x2,y2).
        // Then x0,y0 - the previous vertex,
        //      x3,y3 - the next one.
        
        double xc1 = (x0 + x1) / 2.0;
        double yc1 = (y0 + y1) / 2.0;
        double xc2 = (x1 + x2) / 2.0;
        double yc2 = (y1 + y2) / 2.0;
        double xc3 = (x2 + x3) / 2.0;
        double yc3 = (y2 + y3) / 2.0;
        
        double len1 = sqrt((x1-x0) * (x1-x0) + (y1-y0) * (y1-y0));
        double len2 = sqrt((x2-x1) * (x2-x1) + (y2-y1) * (y2-y1));
        double len3 = sqrt((x3-x2) * (x3-x2) + (y3-y2) * (y3-y2));
        
        double k1 = len1 / (len1 + len2);
        double k2 = len2 / (len2 + len3);
        
        double xm1 = xc1 + (xc2 - xc1) * k1;
        double ym1 = yc1 + (yc2 - yc1) * k1;
        
        double xm2 = xc2 + (xc3 - xc2) * k2;
        double ym2 = yc2 + (yc3 - yc2) * k2;
        double smooth_value = 0.8;
        // Resulting control points. Here smooth_value is mentioned
        // above coefficient K whose value should be in range [0...1].
        float ctrl1_x = xm1 + (xc2 - xm1) * smooth_value + x1 - xm1;
        float ctrl1_y = ym1 + (yc2 - ym1) * smooth_value + y1 - ym1;
        
        float ctrl2_x = xm2 + (xc2 - xm2) * smooth_value + x2 - xm2;
        float ctrl2_y = ym2 + (yc2 - ym2) * smooth_value + y2 - ym2;
        
        CGContextMoveToPoint(cacheContext, point1.x, point1.y);
        CGContextAddCurveToPoint(cacheContext, ctrl1_x, ctrl1_y, ctrl2_x, ctrl2_y, point2.x, point2.y);
        CGContextStrokePath(cacheContext);
        
        CGRect dirtyPoint1 = CGRectMake(point1.x- (strokeSize/2), point1.y- (strokeSize/2), strokeSize, strokeSize);
        CGRect dirtyPoint2 = CGRectMake(point2.x- (strokeSize/2), point2.y- (strokeSize/2), strokeSize, strokeSize);
        [self setNeedsDisplayInRect:CGRectUnion(dirtyPoint1, dirtyPoint2)];
        
    }
}

- (void) drawToCache {
    if(point1.x > -1){
        UIColor *color;
        
        if (colorType == @"rainbow"){
            
            hue += 0.005;
            if(hue > 1.0) hue = 0.0;
            color = [UIColor colorWithHue:hue saturation:0.7 brightness:1.0 alpha:1.0];
            
        } else if (colorType == @"black"){
            color = [UIColor blackColor];
        }
        
        CGContextSetStrokeColorWithColor(cacheContext, [color CGColor]);
        CGContextSetLineCap(cacheContext, kCGLineCapRound);
        CGContextSetLineJoin(cacheContext, kCGLineJoinRound);
        CGContextSetLineWidth(cacheContext, strokeSize);
         CGContextSetBlendMode(cacheContext, kCGBlendModeNormal);
        double x0 = (point0.x > -1) ? point0.x : point1.x; //after 4 touches we should have a back anchor point, if not, use the current anchor point
        double y0 = (point0.y > -1) ? point0.y : point1.y; //after 4 touches we should have a back anchor point, if not, use the current anchor point
        double x1 = point1.x;
        double y1 = point1.y;
        double x2 = point2.x;
        double y2 = point2.y;
        double x3 = point3.x;
        double y3 = point3.y;
        // Assume we need to calculate the control
        // points between (x1,y1) and (x2,y2).
        // Then x0,y0 - the previous vertex,
        //      x3,y3 - the next one.
        
        double xc1 = (x0 + x1) / 2.0;
        double yc1 = (y0 + y1) / 2.0;
        double xc2 = (x1 + x2) / 2.0;
        double yc2 = (y1 + y2) / 2.0;
        double xc3 = (x2 + x3) / 2.0;
        double yc3 = (y2 + y3) / 2.0;
        
        double len1 = sqrt((x1-x0) * (x1-x0) + (y1-y0) * (y1-y0));
        double len2 = sqrt((x2-x1) * (x2-x1) + (y2-y1) * (y2-y1));
        double len3 = sqrt((x3-x2) * (x3-x2) + (y3-y2) * (y3-y2));
        
        double k1 = len1 / (len1 + len2);
        double k2 = len2 / (len2 + len3);
        
        double xm1 = xc1 + (xc2 - xc1) * k1;
        double ym1 = yc1 + (yc2 - yc1) * k1;
        
        double xm2 = xc2 + (xc3 - xc2) * k2;
        double ym2 = yc2 + (yc3 - yc2) * k2;
        double smooth_value = 0.8;
        // Resulting control points. Here smooth_value is mentioned
        // above coefficient K whose value should be in range [0...1].
        float ctrl1_x = xm1 + (xc2 - xm1) * smooth_value + x1 - xm1;
        float ctrl1_y = ym1 + (yc2 - ym1) * smooth_value + y1 - ym1;
        
        float ctrl2_x = xm2 + (xc2 - xm2) * smooth_value + x2 - xm2;
        float ctrl2_y = ym2 + (yc2 - ym2) * smooth_value + y2 - ym2;
        
        CGContextMoveToPoint(cacheContext, point1.x, point1.y);
        CGContextAddCurveToPoint(cacheContext, ctrl1_x, ctrl1_y, ctrl2_x, ctrl2_y, point2.x, point2.y);
        CGContextStrokePath(cacheContext);
        
        CGRect dirtyPoint1 = CGRectMake(point1.x- (strokeSize/2), point1.y- (strokeSize/2), strokeSize, strokeSize);
        CGRect dirtyPoint2 = CGRectMake(point2.x- (strokeSize/2), point2.y- (strokeSize/2), strokeSize, strokeSize);
        [self setNeedsDisplayInRect:CGRectUnion(dirtyPoint1, dirtyPoint2)];
    }
}

- (void) drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGImageRef cacheImage = CGBitmapContextCreateImage(cacheContext);
    CGContextDrawImage(context, self.bounds, cacheImage);
    CGImageRelease(cacheImage);
}

- (void) clearAll {
    
    NSLog(@"CLEAR ALL");
    //CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextClearRect(cacheContext, self.bounds);
    [self setNeedsDisplay];
    [self drawToCache];
    NSLog(@"Paint View Clear");
}

@end
