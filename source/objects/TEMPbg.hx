package objects;

import flixel.FlxSprite;
import flixel.FlxG;
class TEMPbg extends FlxSprite
{
    public function new() {
        super();
        makeGraphic(FlxG.width, FlxG.height, 0xFF462020);
		alpha = 0.5;
    }
}