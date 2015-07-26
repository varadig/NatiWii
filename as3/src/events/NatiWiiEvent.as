/**
 * Created by varad on 2015. 04. 22..
 */
package events {
import flash.events.Event;

import model.Wiimote;

public class NatiWiiEvent extends Event {
    public static const CONNECTED:String = "CONNECTED";
    public static const CONNECTING:String = "CONNECTING";
    public static const DISCONNECTED:String = "DISCONNECTED";
    public static const NO_WIIMOTES_FOUND:String = "NO_WIIMOTES_FOUND";
    public static const NO_WIIMOTES_CONNECTED:String = "NO_WIIMOTES_CONNECTED";
    private var wiimote:Wiimote;


    public function NatiWiiEvent(type:String,wiimote:Wiimote=null, bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
        this.wiimote = wiimote;
    }

    public override function clone():Event {
        return new NatiWiiEvent(type,wiimote, bubbles, cancelable);
    }
}
}
