//  I'ma Unicorn
//
//  Created by Franky Aguilar on 7/27/12.
//  Copyright (c) 2012 99centbrains Inc. All rights reserved.
//  @99centbrains - http://99centbrains.com
//  ALL ARTWORK AND DESIGN OWNED BY 99centbrains, not for reproduction or redistribution
//

#import "SelectStickerQuickViewController.h"
#import "SVProgressHUD.h"
#import "CWInAppHelper.h"
#import "StickerCollectionViewCell.h"
#import "Flurry.h"

#import <QuartzCore/QuartzCore.h>
#import "CybrFMStickrViewController.h"
#import "StickerTitleCollectionReusableView.h"
#import <iAd/iAd.h>

#import "CWInAppHelper.h"

@interface SelectStickerQuickViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, ADBannerViewDelegate,CybrFMStickrViewControllerDelegate, StickerTitleCollectionReusableViewDelegate>{
    
    
    BOOL iAdBannerVisible;

    
}



@property (nonatomic, strong)  NSMutableArray *stickerpacks;
@property (nonatomic, strong) NSArray *stickerPackIDs;
@property (nonatomic, strong) NSDictionary *stickerPackDictionary;

@property (nonatomic, strong) ADBannerView *iAdBanner;

@property (nonatomic, weak) IBOutlet UICollectionView *ibo_collectionView;
@end

@implementation SelectStickerQuickViewController



@synthesize delegate = _delegate;




- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)iba_dissmissSelectStickerView:(id)sender {
    
    [self.delegate selectStickerQuickViewControllerDidCancel:self];
    
}

- (void)viewDidLoad {

    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController.navigationBar setTintColor:[UIColor magentaColor]];
    
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BTN_RESTORE", @"Title") style:UIBarButtonItemStylePlain target:self
                                                                  action:@selector(iba_restorePurchases:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    self.navigationItem.leftBarButtonItem.enabled = NO;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BTN_DONE", @"Title") style:UIBarButtonItemStylePlain target:self
                                                                   action:@selector(iba_dismissCategoryView:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    
    self.title = NSLocalizedString(@"TITLE_STICKERS", @"Title");
    self.stickerpacks = [[NSMutableArray alloc] init];
    
    
   
    
    
    NSArray *stickerpack_dir = [[NSArray alloc] initWithObjects:
                                @"/stickers/01_catwang/",

                                nil];
    
    
    
    _stickerPackIDs = [[NSArray alloc] initWithObjects:
                      @"com.99centbrains.catwangfree.01",

                      nil];
    
    _stickerPackDictionary = [[NSMutableDictionary alloc]
                             initWithObjects:stickerpack_dir
                             forKeys:_stickerPackIDs];
    
    
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    
   
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];

    
    if (![[CWInAppHelper sharedHelper] products]){
        [[CWInAppHelper sharedHelper] startRequest:@[kBuyKey]];
    } else {
        self.navigationItem.leftBarButtonItem.enabled = YES;
    }
    
    //iAd
    if (!_iAdBanner){
        _iAdBanner = [[ADBannerView alloc] init];
        _iAdBanner.frame = CGRectOffset(_iAdBanner.frame, 0, self.view.frame.size.height);
        [self.view addSubview:_iAdBanner];
        _iAdBanner.delegate = self;
        iAdBannerVisible = NO;
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:CWIAP_Restore
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          [SVProgressHUD showSuccessWithStatus:@""];
                                                      });
                                                      
                                                  }];
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:CWIAP_ProductsAvailable
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      self.navigationItem.leftBarButtonItem.enabled = YES;
                                                      
                                                  }];

    
}

- (void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];

    //iAd
    if (_iAdBanner){
        [_iAdBanner removeFromSuperview];
        _iAdBanner.delegate = nil;
        _iAdBanner = nil;
        
        iAdBannerVisible = NO;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    
}

- (IBAction)iba_restorePurchases:(id)sender{
    
    NSLog(@"Restore Purchases");
    [[CWInAppHelper sharedHelper] restore_purchases];
    
}


- (void)iba_dismissCategoryView:(id)sender{

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return [_stickerPackIDs count];

}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    

    return [[self getStickerPackWithKey:[_stickerPackIDs objectAtIndex:section]] count];

}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    StickerTitleCollectionReusableView *header = (StickerTitleCollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"titleCell" forIndexPath:indexPath];
    header.ibo_title.text = NSLocalizedString(@"THE_INTERNET", @"Title");
    header.delegate = self;
    return header;
    
}

-(void) stickerTitleClicked {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    CybrFMStickrViewController *vc = (CybrFMStickrViewController *)[sb instantiateViewControllerWithIdentifier:@"seg_CybrFMStickrViewController"];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];

}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    StickerCollectionViewCell *cell = (StickerCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ibo_cell" forIndexPath:indexPath];
    
    
    NSString *stickerName = [[self getStickerPackWithKey:[_stickerPackIDs objectAtIndex:indexPath.section]] objectAtIndex:indexPath.item];
    stickerName = [stickerName stringByReplacingOccurrencesOfString:@".png" withString:@""];

    NSString *fileDir = [self getFileNameForKey:[_stickerPackIDs objectAtIndex:indexPath.section]];

    NSData *imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:
                                                        [fileDir stringByAppendingString:stickerName] ofType:@"png"]];
    
    cell.ibo_cellView.image = [UIImage imageWithData:imageData];
    
    NSLog(@"Cell %@",[fileDir stringByAppendingString:stickerName]);
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    StickerCollectionViewCell *cell = (StickerCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    [self.delegate selectStickerPackQuickViewController:self
                           didFinishPickingStickerImage:cell.ibo_cellView.image];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize sizer;
   
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        sizer = CGSizeMake(_ibo_collectionView.frame.size.width/6,
                           _ibo_collectionView.frame.size.width/6);
    } else {
        sizer = CGSizeMake(_ibo_collectionView.frame.size.width/3,
                          _ibo_collectionView.frame.size.width/3);
    }
    
    
    
    return sizer;
    
}

-(void) selectStickerPackQuickViewController:(CybrFMStickrViewController *)controller
                didFinishPickingStickerImage:(UIImage *)image{

    [self.delegate selectStickerPackQuickViewController:self
                           didFinishPickingStickerImage:image];

}

- (NSString *) getFileNameForKey:(NSString *)key{

    NSString *categoryDirectory = [_stickerPackDictionary objectForKey:key];
    return categoryDirectory;
    
}


//GET STICKER PACK DIR FROM ID
- (NSMutableArray *) getStickerPackWithKey:(NSString *)key{
    NSError *error = nil;
    
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    NSString *categoryDirectory = [_stickerPackDictionary objectForKey:key];
    
    NSArray *filelist = [filemgr
                         contentsOfDirectoryAtPath:
                         [resourcePath stringByAppendingString:categoryDirectory]
                         error:&error];
    if (error) {
        NSLog(@"Error in getStickerPack: %@",[error localizedDescription]);
        
        //[//Flurry logError:@"Error: getStickerPack" message:[error localizedDescription] error:error];
        // filelist = nil;
    }
    
    return [filelist mutableCopy];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma BANNER
- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    
    
    if (!iAdBannerVisible){
        NSLog(@"SHOW BANNER");
        [UIView animateWithDuration:.5 animations:^{
            _iAdBanner.frame = CGRectOffset(_iAdBanner.frame, 0, - _iAdBanner.frame.size.height);
            iAdBannerVisible = YES;
            
        }];
        
    }
    
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    
    
    if (iAdBannerVisible){
        NSLog(@"HIDE BANNER");

        [UIView animateWithDuration:.5 animations:^{
            _iAdBanner.frame = CGRectOffset(_iAdBanner.frame, 0, _iAdBanner.frame.size.height);
            iAdBannerVisible = NO;

        }];
        
    }
}




@end
