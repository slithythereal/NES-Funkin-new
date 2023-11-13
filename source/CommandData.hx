package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.FlxSubState;

class CommandData
{
	public static function watch(obj:FlxObject)
	{
		FlxG.watch.add(obj, 'x');
		FlxG.watch.add(obj, 'y');
	}
}
