package options;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxSubState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxSave;
import haxe.Json;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.input.keyboard.FlxKey;
import flixel.graphics.FlxGraphic;
import Controls;

using StringTools;

class NESFunkinSettingsSubState extends BaseOptionsMenu
{
	public function new()
	{
		title = 'NES Funkin Settings';
		rpcTitle = 'NES Funkin Settings Menu'; //for Discord Rich Presence

		var option:Option = new Option('Mechanics',
		'If true, it turns on the mechanics.',
		'mechanics',
		'bool',
		true);
		addOption(option);

		var option:Option = new Option('NES FUNKIN SHADERS', 
		'If true, it turns on the shaders used in this mod!',
		'nesSHADERS',
		'bool',
		true);
		addOption(option);

		super();
	}
}