package {
import events.NatiWiiButtonEvent;
import events.NatiWiiEvent;
import events.NatiWiiMotionEvent;

import flash.desktop.NativeApplication;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.StatusEvent;
import flash.external.ExtensionContext;
import flash.utils.setTimeout;

import model.Wiimote;
import model.WiimoteDataEnum;

/**
 * ...
 * @author Gábor Váradi
 */
public class NatiWii extends EventDispatcher {
    private var ctx:ExtensionContext;
    private const MAX_WIIMOTES:int = 4;
    private var wiimotes:Vector.<Wiimote>;
    private static var instance:NatiWii;


    public static function getInstance():NatiWii {
        if (instance == null)
            instance = new NatiWii();
        return instance;
    }

    public function NatiWii() {
        this.ctx = ExtensionContext.createExtensionContext('hu.go2design.NatiWii', "");
        this.ctx.addEventListener(StatusEvent.STATUS, this.onStatusEvent);
        NativeApplication.nativeApplication.addEventListener(Event.EXITING, this.onApplicationExiting);

    }

    public function connect():Object {
        this.wiimotes = new Vector.<Wiimote>(MAX_WIIMOTES, true);
        return this.ctx.call('NWConnect');
    }

    public function disconnectAll():void {

        this.ctx.removeEventListener(StatusEvent.STATUS, this.onStatusEvent);
        for each(var wiimote:Wiimote in this.wiimotes) {
            if (wiimote)
                this.disconnect(wiimote.id);
        }
        this.wiimotes = new Vector.<Wiimote>(MAX_WIIMOTES,true);
    }

    public function disconnect(id:int):void {
        var wiimoteToDisconnect:Wiimote;
        for each(var wiimote:Wiimote in this.wiimotes) {
            if (wiimote) {

                if (wiimote.id == id) {
                    wiimoteToDisconnect = wiimote;
                    var index:int = this.wiimotes.indexOf(wiimote);
                    this.wiimotes[index] = null;
                    this.ctx.call("NWDisconnect", wiimoteToDisconnect.id);

                }
            }
        }
    }

    public function setFlags(id:int, flag:uint, enable:Boolean):void {
        this.ctx.call("NWSetFlags", id, flag, enable);
    }

    public function setMotionSensing(id:int, enable:Boolean):void {
        this.ctx.call("NWMotionSensing", id, enable);
    }


    public function rumble(time:int, id:int):void {


        this.ctx.call("NWRumble", true, id);
        setTimeout(ctx.call, time, "NWRumble", false, id);
    }

    private function onStatusEvent(event:StatusEvent):void {
        var wiimote:Wiimote;
        switch (event.code) {
            case NatiWiiButtonEvent.BUTTON_JUST_PRESSED:
            case NatiWiiButtonEvent.BUTTON_PRESSED:
            case NatiWiiButtonEvent.BUTTON_HELD:
            case NatiWiiButtonEvent.BUTTON_RELEASED:
                wiimote = this.getWiimoteBy(event);
                wiimote.buttonPressed(this.getButtonIdBy(event));
                NatiWii.getInstance().dispatchEvent(new NatiWiiButtonEvent(event.code, wiimote));
                break;


            case NatiWiiMotionEvent.MOTION_SENSED:
                var result:Array = (event.level.split(";"));
                wiimotes[result[WiimoteDataEnum.ID] - 1].motionSensed(result);
                NatiWii.getInstance().dispatchEvent(new NatiWiiMotionEvent(NatiWiiMotionEvent.MOTION_SENSED, wiimotes[result[WiimoteDataEnum.ID] - 1]));
                result = null;
                break;

            case NatiWiiEvent.CONNECTING:
                NatiWii.getInstance().dispatchEvent(new NatiWiiEvent(NatiWiiEvent.CONNECTING));
                break;
            case NatiWiiEvent.CONNECTED:
                var connected:int = parseInt(event.level);
                for (var i:int = 0; i < connected; i++)
                    this.wiimotes[i] = new Wiimote(i);
                NatiWii.getInstance().dispatchEvent(new NatiWiiEvent(NatiWiiEvent.CONNECTED));
                break;
            case NatiWiiEvent.DISCONNECTED:
                NatiWii.getInstance().dispatchEvent(new NatiWiiEvent(NatiWiiEvent.DISCONNECTED, this.wiimotes[event.level]));
                this.wiimotes[event.level] = null;
                break;
            case NatiWiiEvent.NO_WIIMOTES_FOUND:
                NatiWii.getInstance().dispatchEvent(new NatiWiiEvent(NatiWiiEvent.NO_WIIMOTES_FOUND));
                break;
            case NatiWiiEvent.NO_WIIMOTES_CONNECTED:
                NatiWii.getInstance().dispatchEvent(new NatiWiiEvent(NatiWiiEvent.NO_WIIMOTES_CONNECTED));
                break;
        }
    }

    public function get connectedWiimotes():Vector.<Wiimote> {
        var connected:Vector.<Wiimote> = new Vector.<Wiimote>();
        for each(var wiimote:Wiimote in this.wiimotes)
            if (wiimote)
                connected.push(wiimote);
        return connected;
    }

    private function getWiimoteBy(event:StatusEvent):Wiimote {
        var array:Array = event.level.split(";");
        return this.wiimotes[array[WiimoteDataEnum.ID] - 1];
    }

    private function getButtonIdBy(event:StatusEvent):int {
        var array:Array = event.level.split(";");
        return array[WiimoteDataEnum.BUTTON_ID];
    }

    private function onApplicationExiting(event:Event):void {
        NatiWii.getInstance().disconnectAll();
    }

}
}