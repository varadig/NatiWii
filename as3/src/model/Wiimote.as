/**
 * Created by varad on 2015. 04. 24..
 */
package model {
public class Wiimote {

    public var id:int;
    public var acceleration:Acceleration;
    public var rotation:Rotation;
    public var button:Button;

    public function Wiimote(id:int) {
        this.id=id;
        this.button = new Button();
        this.acceleration = new Acceleration();
        this.rotation = new Rotation();
    }

    public function buttonPressed(id:int):void
    {
        this.button.id = id;
    }

    public function buttonJustPressed(id:int):void
    {
        this.button.id = id;
    }

    public function motionSensed(result:Array):void {
        this.rotation.roll =  result[WiimoteDataEnum.ROLL];
        this.rotation.pitch =  result[WiimoteDataEnum.PITCH];
        this.rotation.yaw =  result[WiimoteDataEnum.YAW];

        this.acceleration.x =  result[WiimoteDataEnum.ACCEL_X];
        this.acceleration.y =  result[WiimoteDataEnum.ACCEL_Y];
        this.acceleration.z =  result[WiimoteDataEnum.ACCEL_Z];
    }
}
}
