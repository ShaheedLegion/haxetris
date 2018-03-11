package;


import lime.app.Config;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;
import lime.utils.Assets;

#if sys
import sys.FileSystem;
#end

@:access(lime.utils.Assets)


@:keep @:dox(hide) class ManifestResources {
	
	
	public static var preloadLibraries:Array<AssetLibrary>;
	public static var preloadLibraryNames:Array<String>;
	
	
	public static function init (config:Config):Void {
		
		preloadLibraries = new Array ();
		preloadLibraryNames = new Array ();
		
		var rootPath = null;
		
		if (config != null && Reflect.hasField (config, "rootPath")) {
			
			rootPath = Reflect.field (config, "rootPath");
			
		}
		
		if (rootPath == null) {
			
			#if (ios || tvos || emscripten)
			rootPath = "assets/";
			#elseif (sys && windows && !cs)
			rootPath = FileSystem.absolutePath (haxe.io.Path.directory (#if (haxe_ver >= 3.3) Sys.programPath () #else Sys.executablePath () #end)) + "/";
			#else
			rootPath = "";
			#end
			
		}
		
		Assets.defaultRootPath = rootPath;
		
		#if (openfl && !flash && !display)
		
		#end
		
		var data, manifest, library;
		
		data = '{"name":null,"assets":"aoy4:sizei2343079y4:typey5:MUSICy2:idy28:assets%2Fkorobeiniki_end.mp3y9:pathGroupaR4hy7:preloadtgoR0i2828747R1R2R3y29:assets%2Fkorobeiniki_game.mp3R5aR7hR6tgoR0i1339559R1R2R3y30:assets%2Fkorobeiniki_start.mp3R5aR8hR6tgoR0i33464R1R2R3y22:assets%2Fline-drop.mp3R5aR9hR6tgoR0i10075R1R2R3y24:assets%2Fline-remove.mp3R5aR10hR6tgh","version":2,"libraryArgs":[],"libraryType":null}';
		manifest = AssetManifest.parse (data, rootPath);
		library = AssetLibrary.fromManifest (manifest);
		Assets.registerLibrary ("default", library);
		
		
		library = Assets.getLibrary ("default");
		if (library != null) preloadLibraries.push (library);
		else preloadLibraryNames.push ("default");
		
		
	}
	
	
}


#if !display
#if flash

@:keep @:bind #if display private #end class __ASSET__assets_korobeiniki_end_mp3 extends null { }
@:keep @:bind #if display private #end class __ASSET__assets_korobeiniki_game_mp3 extends null { }
@:keep @:bind #if display private #end class __ASSET__assets_korobeiniki_start_mp3 extends null { }
@:keep @:bind #if display private #end class __ASSET__assets_line_drop_mp3 extends null { }
@:keep @:bind #if display private #end class __ASSET__assets_line_remove_mp3 extends null { }
@:keep @:bind #if display private #end class __ASSET__manifest_default_json extends null { }


#elseif (desktop || cpp)

@:file("Assets/korobeiniki_end.mp3") #if display private #end class __ASSET__assets_korobeiniki_end_mp3 extends haxe.io.Bytes {}
@:file("Assets/korobeiniki_game.mp3") #if display private #end class __ASSET__assets_korobeiniki_game_mp3 extends haxe.io.Bytes {}
@:file("Assets/korobeiniki_start.mp3") #if display private #end class __ASSET__assets_korobeiniki_start_mp3 extends haxe.io.Bytes {}
@:file("Assets/line-drop.mp3") #if display private #end class __ASSET__assets_line_drop_mp3 extends haxe.io.Bytes {}
@:file("Assets/line-remove.mp3") #if display private #end class __ASSET__assets_line_remove_mp3 extends haxe.io.Bytes {}
@:file("") #if display private #end class __ASSET__manifest_default_json extends haxe.io.Bytes {}



#else



#end

#if (openfl && !flash)



#end
#end