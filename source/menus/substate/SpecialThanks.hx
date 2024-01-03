package menus.substate;

import objects.Square;
import flixel.FlxG;
import objects.GameSprite;
import objects.GameSprite.GameText;
import flixel.group.FlxGroup.FlxTypedGroup;
import objects.DescBox;

using StringTools;

class SpecialThanks extends MusicBeatSubstate
{
    var specialThanksArray:Array<Array<Dynamic>> = [
        ['Ne_Eo', 'previous coder for the mod (when it was in the first stages of development)', 'https://twitter.com/Ne_Eo_Twitch'],
        ['HowToAvenge101', 'music help', 'https://twitter.com/howtoavenge101'],
        ['Lunarcleint', 'code help (via dms lol)', 'https://www.twitter.com/lunarcleint'],
        ['CosbyDaf', 'creator of NES Godzilla Creepypasta', 'https://www.deviantart.com/cosbydaf']
    ];
    var textGrp:FlxTypedGroup<GameText>;
    private static var curCredSelected:Int = 0;
    var descBox:DescBox;
    var daSquare:Square;

    public function new() {
        super();
        textGrp = new FlxTypedGroup<GameText>();
        add(textGrp);

        /*
            daSquare = new Square(540, 190);
            add(daSquare);
        */

        descBox = new DescBox(true, 'Special Thanks');
        add(descBox);

        changeSelection(0);
    }

    var cantUnpause:Float = 0.1;
    override function update(elapsed:Float) {
        cantUnpause -= elapsed;

        super.update(elapsed);

        if(cantUnpause <= 0){
            if(controls.BACK)
                close();
        }
    }

    function changeSelection(cool:Int) {
        curCredSelected += cool;
        if(curCredSelected >= specialThanksArray.length)
            curCredSelected = 0;
        if(curCredSelected < 0)
            curCredSelected = specialThanksArray.length - 1;

        descBox.changeDescText(specialThanksArray[curCredSelected][1], 270);
    }
}