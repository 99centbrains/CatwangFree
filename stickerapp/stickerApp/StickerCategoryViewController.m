//
//  StickerCategoryViewController.m
//  Freedomizer
//
//  Created by Franky Aguilar on 5/19/15.
//
//

#import "StickerCategoryViewController.h"
#import "StickerCategoryCollectionViewCell.h"
#import "SelectStickerQuickViewController.h"
#import "CWInAppHelper.h"
#import "SVProgressHUD.h"
@interface StickerCategoryViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, SelectStickerQuickViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *ibo_collectionView;
@property (nonatomic, strong)  NSArray *prop_packs;
@property (nonatomic, strong)  NSArray *prop_pack_dir;
@end

@implementation StickerCategoryViewController
@synthesize delegate;

- (void)viewDidLoad {
    
    _prop_packs = kStickerPacks;
    //NSLog(@"PACKS %@", _prop_packs);
    
    //UNLOCK FREE PACKS
    for (NSString *freeID in kFreePacks){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:freeID];
    }

    self.title = @"Packs";
    
    [self.navigationController.navigationBar setTintColor:[UIColor magentaColor]];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Restore" style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(iba_restorePurchases:)];
    self.navigationItem.leftBarButtonItem = leftButton;
    self.navigationItem.leftBarButtonItem.enabled = NO;
    
    UIBarButtonItem *buttonDone = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(iba_dismissVC:)];
    self.navigationItem.rightBarButtonItem = buttonDone;
    
    
    if (![[CWInAppHelper sharedHelper] products]){
        [[CWInAppHelper sharedHelper] startRequest:kLockedPacks];
        self.navigationItem.leftBarButtonItem.enabled = NO;
        
    } else {
        
       self.navigationItem.leftBarButtonItem.enabled = YES;
        
    }
    
    
    // CATCHERS
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:CWIAP_Restore
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          [SVProgressHUD showSuccessWithStatus:@"Items Restored"];
                                                      });
                                                      
                                                  }];
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:CWIAP_ProductsAvailable
                                                      object:nil
                                                       queue:[[NSOperationQueue alloc] init]
                                                  usingBlock:^(NSNotification *note) {
                                                      
                                                      self.navigationItem.leftBarButtonItem.enabled = YES;
                                                      
                                                  }];

    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)iba_restorePurchases:(id)sender{
    
    NSLog(@"Restore Purchases");
    [[CWInAppHelper sharedHelper] restore_purchases];
    
}

//LIST
//GET STICKER PACK DIR FROM ID
- (NSMutableArray *) getStickerPackWithKey:(NSString *)key{
    NSError *error = nil;
    
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    NSArray *filelist = [filemgr
                         contentsOfDirectoryAtPath:
                         [resourcePath stringByAppendingString:key]
                         error:&error];
    if (error) {
        NSLog(@"Error in getStickerPack: %@",[error localizedDescription]);
        
        //[//Flurry logError:@"Error: getStickerPack" message:[error localizedDescription] error:error];
        // filelist = nil;
    }
    
    return [filelist mutableCopy];
}

- (void) iba_dismissVC:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self.navigationController setNavigationBarHidden:NO];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//COLLECTION
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [_prop_packs count];
}



- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    StickerCategoryCollectionViewCell *cell = (StickerCategoryCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.ibo_Image.image = [UIImage imageNamed:[[_prop_packs objectAtIndex:indexPath.row] objectAtIndex:0]];
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    StickerCategoryCollectionViewCell *cell = (StickerCategoryCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if ([[_prop_packs objectAtIndex:indexPath.row] count] <=1){
        return;
    }
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SelectStickerStoryboard" bundle:nil];
    SelectStickerQuickViewController *selectStickerVC = (SelectStickerQuickViewController *)[sb instantiateViewControllerWithIdentifier:@"seg_SelectStickerQuickViewController"];
    
    selectStickerVC.delegate = self;
    selectStickerVC.title = @"Stickers";
    
    NSMutableArray *packs = [[_prop_packs objectAtIndex:indexPath.row] objectAtIndex:1];
    selectStickerVC.prop_folder_directories = [packs copy];
    [self.navigationController pushViewController:selectStickerVC animated:YES];
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    CGSize sizer = CGSizeMake(_ibo_collectionView.frame.size.width, 250);
    return sizer;
    
}

-(void) didFinishPickingStickerImage:(UIImage *)image{

    [self.delegate selectStickerPackQuickViewController:self didFinishPickingStickerImage:image];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

@end
