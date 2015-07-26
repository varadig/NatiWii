//
//  NatiWiiHandler.m
//  NatiWii
//
//  Created by Váradi Gábor on 7/24/15.
//  Copyright (c) 2015 Váradi Gábor. All rights reserved.
//

#import "NatiWiiHandler.h"
#import "wiiuse.h"
#define MAX_WIIMOTES 4

/*NatiWiiEvents*/
#define CONNECTED "CONNECTED"
#define CONNECTING "CONNECTING"
#define DISCONNECTED "DISCONNECTED"
#define NO_WIIMOTES_FOUND "NO_WIIMOTES_FOUND"
#define NO_WIIMOTES_CONNECTED "NO_WIIMOTES_CONNECTED"

/*WiiButtonEvents*/
#define BUTTON_PRESSED "BUTTON_PRESSED"
#define BUTTON_JUST_PRESSED "BUTTON_JUST_PRESSED"
#define BUTTON_HELD "BUTTON_HELD"
#define BUTTON_RELEASED "BUTTON_RELEASED"

/*WiiMotionEvents*/
#define MOTION_SENSED "MOTION_SENSED"

#define LOG "log"

#define DISPATCH_STATUS_EVENT(extensionContext, code, status) FREDispatchStatusEventAsync((extensionContext), (uint8_t*)code, (uint8_t*)status)


enum DATA_ENUM
{
    ID = 0,
    ACCEL_X = 1,
    ACCEL_Y = 2,
    ACCEL_Z = 3,
    ROLL = 4,
    PITCH = 5,
    YAW = 6
};

@interface NatiWiiHandler () {
}
@property FREContext context;
@property FREObject asClass;
@property wiimote** wiimotes;
@property int found;
@property int connected;
@property bool motionsensing;
@property NSThread* wiimoteThread;

@end

@implementation NatiWiiHandler

@synthesize context, asClass, wiimotes,found, connected, motionsensing, wiimoteThread;

- (id)initWithContext:(FREContext)extensionContext
{
    self = [super init];
        context = extensionContext;
    return self;
}


-(FREObject) Init:(FREObject) actionScriptClass
{
    asClass = actionScriptClass;
    return NULL;
}


-(FREObject) Connect
{

    self.wiimoteThread = [[NSThread alloc] initWithTarget:self selector:@selector(findThreadHandler) object:nil];
    [wiimoteThread start];
    return NULL;
}

-(void)findThreadHandler
{
    NSLog(@"Connecting");
    DISPATCH_STATUS_EVENT(context, CONNECTING, "");
    wiimotes = wiiuse_init(MAX_WIIMOTES);
    
    found = wiiuse_find(wiimotes, MAX_WIIMOTES, 5);
    if (!found) {
        DISPATCH_STATUS_EVENT(context, NO_WIIMOTES_FOUND, "");
        [wiimoteThread cancel];
        return;
        }
    
    
    connected = wiiuse_connect(wiimotes, MAX_WIIMOTES);
    if (connected)
    {
        char numWiimotes[128];
        sprintf(numWiimotes,"%i"
                ,connected);
        DISPATCH_STATUS_EVENT(context, CONNECTED, numWiimotes);
    }
    else
    {
        DISPATCH_STATUS_EVENT(context, NO_WIIMOTES_CONNECTED, "");
        [wiimoteThread cancel];
        return;

    }
    wiiuse_set_leds(wiimotes[0], WIIMOTE_LED_1);
    wiiuse_set_leds(wiimotes[1], WIIMOTE_LED_2);
    wiiuse_set_leds(wiimotes[2], WIIMOTE_LED_3);
    wiiuse_set_leds(wiimotes[3], WIIMOTE_LED_4);
    
    
    wiiuse_rumble(wiimotes[0], 1);
    
    sleep(1);
    
    wiiuse_rumble(wiimotes[0], 0);
    
    wiiuse_motion_sensing(wiimotes[0],1);

    [self eventThreadHandler];
    
}

- (void)eventThreadHandler
{
    while(1)
    {
        bool available = (wiiuse_poll(wiimotes,MAX_WIIMOTES)==1)?true:false;
        
        if(available)
        {
            int i = 0;
            for (; i < MAX_WIIMOTES; ++i) {
                switch (wiimotes[i]->event) {
                    case WIIUSE_READ_DATA:
                    case WIIUSE_EVENT:
                        if(IS_JUST_PRESSED(wiimotes[i],WIIMOTE_BUTTON_A))       [self buttonJustPressed:WIIMOTE_BUTTON_A : wiimotes[i]->unid];
                        if(IS_JUST_PRESSED(wiimotes[i],WIIMOTE_BUTTON_B))		[self buttonJustPressed:WIIMOTE_BUTTON_B : wiimotes[i]->unid];
                        if(IS_JUST_PRESSED(wiimotes[i],WIIMOTE_BUTTON_UP))		[self buttonJustPressed:WIIMOTE_BUTTON_UP : wiimotes[i]->unid];
                        if(IS_JUST_PRESSED(wiimotes[i],WIIMOTE_BUTTON_DOWN))	[self buttonJustPressed:WIIMOTE_BUTTON_DOWN : wiimotes[i]->unid];
                        if(IS_JUST_PRESSED(wiimotes[i],WIIMOTE_BUTTON_LEFT))	[self buttonJustPressed:WIIMOTE_BUTTON_LEFT : wiimotes[i]->unid];
                        if(IS_JUST_PRESSED(wiimotes[i],WIIMOTE_BUTTON_RIGHT))	[self buttonJustPressed:WIIMOTE_BUTTON_RIGHT : wiimotes[i]->unid];
                        if(IS_JUST_PRESSED(wiimotes[i],WIIMOTE_BUTTON_MINUS))	[self buttonJustPressed:WIIMOTE_BUTTON_MINUS : wiimotes[i]->unid];
                        if(IS_JUST_PRESSED(wiimotes[i],WIIMOTE_BUTTON_PLUS))	[self buttonJustPressed:WIIMOTE_BUTTON_PLUS : wiimotes[i]->unid];
                        if(IS_JUST_PRESSED(wiimotes[i],WIIMOTE_BUTTON_HOME))	[self buttonJustPressed:WIIMOTE_BUTTON_HOME : wiimotes[i]->unid];
                        if(IS_JUST_PRESSED(wiimotes[i],WIIMOTE_BUTTON_ONE))		[self buttonJustPressed:WIIMOTE_BUTTON_ONE : wiimotes[i]->unid];
                        if(IS_JUST_PRESSED(wiimotes[i],WIIMOTE_BUTTON_TWO))		[self buttonJustPressed:WIIMOTE_BUTTON_TWO : wiimotes[i]->unid];
                        
                        
                        if(IS_PRESSED(wiimotes[i],WIIMOTE_BUTTON_A))		[self buttonPressed:WIIMOTE_BUTTON_A : wiimotes[i]->unid];
                        if(IS_PRESSED(wiimotes[i],WIIMOTE_BUTTON_B))		[self buttonPressed: WIIMOTE_BUTTON_B :wiimotes[i]->unid];
                        if(IS_PRESSED(wiimotes[i],WIIMOTE_BUTTON_UP))		[self buttonPressed:WIIMOTE_BUTTON_UP :wiimotes[i]->unid];
                        if(IS_PRESSED(wiimotes[i],WIIMOTE_BUTTON_DOWN))		[self buttonPressed:WIIMOTE_BUTTON_DOWN :wiimotes[i]->unid];
                        if(IS_PRESSED(wiimotes[i],WIIMOTE_BUTTON_LEFT))		[self buttonPressed:WIIMOTE_BUTTON_LEFT :wiimotes[i]->unid];
                        if(IS_PRESSED(wiimotes[i],WIIMOTE_BUTTON_RIGHT))	[self buttonPressed:WIIMOTE_BUTTON_RIGHT :wiimotes[i]->unid];
                        if(IS_PRESSED(wiimotes[i],WIIMOTE_BUTTON_MINUS))	[self buttonPressed:WIIMOTE_BUTTON_MINUS :wiimotes[i]->unid];
                        if(IS_PRESSED(wiimotes[i],WIIMOTE_BUTTON_PLUS))		[self buttonPressed:WIIMOTE_BUTTON_PLUS :wiimotes[i]->unid];
                        if(IS_PRESSED(wiimotes[i],WIIMOTE_BUTTON_HOME))		[self buttonPressed:WIIMOTE_BUTTON_HOME :wiimotes[i]->unid];
                        if(IS_PRESSED(wiimotes[i],WIIMOTE_BUTTON_ONE))		[self buttonPressed:WIIMOTE_BUTTON_ONE :wiimotes[i]->unid];
                        if(IS_PRESSED(wiimotes[i],WIIMOTE_BUTTON_TWO))		[self buttonPressed:WIIMOTE_BUTTON_TWO :wiimotes[i]->unid];
                        
                       
                        if(IS_HELD(wiimotes[i],WIIMOTE_BUTTON_A))           [self buttonHeld:WIIMOTE_BUTTON_A : wiimotes[i]->unid];
                        if(IS_HELD(wiimotes[i],WIIMOTE_BUTTON_B))           [self buttonHeld: WIIMOTE_BUTTON_B :wiimotes[i]->unid];
                        if(IS_HELD(wiimotes[i],WIIMOTE_BUTTON_UP))          [self buttonHeld:WIIMOTE_BUTTON_UP :wiimotes[i]->unid];
                        if(IS_HELD(wiimotes[i],WIIMOTE_BUTTON_DOWN))		[self buttonHeld:WIIMOTE_BUTTON_DOWN :wiimotes[i]->unid];
                        if(IS_HELD(wiimotes[i],WIIMOTE_BUTTON_LEFT))		[self buttonHeld:WIIMOTE_BUTTON_LEFT :wiimotes[i]->unid];
                        if(IS_HELD(wiimotes[i],WIIMOTE_BUTTON_RIGHT))       [self buttonHeld:WIIMOTE_BUTTON_RIGHT :wiimotes[i]->unid];
                        if(IS_HELD(wiimotes[i],WIIMOTE_BUTTON_MINUS))       [self buttonHeld:WIIMOTE_BUTTON_MINUS :wiimotes[i]->unid];
                        if(IS_HELD(wiimotes[i],WIIMOTE_BUTTON_PLUS))		[self buttonHeld:WIIMOTE_BUTTON_PLUS :wiimotes[i]->unid];
                        if(IS_HELD(wiimotes[i],WIIMOTE_BUTTON_HOME))		[self buttonHeld:WIIMOTE_BUTTON_HOME :wiimotes[i]->unid];
                        if(IS_HELD(wiimotes[i],WIIMOTE_BUTTON_ONE))         [self buttonHeld:WIIMOTE_BUTTON_ONE :wiimotes[i]->unid];
                        if(IS_HELD(wiimotes[i],WIIMOTE_BUTTON_TWO))         [self buttonHeld:WIIMOTE_BUTTON_TWO :wiimotes[i]->unid];
                        
                        if(IS_RELEASED(wiimotes[i],WIIMOTE_BUTTON_A))           [self buttonReleased:WIIMOTE_BUTTON_A : wiimotes[i]->unid];
                        if(IS_RELEASED(wiimotes[i],WIIMOTE_BUTTON_B))           [self buttonReleased: WIIMOTE_BUTTON_B :wiimotes[i]->unid];
                        if(IS_RELEASED(wiimotes[i],WIIMOTE_BUTTON_UP))          [self buttonReleased:WIIMOTE_BUTTON_UP :wiimotes[i]->unid];
                        if(IS_RELEASED(wiimotes[i],WIIMOTE_BUTTON_DOWN))		[self buttonReleased:WIIMOTE_BUTTON_DOWN :wiimotes[i]->unid];
                        if(IS_RELEASED(wiimotes[i],WIIMOTE_BUTTON_LEFT))		[self buttonReleased:WIIMOTE_BUTTON_LEFT :wiimotes[i]->unid];
                        if(IS_RELEASED(wiimotes[i],WIIMOTE_BUTTON_RIGHT))       [self buttonReleased:WIIMOTE_BUTTON_RIGHT :wiimotes[i]->unid];
                        if(IS_RELEASED(wiimotes[i],WIIMOTE_BUTTON_MINUS))       [self buttonReleased:WIIMOTE_BUTTON_MINUS :wiimotes[i]->unid];
                        if(IS_RELEASED(wiimotes[i],WIIMOTE_BUTTON_PLUS))		[self buttonReleased:WIIMOTE_BUTTON_PLUS :wiimotes[i]->unid];
                        if(IS_RELEASED(wiimotes[i],WIIMOTE_BUTTON_HOME))		[self buttonReleased:WIIMOTE_BUTTON_HOME :wiimotes[i]->unid];
                        if(IS_RELEASED(wiimotes[i],WIIMOTE_BUTTON_ONE))         [self buttonReleased:WIIMOTE_BUTTON_ONE :wiimotes[i]->unid];
                        if(IS_RELEASED(wiimotes[i],WIIMOTE_BUTTON_TWO))         [self buttonReleased:WIIMOTE_BUTTON_TWO :wiimotes[i]->unid];
                        
                        if(WIIUSE_USING_ACC(wiimotes[i]))
                            [self motionSensing:wiimotes[i]];
                        break;
                        case WIIUSE_DISCONNECT:
                        case WIIUSE_UNEXPECTED_DISCONNECT:
                            [self handleDisconnected:wiimotes[i]->unid];
                         break;
                }
                }
        }

    }
}

-(void) handleDisconnected:(int)moteID
{
    
    char data[128];
    sprintf(data,"%i",moteID-1);
    DISPATCH_STATUS_EVENT(context, DISCONNECTED, data);
    NSLog(@"Wiimote %i disconnected",moteID);
  
}

-(void) buttonJustPressed:(uint)buttonID :(int)moteID
{
    char data[128];
    sprintf(data,"%i;%u",moteID,buttonID);
    DISPATCH_STATUS_EVENT(context, BUTTON_JUST_PRESSED, data);
    NSLog(@"Button %u just pressed on %i mote",buttonID,moteID);
}

-(void) buttonPressed:(uint) buttonID :(int) moteID
{
   char data[128];
    sprintf(data,"%i;%u",moteID,buttonID);
    DISPATCH_STATUS_EVENT(context, BUTTON_PRESSED, data);
    NSLog(@"Button %u pressed on %i mote",buttonID,moteID);
}

-(void) buttonHeld:(uint) buttonID :(int) moteID
{
    char data[128];
    sprintf(data,"%i;%u",moteID,buttonID);
    DISPATCH_STATUS_EVENT(context, BUTTON_HELD, data);
    NSLog(@"Button %u held on %i mote",buttonID,moteID);
}

-(void) buttonReleased:(uint) buttonID :(int) moteID
{
    char data[128];
    sprintf(data,"%i;%u",moteID,buttonID);
    DISPATCH_STATUS_EVENT(context, BUTTON_RELEASED, data);
    NSLog(@"Button %u released on %i mote",buttonID,moteID);
}

-(void) motionSensing:(struct wiimote_t*) wm
{
    char data[128];
    sprintf(data
            ,"%i;%e;%e;%e;%i;%i;%i"
            ,wm->unid
            ,wm->orient.roll,wm->orient.pitch,wm->orient.yaw
            ,wm->accel.x,wm->accel.y,wm->accel.z);
    DISPATCH_STATUS_EVENT(context, MOTION_SENSED, data);
}

-(FREObject) Disconnect:(FREObject)id
{

    int wiimoteID;
    FREGetObjectAsInt32(id, &wiimoteID);
    wiiuse_disconnect(wiimotes[wiimoteID]);
    NSLog(@"Wiimote %i disconnect",wiimoteID);
    return NULL;
}
-(FREObject) Rumble:(FREObject)isOn :(FREObject)id
{
    int wiimoteID;
    uint32_t on;
    FREGetObjectAsBool(isOn, &on);
    FREGetObjectAsInt32(id, &wiimoteID);
    wiiuse_rumble(wiimotes[wiimoteID], on);
    NSLog(@"Wiimote Rumlbe %i on device %i",on,wiimoteID);
    return NULL;
}

-(FREObject) MostionSensing:(FREObject)id :(FREObject)enable
{
    int moteID;
    uint32_t state;
    FREGetObjectAsInt32(id, &moteID);
    FREGetObjectAsBool(enable, &state);
    wiiuse_motion_sensing(wiimotes[moteID], state);
    NSLog(@"Motions sensing on %i, set state to %i",moteID,state);
    
    return NULL;
}

-(FREObject) SetFlags:(FREObject)id :(FREObject)flag :(FREObject)enable
{
    int _id;
    int _flag;
    uint32_t _enable;
    

    FREGetObjectAsInt32(id, &_id);
    FREGetObjectAsInt32(flag, &_flag);
    FREGetObjectAsBool(enable, &_enable);
    
    
    wiiuse_set_flags(wiimotes[_id], _flag, _enable);
    NSLog(@"Motions set flag: %i, on wiimote id: %i to value: %i",_flag,_id,_enable);
    
    return NULL;
}

@end
