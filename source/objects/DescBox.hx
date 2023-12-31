package objects;

import flixel.group.FlxGroup;
import objects.GameSprite.GameText;
import objects.GameSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.text.FlxText.FlxTextBorderStyle;

class DescBox extends FlxGroup
{
    var descBox:GameSprite;
    var descTxt:GameText;
    public var descBoxVisible:Bool = false;

    public function new(?boxVisible:Bool = false)
    {
        super();

        descBoxVisible = boxVisible;

        descBox = new GameSprite();
        descBox.makeGraphic(1, 1, FlxColor.BLACK);
        descBox.alpha = 0.6;
        descBox.visible = descBoxVisible;
        add(descBox);

        descTxt = new GameText(50, 600, 1180, "", 32);
        descTxt.setFormat(Paths.font("Pixel_NES.otf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
          descTxt.scrollFactor.set();
          descTxt.borderSize = 2.4;
          descTxt.visible = descBoxVisible;
          add(descTxt);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
        if(FlxG.keys.justPressed.TAB)
            toggleDescText();
        
    }
    public function changeDescText(newText:String, ?newY:Float){
        descTxt.text = newText;
        descTxt.screenCenter(Y);
        descTxt.y += newY;

      descBox.setPosition(descTxt.x - 10, descTxt.y - 10);
      descBox.setGraphicSize(Std.int(descTxt.width + 20), Std.int(descTxt.height + 25));
      descBox.updateHitbox();
    }
    public function toggleDescText()
    {
      descTxt.visible = !descTxt.visible;
      descBox.visible = !descBox.visible;
    }
}