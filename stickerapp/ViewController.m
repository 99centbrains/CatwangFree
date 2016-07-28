//  I'ma Unicorn
//
//  Created by Franky Aguilar on 7/27/12.
//  Copyright (c) 2012 99centbrains Inc. All rights reserved.
//  @99centbrains - http://99centbrains.com
//  ALL ARTWORK AND DESIGN OWNED BY 99centbrains, not for reproduction or redistribution
//
#import "ViewController.h"
#import "PlayViewController.h"
#import "AppDelegate.h"
#import "Flurry.h"
#import "CWInAppHelper.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "SVProgressHUD.h"
#import "SVModalWebViewController.h"

@interface ViewController (){
    

}


@property (nonatomic, strong)UIPopoverController *popController;


@end


@implementation ViewController

@synthesize ibo_getphoto = _ibo_getphoto;

- (void)viewDidLoad {
   
    [super viewDidLoad];
   
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];

    NSLog(@"View Did Appear");
}



//PHOTOS
- (IBAction)iba_photoTake:(id)sender{

        
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        
        
		picker.sourceType = UIImagePickerControllerSourceTypeCamera;
		[self presentViewController:picker animated:YES completion:nil];
        
        
	} else {
        
		[self iba_photoChoose:sender];
        
	}
    
}



- (IBAction)iba_photoChoose:(id)sender{

    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
   
    
    
        
        [self presentViewController:picker animated:YES completion:nil];
        
    
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        
        
        [_popController dismissPopoverAnimated:YES];
        
    } else {
        
                
    }
    [picker dismissViewControllerAnimated:YES completion:nil];

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    PlayViewController *playViewController = (PlayViewController *)[sb instantiateViewControllerWithIdentifier:@"seg_PlayViewController"];

    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        playViewController.userImage = [self editedImageFromMediaWithInfo:info];
        [self.navigationController pushViewController:playViewController animated:YES];
        //
    }];

}

- (IBAction)iba_shareApp:(UIButton *)sender{

    
    NSString *shareText = kShareDescription;
    NSURL *shareURL = [NSURL URLWithString:kShareURL];
    
    NSArray *activityItems = @[shareText, shareURL];
    NSArray *excludeActivities = @[UIActivityTypeAddToReadingList,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypePrint];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc]
                                                    initWithActivityItems:activityItems
                                                    applicationActivities:nil];
    activityController.excludedActivityTypes = excludeActivities;
    
    //CHECK FOR ACTIVITY TYPE AND DISPLAY CORRECT UIDOCUMENTATIONCONTROLLER
    activityController.completionHandler = ^(NSString *activityType, BOOL completed){
        
    };
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        _popController = [[UIPopoverController alloc] initWithContentViewController:activityController];
        _popController.popoverContentSize = CGSizeMake(500, 425);
        [_popController presentPopoverFromRect:[sender convertRect:sender.bounds toView:self.view] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        [SVProgressHUD dismiss];
    
    } else {
        
        [SVProgressHUD dismiss];
        [self presentViewController:activityController animated:YES completion:nil];
    
    }

}

- (IBAction)iba_Facebook:(id)sender{
    
    SVModalWebViewController *modalWeb = [[SVModalWebViewController alloc] initWithURL:[NSURL URLWithString:@"http://facebook.com/99centbrains"]];
    [self presentViewController:modalWeb animated:YES completion:^{
        //
    }];

}

- (IBAction)iba_Twitter:(id)sender{
    
    SVModalWebViewController *modalWeb = [[SVModalWebViewController alloc] initWithURL:[NSURL URLWithString:@"http://twitter.com/catgnaw"]];
    [self presentViewController:modalWeb animated:YES completion:^{
        //
    }];

}

- (IBAction)iba_Insta:(id)sender{
    
    SVModalWebViewController *modalWeb = [[SVModalWebViewController alloc] initWithURL:[NSURL URLWithString:@"http://instagram.com/catgnaw"]];
    [self presentViewController:modalWeb animated:YES completion:^{
        //
    }];

}

- (IBAction)iba_Web:(id)sender{
    
    SVModalWebViewController *modalWeb = [[SVModalWebViewController alloc] initWithURL:[NSURL URLWithString:@"http://catgnaw.com"]];
    [self presentViewController:modalWeb animated:YES completion:^{
        //
    }];

}

//VIEW UNLOAD
- (void)viewDidUnload {
    
    _popController = nil;
    [super viewDidUnload];

}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{

    popoverController = nil;
    NSLog(@"PopOver NIL");

}

-(UIImage*)editedImageFromMediaWithInfo:(NSDictionary*)info{
   
    UIImage *resultImage;
    
    //-(UIImage *)cropImage:(UIImage *)sourceImage cropRect:(CGRect)cropRect aspectFitBounds:(CGSize)finalImageSize fillColor:(UIColor *)fillColor {
    CGSize finalImageSize = CGSizeMake(700, 700);
    UIColor *fillColor = [UIColor clearColor];
    
    
    UIImage *sourceImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    CGRect cropRect = [[info valueForKey:@"UIImagePickerControllerCropRect"] CGRectValue];
    CGImageRef sourceImageRef = sourceImage.CGImage;
    
    //Since the crop rect is in UIImageOrientationUp we need to transform it to match the source image.
    CGAffineTransform rectTransform = [self transformSize:sourceImage.size orientation:sourceImage.imageOrientation];
    CGRect transformedRect = CGRectApplyAffineTransform(cropRect, rectTransform);
    
    //Now we get just the region of the source image that we are interested in.
    CGImageRef cropRectImage = CGImageCreateWithImageInRect(sourceImageRef, transformedRect);
    
    //Figure out which dimension fits within our final size and calculate the aspect correct rect that will fit in our new bounds
    CGFloat horizontalRatio = finalImageSize.width / CGImageGetWidth(cropRectImage);
    CGFloat verticalRatio = finalImageSize.height / CGImageGetHeight(cropRectImage);
    CGFloat ratio = MIN(horizontalRatio, verticalRatio); //Aspect Fit
    CGSize aspectFitSize = CGSizeMake(CGImageGetWidth(cropRectImage) * ratio, CGImageGetHeight(cropRectImage) * ratio);
    
    
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 finalImageSize.width,
                                                 finalImageSize.height,
                                                 CGImageGetBitsPerComponent(cropRectImage),
                                                 0,
                                                 CGImageGetColorSpace(cropRectImage),
                                                 CGImageGetBitmapInfo(cropRectImage));
    
    if (context == NULL) {
        NSLog(@"NULL CONTEXT!");
    }
    
    //Fill with our background color
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, finalImageSize.width, finalImageSize.height));
    
    //We need to rotate and transform the context based on the orientation of the source image.
    CGAffineTransform contextTransform = [self transformSize:finalImageSize orientation:sourceImage.imageOrientation];
    CGContextConcatCTM(context, contextTransform);
    
    //Give the context a hint that we want high quality during the scale
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    
    //Draw our image centered vertically and horizontally in our context.
    CGContextDrawImage(context, CGRectMake((finalImageSize.width-aspectFitSize.width)/2, (finalImageSize.height-aspectFitSize.height)/2, aspectFitSize.width, aspectFitSize.height), cropRectImage);
    
    //Start cleaning up..
    CGImageRelease(cropRectImage);
    
    CGImageRef finalImageRef = CGBitmapContextCreateImage(context);
    resultImage = [UIImage imageWithCGImage:finalImageRef];
    CGContextRelease(context);
    CGImageRelease(finalImageRef);
    
    return [UIImage imageWithData:UIImagePNGRepresentation(resultImage)];
    
}

- (CGAffineTransform) transformSize:(CGSize)imageSize orientation:(UIImageOrientation)orientation {
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (orientation) {
        case UIImageOrientationLeft: { // EXIF #8
            CGAffineTransform txTranslate = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            CGAffineTransform txCompound = CGAffineTransformRotate(txTranslate,M_PI_2);
            transform = txCompound;
            break;
        }
        case UIImageOrientationDown: { // EXIF #3
            CGAffineTransform txTranslate = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            CGAffineTransform txCompound = CGAffineTransformRotate(txTranslate,M_PI);
            transform = txCompound;
            break;
        }
        case UIImageOrientationRight: { // EXIF #6
            CGAffineTransform txTranslate = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            CGAffineTransform txCompound = CGAffineTransformRotate(txTranslate,-M_PI_2);
            transform = txCompound;
            break;
        }
        case UIImageOrientationUp: // EXIF #1 - do nothing
        default: // EXIF 2,4,5,7 - ignore
            break;
    }
    return transform;
}


//EXTERNAL


// EXTERNAL
- (void)handleDocumentOpenURL:(NSString *)url {
    
    if (url) {
        PlayViewController *playViewController;
        
        NSData* data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
        UIImage *image = [UIImage imageWithData:data];
        data = nil;
        
        
        playViewController = [[PlayViewController alloc] initWithNibName:@"PlayViewController" bundle:nil];
        playViewController.userImage = image;
        
        [self presentViewController:playViewController animated:NO completion:nil];
    }
    
}


//UA
- (void)handleExternalURL:(NSString*)url{
    
    NSURL *URL = [NSURL URLWithString:url];
    
    [[UIApplication sharedApplication] openURL:URL];
    
    
}
- (void)handleInternalURL:(NSString*)url{
    
    NSURL *URL = [NSURL URLWithString:url];
    
    [[UIApplication sharedApplication] openURL:URL];
    
}

@end
