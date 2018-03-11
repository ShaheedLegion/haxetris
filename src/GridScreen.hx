class GridScreen implements IGameObject {

	private var gridController: IGameObject;

	public function new(worldState: WorldState, controller: IGameObject) {
		update(worldState);
	}

	public function resize (newWidth: Int, newHeight: Int): Void {}

	public function render(worldState: WorldState): Void {
		//super.render(worldState);
		var canvas = worldState.getCanvas();
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

		var gridLocationX = xpos;
		var gridLocationY = ypos;
		var gridPixelWidth = newWidthCalculated;
		var gridPixelHeight = newHeightCalculated;
		canvas.graphics.beginFill (0x2F332F, 1);
		canvas.graphics.drawRect (gridLocationX, gridLocationY, gridPixelWidth, gridPixelHeight);

		worldState.setGridLocationX(gridLocationX);
		worldState.setGridLocationY(gridLocationY);
		worldState.setGridWidth(gridPixelWidth);
		worldState.setGridHeight(gridPixelHeight);

		canvas.graphics.lineStyle(1.0, 0x222222, 1.0);

		var lineStepX: Int = Math.ceil(worldState.getGridWidth() / worldState.getGridColumns());
		var lineStepY: Int = Math.ceil(worldState.getGridHeight() / worldState.getGridRows());
		var currentX: Int = 0;
		var currentY: Int = worldState.getGridY();
		var gridRep = worldState.getGridController().getGridRepresentation();

		var currentIndex = 0;
		for (y in 0...worldState.getGridRows()) {
			currentX = worldState.getGridX();
			canvas.graphics.moveTo(currentX, currentY);
			canvas.graphics.lineTo(currentX + worldState.getGridWidth(), currentY);

			for (x in 0...worldState.getGridColumns()) {
				canvas.graphics.moveTo(currentX, currentY);
				canvas.graphics.lineTo(currentX, currentY + worldState.getGridHeight());

				// Draw the block, then increment the index.
				canvas.graphics.beginFill(gridRep[currentIndex]);
				canvas.graphics.drawRect(currentX, currentY, lineStepX, lineStepY);
				++currentIndex;
				currentX += lineStepX;
			}

			currentY += lineStepY;
		} 
		
	}
	public function update(worldState: WorldState): Void {}
	public function outputDebug(worldState: WorldState): Void {}

}