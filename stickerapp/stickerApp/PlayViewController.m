//  I'ma Unicorn
//
//  Created by Franky Aguilar on 7/27/12.
//  Copyright (c) 2012 99centbrains Inc. All rights reserved.
//  @99centbrains - http://99centbrains.com
//  ALL ARTWORK AND DESIGN OWNED BY 99centbrains, not for reproduction or redistribution

#import "PlayViewController.h"
#import "QuartzCore/QuartzCore.h"

#import "SelectStickerQuickViewController.h"
#import "StickyImageView.h"
#import "PlayEditModeViewController.h"
#import "ShareViewController.h"
#import "AppDelegate.h"
#import "PaintView.h"
#import "SVProgressHUD.h"
#import "Flurry.h"
#import "UIImage+Trim.h"
#import "PaintToolSetViewController.h"

@interface PlayViewController ()<PaintToolSetViewControllerDelegate>{

    UIPopoverController *popController;
}

- (IBAction)actionStartNew:(id)sender;
- (IBAction)actionSave:(id)sender;
- (IBAction)actionSelectSticker:(id)sender;


- (UIImage *)saveImage;

@property (nonatomic, strong) StickyImageView *currentSticker;
@property (nonatomic, strong) PaintView *paint;
@property (nonatomic, strong) PlayEditModeViewController *ibo_editMode;
@property (nonatomic, strong) PaintToolSetViewController *ibo_paintMode;

@property (nonatomic, strong) UIPopoverController *popController;

@property (nonatomic, weak) IBOutlet UIView* ibo_multpleviews;
@property (nonatomic, weak) IBOutlet UIView* ibo_viewStickerStage;
@property (nonatomic, weak) IBOutlet UIImageView *ibo_imageUser;

@property (nonatomic, weak) IBOutlet UIView *ibo_renderView;
@property (nonatomic, weak) IBOutlet UIView* ibo_toolbarView;


@end

@implementation PlayViewController

@synthesize userImage;
@synthesize paint;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    
    [_ibo_imageUser setImage:userImage];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ui_cropview_checkers.png"]];

    
    //GESTURES
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleToolBar:)];
    doubleTapGesture.delegate = self;
    doubleTapGesture.numberOfTapsRequired = 2;
    doubleTapGesture.numberOfTouchesRequired = 1;
    //[ibo_viewPlayStage addGestureRecognizer:doubleTapGesture];
    
    UILongPressGestureRecognizer *longTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self 
                                action:@selector(clearAllStickers:)];
    longTap.delegate = self;
    longTap.numberOfTouchesRequired = 1;
    longTap.minimumPressDuration = .8;
    longTap.allowableMovement = 2;
    //[ibo_viewPlayStage addGestureRecognizer:longTap];
    
    
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] 
                                                 initWithTarget:self action:@selector(stickyPinch:)];
    pinchRecognizer.delegate = self;
    [self.view addGestureRecognizer:pinchRecognizer];
    
    UIRotationGestureRecognizer *roateRecognizer = [[UIRotationGestureRecognizer alloc] 
                                                    initWithTarget:self action:@selector(stickyRotate:)];
    roateRecognizer.delegate = self;
    [_ibo_viewStickerStage addGestureRecognizer:roateRecognizer];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] 
                                          initWithTarget:self action:@selector(stickyMove:)];
    panGesture.delegate = self;
    [panGesture setMinimumNumberOfTouches:1];
    [panGesture setMaximumNumberOfTouches:2];
    [_ibo_viewStickerStage addGestureRecognizer:panGesture];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeCurrentSticker:) 
                                                 name:@"SetCurrentStickerNotification"
                                               object:nil];


    paint = [[PaintView alloc] initWithFrame:self.view.bounds];
    [_ibo_multpleviews insertSubview:paint belowSubview:_ibo_viewStickerStage];
    paint.backgroundColor = [UIColor clearColor];
    paint.alpha = YES;
    paint.userInteractionEnabled = NO;

    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _ibo_renderView.layer.shadowColor = [UIColor blackColor].CGColor;
    _ibo_renderView.layer.shadowOffset = CGSizeMake(0, 0);
    _ibo_renderView.layer.shadowRadius = 2.0f;
    _ibo_renderView.layer.masksToBounds = NO;
    _ibo_renderView.layer.shadowOpacity = .75f;
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (IBAction)actionSelectSticker:(id)sender{
    

    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    UINavigationController *nav = (UINavigationController *)[sb instantiateViewControllerWithIdentifier:@"seg_NavigationController"];
    
    SelectStickerQuickViewController *vc = [nav.viewControllers objectAtIndex:0];
    vc.delegate = self;
    
    [self presentViewController:nav animated:YES completion:^{
        //
    }];

}

//SELECT STICKER DELEGATES
-(void) selectStickerPackQuickViewController:(SelectStickerQuickViewController *)controller
           didFinishPickingStickerImage:(UIImage *)image {
    
 

    [controller dismissViewControllerAnimated:YES completion:nil];
    controller.delegate = nil;
    controller = nil;
    
    
    //image = [image imageByTrimmingTransparentPixels];
    _currentSticker = [[StickyImageView alloc] initWithImage:[image imageByTrimmingTransparentPixels]];
    
    //[dragger setFrameForFrame];
    _currentSticker.frame = CGRectMake(0,
                                      0,
                                      250,
                                      (image.size.height/image.size.width) * 250);
    
    _currentSticker.contentMode = UIViewContentModeScaleAspectFit;
    _currentSticker.center = CGPointMake(_ibo_viewStickerStage.frame.size.width/2,
                                         _ibo_viewStickerStage.frame.size.height/2);
    _currentSticker.userInteractionEnabled = YES;
    
    _currentSticker.userInteractionEnabled = YES;
    _currentSticker.layer.borderColor = [UIColor colorWithRed:50.0/255.0 green:202.0/255.0 blue:250.0/255.0 alpha:255].CGColor;
    _currentSticker.layer.borderWidth = 5.0f;
    [self setBorderOnCurrentSticker];
    
    [_ibo_viewStickerStage addSubview:_currentSticker];
    [self hideToolBar];
    [self showEditMode];
}


- (void)selectStickerQuickViewControllerDidCancel:(SelectStickerQuickViewController *)controller{
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

-(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

- (void) changeCurrentSticker:(NSNotification *) notification {
    
    [self removeBorderOnCurrentSticker];
    _currentSticker = nil;
    
    [self showEditMode];
    [self hideToolBar];
    
    _currentSticker = notification.object;
    [self setBorderOnCurrentSticker];

    
    [[_currentSticker superview] bringSubviewToFront:_currentSticker];
    
  
}



- (void)showEditMode{
    
    if (!_ibo_editMode){
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        
        _ibo_editMode = (PlayEditModeViewController *)[sb instantiateViewControllerWithIdentifier:@"seg_PlayEditModeViewController"];
        _ibo_editMode.delegate = self;

        _ibo_editMode.delegate = self;
        _ibo_editMode.view.frame = CGRectMake(0,
                                         self.view.bounds.size.height - 100,
                                         self.view.bounds.size.width,
                                         100);
        
        [self.view addSubview:_ibo_editMode.view];
        
       
    }
    
}

- (void)hideEditMode{
    
    [_ibo_editMode.view removeFromSuperview];
    _ibo_editMode.delegate = nil;
    _ibo_editMode = nil;
    
    //[self showSelectedViews:@[_ibo_btn_cam, _ibo_btn_painter, _ibo_btn_text]];

    
}

- (void)showToolBar{
    
    _ibo_toolbarView.hidden = NO;
    
}

- (void)hideToolBar{
    
    _ibo_toolbarView.hidden = YES;
}

- (void)showPainterTool{
    
    if (!_ibo_paintMode){
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        
        _ibo_paintMode = (PaintToolSetViewController *)[sb instantiateViewControllerWithIdentifier:@"seg_PaintToolSetViewController"];
        _ibo_paintMode.delegate = self;
        _ibo_paintMode.view.frame = CGRectMake(0,
                                              self.view.bounds.size.height - 100,
                                              self.view.bounds.size.width,
                                              100);
        
        [self.view addSubview:_ibo_paintMode.view];
        
        
    }
    
}

- (void)hidePainterTool{
    
    [_ibo_paintMode.view removeFromSuperview];
    _ibo_paintMode.delegate = nil;
    _ibo_paintMode = nil;
    
    //[self showSelectedViews:@[_ibo_btn_cam, _ibo_btn_painter, _ibo_btn_text]];
    
    
}

#pragma EDIT MODE
- (void)editModeLayerMoveUp:(SelectStickerQuickViewController *)controller{
    
    int currentStickerIndex = [_ibo_viewStickerStage.subviews indexOfObject:_currentSticker];
    [_ibo_viewStickerStage exchangeSubviewAtIndex:currentStickerIndex+1 withSubviewAtIndex:currentStickerIndex];
    
}

- (void)editModeLayerMoveDown:(SelectStickerQuickViewController *)controller{
    
    int currentStickerIndex = [_ibo_viewStickerStage.subviews indexOfObject:_currentSticker];
    [_ibo_viewStickerStage exchangeSubviewAtIndex:currentStickerIndex- 1 withSubviewAtIndex:currentStickerIndex];
    
}

- (void)editModeStickerDone:(SelectStickerQuickViewController *)controller{
    
    [self hideEditMode];
    [self showToolBar];
    [self removeBorderOnCurrentSticker];
    
    _currentSticker = nil;
    
}
- (void)editModeStickerTrash:(PlayEditModeViewController *)controller{
    
    
    [_currentSticker removeFromSuperview];
    _currentSticker = nil;
    [self showToolBar];
    [self hideEditMode];
    
}


- (void)editModeStickerCopy:(SelectStickerQuickViewController *)controller{
    [self removeBorderOnCurrentSticker];
    
    [self selectStickerPackQuickViewController:nil didFinishPickingStickerImage:_currentSticker.image];

}

- (void) editModeStickerFlip:(PlayEditModeViewController*)controller{

    [_currentSticker flipSticker];
}

#pragma BORDER ARGUMENTS
- (void) setBorderOnCurrentSticker{
    
    if (_currentSticker){
        _currentSticker.backgroundColor = [UIColor colorWithWhite:1 alpha:.5];
        _currentSticker.layer.borderColor = [UIColor magentaColor].CGColor;
        _currentSticker.layer.borderWidth = 3.0f;
    }
    
}

- (void) removeBorderOnCurrentSticker{
    
    if (_currentSticker){
        _currentSticker.backgroundColor = [UIColor clearColor];
        _currentSticker.layer.borderColor = [UIColor clearColor].CGColor;
        _currentSticker.layer.borderWidth = 0.0f;
    }
    
}


#pragma GESTURE
#pragma mark Gesture Recognition
BOOL currenltyScaling = NO;
static CGFloat previousScale = 1.0;

-(void) stickyPinch:(UIPinchGestureRecognizer *)recognizer {
    
    if (_currentSticker) {
        
        if([recognizer state] == UIGestureRecognizerStateEnded) {
            currenltyScaling = NO;
            previousScale = 1.0;
            return;
        }
        currenltyScaling = YES;
        CGFloat newScale = 1.0 - (previousScale - [recognizer scale]);
        
        CGAffineTransform currentTransformation = _currentSticker.transform;
        CGAffineTransform newTransform = CGAffineTransformScale(currentTransformation, newScale, newScale);
        
        _currentSticker.transform = newTransform;
        
        previousScale = [recognizer scale];
    }
    
}


BOOL currentlyRotating = NO;

static CGFloat previousRotation = 0.0;
- (void)stickyRotate:(UIRotationGestureRecognizer *)recognizer {    
    
    //NSLog(@"Rotate");
    if (_currentSticker){
        
    if([recognizer state] == UIGestureRecognizerStateEnded) {
        
        currentlyRotating = NO;
        previousRotation = 0.0;
        return;
    }
    
    currentlyRotating = YES;
    CGFloat newRotation = 0.0 - (previousRotation - [recognizer rotation]);
    
    CGAffineTransform currentTransformation = _currentSticker.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransformation, newRotation);
    
    _currentSticker.transform = newTransform;
    
    previousRotation = [recognizer rotation];
        
    }
    
}

static CGFloat beginX = 0;
static CGFloat beginY = 0;
BOOL toggleToolBar = NO;

-(void)stickyMove:(UIPanGestureRecognizer *) recognizer {

   
    if (_currentSticker){
        StickyImageView *view = _currentSticker;
        
        [[_currentSticker superview] bringSubviewToFront:_currentSticker];
               
        if([recognizer state] == UIGestureRecognizerStateEnded) {
            currentlyRotating = NO;
            
            return;
        
        }
        
        if (view == _currentSticker) {
         

            CGPoint newCenter = [recognizer translationInView:self.view];
            
            if([recognizer state] == UIGestureRecognizerStateBegan) {
                
                beginX = view.center.x;
                beginY = view.center.y;
                
            }
            
            newCenter = CGPointMake(beginX + newCenter.x, beginY + newCenter.y);
            
            [view setCenter:newCenter];
            
        } 
        
    }
    
}



//- (void)clearAllStickers:(UILongPressGestureRecognizer *)tap{
//    
//    if (tap.numberOfTouches == 1){
//
//        
//    if (tap.state != UIGestureRecognizerStateBegan)
//        return;
//    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Clear All?" message:@"Remove all stickers from background?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
//    alertView.tag = 2;
//    [alertView show];
//        
//     }
//    
//}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
} 

typedef enum {
    ClearAllStickersAlertViewTag,
    StartOverAlertViewTag
} AlertViewTag;

- (IBAction)clearAllStickers:(id)sender{
    
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Clear All?" message:@"Remove all stickers from background?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    alertView.tag = ClearAllStickersAlertViewTag;
    paint.userInteractionEnabled = NO;
    [alertView show];

    
}
#pragma CREATE NEW
- (IBAction)actionStartNew:(id)sender{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Start Over?" message:@"Ready to take a new photo?" delegate:self cancelButtonTitle:@"No Thanks" otherButtonTitles:@"Yes", nil];
    alertView.tag = StartOverAlertViewTag;
    [alertView show];

}


#pragma SAVE AND SHARE

- (IBAction)actionSave:(id)sender{
    
    [SVProgressHUD show];
    [self saveImage:^(UIImage *img) {
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        
        ShareViewController *vc = (ShareViewController *)[sb instantiateViewControllerWithIdentifier:@"seg_ShareViewController"];
        vc.userExportedImage = img;
        [self.navigationController pushViewController:vc animated:YES];
    
    }];
    
    
    
    
}

- (void)saveImage:(void (^)(UIImage *))callback{
    
    UIGraphicsBeginImageContextWithOptions(_ibo_renderView.bounds.size, NO, 0);
    [_ibo_renderView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    NSLog(@"Save Image Size %@", NSStringFromCGSize(image.size));
    UIGraphicsEndImageContext();
    
    callback([self imageWithImage:image]);
    
}

- (UIImage *)imageWithImage:(UIImage *)image {
    
    int resolutionScale;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        resolutionScale = 2;
    } else {
        resolutionScale = 4;
    }
    
    float w = image.size.width *  resolutionScale;
    float h = image.size.height *  resolutionScale;
    CGRect bounds = CGRectMake(0.0, 0.0, w, h);
    
    UIGraphicsBeginImageContextWithOptions(bounds.size, NO, 0.0);
    
    [image drawInRect:CGRectMake(0, 0, bounds.size.width, bounds.size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    NSLog(@"New Image Size %@", NSStringFromCGSize(newImage.size));
    UIGraphicsEndImageContext();
    
    return newImage;
    
}


- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    switch ([alertView tag]) {
        case StartOverAlertViewTag:
            if (buttonIndex == 1){

                [self.navigationController popViewControllerAnimated:YES];
            }
            break;
            
        case ClearAllStickersAlertViewTag:
            
            if (_ibo_viewStickerStage.subviews){//Clean Up
                if (buttonIndex == 1){
                    for (UIView *view in _ibo_viewStickerStage.subviews) {
                        [view removeFromSuperview];
                        
                    }
                    [paint clearAll];
                    [self editModeStickerDone:nil];
                }
                
            }
            break;
            
        default:
            break;
    }
    
    
}
//- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
//    switch ([alertView tag]) {
//        case 0:
//            if (buttonIndex == 1){
//                
//                [self dismissViewControllerAnimated:NO completion:^(void){
//                    
//                    ibo_viewPlayStage = nil;
//                    ibo_multpleviews = nil;
//                    ibo_viewStickerStage = nil;
//                    ibo_imageUser = nil;
//                    ibo_renderView = nil;
//                    
//                    [ibo_renderView removeFromSuperview];
//                    
//                    [[NSNotificationCenter defaultCenter] removeObserver:self];
//                    
//                    NSLog(@"PlayView Did Unload");
//                    AudioPlay *player = [[AudioPlay alloc]init];
//                    [player playSoundWithFileName:@"sound_sparkle2"];
//
//                    
//                }];
//                
//            }
//            break;
//            
//        case 1:
//            //
//            break;
//            
//        case 2:
//            if (ibo_viewStickerStage.subviews){//Clean Up
//                if (buttonIndex == 1){
//                    for (UIView *view in ibo_viewStickerStage.subviews) {
//                        [view removeFromSuperview];
//                    }
//                    [self editModeStickerDone:nil];
//                }
//                
//            }
//            break;
//            
//        default:
//            break;
//    }
//}

-(IBAction) selectStickerPainter{
    
    if (_currentSticker){
        [self removeBorderOnCurrentSticker];
        _currentSticker = nil;
    }
    
    [self hideToolBar];
    [self hideEditMode];
    [self showPainterTool];
    
    _ibo_viewStickerStage.userInteractionEnabled = NO;

    paint.userInteractionEnabled = YES;
    
}
- (void) editModePaintSetDone:(PaintToolSetViewController *)controller{
    paint.userInteractionEnabled = NO;
    _ibo_viewStickerStage.userInteractionEnabled = YES;
    [self hidePainterTool];
    [self showToolBar];
}

//PAINT VIEW
- (void) editModePaintSetPaint:(PlayEditModeViewController*)controller{
    [paint setEraser:NO];
}
- (void) editModePaintSetEraser:(PlayEditModeViewController*)controller{
    [paint setEraser:YES];
}
- (void) editModePaintSetSize:(PlayEditModeViewController*)controller withValue:(int)value{
    paint.strokeSize = value;
}



- (void)viewDidUnload {

    [super viewDidUnload];

}

-(void)setView:(UIView*)view {
    if(view != nil) {
        [super setView:view];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
