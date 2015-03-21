//  I'ma Unicorn
//
//  Created by Franky Aguilar on 7/27/12.
//  Copyright (c) 2012 99centbrains Inc. All rights reserved.
//  @99centbrains - http://99centbrains.com
//  ALL ARTWORK AND DESIGN OWNED BY 99centbrains, not for reproduction or redistribution
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <Twitter/Twitter.h>

@class ShareViewController;

@protocol ShareViewControllerDelegate <NSObject>

- (void)shareViewDidComplete:(ShareViewController *)controller withMessage:(NSString*)message;

- (void)shareViewDidCompleteNew:(ShareViewController *)controller;


@end

@interface ShareViewController : UIViewController<MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UIDocumentInteractionControllerDelegate, UIAlertViewDelegate>{
    UIImage *userExportedImage;
    
    
}

@property (nonatomic, strong)UIImage *userExportedImage;

@property (nonatomic, weak)IBOutlet UIImageView *ibo_bgView;

@property (nonatomic, unsafe_unretained) id <ShareViewControllerDelegate> delegate;
@property (nonatomic) UIDocumentInteractionController *documentController;

@end
