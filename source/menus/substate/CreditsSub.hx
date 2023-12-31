package menus.substate;

import objects.GameSprite;
import flixel.FlxG;
import flixel.FlxSprite;
import objects.GameSprite.GameText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
using StringTools;
class CreditsSub extends MusicBeatSubstate
{
    var credArray:Array<Array<Dynamic>> = [
        ['Kit', 'director/concept artist/sound design', 'https://twitter.com/Kitcoutski2002'],
        ['Sieggy', 'artist/animator', 'https://twitter.com/SieniorGargoyle/'],
        ['Zomboi', 'musician/sound design', 'https://soundcloud.com/zomboimusic'],
        ['Slithy', 'coder/finished the mod', 'https://slithy.carrd.co']
    ];
    var portraitSprite:GameSprite = null;
    var credName:GameText = null;
    var portraitGrp:FlxTypedGroup<GameSprite>;
    var isCredOpen:Bool = false;
    private static var curCredSelected:Int = 0;

    public function new() {
        super();

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
        portraitSprite = new GameSprite();
        portraitSprite.antialiasing = false;
        portraitSprite.scale.set(10, 10);
        portraitSprite.updateHitbox();
        add(portraitSprite);
        CommandData.watch(portraitSprite);
        toggleCredIconStuff();

        selectCred(0);
    }

    var cantUnpause:Float = 0.1;
    override function update(elapsed:Float)
    {
        cantUnpause -= elapsed;
        super.update(elapsed);

        if(cantUnpause <= 0){
            if(controls.ACCEPT)
                openCredStuff(curCredSelected);
        }

        if(controls.UI_LEFT_P)
            selectCred(-1);
        else if(controls.UI_RIGHT_P)
            selectCred(1);
        else if(controls.BACK)
            close();

    }

    function coolFunc(coolFunc:String){
        switch(coolFunc){
            default:
                trace("bruh");
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
    }   

    function toggleCredIconStuff()
    {
        portraitSprite.visible = !portraitSprite.visible;        
    }
    function openCredStuff(daCred:Int)
    {
        trace("credOpened");
        if(!isCredOpen)
            toggleCredIconStuff();
        
        isCredOpen = true;

        portraitSprite.frames = portraitGrp.members[daCred].frames;
        portraitSprite.animation.addByPrefix('red', '${credArray[daCred][0].toLowerCase()} red');
        portraitSprite.animation.play('red');
        portraitSprite.setPosition(100, 100);
        portraitSprite.updateHitbox();


    }
}