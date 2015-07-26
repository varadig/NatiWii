# NatiWii
Native Extension for Nintendo Wiimote

The extension is use wiiuse C library.

USAGE:
======


NatiWii.getInstance().addEventListener(NatiWiiEvent.CONNECTED, this.onNatiWiiEvent);
NatiWii.getInstance().addEventListener(NatiWiiEvent.CONNECTING, this.onNatiWiiEvent);
NatiWii.getInstance().addEventListener(NatiWiiEvent.DISCONNECTED, this.onNatiWiiEvent);
NatiWii.getInstance().addEventListener(NatiWiiEvent.NO_WIIMOTES_FOUND, this.onNatiWiiEvent);
NatiWii.getInstance().addEventListener(NatiWiiEvent.NO_WIIMOTES_CONNECTED, this.onNatiWiiEvent);
NatiWii.getInstance().addEventListener(NatiWiiMotionEvent.MOTION_SENSED, this.onAcceleration);
NatiWii.getInstance().addEventListener(NatiWiiButtonEvent.BUTTON_JUST_PRESSED, onButtonJustPressed);
NatiWii.getInstance().addEventListener(NatiWiiButtonEvent.BUTTON_PRESSED, onButtonJustPressed);
NatiWii.getInstance().addEventListener(NatiWiiButtonEvent.BUTTON_HELD, onButtonHeld);
NatiWii.getInstance().addEventListener(NatiWiiButtonEvent.BUTTON_RELEASED, onButtonReleased);


NatiWii.getInstance().connect();


private function onButtonReleased(event:NatiWiiButtonEvent):void {
    trace("button released:", event.wiimote.button.id);
}

private function onButtonHeld(event:NatiWiiButtonEvent):void {
    trace("button held:", event.wiimote.button.id);

}

private function onAcceleration(event:NatiWiiMotionEvent):void {
	var str:String = "\n";
    
    str += ("acceleration x:" + event.data.acceleration.x.toString());
    str += ("\n");
    str += ("acceleration y:" + event.data.acceleration.y.toString());
    str += ("\n");
    str += ("acceleration z:" + event.data.acceleration.z.toString());
    str += ("\n");
    str += ("\n");
    str += ("rotation pitch:" + event.data.rotation.pitch.toString());
    str += ("\n");
    str += ("rotation roll:" + event.data.rotation.roll.toString());
    str += ("\n");
    str += ("rotation yaw:" + event.data.rotation.yaw.toString());


}

private function onNatiWiiEvent(event:NatiWiiEvent):void {
    switch (event.type) {
        case NatiWiiEvent.CONNECTING:
            trace("connecting");
            break;
        case NatiWiiEvent.CONNECTED:
            trace("connected");
            break;
        case NatiWiiEvent.DISCONNECTED:
            trace("disconnected");
            break;
        case NatiWiiEvent.NO_WIIMOTES_CONNECTED:
            trace("no wiimotes connected");
            break;
        case NatiWiiEvent.NO_WIIMOTES_FOUND:
            trace("no wiimotes found");
            break;
    }
}

private function onButtonJustPressed(event:NatiWiiButtonEvent):void {
    trace ("button, "event.wiimote.button.id," is just pressed")
}
private function onButtonPressed(event:NatiWiiButtonEvent):void {
    trace ("button, "event.wiimote.button.id," is pressed")
}
