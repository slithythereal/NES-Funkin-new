package objects;

import flixel.FlxSprite;
import flixel.util.FlxColor;

class Square extends FlxSprite //TODO work on this
{
    public var squarePos:Array<Float> = [];
    public var squareMulti:Float;
    public function new(?x:Float = 0, ?daSquareMulti:Float = 1){
        super(x);
        squareMulti = daSquareMulti;
        makeGraphic(35, 35, 0xFFFF0000);
        CommandData.watch(this);
    }

}