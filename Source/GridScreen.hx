class GridScreen implements IGameObject {

	private var gridLocationX: Int;
	private var gridLocationY: Int;
	private var gridPixelWidth: Int;
	private var gridPixelHeight: Int;

	public function new(worldState: WorldState) {
		//super(worldState);
		update(worldState);
	}

	public function resize (newWidth: Int, newHeight: Int): Void {
		//super.resize(newWidth, newHeight);
	}
	public function render(worldState: WorldState): Void {
		//super.render(worldState);

		// I know in perfect pixesl what the width/height of the grid should be.
		var width = worldState.getDisplayWidth();
		var height = worldState.getDisplayHeight();
		var proportionToX = worldState.getGridHeight() / worldState.getGridWidth();
		var proportionToY = worldState.getGridWidth() / worldState.getGridHeight();

		var newWidthCalculated = Std.int(height * proportionToY);
		var newHeightCalculated = Std.int(height);

		if (newWidthCalculated > width) {
			newWidthCalculated = width;
			newHeightCalculated = Std.int(width * proportionToX);
		}

		var remainderX = width - newWidthCalculated;
		var remainderY = height - newHeightCalculated;
		var xpos = (remainderX >> 1);
		var ypos = (remainderY >> 1);

		gridLocationX = xpos;
		gridLocationY = ypos;
		gridPixelWidth = newWidthCalculated;
		gridPixelHeight = newHeightCalculated;
		worldState.getCanvas().graphics.beginFill (0xFF0000, 1);
		worldState.getCanvas().graphics.drawRect (gridLocationX, gridLocationY, gridPixelWidth, gridPixelHeight);
	}
	public function update(worldState: WorldState): Void {
		//super.update(worldState);

	}
	public function outputDebug(worldState: WorldState): Void {
		//super.outputDebug(worldState);
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

}