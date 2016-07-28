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

#import <QuartzCore/QuartzCore.h>
#import "StickerTitleCollectionReusableView.h"
#import <iAd/iAd.h>

#import "CWInAppHelper.h"
#import "StickerPackCollectionViewCell.h"
#import "StickerTitleCollectionReusableView.h"

@interface SelectStickerQuickViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, ADBannerViewDelegate, StickerTitleCollectionReusableViewDelegate, StickerPackCollectionViewCellDelegate>{
    
    BOOL iAdBannerVisible;

}

@property (nonatomic, strong)  NSMutableArray *prop_stickerPacks;
@property (nonatomic, weak)  IBOutlet UIPageControl *ibo_pageControl;
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
    
    
    
}

- (void)viewDidLoad {

    //NSLog(@"PROP %@", [self getStickerPackFromDIR:[_prop_folder_directories objectAtIndex:0]]);
    
    _prop_stickerPacks = [[NSMutableArray alloc] init];
    for (NSArray *pack in _prop_folder_directories){
       
        [_prop_stickerPacks addObject:[self getStickerPackFromDIR:[pack objectAtIndex:2]]];
        //NSLog(@"PROP %@", [self getStickerPackFromDIR:[pack objectAtIndex:2]]);
    }
    
    _ibo_pageControl.numberOfPages = _prop_stickerPacks.count;
    
    //_prop_folder_directories = nil;
    
    
    
   

    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BTN_DONE", @"Title") style:UIBarButtonItemStylePlain target:self action:@selector(iba_dismissCategoryView:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    //NSLog(@"View did Load%@", );
   
    [super viewDidLoad];
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];

    
//    if (![[CWInAppHelper sharedHelper] products]){
//        [[CWInAppHelper sharedHelper] startRequest:@[kBuyKey]];
//    } else {
//        self.navigationItem.leftBarButtonItem.enabled = YES;
//    }
    
//    //iAd
//    if (!_iAdBanner){
//        _iAdBanner = [[ADBannerView alloc] init];
//        _iAdBanner.frame = CGRectOffset(_iAdBanner.frame, 0, self.view.frame.size.height);
//        [self.view addSubview:_iAdBanner];
//        _iAdBanner.delegate = self;
//        iAdBannerVisible = NO;
//    }
//    
    

    
    //
    //PURCHASERS
    [[NSNotificationCenter defaultCenter] addObserverForName:CWIAP_ProductPurchased
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      
                                                      [SVProgressHUD showSuccessWithStatus:@"Purchased"];
                                                      
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          [_ibo_collectionView reloadData];
                                                      });
                                                      
                                                      
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:CWIAP_Restore
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      
                                                     [SVProgressHUD showSuccessWithStatus:@"Restored"];
                                                      
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          [_ibo_collectionView reloadData];
                                                      });
                                                      
                                                  }];
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:CWIAP_ProductsAvailable
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          [_ibo_collectionView reloadData];
                                                          self.navigationItem.leftBarButtonItem.enabled = YES;
                                                      });
                                                      
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
    
    

    
}

- (IBAction)iba_restorePurchases:(id)sender{
    
    NSLog(@"Restore Purchases");
    [[CWInAppHelper sharedHelper] restore_purchases];
    
}


- (void)iba_dismissCategoryView:(id)sender{

    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;

}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    

    return [_prop_stickerPacks count];

}

-(void) stickerTitleClicked {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
}



- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    _ibo_pageControl.currentPage = indexPath.row;
    
    StickerPackCollectionViewCell *cell = (StickerPackCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"packCell" forIndexPath:indexPath];

    cell.stickerPackDirectory = [_prop_stickerPacks objectAtIndex:indexPath.item];
    cell.delegate = self;
    cell.stickerPackID = [[_prop_folder_directories objectAtIndex:indexPath.row] objectAtIndex:0];
    cell.stickerPackName = [[_prop_folder_directories objectAtIndex:indexPath.row] objectAtIndex:1];
    
    NSString *packID = [[_prop_folder_directories objectAtIndex:indexPath.row] objectAtIndex:0];
    cell.pack_locked = [[NSUserDefaults standardUserDefaults] boolForKey:packID];
   
    
    
    //CHECK PURCHASE
    [cell reload];

    //NSLog(@"CELL %@",  [_prop_stickerPacks objectAtIndex:indexPath.item]);

    
    return cell;
}

-(void) didFinishPickingStickerImage:(UIImage *)image{
    
    [self.delegate didFinishPickingStickerImage:image];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

//    StickerCollectionViewCell *cell = (StickerCollectionViewCell *)[collectionView
//                                                                    cellForItemAtIndexPath:indexPath];
//    [self.delegate selectStickerPackQuickViewController:self
//                           didFinishPickingStickerImage:cell.ibo_cellView.image];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize sizer = CGSizeMake(_ibo_collectionView.frame.size.width, _ibo_collectionView.frame.size.height);
    return sizer;
    
}




//GET STICKER PACK DIR FROM ID
- (NSMutableArray *) getStickerPackFromDIR:(NSString *)key{
    NSError *error = nil;
    
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    NSArray *filelist = [filemgr
                         contentsOfDirectoryAtPath:
                         [resourcePath stringByAppendingString:key]
                         error:&error];
    
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    for (NSString *file in filelist){
        [temp addObject:[key stringByAppendingString:file]];
    }
    
    filelist = nil;
    
    return temp;
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
