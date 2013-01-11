//
//  AudioQueueTest.h
//  AudioQueueTest
//
//  Created by Romain Goyet on 11/04/12.
//  Copyright (c) 2012 Applidium. All rights reserved.
//

// CPP magic to include the file named "AudioQueueTest_$(CONFIGURATION).h"
#define str_(x) #x
#define str2_(x) str_(x)
#define cat_(x,y) x ## y
#define cat2_(x,y) cat_(x,y)
#define ENVIRONMENT_HEADER str2_(cat2_(AudioQueueTest_, CONFIGURATION.h))
#include ENVIRONMENT_HEADER
