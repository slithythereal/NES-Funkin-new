package options;

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
import objects.TEMPbg;
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

class BaseOptionsMenu extends MusicBeatSubstate
{
	private var curOption:Option = null;
	private var curSelected:Int = 0;
	private var optionsArray:Array<Option>;

	private var grpOptions:FlxTypedGroup<GameText>;
	private var grpTexts:FlxTypedGroup<AttachedText>;

	private var boyfriend:Character = null;
	private var descBox:FlxSprite;
	private var descText:FlxText;

	public var title:String;
	public var rpcTitle:String;

	public var squareY:String;
	private var squareMulti:Float = 190; //y offset var (i think)
	private var daSquare:FlxSprite;
    private var squarePos:Array<Float> = [];


	public function new()
	{
		super();

		if(title == null) title = 'Options';
		if(rpcTitle == null) rpcTitle = 'Options Menu';
		if(squareY != null)
			squareMulti = Std.parseFloat(squareY);
		else
			squareY = Std.string(squareMulti);
		
		#if desktop
		DiscordClient.changePresence(rpcTitle, null);
		#end

		// avoids lagspikes while scrolling through menus!
		grpOptions = new FlxTypedGroup<GameText>();
		add(grpOptions);

		daSquare = new FlxSprite(485, squareMulti);
        daSquare.makeGraphic(35, 35, 0xFFFF0000);
        add(daSquare);
        CommandData.watch(daSquare);

		grpTexts = new FlxTypedGroup<AttachedText>();
		add(grpTexts);

		descBox = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
		descBox.alpha = 0.6;
		descBox.visible = false;
		add(descBox);
		
		var titleText:FlxText = new FlxText(25, 40, 0, title);
		titleText.setFormat(Paths.font("Pixel_NES.otf"), 30, FlxColor.WHITE, CENTER);
		titleText.alpha = 0.4;  
		add(titleText);
		
		var descInfo:FlxText = new FlxText(25, 80, 0,  'PRESS [TAB] TO TOGGLE DESCRIPTION');
		descInfo.setFormat(Paths.font("Pixel_NES.otf"), 15, FlxColor.WHITE, CENTER);
		descInfo.alpha = 0.2;
		add(descInfo);

		descText = new FlxText(50, 600, 1180, "", 32);
		descText.setFormat(Paths.font("Pixel_NES.otf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 2.4;
		descText.visible = false;
		add(descText);

		for (i in 0...optionsArray.length)
		{
			var offset:Float = squareMulti + (i * (115/2));
			var daText:String;
			if(optionsArray[i].type == 'percent')
				daText = optionsArray[i].name + ': ' + (optionsArray[i].getValue() * 100) + '%';
			else
				daText = optionsArray[i].name + ': ' + optionsArray[i].getValue();

			var optionsTxt:GameText = new GameText(526, 0, 0, daText);
			optionsTxt.setFormat(Paths.font("Pixel_NES.otf"), 32, FlxColor.WHITE, CENTER);
			if(optionsTxt.text == 'back')
				offset += 100;
			optionsTxt.ID = i;
			optionsTxt.y = offset;
			optionsTxt.updateHitbox();
			grpOptions.add(optionsTxt);
			CommandData.watch(optionsTxt);

            squarePos.push(offset + 7);

			if(optionsArray[i].showBoyfriend && boyfriend == null)
				reloadBoyfriend();
		}

		changeSelection();
	}

	public function addOption(option:Option) {
		if(optionsArray == null || optionsArray.length < 1) optionsArray = [];
		optionsArray.push(option);
	}

	var nextAccept:Int = 5;
	var holdTime:Float = 0;
	var holdValue:Float = 0;
	override function update(elapsed:Float)
	{
		if (controls.UI_UP_P)
		{
			changeSelection(-1);
		}
		if (controls.UI_DOWN_P)
		{
			changeSelection(1);
		}

		if (controls.BACK) {
			close();
			FlxG.sound.play(Paths.sound('cancelMenu'));
		}

		if(FlxG.keys.justPressed.TAB)
			toggleDescText();


		if(nextAccept <= 0)
		{
			var isBool = true;
			if(curOption.type != 'bool')
			{
				isBool = false;
			}

			if(isBool)
			{
				if(controls.ACCEPT)
				{
					curOption.setValue((curOption.getValue() == true) ? false : true);
					curOption.change();
					changeText();
				}
			} else {
				if(controls.UI_LEFT || controls.UI_RIGHT) {
					var pressed = (controls.UI_LEFT_P || controls.UI_RIGHT_P);
					if(holdTime > 0.5 || pressed) {
						if(pressed) {
							var add:Dynamic = null;
							if(curOption.type != 'string') {
								add = controls.UI_LEFT ? -curOption.changeValue : curOption.changeValue;
							}

							switch(curOption.type)
							{
								case 'int' | 'float' | 'percent':
									holdValue = curOption.getValue() + add;
									if(holdValue < curOption.minValue) holdValue = curOption.minValue;
									else if (holdValue > curOption.maxValue) holdValue = curOption.maxValue;

									switch(curOption.type)
									{
										case 'int':
											holdValue = Math.round(holdValue);
											curOption.setValue(holdValue);

										case 'float' | 'percent':
											holdValue = FlxMath.roundDecimal(holdValue, curOption.decimals);
											curOption.setValue(holdValue);
									}

								case 'string':
									var num:Int = curOption.curOption; //lol
									if(controls.UI_LEFT_P) --num;
									else num++;

									if(num < 0) {
										num = curOption.options.length - 1;
									} else if(num >= curOption.options.length) {
										num = 0;
									}

									curOption.curOption = num;
									curOption.setValue(curOption.options[num]); //lol
									//trace(curOption.options[num]);
							}
							//updateTextFrom(curOption);
							curOption.change();
							changeText();
						} else if(curOption.type != 'string') {
							holdValue += curOption.scrollSpeed * elapsed * (controls.UI_LEFT ? -1 : 1);
							if(holdValue < curOption.minValue) holdValue = curOption.minValue;
							else if (holdValue > curOption.maxValue) holdValue = curOption.maxValue;

							switch(curOption.type)
							{
								case 'int':
									curOption.setValue(Math.round(holdValue));
								
								case 'float' | 'percent':
									curOption.setValue(FlxMath.roundDecimal(holdValue, curOption.decimals));
							}
							//updateTextFrom(curOption);
							curOption.change();
							changeText();
						}
					}

					if(curOption.type != 'string') {
						holdTime += elapsed;
					}
				} else if(controls.UI_LEFT_R || controls.UI_RIGHT_R) {
					clearHold();
				}
			}

			if(controls.RESET)
			{
				for (i in 0...optionsArray.length)
				{
					var leOption:Option = optionsArray[i];
					leOption.setValue(leOption.defaultValue);
					if(leOption.type != 'bool')
					{
						if(leOption.type == 'string')
						{
							leOption.curOption = leOption.options.indexOf(leOption.getValue());
						}
						//updateTextFrom(leOption);
						changeText();
					}
					leOption.change();
				}
				FlxG.sound.play(Paths.sound('cancelMenu'));
			}
		}

		if(boyfriend != null && boyfriend.animation.curAnim.finished) {
			boyfriend.dance();
		}

		if(nextAccept > 0) {
			nextAccept -= 1;
		}
		super.update(elapsed);
	}

	function changeText(){
		grpOptions.forEach(function(txt:GameText){
			if(txt.ID == curSelected){
				if(optionsArray[curSelected].type == 'percent')
					txt.text = optionsArray[curSelected].name + ': ' + (optionsArray[curSelected].getValue() * 100) + '%';
				else
					txt.text = optionsArray[curSelected].name + ': ' + optionsArray[curSelected].getValue();
			}
		});
		trace(optionsArray[curSelected].name + "'s var is now " + optionsArray[curSelected].getValue());
	}

	function updateTextFrom(option:Option) {
		var text:String = option.displayFormat;
		var val:Dynamic = option.getValue();
		if(option.type == 'percent') val *= 100;
		var def:Dynamic = option.defaultValue;
		option.text = text.replace('%v', val).replace('%d', def);
	}

	function clearHold()
	{
		if(holdTime > 0.5) {
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}
		holdTime = 0;
	}
	
	function changeSelection(change:Int = 0)
	{
		curSelected += change;
		if (curSelected < 0)
			curSelected = optionsArray.length - 1;
		if (curSelected >= optionsArray.length)
			curSelected = 0;

		descText.text = optionsArray[curSelected].description;
		descText.screenCenter(Y);
		descText.y += 270;

		descBox.setPosition(descText.x - 10, descText.y - 10);
		descBox.setGraphicSize(Std.int(descText.width + 20), Std.int(descText.height + 25));
		descBox.updateHitbox();

        daSquare.y = squarePos[curSelected];

		if(boyfriend != null)
		{
			boyfriend.visible = optionsArray[curSelected].showBoyfriend;
		}
		curOption = optionsArray[curSelected]; //shorter lol
		trace("CURSELECTED: " + optionsArray[curSelected].name + " VAR = " + optionsArray[curSelected].getValue());
	}

	function toggleDescText()
	{
		descText.visible = !descText.visible;
		descBox.visible = !descText.visible;
	}
	public function reloadBoyfriend()
	{
		var wasVisible:Bool = false;
		if(boyfriend != null) {
			wasVisible = boyfriend.visible;
			boyfriend.kill();
			remove(boyfriend);
			boyfriend.destroy();
		}

		boyfriend = new Character(840, 170, 'bf', true);
		boyfriend.setGraphicSize(Std.int(boyfriend.width * 0.75));
		boyfriend.updateHitbox();
		boyfriend.dance();
		insert(1, boyfriend);
		boyfriend.visible = wasVisible;
	}
}
