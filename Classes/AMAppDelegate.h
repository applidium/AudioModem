//
//  AMAppDelegate.h
//  AudioModem
//
//  Created by Tarek Belkahia on 11/01/13.
//  Copyright (c) 2013 Applidium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMRecorder.h"
#import "AMPlayer.h"

@interface AMAppDelegate : UIResponder <UIApplicationDelegate> {
    AMRecorder * _recorder;
    AMPlayer * _player;
}
@property (strong, nonatomic) IBOutlet UIWindow * window;
@end
