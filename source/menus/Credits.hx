package menus;

import flixel.addons.transition.FlxTransitionableState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;

class Credits extends MusicBeatSubstate {
    var credArray:Array<Array<Dynamic>> = [
        ['Kit', 'director/concept artist/sound design', 'https://twitter.com/Jason12876749'],
        ['Sieggy', 'artist/animator', 'https://twitter.com/SieniorGargoyle/'],
        ['Zomboi', 'musician/sound design', 'https://soundcloud.com/zomboimusic']
    ];
    var specialThanksArray:Array<Array<Dynamic>> = [
        ['HowToAvenge101', 'music help', 'https://www.youtube.com/@howtoavenge1016/'],
        ['Ne_Eo', 'previous coder', 'https://twitter.com/Ne_Eo_Twitch'],
        ['ManibyJelly', 'charter/backup coder', 'https://gamebanana.com/members/2042207'],
        ['CosbyDaf', 'creator of NES godzilla', 'https://www.deviantart.com/cosbydaf']
    ];

    public function new() {
        super();
        Init.curState = 'Credits';

        if(FlxG.random.int(0, 100) <= 1)
            credArray.push(['Slithy', 'coder/finished the mod\ntype "november"', 'https://slithy.carrd.co']);
        else
            credArray.push(['Slithy', 'coder/finished the mod', 'https://slithy.carrd.co']);
    }
}