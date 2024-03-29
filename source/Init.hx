package;

import data.StoryModeData;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.input.keyboard.FlxKey;
import lime.app.Application;
import flixel.util.FlxTimer;
import flixel.addons.transition.FlxTransitionableState;
import haxe.Http;

#if desktop
import Discord.DiscordClient;
#end

using StringTools;

class Init extends MusicBeatState {
    public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS, FlxKey.MINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS, FlxKey.PLUS];
	public static var modVersion:String = '1.0.0';

    override public function create()
    {
        Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		#if LUA_ALLOWED
		Paths.pushGlobalMods();
		#end

		WeekData.loadTheFirstEnabledMod();

		FlxG.game.focusLostFramerate = 60;
		FlxG.sound.muteKeys = muteKeys;
		FlxG.sound.volumeDownKeys = volumeDownKeys;
		FlxG.sound.volumeUpKeys = volumeUpKeys;
		FlxG.keys.preventDefaultKeys = [TAB];

		PlayerSettings.init();

        super.create();

    	FlxG.save.bind('funkin', 'ninjamuffin99');
		ClientPrefs.loadPrefs();
		Highscore.load();

		FlxG.fullscreen = ClientPrefs.isFullscreen;

        persistentUpdate = true;
        persistentDraw = true;

        if (FlxG.save.data.weekCompleted != null)
        {
            StoryModeData.weekCompleted = FlxG.save.data.weekCompleted;
        }

        #if desktop
		if (!DiscordClient.isInitialized)
		{
			DiscordClient.initialize();
			Application.current.onExit.add (function (exitCode) {
				DiscordClient.shutdown();
			});
		}
		#end

		FlxG.mouse.visible = false;
        new FlxTimer().start(1, function(tmr:FlxTimer){

			#if UPDATE_CHECKER
			trace("UPDATE CHECKER EXIST YEA");
			var http = new Http("https://raw.githubusercontent.com/slithythereal/NES-Funkin-new/main/gitVersion.txt");
			var theData:Array<String> = [];
			http.onData = function(data:String){
				theData.push('${data.split('\n')[0].trim()}');
				if(!modVersion.contains(theData[0].trim())){
					CoolUtil.browserLoad('https://github.com/slithythereal/NES-Funkin-new/tree/main');
				}
			}
			http.onError = function(error){
				trace('error: $error');
			}
			#end

			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
            LoadingState.loadAndSwitchState(new menus.Title());
        });
    }

	public static var menuMusicTime:Float = 0;

	public static function playMenuMusic(){
		FlxG.sound.playMusic(Paths.music("freakyMenu"));
		FlxG.sound.music.loopTime = 59075; //29.531 seconds * 1000 = 29531
		FlxG.sound.music.endTime = 177237; // 2 minutes in milliseconds = 120000, then add 120000 + (57.248 * 1000)
	}
}