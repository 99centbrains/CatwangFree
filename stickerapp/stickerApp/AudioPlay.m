//  I'ma Unicorn
//
//  Created by Franky Aguilar on 7/27/12.
//  Copyright (c) 2012 99centbrains Inc. All rights reserved.
//  @99centbrains - http://99centbrains.com
//  ALL ARTWORK AND DESIGN OWNED BY 99centbrains, not for reproduction or redistribution
//
//

#import "AudioPlay.h"

@implementation AudioPlay
- (id)init{
    
    self = [super init];
    if (self) {
        NSLog(@"AUDIO PLAY");
    
    }
    return self;
}


- (void)playSoundWithFileName:(NSString *)fileName{
    
   /* NSError *error;
    
        NSString *soundFile = [[NSBundle mainBundle] pathForResource:fileName ofType:@"mp3"];
        NSURL *url = [[NSURL alloc] initWithString:soundFile];
    
        audioplayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        audioplayer.delegate = self;
        [audioplayer prepareToPlay];
        [audioplayer  play];
        NSLog(@"%@", [error description]);
    
    */
    
    //
    
    
    NSString *effect;
    NSString *type;
    
    effect = fileName;
       type = @"mp3";
    
        NSUserDefaults *value = [NSUserDefaults standardUserDefaults];
    if ([value boolForKey:@"vol"]) {
        SystemSoundID soundID;
        NSString *path = [[NSBundle mainBundle] pathForResource:effect ofType:type];
        NSURL *url = [NSURL fileURLWithPath:path];
        AudioServicesCreateSystemSoundID ((__bridge CFURLRef)url, &soundID);
        AudioServicesPlaySystemSound(soundID);
    }

    
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"Audio Player Did Finish");
    if (flag){
        player = nil;
    }
}


@end
