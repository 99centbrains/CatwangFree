//  I'ma Unicorn
//
//  Created by Franky Aguilar on 7/27/12.
//  Copyright (c) 2012 99centbrains Inc. All rights reserved.
//  @99centbrains - http://99centbrains.com
//  ALL ARTWORK AND DESIGN OWNED BY 99centbrains, not for reproduction or redistribution
//

#import "ShareViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "Flurry.h"
#import "SVProgressHUD.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import <Chartboost/Chartboost.h>
#import "UIImage+ImageEffects.h"

@interface ShareViewController (){
    IBOutlet UIImageView* ibo_previewImage;
}
- (IBAction)sharePhotoLibrary:(id)sender;
- (IBAction)shareEmail:(id)sender;
- (IBAction)shareTwitter:(id)sender;
- (IBAction)shareFacebook:(id)sender;
- (IBAction)shareInstagram:(id)sender;
- (IBAction)shareMMS;
- (IBAction)selfClose:(id)sender;

@end

@implementation ShareViewController

@synthesize userExportedImage;
@synthesize delegate;
@synthesize documentController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    _ibo_bgView.image = [userExportedImage applyBlurWithRadius:20 tintColor:nil saturationDeltaFactor:1.0 maskImage:nil];
    userExportedImage = [UIImage imageWithData:UIImagePNGRepresentation(userExportedImage)];
    
    ibo_previewImage.image = userExportedImage;
    
    ibo_previewImage.layer.shadowColor = [UIColor blackColor].CGColor;
    ibo_previewImage.layer.shadowOffset = CGSizeMake(0, 0);
    ibo_previewImage.layer.shadowRadius = 2.0f;
    ibo_previewImage.layer.masksToBounds = NO;
    ibo_previewImage.layer.shadowOpacity = .75f;

    
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (IBAction)iba_dismissVC:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [SVProgressHUD dismiss];
    [Chartboost showInterstitial:CBLocationHomeScreen];

}

- (IBAction)sharePhotoLibrary:(id)sender {
    

    NSLog(@"Share Photo Libarary");
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    [library saveImage:userExportedImage toAlbum:kAlbumName withCompletionBlock:^(NSError *error) {
        if (error!=nil) {
            NSLog(@"Big error: %@", [error description]);
            [Flurry logError:@"Error: sharePhotoLibrary" message:[error localizedDescription] error:error];
        }
    }];
    
    // UIImageWriteToSavedPhotosAlbum(userExportedImage,nil,@selector(sharePhotoLibraryComplete:),nil);
	//[self sharePhotoLibraryComplete];
    [SVProgressHUD showSuccessWithStatus:@"Saved!"];
    [Flurry logEvent:@"Share - Saved Image"];
    
}

- (void)sharePhotoLibraryComplete {
    
    
    [self.delegate shareViewDidComplete:self withMessage:@"Saved"];
    
}


- (IBAction)shareEmail:(id)sender {
    
    [Flurry logEvent:@"Share - Emailed"];
    
    if (![MFMailComposeViewController canSendMail]){
        return;
    }
    
    MFMailComposeViewController *emailController = [[MFMailComposeViewController alloc] init];
    emailController.mailComposeDelegate = self;
    
    NSMutableString *emailBody = [[NSMutableString alloc] initWithString:@"<html><body>"];
    [emailBody appendString:@"<p>"];
    [emailBody appendString:kShareDescription];
    [emailBody appendString:@"</p>"];
    [emailBody appendString:@"</body></html>"];
    
    NSData *imageData = UIImagePNGRepresentation(userExportedImage);
    
    [emailController setSubject:kShareSubject];
    [emailController addAttachmentData:imageData mimeType:@"image/png" fileName:@"Photo.png"];
    [emailController setMessageBody:emailBody isHTML:YES];
    
    [self presentViewController:emailController animated:YES completion:nil];
    
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (result ==     MessageComposeResultSent){
        [self.delegate shareViewDidComplete:self withMessage:@"Sent"];
    } else {
        [self.delegate shareViewDidComplete:self withMessage:@"Failed"];
    }
    
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MessageComposeResultSent){
        [SVProgressHUD showSuccessWithStatus:@"Sent"];
    } else {
        [SVProgressHUD showErrorWithStatus:@"Failed"];
    }
    
    
    controller = nil;
    
    return;
}



- (IBAction)shareTwitter:(id)sender {
    
    [Flurry logEvent:@"Share - Twitter"];
    
    if ([[[UIDevice currentDevice] systemVersion] compare:@"6.0" options:NSNumericSearch] != NSOrderedAscending) {
        SLComposeViewController *twController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        SLComposeViewControllerCompletionHandler __block completionHandler =
        ^(SLComposeViewControllerResult result) {
            
            [twController dismissViewControllerAnimated:YES completion:nil];
            
            if(result == SLComposeViewControllerResultDone) {
                
            }
        };
        
        [twController addImage:userExportedImage];
        [twController setInitialText:kShareDescription];
        [twController setCompletionHandler:completionHandler];
        [self presentViewController:twController animated:YES completion:nil];
    } else {
        if ([TWTweetComposeViewController canSendTweet]) {
            TWTweetComposeViewController *tweetSheet = [[TWTweetComposeViewController alloc] init];
            [tweetSheet addImage:userExportedImage];
            [tweetSheet setInitialText:kShareDescription];
            [self presentViewController:tweetSheet animated:YES completion:^(void){
            }];
            
        } else {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Sorry"
                                      message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
        }
    }
    
}

- (IBAction)shareFacebook:(id)sender{
    
    [Flurry logEvent:@"Share - Facebook"];
    
    if ([[[UIDevice currentDevice] systemVersion] compare:@"6.0" options:NSNumericSearch] != NSOrderedAscending){
        
        SLComposeViewController *fbController = [SLComposeViewController
                                                 composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        SLComposeViewControllerCompletionHandler __block completionHandler=
        ^(SLComposeViewControllerResult result){
            
            [fbController dismissViewControllerAnimated:YES completion:nil];
            
            switch(result){
                case SLComposeViewControllerResultCancelled:
                default:
                {
                    
                    
                }
                    break;
                case SLComposeViewControllerResultDone:
                {
              
                    //[self.delegate shareViewDidComplete:self withMessage:@"Posted"];
                    [SVProgressHUD showSuccessWithStatus:@"Posted"];
                }
                    break;
            }};
        
        [fbController addImage:userExportedImage];
        [fbController setInitialText:kShareDescription];
        [fbController setCompletionHandler:completionHandler];
        [self presentViewController:fbController animated:YES completion:nil];
        
    } else {
        
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't send a post to facebook right now. Make sure you have a Facebook account setup for iOS6."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
        
    }
    
}


- (IBAction)shareInstagram:(id)sender{
    
    [Flurry logEvent:@"Share - Instagram"];
    
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        
        NSURL *url;
        
        CGRect rect = CGRectMake(0 ,0 , 0, 0);
        UIImage *i = userExportedImage;
        
        CGRect cropRect = CGRectMake(0, 0, i.size.width, i.size.height);
        NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Share.igo"];
        CGImageRef imageRef = CGImageCreateWithImageInRect([userExportedImage CGImage], cropRect);
        UIImage *img = [[UIImage alloc] initWithCGImage:imageRef];
        CGImageRelease(imageRef);
        [UIImagePNGRepresentation(img) writeToFile:jpgPath atomically:YES];
        url = [[NSURL alloc] initFileURLWithPath:jpgPath];
        
        UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL:url];
        interactionController.UTI = @"com.instagram.exclusivegram";
        interactionController.annotation = [NSDictionary dictionaryWithObject:kInstagramParam forKey:@"InstagramCaption"];
        interactionController.delegate = self;
        
        self.documentController = interactionController;
        [self.documentController presentOpenInMenuFromRect:rect inView:self.view animated:YES];
        
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"No Instagram" message:@"Looks like you dont have Instagram on this device!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}


- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if ([alertView tag] == 0){
        if (buttonIndex == 1){
            [self.view removeFromSuperview];
        }
    }
    
    
    if ([alertView tag] == 45){
        NSURL *url = [NSURL URLWithString:@"sms:"];
        [[UIApplication sharedApplication] openURL:url];
    }
    
    
}
- (IBAction)shareMMS{
    [Flurry logEvent:@"Share - MMS"];
    
    if(![MFMessageComposeViewController canSendText]) {
        
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support MMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
        
    }
    
    NSData *imgData = UIImagePNGRepresentation(userExportedImage);
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController addAttachmentData:imgData typeIdentifier:(NSString *)kUTTypePNG filename:@"catwang.png"];
    
    [self presentViewController:messageController animated:YES completion:nil];
    
}




- (IBAction)iba_externalApp:(id)sender{

    NSLog(@"Send to External App");
    
    NSString * pngPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/99centbrains.png"];
    
    [UIImagePNGRepresentation(userExportedImage)writeToFile:pngPath atomically:YES];
    
    NSURL *url = [[NSURL alloc] initFileURLWithPath:pngPath];
    
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL:url];
    //interactionController.annotation = [NSDictionary dictionaryWithObject:kInstagramParam forKey:@"InstagramCaption"];
    interactionController.delegate = self;
    
    self.documentController = interactionController;
    CGRect rect = CGRectMake(0 ,0 , 0, 0);
    [self.documentController presentOpenInMenuFromRect:rect inView:self.view animated:YES];
    
}


- (void)viewDidUnload {
   
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
