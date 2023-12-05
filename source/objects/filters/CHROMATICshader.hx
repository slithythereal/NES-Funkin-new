package objects.filters;

import flixel.system.FlxAssets.FlxShader;

class CHROMATICshader extends FlxShader
{
    public var chromeOFFSET:Float = 0.001;
    public var chromShaderAddVar:Float = 0.0015625;
    @:glFragmentSource('
        #pragma header
        
        uniform vec2 rOffset;
        uniform vec2 gOffset;
        uniform vec2 bOffset;

        vec4 offsetColor(vec2 offset)
        {
            return texture2D(bitmap, openfl_TextureCoordv.st - offset);
        }

        void main()
        {
            vec4 base = texture2D(bitmap, openfl_TextureCoordv);
            base.r = offsetColor(rOffset).r;
            base.g = offsetColor(gOffset).g;
            base.b = offsetColor(bOffset).b;

            gl_FragColor = base;
        }
    ')
    public function new(chrome:Float)
    {
        super();
        setChrome(chrome);
    }

    public inline function setChrome(chromeOffset:Float):Void
    {
        this.rOffset.value = [chromeOffset, 0.0];
        this.gOffset.value = [0.0];
        this.bOffset.value = [-chromeOffset, 0.0];
        chromeOFFSET = chromeOffset;
    }
}