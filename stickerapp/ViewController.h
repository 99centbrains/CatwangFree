//  I'ma Unicorn
//
//  Created by Franky Aguilar on 7/27/12.
//  Copyright (c) 2012 99centbrains Inc. All rights reserved.
//  @99centbrains - http://99centbrains.com
//  ALL ARTWORK AND DESIGN OWNED BY 99centbrains, not for reproduction or redistribution
//

#import <UIKit/UIKit.h>


@interface ViewController : UIViewController <UIImagePickerControllerDelegate, 
UINavigationControllerDelegate, UIActionSheetDelegate, UIPopoverControllerDelegate > {
    
    IBOutlet UIView *ibo_getphoto;
}

- (void)handleDocumentOpenURL:(NSString *)url;
- (void)handleExternalURL:(NSString*)url;
- (void)handleInternalURL:(NSString*)url;



@property (nonatomic, strong) IBOutlet UIView *ibo_getphoto;

@end
