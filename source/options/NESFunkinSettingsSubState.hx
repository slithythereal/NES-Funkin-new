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
import data.WindowsData;

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

		var option:Option = new Option('Fullscreen', 
		'Fullscreen option bc I felt like it -slithy\nalso it might not work the first time',
		'isFullscreen',
		'bool',
		false);
		addOption(option);
		option.onChange = onChangeFullscreen;

		#if cpp
		var option:Option = new Option('Window Color', 
		'The color of the window, really cool effect!',
		'windowColor', 
		'string',
		'DARK',
		['DARK', 'LIGHT']);
		addOption(option);
		option.onChange = onChangeWindowColor;
		#end

		#if !html5
		var option:Option = new Option('Auto Pause',
		'FNF mods normally have a "auto pause" mechanic where if you back out of a window, the game automatically pauses. \nThis option turns it on or off!',
		'isAutoPauseOn',
		'bool',
		false);
		addOption(option);
		option.onChange = onChangeFocusLost;
		#end

		super();
	}
	function onChangeFullscreen(){
		FlxG.fullscreen = !FlxG.fullscreen;
	}
	function onChangeWindowColor(){
		#if cpp
		if(ClientPrefs.windowColor == 'DARK')
			WindowsData.setWindowColorMode(DARK);
		else 
			WindowsData.setWindowColorMode(LIGHT);
		#end
	}
	function onChangeFocusLost(){
		#if !html5
		FlxG.autoPause = !FlxG.autoPause;
		#end
	}
}