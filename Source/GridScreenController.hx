class GridScreenController implements IGameObject {

	private var autoMode: Bool;

	public function new(worldState: WorldState) {
		autoMode = true;
	}

	public function render(worldState: WorldState): Void {
		//super.render(worldState);
/*
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
		worldState.getCanvas().graphics.beginFill (0x223322, 1);
		worldState.getCanvas().graphics.drawRect (gridLocationX, gridLocationY, gridPixelWidth, gridPixelHeight);
*/
	}
	public function update(worldState: WorldState): Void {
		//super.update(worldState);

	}
	public function outputDebug(worldState: WorldState): Void {
		//super.outputDebug(worldState);
	}

	public function resize (newWidth: Int, newHeight: Int): Void {}

}