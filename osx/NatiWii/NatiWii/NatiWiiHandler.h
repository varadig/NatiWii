//
//  NatiWiiHandler.h
//  NatiWii
//
//  Created by Váradi Gábor on 7/24/15.
//  Copyright (c) 2015 Váradi Gábor. All rights reserved.
//

#include <Foundation/Foundation.h>
#include <Adobe AIR/Adobe AIR.h>
#import "wiiuse.h"
//#include <WiiRemote/WiiRemote.h>

@interface NatiWiiHandler : NSObject
{
    FREContext * context;
    FREObject asClass;
    wiimote** wiimotes;
    int found;
    int connected;
    bool motionsensing;
    NSThread *wiimoteThread;

}
- (id)initWithContext:(FREContext)extensionContext;
-(FREObject) Init:(FREObject) actionScriptClass;
-(FREObject) Connect;
-(FREObject) Disconnect:(FREObject) id;
-(FREObject) Rumble:(FREObject)isOn :(FREObject)id;
-(FREObject) MostionSensing:(FREObject)id :(FREObject)enable;
-(FREObject) SetFlags:(FREObject)id :(FREObject)flag :(FREObject)enable;
-(void) buttonJustPressed:(uint)buttonID :(int)moteID;
-(void) buttonPressed:(uint) buttonID :(int) moteID;
-(void) buttonHeld:(uint) buttonID :(int) moteID;
-(void) buttonReleased:(uint) buttonID :(int) moteID;
-(void) motionSensing:(struct wiimote_t*) wm;
@end

