package menus.substate;

import objects.Square;
import flixel.FlxG;
import objects.GameSprite;
import objects.GameSprite.GameText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import objects.DescBox;
import objects.ControlsTxt;

using StringTools;

class SpecialThanks extends MusicBeatSubstate
{
    var specialThanksArray:Array<Array<Dynamic>> = [
        ['Ne_Eo', 'previous coder for the mod (when it was in the first stages of development)', 'https://twitter.com/Ne_Eo_Twitch'],
        ['Lunarcleint', 'code help (mainly with shaders)', 'https://www.twitter.com/lunarcleint'],
        ['HowToAvenge101', 'menu music help', 'https://twitter.com/howtoavenge101'],
        ['Nyctoniac', 'some concept art', 'https://twitter.com/nyctoniac'],
        [
            'shaders', 
            'shaders credits are here\n[OPEN CREDIT LINK TO VIEW]', 
            'https://raw.githubusercontent.com/slithythereal/NES-Funkin-new/main/ShaderCreds.txt'
        ],
        ['Vortex2Oblivion', 'shadertoy to flixel converter script\nTHANK YOU SO MUCH IM SO GLAD I FOUND THIS SCRIPT', 'https://github.com/Vortex2Oblivion/shadertoy-to-flixel/tree/master'],
        ['Shadow Mario', 'creator of Psych Engine', 'https://twitter.com/Shadow_Mario_'],
        ['Funkin Crew', 'developers of FNF', 'https://funkin.me'],
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
    
        daSquare = new Square(500, 60);
        add(daSquare);

        for(i in 0...specialThanksArray.length){
            var offset:Float = daSquare.squareMulti + (i * 60);
            var funnyTxt:GameText = new GameText(daSquare.x + 45, offset);
            funnyTxt.setFormat(Paths.font("Pixel_NES.otf"), 40, FlxColor.WHITE, CENTER);
            funnyTxt.text = specialThanksArray[i][0];
            funnyTxt.ID = i;
            textGrp.add(funnyTxt);   
            funnyTxt.updateHitbox();
            daSquare.pushSquarePos(offset + 10);
        }

        var descInfo:FlxText = new FlxText(25, 100, 0,  'PRESS [ENTER] TO OPEN CREDIT LINK');
        descInfo.setFormat(Paths.font("Pixel_NES.otf"), 15, FlxColor.WHITE, CENTER);
        descInfo.alpha = 0.2;
        add(descInfo);

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
            if(controls.UI_UP_P)
                changeSelection(-1);
            if(controls.UI_DOWN_P)
                changeSelection(1);
            if(FlxG.keys.justPressed.ENTER)
                CoolUtil.browserLoad(specialThanksArray[curCredSelected][2]);
        }
    }

    function changeSelection(cool:Int) {
        curCredSelected += cool;
        if(curCredSelected >= specialThanksArray.length)
            curCredSelected = 0;
        if(curCredSelected < 0)
            curCredSelected = specialThanksArray.length - 1;

        descBox.changeDescText('--${specialThanksArray[curCredSelected][0]}--\n${specialThanksArray[curCredSelected][1]}', 270);
        daSquare.changeY(curCredSelected);

        for (text in textGrp) {
            if(text.ID == curCredSelected && text.text == 'CosbyDaf')
                text.color = FlxColor.RED;
            else
                text.color = FlxColor.WHITE;
        }
    }
}