package objects;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;


class GameSprite extends FlxSprite
{
	// stolen from @sugarcoatedOwO on twitter :troll:
	public var _dynamic:Dynamic = {};

	public function new(?X:Float = 0, ?Y:Float = 0)
	{
		super(X, Y);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (_dynamic.update != null)
		{
			_dynamic.update(elapsed);
		}
	}
	public function setScale(width:Float, height:Float)
	{
		scale.set(width, height);
		updateHitbox();
	}
}
class GameText extends FlxText
{
	public var _dynamic:Dynamic = {};

	public function new(?X:Float = 0, ?Y:Float = 0, ?FieldWidth:Float = 0, ?Text:String, Size:Int = 8, EmbeddedFont:Bool = true)
	{
		super(X, Y, FieldWidth, Text, Size, EmbeddedFont);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (_dynamic.update != null)
		{
			_dynamic.update(elapsed);
		}
	}
}
