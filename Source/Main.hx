import openfl.display.Sprite;
import openfl.display.StageScaleMode;
import openfl.events.Event;

class Main extends Sprite implements IResizeable {
	
	private var haxeTris: HaxeTris; 

	public function new() {
		super ();

		stage.scaleMode = StageScaleMode.SHOW_ALL;
		haxeTris = new HaxeTris();
		addChild (haxeTris);
		haxeTris.init();
		
		resize (stage.stageWidth, stage.stageHeight);
		stage.addEventListener (Event.RESIZE, onResize);
	}

	public function resize (newWidth: Int, newHeight: Int): Void {
		haxeTris.resize (newWidth, newHeight);
		trace("NewW: " + newWidth + " NewH: " + newHeight + " SW: " + stage.width + " SH: " + stage.height);
	}

	private function onResize (event:Event):Void {
		resize (stage.stageWidth, stage.stageHeight);
	}
}