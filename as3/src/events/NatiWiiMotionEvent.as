/**
 * Created by varad on 2015. 04. 24..
 */
package events {
import flash.events.Event;

import model.Wiimote;

public class NatiWiiMotionEvent extends Event {
    public static var MOTION_SENSED:String = "MOTION_SENSED";
    public var data:Wiimote;
    public function NatiWiiMotionEvent(type:String,data:Wiimote, bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
        this.data = data;
    }

    public override function clone():Event {
        return new NatiWiiMotionEvent(type, data, bubbles, cancelable);
    }
}
}
