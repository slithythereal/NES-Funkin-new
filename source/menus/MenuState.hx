package menus;

import objects.Square;
import flixel.tweens.FlxEase;
import editors.CharacterEditorState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.addons.transition.FlxTransitionableState;
import flixel.text.FlxText;
import flixel.input.keyboard.FlxKey;
import flixel.addons.display.FlxBackdrop;
import objects.GalleryGroup;
import flixel.tweens.FlxTween;
#if desktop
import Discord.DiscordClient;
#end
using StringTools;

class MenuState extends MusicBeatState {
    
    private static var curOptSelected:Int = 0;

    public var optionsArray:Array<String> = ['play', 'settings', 'credits', 'exit'];
    private var optionGrp:FlxTypedGroup<FlxText>;

	var codes:Array<String> = [
		'november'
	];
	var codesBuffer:String = ''; //titlestate code lol
	var allowedKeys:String = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

    var daSquare:Square;
    var squarePos:Array<Float> = [];
    var squareMulti:Float = 190;
    
    var selectedSMTH:Bool = false;
    var galleryGrp:GalleryGroup;
 
    
    override function create() {
        #if desktop
		DiscordClient.changePresence("Main Menu", null);
		#end

        galleryGrp = new GalleryGroup();
        add(galleryGrp);

        optionGrp = new FlxTypedGroup<FlxText>();
        add(optionGrp);

        daSquare = new Square(485, squareMulti);
        add(daSquare);

        for(i in 0...optionsArray.length)
        {
            var offset:Float = squareMulti + (i * 115);
            var optionsTxt:FlxText = new FlxText(526, offset);
            optionsTxt.setFormat(Paths.font("Pixel_NES.otf"), 40, FlxColor.WHITE, CENTER);
            optionsTxt.text = optionsArray[i];
            if(optionsTxt.text == 'exit')
                optionsTxt.color = FlxColor.RED;
            optionsTxt.ID = i;
            optionGrp.add(optionsTxt);   
            optionsTxt.updateHitbox();
            squarePos.push(offset + 10);
        }

        changeItem(0);

        super.create();
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        if(!selectedSMTH){
            if(controls.UI_UP_P)
                changeItem(-1);
            if(controls.UI_DOWN_P)
                changeItem(1);
            if(controls.ACCEPT)
                coolFunc('${optionsArray[curOptSelected]}');
            #if debug
            if(FlxG.keys.justPressed.SEVEN)
                MusicBeatState.switchState(new editors.MasterEditorMenu());
            #end

            if(FlxG.keys.firstJustPressed() != FlxKey.NONE){ //literally just titlestate.hx code
                var keyPressed:FlxKey = FlxG.keys.firstJustPressed();
                var keyName:String = Std.string(keyPressed);
                if(allowedKeys.contains(keyName)) {
                    codesBuffer += keyName;
                    if(codesBuffer.length >= 32) codesBuffer = codesBuffer.substring(1);
    
                    for (wordRaw in codes){
                        var word:String = wordRaw.toUpperCase();
                        if (codesBuffer.contains(word)){
                            //function
                            trace("yuhhhhhhh");
                            FlxG.openURL('https://youtube.com/playlist?list=PLg5pkob-JRkbkoT5yiKOzdj_LEiQYQW2H&si=vRTtNXPTAzxhPF5D');
    
                            codesBuffer = '';
                            break;
                        }
                    }
                }
            
            }   
        }
    }

    function coolFunc(daFunc:String) {
        galleryGrp.setGalleryX();
        switch(daFunc)
        {
            case 'play':
                selectedSMTH = true;
                WeekData.reloadWeekFiles(true);
                FreeplayState.destroyFreeplayVocals();
                PlayState.isStoryMode = true;
                CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
                PlayState.storyDifficulty = 1;
                PlayState.storyPlaylist = ["Godzilla"];
                var diffic = CoolUtil.getDifficultyFilePath(PlayState.storyDifficulty);
                if(diffic == null) diffic = '';
                PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + diffic, PlayState.storyPlaylist[0].toLowerCase());
                PlayState.campaignScore = 0;
                PlayState.campaignMisses = 0;
                LoadingState.loadAndSwitchState(new PlayState(), true);
            case 'exit':
                Sys.exit(1);
            /*
            case 'credits':
                FlxTransitionableState.skipNextTransIn = true;
                FlxTransitionableState.skipNextTransOut = true;
                MusicBeatState.switchState(new Credits());
            */
            case 'settings':
                FlxTransitionableState.skipNextTransIn = true;
                FlxTransitionableState.skipNextTransOut = true;
                LoadingState.loadAndSwitchState(new options.OptionsState());
            default:
                trace("NO FUNCTION LOL :((((((((((((");
                trace('option put: $daFunc');
        }
    }

    function changeItem(num:Int) {
        curOptSelected += num;
        if(curOptSelected >= optionsArray.length)
            curOptSelected = 0;
        if(curOptSelected < 0)
            curOptSelected = optionsArray.length - 1;

        daSquare.y = squarePos[curOptSelected];
    }
}