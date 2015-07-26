/**
 * Created by varad on 2015. 04. 24..
 */
package events {
import flash.events.Event;

import model.Wiimote;

public class NatiWiiButtonEvent extends Event {
    public static const BUTTON_JUST_PRESSED:String = "BUTTON_JUST_PRESSED";
    public static const BUTTON_PRESSED:String = "BUTTON_PRESSED";
    public static const BUTTON_HELD:String = "BUTTON_HELD";
    public static const BUTTON_RELEASED:String = "BUTTON_RELEASED";
    public var wiimote:Wiimote;

    public function NatiWiiButtonEvent(type:String, wiimote:Wiimote, bubbles:Boolean = false, cancelable:Boolean = false) {
        super(type, bubbles, cancelable);
        this.wiimote = wiimote;
    }

    public override function clone():Event {
        return new NatiWiiButtonEvent(type, wiimote, bubbles, cancelable);
    }
}
}
