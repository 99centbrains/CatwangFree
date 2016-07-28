//  I'ma Unicorn
//
//  Created by Franky Aguilar on 7/27/12.
//  Copyright (c) 2012 99centbrains Inc. All rights reserved.
//  @99centbrains - http://99centbrains.com
//  ALL ARTWORK AND DESIGN OWNED BY 99centbrains, not for reproduction or redistribution


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>




//SDK Keys
#define kFlurryKey @"VQ7WM6AV4NJANRJ6W9E6"
#define kApplicationProductName @"Catwang"
#define kAppiTunesID 967807794


//Share Copy

#define kShareSubject @"#Catwang by @Catgnaw"
#define kShareDescription @"Get #Catwang free on the appstore."
#define kInstagramParam @"@Catgnaw #Catwang"

//Photo Lib Album Name
#define kAlbumName @"Catwang"

#define kShareURL @"http://catgnaw.com"

//IAP

#define kStickerPack1_page01 @[@"com.99centbrains.catwang.01", @"Free Stuff", @"/stickers/1Catwang/01_catwang/"]
#define kStickerPack1_page02 @[@"com.99centbrains.catwang.02", @"Free Stuff 2", @"/stickers/1Catwang/02_catwang/"]
#define kStickerPack1_page03 @[@"com.99centbrains.catwang.03", @"Free Stuff 3", @"/stickers/1Catwang/03_catwang/"]
#define kStickerPack1 @[@"catwang_banner_01.png", @[kStickerPack1_page01, kStickerPack1_page02, kStickerPack1_page03]]

#define kStickerPack2_page01 @[@"com.99centbrains.catgang.01", @"More Catwang", @"/stickers/2Catgnaw/cw_morecatwang/"]
#define kStickerPack2_page02 @[@"com.99centbrains.catgang.02", @"Even More", @"/stickers/2Catgnaw/cw_evenmorecatwang/"]
#define kStickerPack2_page03 @[@"com.99centbrains.catgang.03", @"Megawang", @"/stickers/2Catgnaw/cw_megawang/"]
#define kStickerPack2_page04 @[@"com.99centbrains.catgang.04", @"Show Me Catwang", @"/stickers/2Catgnaw/cw_showmeyour/"]
#define kStickerPack2_page05 @[@"com.99centbrains.catgang.05", @"FVCK Catwang", @"/stickers/2Catgnaw/cw_fvckcatwang/"]
#define kStickerPack2_page06 @[@"com.99centbrains.catgang.06", @"Sun Burnt", @"/stickers/2Catgnaw/cw_ss13/"]
#define kStickerPack2 @[@"catwang_banner_02.png", @[kStickerPack2_page01, kStickerPack2_page02, kStickerPack2_page03, kStickerPack2_page04, kStickerPack2_page05, kStickerPack2_page06]]

#define kStickerPack3_page01 @[@"com.99centbrains.catgnaw.01", @"OMGlob", @"/stickers/3Catgang/cw_ohmyglob/"]
#define kStickerPack3_page02 @[@"com.99centbrains.catgnaw.02", @"Radical", @"/stickers/3Catgang/cw_radical/"]
#define kStickerPack3_page03 @[@"com.99centbrains.catgnaw.03", @"S.W.A.F", @"/stickers/3Catgang/cw_swaf/"]
#define kStickerPack3 @[@"catwang_banner_03.png", @[kStickerPack3_page01, kStickerPack3_page02, kStickerPack3_page03]]

#define kStickerPack4_page01 @[@"com.99centbrains.eatit.01", @"Super Food", @"/stickers/Eatit/cw_morefood/"]
#define kStickerPack4_page02 @[@"com.99centbrains.eatit.02", @"OMGPizza", @"/stickers/Eatit/cw_omg_pizza/"]
#define kStickerPack4_page03 @[@"com.99centbrains.eatit.03", @"Munchies", @"/stickers/Eatit/cw_stuffit/"]
#define kStickerPack4 @[@"catwang_banner_04.png", @[kStickerPack4_page01, kStickerPack4_page02, kStickerPack4_page03]]

#define kStickerPack5_page01 @[@"com.99centbrains.rockit.01", @"Doodle Squad", @"/stickers/Rockit/cw_doodlesquad/"]
#define kStickerPack5_page02 @[@"com.99centbrains.rockit.02", @"Summer Gear", @"/stickers/Rockit/cw_summer1401/"]
#define kStickerPack5_page03 @[@"com.99centbrains.rockit.03", @"Summer Swag", @"/stickers/Rockit/cw_summer1402/"]
#define kStickerPack5_page04 @[@"com.99centbrains.rockit.04", @"Super Gear", @"/stickers/Rockit/cw_supergear/"]
#define kStickerPack5 @[@"catwang_banner_05.png", @[kStickerPack5_page01, kStickerPack5_page02, kStickerPack5_page03, kStickerPack5_page04]]

#define kStickerPack6_page01 @[@"com.99centbrains.splasher.01", @"Pop Splash", @"/stickers/Splash/cw_moreshapes/"]
#define kStickerPack6_page02 @[@"com.99centbrains.splasher.02", @"More Shapes", @"/stickers/Splash/cw_popsplash/"]
#define kStickerPack6_page03 @[@"com.99centbrains.splasher.03", @"Hollow Swag", @"/stickers/Splash/fillers_01/"]
#define kStickerPack6_page04 @[@"com.99centbrains.splasher.04", @"Big Black", @"/stickers/Splash/fillers_10/"]
#define kStickerPack6 @[@"catwang_banner_06.png", @[kStickerPack6_page01, kStickerPack6_page02, kStickerPack6_page03, kStickerPack6_page04]]


#define kStickerPacks @[kStickerPack1, kStickerPack2, kStickerPack3, kStickerPack4, kStickerPack5, kStickerPack6]

#define kFreePacks @[@"com.99centbrains.catwang.01",@"com.99centbrains.catwang.02",@"com.99centbrains.catwang.03"]

#define kLockedPacks @[@"com.99centbrains.catgang.01",@"com.99centbrains.catgang.02",@"com.99centbrains.catgang.03",@"com.99centbrains.catgang.04",@"com.99centbrains.catgang.05",@"com.99centbrains.catgang.06",@"com.99centbrains.catgnaw.01",@"com.99centbrains.catgnaw.02",@"com.99centbrains.catgnaw.03",@"com.99centbrains.eatit.01",@"com.99centbrains.eatit.02",@"com.99centbrains.eatit.03",@"com.99centbrains.rockit.01",@"com.99centbrains.rockit.02",@"com.99centbrains.rockit.03",@"com.99centbrains.rockit.04",@"com.99centbrains.splasher.03",@"com.99centbrains.splasher.01",@"com.99centbrains.splasher.02",@"com.99centbrains.splasher.03",@"com.99centbrains.splasher.04"]


