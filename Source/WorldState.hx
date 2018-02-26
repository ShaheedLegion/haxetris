import openfl.display.Sprite;
import openfl.geom.Point;

class WorldState implements IResizeable {
	private var gridColumns: Int;	// number of columns.
	private var gridRows: Int;	// number of rows.
	private var gridLocationX: Int; // start location in pixels (after scaling).
	private var gridLocationY: Int; // start location in pixels (after scaling).
	private var gridPixelWidth: Int; // width in pixels (after scaling).
	private var gridPixelHeight: Int; // height in pixels (after scaling).
	private var intrinsicWidth: Int;	// internal width of canvas buffers / game screens.
	private var intrinsicHeight: Int;	// internal height of canvas buffers / game screens.
	private var displayWidth: Int;	// external width of game display / canvas.
	private var displayHeight: Int;	// external height of game display / canvas.
	private var canvas: Sprite;	// drawable surface of the game.
	private var gridScreen: GridScreen; // Grid screen display.
	private var gridController: GridScreenController; // Grid Screen Controller.
	private var touchRegistered: Bool; // Is user touching screen?
	private var touchBeginPoint: Point; //Point where touch started.
	private var touchEndPoint: Point; // Point where touch gesture ended.
	private var keyPressed: Array<Int>; // The key that was pressed.

	@:allow(HaxeTris)
	private function new(gw: Int, gh: Int, w: Int, h: Int) {
		gridColumns = gw;
		gridRows = gh;
		intrinsicWidth = w;
		intrinsicHeight = h;
		displayWidth = w;
		displayHeight = h;
		gridPixelWidth = w;
		gridPixelHeight = h;
		keyPressed = new Array();
		canvas = new Sprite();

		canvas.graphics.beginFill (0xFF0000, 1);
		canvas.graphics.drawRect (0, 0, intrinsicWidth, intrinsicHeight);
		gridController = new GridScreenController(this);
		gridScreen = new GridScreen(this, gridController);
	}

	@:allow(HaxeTris, GridScreen)
	private function getCanvas(): Sprite { return canvas; }

	// Get a canvas with properties that have been cleared.
	public function getPreparedCanvas(): Sprite {
		canvas.graphics.clear();
		canvas.scaleX = 1;
		canvas.scaleY = 1;
		return canvas;
	}
	public function getGridScreen(): IGameObject {
		return gridScreen;
	}
	public function getGridController(): IGridScreenController {
		return gridController;
	}

	public function getGridX(): Int {
		return gridLocationX;
	}
	public function getGridY(): Int {
		return gridLocationY;
	}
	public function getGridWidth(): Int {
		return gridPixelWidth;
	}
	public function getGridHeight(): Int {
		return gridPixelHeight;
	}
	public function getGridColumns(): Int {
		return gridColumns;
	}
	public function getGridRows(): Int {
		return gridRows;
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

	@:allow(GridScreen)
	private function setGridLocationX(x: Int) {
		gridLocationX = x;
	}
	@:allow(GridScreen)
	private function setGridLocationY(y: Int) {
		gridLocationY = y;
	}
	@:allow(GridScreen)
	private function setGridWidth(w: Int) {
		gridPixelWidth = w;
	}
	@:allow(GridScreen)
	private function setGridHeight(h: Int) {
		gridPixelHeight = h;
	}

	public function resize(newWidth: Int, newHeight: Int): Void {
		canvas.width = newWidth;
		canvas.height = newHeight;
		displayWidth = newWidth;
		displayHeight = newHeight;
	}

	@:allow(HaxeTris)
	private function setKeyPressed(key: Int) {
		keyPressed.push(key);
	}
	@:allow(HaxeTris)
	private function setTouchStarted(x: Float, y: Float) {
		touchRegistered = true;
	}
	@:allow(HaxeTris)
	private function setTouchMoved(x: Float, y: Float) {
		touchRegistered = true;
	}
	@:allow(HaxeTris)
	private function setTouchEnded(x: Float, y: Float) {
		touchRegistered = false;
	}

	// Any listeners asking for the key will 'Consume' the key press.
	public function consumeKeyPress(): Int {
		if (keyPressed.length == 0) return -1;
		return keyPressed.shift();
	}
}