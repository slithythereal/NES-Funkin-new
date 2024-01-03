package objects;

import flixel.text.FlxText;
import objects.GameSprite.GameText;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.math.FlxMath;

using StringTools;

//made this to replace the alphabet for the controls menu
class ControlsTxt extends GameText {

    public var forceX:Float = Math.NEGATIVE_INFINITY;
    public var targetY:Float = 0;
    public var yMult:Float = 120;
    public var xAdd:Float = 0;
    public var yAdd:Float = 0;
    
    public function new(x:Float, y:Float, text:String = "", bold:Bool = false, typed:Bool = false)
    {
        super(x, y);
        super.text = text;
        setFormat(Paths.font("Pixel_NES.otf"), 45, FlxColor.WHITE, CENTER);
    }
    override function update(elapsed:Float){
        var scaledY = FlxMath.remapToRange(targetY, 0, 1, 0, 1.3);

        var lerpVal:Float = CoolUtil.boundTo(elapsed * 9.6, 0, 1);
        y = FlxMath.lerp(y, (scaledY * yMult) + (FlxG.height * 0.48) + yAdd, lerpVal);
        if(forceX != Math.NEGATIVE_INFINITY) 
            x = forceX;
         else 
            x = FlxMath.lerp(x, (targetY * 20) + 90 + xAdd, lerpVal);

        super.update(elapsed);
    }
}

class MoreControlsTxt extends ControlsTxt {
    public var offsetX:Float = 0;
	public var offsetY:Float = 0;
	public var sprTracker:ControlsTxt;

    public function new(text:String = "", ?offsetX:Float = 0, ?offsetY:Float = 0,  ?bold = false, ?scale:Float = 1)
    {
        super(0, 0);
        super.text = text;
        this.offsetX = offsetX;
        this.offsetY = offsetY;
    }

    override function update(elapsed:Float) {
		super.update(elapsed); //so update the pos setting first, then add the pos for this text. got it -slithy
        
        if (sprTracker != null) 
			setPosition(sprTracker.x + offsetX, sprTracker.y + offsetY);
		
	}
}