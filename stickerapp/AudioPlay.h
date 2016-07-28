//  I'ma Unicorn
//
//  Created by Franky Aguilar on 7/27/12.
//  Copyright (c) 2012 99centbrains Inc. All rights reserved.
//  @99centbrains - http://99centbrains.com
//  ALL ARTWORK AND DESIGN OWNED BY 99centbrains, not for reproduction or redistribution
//
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface AudioPlay : NSObject <AVAudioPlayerDelegate>{
    AVAudioPlayer *audioplayer;
}

- (void)playSoundWithFileName:(NSString *)fileName;
@end
