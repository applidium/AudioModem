//
//  AQTRecorder.m
//  AudioQueueTest
//
//  Created by Tarek Belkahia on 11/01/13.
//
//

#import "AQTRecorder.h"

void HandleInputBuffer(void * inUserData,
                       AudioQueueRef inAQ,
                       AudioQueueBufferRef inBuffer,
                       const AudioTimeStamp * inStartTime,
                       UInt32 inNumPackets,
                       const AudioStreamPacketDescription * inPacketDesc) {
    AQRecordState * pRecordState = (AQRecordState *)inUserData;

    if (inNumPackets == 0 && pRecordState->mDataFormat.mBytesPerPacket != 0) {
        inNumPackets = inBuffer->mAudioDataByteSize / pRecordState->mDataFormat.mBytesPerPacket;
    }

    if ( ! pRecordState->mIsRunning) {
        return;
    }

    int i = 0;
    //for (i = 0; i < inBuffer->mAudioDataByteSize / pRecordState->mDataFormat.mBytesPerPacket; i++) {
        double seconds = ((double)(pRecordState->mCurrentPacket + (long)i)) / pRecordState->mDataFormat.mSampleRate;
        double amplitude = ((double)((SInt16 *)inBuffer->mAudioData)[i]) / SHRT_MAX;
        printf("%06f, %+1.9f\n",  seconds, amplitude);
    //}

    pRecordState->mCurrentPacket += inNumPackets;

    AudioQueueEnqueueBuffer(pRecordState->mQueue, inBuffer, 0, NULL);
}

@interface AQTRecorder (Private)
- (void)_setupAudioFormat;
- (void)_deriveBufferSize:(Float64)seconds;
@end

@implementation AQTRecorder
- (void)dealloc {
    AudioQueueDispose(_recordState.mQueue, true);
    [super dealloc];
}

- (void)startRecording {
    [self _setupAudioFormat];
    _recordState.mCurrentPacket = 0;

    OSStatus status = noErr;
    status = AudioQueueNewInput(&_recordState.mDataFormat,
                                HandleInputBuffer,
                                &_recordState,
                                NULL,
                                NULL,
                                0,
                                &_recordState.mQueue);

    ADAssert(noErr == status, @"Could not create queue.");

    [self _deriveBufferSize:0.02f];

    for (int i = 0; i < kNumberBuffers; i++) {
        AudioQueueAllocateBuffer(_recordState.mQueue, _recordState.bufferByteSize, &_recordState.mBuffers[i]);
        AudioQueueEnqueueBuffer(_recordState.mQueue, _recordState.mBuffers[i], 0, NULL);
    }

    ADAssert(noErr == status, @"Could not allocate buffers.");

    _recordState.mIsRunning = YES;
    status = AudioQueueStart(_recordState.mQueue, NULL);

    ADAssert(noErr == status, @"Could not start recording.");
}

- (void)stopRecording {
    if (_recordState.mIsRunning) {
        AudioQueueStop(_recordState.mQueue, true);
        _recordState.mIsRunning = false;
    }
}
@end

@implementation AQTRecorder (Private)
- (void)_setupAudioFormat {
    _recordState.mDataFormat.mFormatID = kAudioFormatLinearPCM;
    _recordState.mDataFormat.mSampleRate = 44100.0f;
    _recordState.mDataFormat.mBitsPerChannel = 16;
    _recordState.mDataFormat.mChannelsPerFrame = 1;
    _recordState.mDataFormat.mFramesPerPacket = 1;
    _recordState.mDataFormat.mBytesPerFrame = _recordState.mDataFormat.mBytesPerPacket = _recordState.mDataFormat.mChannelsPerFrame * sizeof(SInt16);
    _recordState.mDataFormat.mReserved = 0;
    _recordState.mDataFormat.mFormatFlags = kLinearPCMFormatFlagIsNonInterleaved | kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked ;//| kLinearPCMFormatFlagIsBigEndian;
}
- (void)_deriveBufferSize:(Float64)seconds {
    static const int maxBufferSize = 0x50000;

    int maxPacketSize = _recordState.mDataFormat.mBytesPerPacket;

    if (maxPacketSize == 0) {
        UInt32 maxVBRPacketSize = sizeof(maxPacketSize);
        AudioQueueGetProperty(_recordState.mQueue, kAudioQueueProperty_MaximumOutputPacketSize, &maxPacketSize, &maxVBRPacketSize);
    }

    Float64 numBytesForTime = _recordState.mDataFormat.mSampleRate * maxPacketSize * seconds;
    _recordState.bufferByteSize = (UInt32) MIN(numBytesForTime, maxBufferSize);
}
@end