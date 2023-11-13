package menus;

import flixel.tweens.FlxTween;
import objects.GameSprite;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import objects.GameSprite;
import objects.GameSprite.GameText;
import flixel.tweens.FlxEase;
class Title extends MusicBeatState
{
    var redBox:FlxSprite;
    var godZillaLogo:GameSprite;
    var introSkipped:Bool = false;
    var pressEnterTxt:GameText;
    var creepypastaTxt:GameText;
    override function create() {
        trace("in title :)");

        redBox = new FlxSprite().makeGraphic(FlxG.width, FlxG.height - 300, 0xFFFF0000);
        redBox.screenCenter();
        add(redBox);

        godZillaLogo = new GameSprite(235, 150);
        godZillaLogo.frames = Paths.getSparrowAtlas('godzillaLogo');
        godZillaLogo.animation.addByPrefix('start', 'bootup', 1);
        godZillaLogo.animation.addByPrefix('loop', 'loop', 24);
        godZillaLogo.animation.addByPrefix('end1', 'ending1', 1);
        godZillaLogo.animation.addByPrefix('end2', 'ending2', 1);
        godZillaLogo.animation.addByPrefix('end3', 'ending3', 1);
        godZillaLogo.animation.play('start');
        godZillaLogo.scale.set(1.2, 1.2);
        godZillaLogo.updateHitbox();
        add(godZillaLogo);

        FlxG.sound.playMusic(Paths.music("titleStart"));
        FlxG.sound.music.loopTime = 4.132;

        super.create();        
    }
    var selectedSMTH:Bool = true;
    override function update(elapsed:Float) {
        super.update(elapsed);
        if(FlxG.sound.music.time >= 3537 && !introSkipped)
            transition();
        
        if(controls.ACCEPT && !selectedSMTH)
            endTrans();
    }


    function endTrans()
    {
        selectedSMTH = true;
        var timeMulti = 0.075;
        FlxG.sound.music.stop();
        remove(pressEnterTxt);
        //im so lazy bro 😭 GOTTA REDO THIS
        new FlxTimer().start(timeMulti, function(tmr:FlxTimer){
            remove(creepypastaTxt);
            new FlxTimer().start(timeMulti, function(tmr:FlxTimer){
                godZillaLogo.animation.play("end1");
                new FlxTimer().start(timeMulti, function(tmr:FlxTimer){
                    godZillaLogo.animation.play('end2');
                    new FlxTimer().start(timeMulti, function(tmr:FlxTimer){
                        godZillaLogo.animation.play('end3');
                        new FlxTimer().start(timeMulti, function(tmr:FlxTimer){
                            remove(godZillaLogo);
                            new FlxTimer().start(0.75, function(tmr:FlxTimer){
                                Init.playMenuMusic();
                                MusicBeatState.switchState(new menus.MenuState());
                            });
                        });
                    });
                });
            });
        });
    }


    function transition()
    {
        introSkipped = true;
        var white:FlxSprite = new FlxSprite().makeGraphic(FlxG.width,FlxG.height);
        add(white);
        FlxTween.tween(white, {alpha: 0}, 0.75, {ease: FlxEase.linear, onComplete: function(twn:FlxTween){
            remove(white);
            selectedSMTH = false;
        }});
        remove(redBox);
        godZillaLogo.animation.play('loop');

        pressEnterTxt = new GameText(0, 600, 0,"PRESS START");
        pressEnterTxt.setFormat(Paths.font('Pixel_NES.otf'), 32, FlxColor.WHITE, CENTER);
        pressEnterTxt.screenCenter(X);
        pressEnterTxt._dynamic.tweenOut = function(){
            FlxTween.tween(pressEnterTxt, {alpha: 0}, 1, {ease: FlxEase.linear, onComplete: function(twn:FlxTween){
                pressEnterTxt._dynamic.tweenIn();
            }});
        }
        pressEnterTxt._dynamic.tweenIn = function(){
            FlxTween.tween(pressEnterTxt, {alpha: 1}, 1, {ease: FlxEase.linear, onComplete: function(twn:FlxTween){
                pressEnterTxt._dynamic.tweenOut();
            }});
        }
        add(pressEnterTxt);
        pressEnterTxt._dynamic.tweenOut();

        creepypastaTxt = new GameText(0,25,0,"GODZILLA CREEPYPASTA");
        creepypastaTxt.setFormat(Paths.font('Pixel_NES.otf'), 37, FlxColor.WHITE, CENTER);
        creepypastaTxt.screenCenter(X);
        add(creepypastaTxt);
        CommandData.watch(creepypastaTxt);
    }
}