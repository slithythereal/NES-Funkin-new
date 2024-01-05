package objects;

import flixel.group.FlxGroup.FlxTypedGroup;
import objects.GameSprite;
import flixel.util.FlxColor;
import objects.GameSprite.GameText;
import flixel.group.FlxSpriteGroup;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.system.FlxSound;

class RUNtxt extends FlxGroup
{
    public var runArray:Array<String> = ['R','U','N'];
    public var runGrp:FlxTypedGroup<RunLetter>;
    public var strike:Int = 0;
    public var isRunningHealthDrain:Bool = false;
    public var healthDrainVar:Float = 0.6;
    public var roarSound:FlxSound;
    public var killSound:FlxSound;

    public function new(?x:Float = 0, ?y:Float = 0)
    {
        super();

        runGrp = new FlxTypedGroup<RunLetter>();
        add(runGrp);

        for(i in 0...runArray.length){
            var offset:Float = x + (i * 40);
            var txt:RunLetter = new RunLetter(offset, y, 0, runArray[i]);
            txt.setFormat(Paths.font("Pixel_NES.otf"), 50, FlxColor.WHITE, CENTER);
            txt.ID = i;
            txt.updateHitbox();
            runGrp.add(txt);
        }
        roarSound = new FlxSound();
        roarSound.loadEmbedded(Paths.sound('run/redRoar_1'));
        FlxG.sound.list.add(roarSound);

        killSound = new FlxSound();
        killSound.loadEmbedded(Paths.sound('run/neskill'), true);
        FlxG.sound.list.add(killSound);
    }

    public function addStrike(num:Int)
    {
        if(strike < runArray.length){
            strike += num;
            trace("STRIKE " + strike);
            runGrp.forEach(function(txt:RunLetter){
                if(txt.ID == strike - 1 && !txt.isRED){
                    txt.isRED = true;
                    txt.color = FlxColor.RED;
                    trace(runArray[txt.ID] + ' is now red!');
                }
            });
            FlxG.sound.play(Paths.sound('run/redBite'));
            if(strike == runArray.length && !isRunningHealthDrain){
                isRunningHealthDrain = true;
                roarSound.play();
                killSound.play();
            }
        }
    }
}

class RunLetter extends GameText 
{
    public var isRED:Bool = false;
    public function new(?X:Float = 0, ?Y:Float = 0, ?fieldWidth:Null<Float>, ?text:String = '')
    {
        super(X, Y, fieldWidth, text);
    }
}