/**
 * Created by varad on 2015. 04. 22..
 */
package model {
public class Rotation {

    public var roll:int;
    public var pitch:int;
    public var yaw:int;

    public function Rotation() {
    }

    public function update(result:Array = null):void {

        roll = (result[WiimoteDataEnum.ROLL]) ? result[WiimoteDataEnum.ROLL] : 0;
        pitch = (result[WiimoteDataEnum.PITCH]) ? result[WiimoteDataEnum.PITCH] : 0;
        yaw = (result[WiimoteDataEnum.YAW]) ? result[WiimoteDataEnum.YAW] : 0;
    }

    public function toString():String{
        var str:String ="";
        str+="roll:"+roll+"\n";
        str+="pitch:"+pitch+"\n";
        str+="yaw:"+yaw+"\n";
        return str;
    }
}
}
