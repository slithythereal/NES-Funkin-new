package menus;

import flixel.FlxSubState;
import objects.GameSprite.GameText;
import objects.GameSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.transition.FlxTransitionableState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import objects.GalleryGroup;
import flixel.util.FlxColor;
import menus.substate.*;

class Credits extends MusicBeatState {
    /*public static var credArray:Array<Array<Dynamic>> = [
        ['Kit', 'director/concept artist/sound design', 'https://twitter.com/Kitcoutski2002'],
        ['Sieggy', 'artist/animator', 'https://twitter.com/SieniorGargoyle/'],
        ['Zomboi', 'musician/sound design', 'https://soundcloud.com/zomboimusic']
    ];
    public static var specialThanksArray:Array<Array<Dynamic>> = [
        ['ManibyJelly', 'charter/backup coder', 'https://gamebanana.com/members/2042207'],
        ['Ne_Eo', 'previous coder', 'https://twitter.com/Ne_Eo_Twitch'],
        ['HowToAvenge101', 'music help', 'https://www.youtube.com/@howtoavenge1016/'],
        ['Lunarcleint', 'shader help', 'https://www.twitter.com/lunarcleint'],
        ['CosbyDaf', 'creator of NES godzilla', 'https://www.deviantart.com/cosbydaf']
    ];*/
    var galleryGrp:GalleryGroup;
    var menus:Array<String> = ['Lead Developers', 'Special Thanks'];
    var curSelected:Int = 0;
    var textGrp:FlxTypedGroup<GameText>;
    var boxGrp:FlxTypedGroup<GameSprite>;
    var isInSubState:Bool = false;

    override  function create() {
        super.create();

        persistentUpdate = true;

        galleryGrp = new GalleryGroup();
        add(galleryGrp);

        textGrp = new FlxTypedGroup<GameText>();
        add(textGrp);

        boxGrp = new FlxTypedGroup<GameSprite>();
        add(boxGrp);

        for(i in 0...menus.length)
        {
            var box:GameSprite = new GameSprite(125 + (i * 605), 250);
            box.loadGraphic(Paths.image('credits/box'));
            box.antialiasing = false;
            box.setScale(5,5);
            box.ID = i;
            boxGrp.add(box);

            var txt:GameText = new GameText(box.x + 10, box.y + 50, 400);
            txt.text = menus[i];
            txt.setFormat(Paths.font("Pixel_NES.otf"), 40, FlxColor.WHITE, CENTER);
            txt.ID = i;
            textGrp.add(txt);
        }
        changeSelected(0);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        if(!isInSubState)
        {
            if(controls.BACK)
                coolFunc('back');
            else if(controls.UI_LEFT_P)
                changeSelected(-1);
            else if (controls.UI_RIGHT_P)
                changeSelected(1);
            else if (controls.ACCEPT)
                coolFunc(menus[curSelected]);
        }
    }

    function coolFunc(daFunc:String)
    {
        galleryGrp.setGalleryX();
        switch(daFunc){
            case 'Lead Developers':
                openSubState(new CreditsSub());
            case 'Special Thanks':
                openSubState(new SpecialThanks());
            case 'back':
                FlxTransitionableState.skipNextTransIn = true;
                FlxTransitionableState.skipNextTransOut = true;
				LoadingState.loadAndSwitchState(new menus.MenuState());
                
            default:
                trace('func dont exist lol');
        }
    }

    function changeSelected(cool:Int) {
        curSelected += cool;
        if(curSelected >= menus.length)
            curSelected = 0;
        if(curSelected < 0)
            curSelected = menus.length - 1;

        boxGrp.forEach(function(spr:GameSprite){
            if(spr.ID == curSelected)
                spr.color = FlxColor.RED;
            else
                spr.color = FlxColor.WHITE;
        });
    }

    override function openSubState(SubState:FlxSubState) {
        isInSubState = true;
        for(sprite in boxGrp)
            sprite.visible = false;
        for (text in textGrp) {
            text.visible = false;
        }
        super.openSubState(SubState);
    }
    override function closeSubState(){
        isInSubState = false;
        for(sprite in boxGrp)
            sprite.visible = true;
        for (text in textGrp) {
            text.visible = true;
        }
        super.closeSubState();
    }
}