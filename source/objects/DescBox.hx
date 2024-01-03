package objects;

import flixel.group.FlxGroup;
import objects.GameSprite.GameText;
import objects.GameSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.text.FlxText.FlxTextBorderStyle;
import flixel.text.FlxText;

//look idk how descbox.hx ended up looking like this, it must've been some kinda accident 💀 -slithy
class DescBox extends FlxGroup
{
    var descBox:GameSprite;
    var descTxt:GameText;
    public var descBoxVisible:Bool = false;

    public function new(?boxVisible:Bool = false, title:String)
    {
        super();

        descBoxVisible = boxVisible;

        var titleText:TitleText = new TitleText(title);
        add(titleText);
        
        var descInfo:FlxText = new FlxText(25, 80, 0,  'PRESS [TAB] TO TOGGLE DESCRIPTION');
        descInfo.setFormat(Paths.font("Pixel_NES.otf"), 15, FlxColor.WHITE, CENTER);
        descInfo.alpha = 0.2;
        add(descInfo);

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
class TitleText extends FlxGroup { //lazy fr -slithy
  public function new(title:String){
    super();
    var titleText:FlxText = new FlxText(25, 40, 0, title);
    titleText.setFormat(Paths.font("Pixel_NES.otf"), 30, FlxColor.WHITE, CENTER);
    titleText.alpha = 0.4;  
    add(titleText);
  }
}