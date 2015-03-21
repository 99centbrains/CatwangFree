//
//  CybrFMStickrViewController.m
//  CatwangFree
//
//  Created by Fonky on 3/2/15.
//
//

#import "CybrFMStickrViewController.h"
#import "StickerCollectionViewCell.h"
#import "SVProgressHUD.h"
#import <iAd/iAd.h>
#import "CWInAppHelper.h"

@interface CybrFMStickrViewController ()<ADBannerViewDelegate, UIScrollViewDelegate>{

    BOOL iAdBannerVisible;
    NSInteger feedOffset;
    BOOL gettingNewData;
    
    BOOL purchased;
}

@property (nonatomic, weak) IBOutlet UICollectionView *ibo_collectionView;
@property (nonatomic, strong) ADBannerView *iAdBanner;
@property (nonatomic, strong) NSMutableArray *array_Stickers;

#define kStickerFeedURL @"http://api.tumblr.com/v2/blog/cybrfm.99centbrains.com/posts/photo"





@end

@implementation CybrFMStickrViewController

@synthesize delegate;

- (void)viewDidLoad {
    
    purchased = [[NSUserDefaults standardUserDefaults] boolForKey:kBuyKey];
    
    feedOffset = 0;
    gettingNewData = YES;
    

    [SVProgressHUD show];
    _array_Stickers = [[NSMutableArray alloc] init];
    [self requestAPIJsonObject:kStickerFeedURL];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ui_cropview_checkers.png"]];

    
    
    self.title = NSLocalizedString(@"TITLE_STICKERS", @"Title");

    NSString *purchaseBTN = @"🔒";
    
    if (!purchased){
    
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:purchaseBTN style:UIBarButtonItemStylePlain target:self
                                                                           action:@selector(iba_unlockStickers:)];
        self.navigationItem.rightBarButtonItem = rightButton;
        self.navigationItem.rightBarButtonItem.enabled = NO;
    
    }
    
    [[NSNotificationCenter defaultCenter] addObserverForName:CWIAP_ProductPurchased
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      
                                                      [SVProgressHUD showSuccessWithStatus:@""];
                                                      purchased = [[NSUserDefaults standardUserDefaults] boolForKey:kBuyKey];
                                                      
                                                      self.navigationItem.leftBarButtonItem = nil;
                                                  
                                                  }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:CWIAP_Restore
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      
                                                      [SVProgressHUD showSuccessWithStatus:@""];
                                                      
                                                      purchased = [[NSUserDefaults standardUserDefaults] boolForKey:kBuyKey];
                                                      
                                                      self.navigationItem.leftBarButtonItem = nil;
                                                  }];
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:CWIAP_ProductsAvailable
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      self.navigationItem.rightBarButtonItem.enabled = YES;
  
                                                  }];


    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)iba_dismissCategoryView:(id)sender{

    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)iba_unlockStickers:(id)sender{
    
    [[CWInAppHelper sharedHelper] buyProductWithProductIdentifier:kBuyKey singleItem:YES];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    //iAd
    if (!_iAdBanner){
        _iAdBanner = [[ADBannerView alloc] init];
        _iAdBanner.frame = CGRectOffset(_iAdBanner.frame, 0, self.view.frame.size.height);
        [self.view addSubview:_iAdBanner];
        _iAdBanner.delegate = self;
        iAdBannerVisible = NO;
    }
    
    
    if (![[CWInAppHelper sharedHelper] products]){
        self.navigationItem.rightBarButtonItem.enabled = NO;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [_array_Stickers count];
    
}

- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    StickerCollectionViewCell *cell = (StickerCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"ibo_cell" forIndexPath:indexPath];
    
    NSString *fileURL = [[_array_Stickers objectAtIndex:indexPath.item] objectAtIndex:0];
    //NSLog(@"FILE %@", fileURL);
    cell.staticURL = [NSURL URLWithString:fileURL];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!purchased){
        [self iba_unlockStickers:nil];
        return;
    }
    
    StickerCollectionViewCell *cell = (StickerCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (cell.ibo_cellView.image){
        [self.delegate selectStickerPackQuickViewController:self didFinishPickingStickerImage:cell.ibo_cellView.image];
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize sizer;
    
  
    sizer = CGSizeMake(_ibo_collectionView.frame.size.width/3,
                       _ibo_collectionView.frame.size.width/3);
    
    
    return sizer;
    
}

////
#pragma DYNAMIC
#pragma GETJSON ******************************


- (void) requestAPIJsonObject:(NSString *)url{
    
    
    NSString *tumblrAPIKEY = @"NeZwZAOEWLjLutMEryVZd9D3RpAPZmLRXkyB8U30hlt5kpMJSQ";
    NSString *tumblrAPILoadOffset = @"offset=";
    
    NSString *myUrlString = [NSString stringWithFormat:@"%@?api_key=%@&%@%d", url, tumblrAPIKEY, tumblrAPILoadOffset, feedOffset * 20 ];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest
                                       requestWithURL:[NSURL URLWithString:myUrlString]];
    //[urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *error) {
                               if ([data length] >0 && error == nil){
                                   
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       NSLog(@"PARSE REPSONSE");
                                       [self parseResponse:data];
                                   });
                                   
                               }
                               //ERROR - SET HANDLING
                               else if ([data length] == 0 && error == nil){
                                   NSLog(@"Empty Response, not sure why?");
                               }
                               else if (error != nil){
                                   NSLog(@"Not again, what is the error = %@", error);
                               }
                               
                           }];
    
    
}

- (void) parseResponse:(NSData *)data {
    
    NSError *error = nil;
    
    //JSON OBJECT
    id jsonObject = [NSJSONSerialization
                     JSONObjectWithData:data
                     options:NSJSONReadingAllowFragments
                     error:&error];
    
    //json object not nil and no error
    if (jsonObject != nil && error == nil){
        
        NSDictionary *jresponse = [jsonObject objectForKey:@"response"];
        NSArray *postArra = [jresponse objectForKey:@"posts"];
        
        for (NSDictionary *postDictionary in postArra) {
            
            NSArray *photoList = [postDictionary objectForKey:@"photos"];
            
            for (NSDictionary *photoDict in photoList){
                NSLog(@"PHOTO LIST %@", [[photoDict objectForKey:@"original_size"] objectForKey:@"url"]);

                NSMutableArray *photoPost = [[NSMutableArray alloc] init];
                [photoPost addObject:[[photoDict objectForKey:@"original_size"] objectForKey:@"url"]];
                [self addNewCells:photoPost];
                
            }
            
//            for (int i = 0; i < [photoList count]; i++) {
//                
//                NSDictionary *photo = [photoList objectAtIndex:i];
//                NSArray *photoAlternates = [photo objectForKey:@"alt_sizes"];
//                NSDictionary *imager = [photoAlternates objectAtIndex:[photoAlternates count] - 2] ;
//                [photoPost addObject:[imager objectForKey:@"url"]];
//                
//                //NSLog(@"Photo, %@", photo);
//                //NSLog(@"Photo List, %@", imager);
//                //NSLog(@"Photo List, %@", [imager objectForKey:@"url"]);
//                
//                NSDictionary *image = [photo objectForKey:@"original_size"];
//                [photoPost addObject:[image objectForKey:@"url"]];
//                // ADD IMAGE URL to RECIPE ARRAY
//                // [photoPost addObject:[imager objectForKey:@"url"]];
//            }
            
//            NSMutableArray *photoPost = [[NSMutableArray alloc] init];
//            
//            //JSON DICTIONARY
//            NSDictionary *gifImage = [item objectForKey:@"images"];
//            
////            [photoPost addObject:[[gifImage objectForKey:@"fixed_width_still"] objectForKey:@"url"]];
////            [photoPost addObject:[[gifImage objectForKey:@"fixed_width_downsampled"] objectForKey:@"url"]];
//            [photoPost addObject:[[gifImage objectForKey:@"original"]  objectForKey:@"url"]];
//            
//            [self addNewCells:photoPost];
//            photoPost = nil;
            
        }
        
        
        
        
    } else {
        NSLog(@"ERROR DAFUQ");
    }
    
    
}

- (void)addNewCells:(NSMutableArray *)newGifs{
    
    NSInteger resultsSize = [_array_Stickers count];
    [_array_Stickers addObject:newGifs];
 
        
        
        [_ibo_collectionView performBatchUpdates:^{
            
            for (NSInteger i = resultsSize; i < resultsSize + 1; i++){
                
                [_ibo_collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]]];
                //[self loadThumbNail:i];
                
                
            }
            
        } completion:^(BOOL done){
            
            [SVProgressHUD dismiss];
            gettingNewData = NO;
        }];
        
        
}

#pragma Scrolling
-(void)scrollViewDidScroll:(UIScrollView *)sender {
    
    //DETECTS SCROLL TO BOTTOM OF COLLECTION
    CGPoint offset = sender.contentOffset;
    CGRect bounds = sender.bounds;
    CGSize size = sender.contentSize;
    UIEdgeInsets inset = sender.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    
    float reload_distance = -50;
    
    if (!gettingNewData){
        
        if(y > h + reload_distance) {
            gettingNewData = YES;
            feedOffset++;
            [self requestAPIJsonObject:kStickerFeedURL];
            //NSog(@"load more rows");
        }
        
    }
    
}
    


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


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
