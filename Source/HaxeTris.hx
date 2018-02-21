import openfl.display.Sprite;
import openfl.events.Event;

class HaxeTris extends Sprite implements IResizeable {

	private var screenManager: ScreenManager;
	private var worldState: WorldState;

	public function new() {
		super ();

		worldState = new WorldState(10, 20, 400, 800);
		screenManager = new ScreenManager(worldState);
	}

	public function init() {
		//Background.filters = [ new BlurFilter (10, 10) ];
		addChild (worldState.getCanvas());

		stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		stage.addEventListener(Event.EXIT_FRAME, onExitFrame);
	}

	// IResizeable
	public function resize (newWidth: Int, newHeight: Int): Void {
		worldState.resize(newWidth, newHeight);
		screenManager.resize(newWidth, newHeight);
	}

	private function onEnterFrame(event: Event): Void {
		screenManager.render(worldState);
	}
	private function onExitFrame(event: Event): Void {
		screenManager.update(worldState);
	}
}