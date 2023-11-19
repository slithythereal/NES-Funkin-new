package objects;

import flixel.group.FlxGroup.FlxTypedGroup;
import objects.GameSprite;
import flixel.util.FlxColor;
import objects.GameSprite.GameText;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup;

class RUNtxt extends FlxGroup
{
    public var runArray:Array<String> = ['R','U','N'];
    public var runGrp:FlxTypedGroup<RunLetter>;
    public var strike:Int = 0;
    public var isRunningHealthDrain:Bool = false;
    public var healthDrainVar:Float = 0.6;

    public function new(?x:Float = 0, ?y:Float = 0)
    {
        super();

        runGrp = new FlxTypedGroup<RunLetter>();
        add(runGrp);

        for(i in 0...runArray.length){
            var offset:Float = x + (i * 60);
            var txt:RunLetter = new RunLetter(offset, y, 0, runArray[i]);
            txt.setFormat(Paths.font("Pixel_NES.otf"), 75, FlxColor.WHITE, CENTER);
            txt.ID = i;
            txt.updateHitbox();
            runGrp.add(txt);
            //CommandData.watch(txt);
        }
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
            if(strike == runArray.length && !isRunningHealthDrain)
                isRunningHealthDrain = true;
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
//lua code
/*
local letterYValue = 500;
local letterSpacing = 60;
local RLetterX = 225;
local UletterX = RLetterX + letterSpacing;
local healthDrain = 0;

function onUpdate(elapsed)
        if getProperty('songMisses') >= 15 then
            setProperty('NLetter.color', getColorFromHex('ff0400'))
            healthDrain = healthDrain + 0.6;
        end
        if healthDrain > 0 then
            healthDrain = healthDrain - 0.2 * elapsed;
            setProperty('health', getProperty('health') - 1 * elapsed);
            if healthDrain < 0 then
                healthDrain = 0;
            end
        end
    end
end
 */
