package objects;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.addons.display.FlxBackdrop;
import flixel.tweens.FlxEase;
import flixel.group.FlxSpriteGroup;

class GalleryGroup extends FlxSpriteGroup
{
    private static var isGalleryShowing:Bool = false;
    private static var galleryX:Float = 0;
    
    var gallery:FlxBackdrop;
    var whiteFlash:FlxSprite;
    private static var whiteflashGone:Bool = false;
    
    public function new() { 
        super();

        gallery = new FlxBackdrop(Paths.image('NESpanorama'), 0, 0, true, false);
        gallery.velocity.set(-25, 0);
        gallery.setPosition(galleryX, 0);
        if(isGalleryShowing)
            gallery.alpha = 0.25;
        else
            gallery.alpha = 0; 
        gallery.visible = isGalleryShowing;
        gallery.scale.set(1.25, 1.25);
        gallery.updateHitbox();
        add(gallery);
        CommandData.watch(gallery);

        if(!whiteflashGone){
            whiteFlash = new FlxSprite().makeGraphic(FlxG.width, FlxG.height);
            whiteFlash.alpha = 0;
            whiteFlash.visible = false;
            add(whiteFlash);
        }
    }

    override public function update(elapsed:Float) {
        super.update(elapsed);

        if(FlxG.sound.music.time >= 59010 && FlxG.sound.music != null && !isGalleryShowing && !whiteflashGone) //59010
        {
            isGalleryShowing = true;
            gallery.visible = true;
            whiteFlash.alpha = 1;
            whiteFlash.visible = true;
            FlxTween.tween(gallery, {alpha: 0.25}, 0.5, {ease: FlxEase.sineIn});
            FlxTween.tween(whiteFlash, {alpha: 0}, 1.5, {ease: FlxEase.linear, onComplete: function(twn:FlxTween){
                whiteflashGone = true;
            }});     
        }
    }
    public function setGalleryX()
        galleryX = gallery.x;
    public function setVelocity(xVelocity:Float)
        gallery.velocity.set(xVelocity, 0);
    public function setAlpha(daAlpha:Float)
        gallery.alpha = daAlpha;
}