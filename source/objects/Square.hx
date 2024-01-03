package objects;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import objects.GameSprite;

class Square extends GameSprite 
{
    var squarePos:Array<Float> = [];
    /**
     * square starting y value
     */
    public var squareMulti:Float;
    public function new(?x:Float = 0, ?squareMulti:Float = 1){
        super(x);
        this.squareMulti = squareMulti;
        makeGraphic(35, 35, 0xFFFF0000);
        CommandData.watch(this);
    }

    public function changeY(cool:Int)
        y = squarePos[cool];
    public function pushSquarePos(pos:Float)
        squarePos.push(pos);
    
}