package menus.substate;

import objects.GameSprite;
import flixel.FlxG;
import flixel.FlxSprite;
import objects.GameSprite.GameText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import objects.DescBox.TitleText;
using StringTools;
class CreditsSub extends MusicBeatSubstate
{
    var credArray:Array<Array<Dynamic>> = [
        ['Kit-_-', 'director/concept artist/sound design', 'https://twitter.com/Kitcoutski2002'],
        ['Sieggy', 'artist/animator', 'https://twitter.com/SieniorGargoyle/'],
        ['Zomboi', 'musician/sound design', 'https://twitter.com/_Zombeats'],
        ['Slithy', 'programmer/finished the mod (kinda)', 'https://slithy.carrd.co']
    ];
    var portraitSprite:GameSprite;
    var credName:GameText;
    var workTxt:GameText;
    var descriptTxt:GameText;
    var portraitGrp:FlxTypedGroup<GameSprite>;
    var isCredOpen:Bool = false;
    private static var curCredSelected:Int = 0;
    var canPressKeys:Bool = true;

    public function new() {
        super();

        var titleText:TitleText = new TitleText('Lead Developers');
        add(titleText);

        portraitGrp = new FlxTypedGroup<GameSprite>();
        add(portraitGrp);

        for(i in 0...credArray.length)
        {
            var credSpr:GameSprite = new GameSprite(190 + (i * 250), 560);
            credSpr.frames = Paths.getSparrowAtlas('credits/credIcons/${credArray[i][0].toLowerCase()}');
            credSpr.animation.addByPrefix('red', '${credArray[i][0].toLowerCase()} red', 1);
            credSpr.animation.addByPrefix('white', '${credArray[i][0].toLowerCase()} white', 1);
            credSpr.animation.play('white');
            credSpr.antialiasing = false;
            credSpr.scale.set(4, 4);
            credSpr.updateHitbox();
            portraitGrp.add(credSpr);
        }

        portraitSprite = new GameSprite(100, 100);
        portraitSprite.antialiasing = false;
        portraitSprite.scale.set(10, 10);
        portraitSprite.updateHitbox();
        add(portraitSprite);
        portraitSprite._dynamic.credTween = function(daCred:Int)
        {
            portraitSprite.frames = portraitGrp.members[daCred].frames;
            portraitSprite.animation.addByPrefix('red', '${credArray[daCred][0].toLowerCase()} red');
            portraitSprite.animation.play('red');
            portraitSprite.updateHitbox();
        }

        credName = new GameText(480, 100);
        credName.setFormat(Paths.font("Pixel_NES.otf"), 44, FlxColor.RED, CENTER);
        add(credName);
        credName._dynamic.credTween = function(daCred:Int) {
            credName.text = credArray[daCred][0].toUpperCase();
            credName.updateHitbox();
        }
        CommandData.watch(credName);

        workTxt = new GameText(480, 145);
        workTxt.setFormat(Paths.font("Pixel_NES.otf"), 24, FlxColor.RED, CENTER);
        add(workTxt);
        workTxt._dynamic.credTween = function(daCred:Int){
            workTxt.text = credArray[daCred][1];
            workTxt.updateHitbox();
        }

        descriptTxt = new GameText(480, 180);
        descriptTxt.setFormat(Paths.font("Pixel_NES.otf"), 16, FlxColor.RED, CENTER);
        add(descriptTxt);
        descriptTxt._dynamic.credTween = function(daCred:Int){
            descriptTxt.text = "PRESS [ENTER] TO OPEN CREDIT LINK";
            descriptTxt.updateHitbox();
        }

        var credInfo:GameText = new GameText(353, 523, 0,  'PRESS [SPACE] TO TOGGLE CREDITS');
        credInfo.setFormat(Paths.font("Pixel_NES.otf"), 24, FlxColor.WHITE, CENTER);
        credInfo.alpha = 0.5;
        add(credInfo);
        credInfo._dynamic.update = function(elapsed:Float)
        {
            if(isCredOpen && credInfo.visible)
                credInfo.visible = false;
        }

        toggleCredIconStuff();

        selectCred(0);
    }

    var cantUnpause:Float = 0.1;
    override function update(elapsed:Float)
    {
        cantUnpause -= elapsed;
        super.update(elapsed);

        if(cantUnpause <= 0){
            if(canPressKeys){
                if(FlxG.keys.justPressed.SPACE){
                    if(!isCredOpen)
                        openCredStuff(curCredSelected);
                    else{
                        toggleCredIconStuff();
                        isCredOpen = false;
                    }
                }
                if(FlxG.keys.justPressed.ENTER && isCredOpen)
                    CoolUtil.browserLoad(credArray[curCredSelected][2]);
                    
                if(controls.UI_LEFT_P)
                    selectCred(-1);
                else if(controls.UI_RIGHT_P)
                    selectCred(1);
                else if(controls.BACK)
                    close();
            }
        }
    }

    function selectCred(cool:Int)
    {
        portraitGrp.members[curCredSelected].animation.play('white');
        curCredSelected += cool;
        if(curCredSelected >= credArray.length)
            curCredSelected = 0;
        if(curCredSelected < 0)
            curCredSelected = credArray.length - 1;

        portraitGrp.members[curCredSelected].animation.play('red');

        if(isCredOpen)
            openCredStuff(curCredSelected);
    }   

    function toggleCredIconStuff()
    {
        portraitSprite.visible = !portraitSprite.visible;      
        credName.visible = !credName.visible;  
        workTxt.visible = !workTxt.visible;
        descriptTxt.visible = !descriptTxt.visible;
    }

    function openCredStuff(daCred:Int)
    {
        if(!isCredOpen){
            toggleCredIconStuff(); 
            isCredOpen = true;
        }
    
        portraitSprite._dynamic.credTween(daCred);
        credName._dynamic.credTween(daCred);
        workTxt._dynamic.credTween(daCred);
        descriptTxt._dynamic.credTween(daCred);
    }
}