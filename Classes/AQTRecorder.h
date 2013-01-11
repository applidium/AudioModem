//
//  AQTRecorder.h
//  AudioQueueTest
//
//  Created by Tarek Belkahia on 11/01/13.
//
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

#define kNumberBuffers 3

typedef struct {
    AudioStreamBasicDescription mDataFormat;
    AudioQueueRef mQueue;
    AudioQueueBufferRef mBuffers[kNumberBuffers];
    UInt32 bufferByteSize;
    SInt64 mCurrentPacket;
    bool mIsRunning;
} AQRecordState;

@interface AQTRecorder : NSObject
@property (nonatomic, assign) AQRecordState recordState;
- (void)startRecording;
- (void)stopRecording;
@end
