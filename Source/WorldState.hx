import openfl.display.Sprite;

class WorldState implements IResizeable {
	private var gridWidth: Int;	// number of columns.
	private var gridHeight: Int;	// number of rows.
	private var intrinsicWidth: Int;	// internal width of canvas buffers / game screens.
	private var intrinsicHeight: Int;	// internal height of canvas buffers / game screens.
	private var displayWidth: Int;	// external width of game display / canvas.
	private var displayHeight: Int;	// external height of game display / canvas.
	private var canvas: Sprite;	// drawable surface of the game.
	private var gridScreen: GridScreen; // Grid screen display.

	@:allow(HaxeTris)
	private function new(gw :Int, gh: Int, w: Int, h: Int) {
		gridWidth = gw;
		gridHeight = gh;
		intrinsicWidth = w;
		intrinsicHeight = h;
		displayWidth = w;
		displayHeight = h;
		canvas = new Sprite();

		canvas.graphics.beginFill (0xFF0000, 1);
		canvas.graphics.drawRect (0, 0, intrinsicWidth, intrinsicHeight);
		gridScreen = new GridScreen(this);
	}

	@:allow(HaxeTris, GridScreen)
	private function getCanvas(): Sprite { return canvas; }

	public function getPreparedCanvas(): Sprite {
		canvas.graphics.clear();
		canvas.scaleX = 1;
		canvas.scaleY = 1;
		return canvas;
	}
	public function getGridScreen(): GridScreen {
		return gridScreen;
	}

	public function getGridWidth(): Int {
		return gridWidth;
	}
	public function getGridHeight(): Int {
		return gridHeight;
	}
	public function getIntrinsicWidth(): Int {
		return intrinsicWidth;
	}
	public function getIntrinsicHeight(): Int {
		return intrinsicHeight;
	}
	public function getDisplayWidth(): Int {
		return displayWidth;
	}
	public function getDisplayHeight(): Int {
		return displayHeight;
	}

	public function resize(newWidth: Int, newHeight: Int): Void {
		canvas.width = newWidth;
		canvas.height = newHeight;
		displayWidth = newWidth;
		displayHeight = newHeight;
	}

}