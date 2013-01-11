//
//  ADSharedMacros.h
//  AppLibrary
//
//  Created by Adrien on 20/08/10.
//  Copyright 2010 Applidium. All rights reserved.
//

#ifdef ADUseLogs
#define ADLog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define ADLog(format, ...)
#endif

#ifdef ADUseAsserts
#define ADAssert(format, ...) NSAssert(format, ## __VA_ARGS__)
#else
#define ADAssert(format, ...)
#endif

#ifdef ADUseIgnoreUnusedParameters
#define ADIgnoreUnusedParameter(parameter) (void)parameter;
#else
#define ADIgnoreUnusedParameter(parameter)
#endif
