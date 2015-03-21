//  I'ma Unicorn
//
//  Created by Franky Aguilar on 7/27/12.
//  Copyright (c) 2012 99centbrains Inc. All rights reserved.
//  @99centbrains - http://99centbrains.com
//  ALL ARTWORK AND DESIGN OWNED BY 99centbrains, not for reproduction or redistribution
//

#import "PlayEditModeViewController.h"
#import "QuartzCore/QuartzCore.h"
@interface PlayEditModeViewController (){

}


@end

@implementation PlayEditModeViewController



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
    
        
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}



- (IBAction)iba_stickerDone:(id)sender{
    
      [self.delegate editModeStickerDone:self];

}

- (IBAction)iba_stickerFlip:(id)sender{
    
    [self.delegate editModeStickerFlip:self];
    
    
}
- (IBAction)iba_stickerSendToBack:(id)sender{

    [self.delegate editModeLayerMoveDown:self];
    
}

- (IBAction)iba_stickerCopy:(id)sender{

    [self.delegate editModeStickerCopy:self];
    
}

- (IBAction)iba_stickerTrash:(id)sender{
    
    [self.delegate editModeStickerTrash:self];
    
}

- (IBAction)iba_stickerlayerUP:(id)sender{
    [self.delegate editModeLayerMoveUp:self];
}
- (IBAction)iba_stickerLayerDown:(id)sender{
    [self.delegate editModeLayerMoveDown:self];
}

- (void)viewDidUnload {
    
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



@end
