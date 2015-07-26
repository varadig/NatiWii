/**
 * Created by varad on 2015. 04. 22..
 */
package model {
public class Acceleration {
    public var x:int;
    public var y:int;
    public var z:int;

    public function Acceleration() {
    }

    public function update(result:Array = null):void {
        x = (result[WiimoteDataEnum.ACCEL_X]) ? result[WiimoteDataEnum.ACCEL_X] : 0;
        y = (result[WiimoteDataEnum.ACCEL_Y]) ? result[WiimoteDataEnum.ACCEL_Y] : 0;
        z = (result[WiimoteDataEnum.ACCEL_Z]) ? result[WiimoteDataEnum.ACCEL_Z] : 0;
    }

    public function toString():String{
        var str:String ="";
        str+="accelx:"+x+"\n";
        str+="accely:"+y+"\n";
        str+="accelz:"+z+"\n";
        return str;
    }
}
}
