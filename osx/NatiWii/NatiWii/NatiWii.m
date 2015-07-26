//
//  NatiWii.m
//  NatiWii
//
//  Created by Váradi Gábor on 7/24/15.
//  Copyright (c) 2015 Váradi Gábor. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <Adobe AIR/Adobe AIR.h>
#include "NatiWiiHandler.h"
#include "NatiWii.h"

#define DEFINE_ANE_FUNCTION(fn) FREObject (fn)(FREContext context, void* functionData, uint32_t argc, FREObject argv[])

#define MAP_FUNCTION(fn, data) { (const uint8_t*)(#fn), (data), &(fn) }
#define DISPATCH_STATUS_EVENT(extensionContext, code, status) FREDispatchStatusEventAsync((extensionContext), (uint8_t*)code, (uint8_t*)status)

NatiWiiHandler* NWHandler;

void ContextInitializer( void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet )
{
    static FRENamedFunction functionMap[] = {
        MAP_FUNCTION( NWInit,NULL),
        MAP_FUNCTION( NWConnect,NULL ),
        MAP_FUNCTION( NWDisconnect,NULL ),
        MAP_FUNCTION( NWRumble,NULL ),
        MAP_FUNCTION( NWMotionSensing, NULL),
        MAP_FUNCTION( NWSetFlags, NULL)
    };
    
    *numFunctionsToSet = sizeof( functionMap ) / sizeof( FRENamedFunction );
    *functionsToSet = functionMap;
    
    NWHandler = [[NatiWiiHandler alloc] initWithContext:ctx];
}


void ContextFinalizer(FREContext ctx)
{
    return;
}

void ExtensionInitializer(void** extData, FREContextInitializer* ctxInitializer, FREContextFinalizer* ctxFinalizer)
{
    *ctxInitializer = &ContextInitializer;
    *ctxFinalizer   = &ContextFinalizer;
}

void ExtensionFinalizer(void* extData)
{
    return;
}

DEFINE_ANE_FUNCTION(NWInit)
{
    return [NWHandler Init:argv[0]];
}

DEFINE_ANE_FUNCTION(NWConnect)
{
    return [NWHandler Connect];
}


DEFINE_ANE_FUNCTION(NWDisconnect){
    return [NWHandler Disconnect:argv[0]];
}

DEFINE_ANE_FUNCTION(NWRumble){
    return [NWHandler Rumble:argv[0] :argv[1]];

}

DEFINE_ANE_FUNCTION(NWMotionSensing){
    return [NWHandler MostionSensing:argv[0] :argv[1]];
}
DEFINE_ANE_FUNCTION(NWSetFlags){
    return [NWHandler SetFlags:argv[0] :argv[1] :argv[2]];
}
