import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.TouchEvent;
import openfl.display.FPS;

class HaxeTris extends Sprite implements IResizeable {

	private var screenManager: ScreenManager;
	private var worldState: WorldState;

	public function new() {
		super ();

		worldState = new WorldState(10, 20, 400, 800);
	}

	public function init() {
		addChild (worldState.getCanvas());
		var fps:FPS = new FPS(10, 10, 0xffffff);
		addChild(fps);

		screenManager = new ScreenManager(worldState);

		stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		stage.addEventListener(Event.EXIT_FRAME, onExitFrame);
		stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		stage.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
		stage.addEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
		stage.addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
	}

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

	private function onKeyUp(event: KeyboardEvent): Void {
		worldState.setKeyPressed(event.keyCode);
	}
	private function onTouchBegin(event: TouchEvent): Void {
		worldState.setTouchStarted(event.stageX, event.stageY);
	}
	private function onTouchMove(event: TouchEvent): Void {
		worldState.setTouchMoved(event.stageX, event.stageY);
	}
	private function onTouchEnd(event: TouchEvent): Void {
		worldState.setTouchEnded(event.stageX, event.stageY);
	}
}