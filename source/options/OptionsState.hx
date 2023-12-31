package options;

import objects.GalleryGroup;
import objects.GameSprite.GameText;
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
import flixel.addons.transition.FlxTransitionableState;

using StringTools;

class OptionsState extends MusicBeatState
{
	public var options:Array<String> = ['NES Funkin', 'Controls', 'Adjust Delay and Combo', 'Graphics', 'Visuals and UI', 'Gameplay', 'back'];
	private var grpOptions:FlxTypedGroup<GameText>;
	private static var curSelected:Int = 0;
    
	//square
	var squareMulti:Float = 25;
	var daSquare:FlxSprite;
    var squarePos:Array<Float> = [];

	var galleryGrp:GalleryGroup;
	var isInSubState:Bool = false;

	function openSelectedSubstate(label:String) {
        galleryGrp.setGalleryX();

		switch(label) {
			case 'NES Funkin':
				openSubState(new options.NESFunkinSettingsSubState());
			case 'Controls':
				openSubState(new options.ControlsSubState());
			case 'Graphics':
				openSubState(new options.GraphicsSettingsSubState());
			case 'Visuals and UI':
				openSubState(new options.VisualsUISubState());
			case 'Gameplay':
				openSubState(new options.GameplaySettingsSubState());
			case 'Adjust Delay and Combo':
				Init.menuMusicTime = FlxG.sound.music.time;
				LoadingState.loadAndSwitchState(new options.NoteOffsetState());
			case 'back':
				FlxTransitionableState.skipNextTransIn = true;
                FlxTransitionableState.skipNextTransOut = true;
				LoadingState.loadAndSwitchState(new menus.MenuState());
		}
	}

	override function create() {
		#if desktop
		DiscordClient.changePresence("Options Menu", null);
		#end
		
		persistentUpdate = true;

        galleryGrp = new GalleryGroup();
        add(galleryGrp);

		grpOptions = new FlxTypedGroup<GameText>();
		add(grpOptions);

        daSquare = new FlxSprite(485, squareMulti);
        daSquare.makeGraphic(35, 35, 0xFFFF0000);
        add(daSquare);
        CommandData.watch(daSquare);

		for (i in 0...options.length)
		{
			var offset:Float = squareMulti + (i * (115/2));
			var optionsTxt:GameText = new GameText(526);
            optionsTxt.setFormat(Paths.font("Pixel_NES.otf"), 40, FlxColor.WHITE, CENTER);
            optionsTxt.text = options[i];
			if(optionsTxt.text == 'back'){
                offset += 100;
			}
			optionsTxt.y = offset;
			optionsTxt.ID = i;
            grpOptions.add(optionsTxt);   
            optionsTxt.updateHitbox();
            squarePos.push(offset + 10);
		}
	
		changeItem();
		ClientPrefs.saveSettings();

		super.create();
	}

	override function openSubState(SubState:FlxSubState){
		isInSubState = true;
		daSquare.visible = false;
		for (text in grpOptions) {
			text.visible = false;
		}
		super.openSubState(SubState);
	}

	override function closeSubState() {
		isInSubState = false;
		daSquare.visible = true;
		for (text in grpOptions) {
			text.visible = true;
		}
		super.closeSubState();
		ClientPrefs.saveSettings();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if(!isInSubState){
			if(controls.BACK)
				openSelectedSubstate('back');
			if (controls.UI_UP_P) 
				changeItem(-1);
			if (controls.UI_DOWN_P) 
				changeItem(1);
			if (controls.ACCEPT) 
				openSelectedSubstate(options[curSelected]);
		}
	}
	
	function changeItem(change:Int = 0) {
		curSelected += change;
		if (curSelected < 0)
			curSelected = options.length - 1;
		if (curSelected >= options.length)
			curSelected = 0;
        daSquare.y = squarePos[curSelected];
	}
}