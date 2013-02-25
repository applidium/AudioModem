//
//  AQTAppDelegate.h
//  AudioQueueTest
//
//  Created by Tarek Belkahia on 11/01/13.
//  Copyright (c) 2013 Applidium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQTRecorder.h"
#import "AQTPlayer.h"

@interface AQTAppDelegate : UIResponder <UIApplicationDelegate> {
    AQTRecorder * _recorder;
    AQTPlayer * _player;
}
@property (strong, nonatomic) IBOutlet UIWindow * window;
@end
