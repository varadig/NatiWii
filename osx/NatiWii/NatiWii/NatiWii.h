//
//  NatiWii.h
//  NatiWii
//
//  Created by Váradi Gábor on 7/24/15.
//  Copyright (c) 2015 Váradi Gábor. All rights reserved.
//
#include <Adobe AIR/Adobe AIR.h>

#define EXPORT __attribute__((visibility("default")))



EXPORT
void ExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet);


EXPORT void ExtFinalizer(void* extData);


EXPORT FREObject NWInit(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
EXPORT FREObject NWConnect(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
EXPORT FREObject NWDisconnect(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
EXPORT FREObject NWRumble(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
EXPORT FREObject NWMotionSensing(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);
EXPORT FREObject NWSetFlags(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]);

