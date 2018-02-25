typedef Block = {
	var width: Int; // width in grid columns.
	var height: Int; // width in grid rows.
	var orientation: Int; // orientation - in [up ... right]
	var x: Int; // position in grid columns.
	var y: Int; // position in grid rows.
	var col: UInt; // color of block type.
	var generator: Array<Int> -> Void; // generator function.
	var data: Array<Int>; // generated data from given generator function.
}

class GridScreenController implements IGridScreenController {

	private var autoMode: Bool;
	private var grid: Array<Int>;
	private var currentBlock: Block;
	private var nextBlock: Block;
	private var blockTypes: Array<Block>;
	private var frameSkip: Int;
	private var frameCounter: Int;

	public function new(worldState: WorldState) {
		autoMode = true;
		frameSkip = 20;
		frameCounter = 20;

		grid = new Array();
		var numGridLocations: Int = worldState.getGridColumns() * worldState.getGridRows();

		while (numGridLocations > 0) {
			grid.push(0);
			--numGridLocations;
		}

		trace("Number of items in grid - " + grid.length);

		blockTypes = new Array();
		var generators: Array<Dynamic> = new Array();

		generators.push(function(data: Array<Int>): Void {
			data.push(1);
			data.push(1);
			data.push(1);
			data.push(1);
		});
		generators.push(function(data: Array<Int>): Void {
			data.push(1);
			data.push(1);
			data.push(0);
			data.push(0);
			data.push(1);
			data.push(1);
		});
		generators.push(function(data: Array<Int>): Void {
			data.push(0);
			data.push(1);
			data.push(1);
			data.push(1);
			data.push(1);
			data.push(0);
		});
		generators.push(function(data: Array<Int>): Void {
			data.push(1);
			data.push(0);
			data.push(1);
			data.push(0);
			data.push(1);
			data.push(1);
		});
		generators.push(function(data: Array<Int>): Void {
			data.push(0);
			data.push(1);
			data.push(0);
			data.push(1);
			data.push(1);
			data.push(1);
		});
		generators.push(function(data: Array<Int>): Void {
			data.push(1);
			data.push(1);
			data.push(1);
			data.push(0);
			data.push(1);
			data.push(0);
		});
		generators.push(function(data: Array<Int>): Void {});
		blockTypes.push({width: 2, height: 2, orientation: 0, x: 0, y: 0, col: 0xF0F0FF, generator: generators[0], data: new Array()});
		blockTypes.push({width: 3, height: 2, orientation: 0, x: 0, y: 0, col: 0xF0F0FF, generator: generators[1], data: new Array()});
		blockTypes.push({width: 3, height: 2, orientation: 0, x: 0, y: 0, col: 0xF0F0FF, generator: generators[2], data: new Array()});
		blockTypes.push({width: 1, height: 4, orientation: 0, x: 0, y: 0, col: 0xF0F0FF, generator: generators[0], data: new Array()});
		blockTypes.push({width: 2, height: 3, orientation: 0, x: 0, y: 0, col: 0xF0F0FF, generator: generators[3], data: new Array()});
		blockTypes.push({width: 2, height: 3, orientation: 0, x: 0, y: 0, col: 0xF0F0FF, generator: generators[4], data: new Array()});
		blockTypes.push({width: 3, height: 2, orientation: 0, x: 0, y: 0, col: 0xF0F0FF, generator: generators[5], data: new Array()});

		for (block in blockTypes) {
			block.generator(block.data);
		}

		currentBlock = blockTypes[0];
		nextBlock = blockTypes[1];
	}

	public function render(worldState: WorldState): Void {}
	public function update(worldState: WorldState): Void {
		// When in auto mode, collission detection is off - so blocks float all the way down the screen.

		--frameSkip;
		if (frameSkip <= 0) {
			advanceBlock(worldState);
			frameSkip = frameCounter;
		}
		
		if (!autoMode) collisionDetect(worldState);
	}
	public function outputDebug(worldState: WorldState): Void {}
	public function resize (newWidth: Int, newHeight: Int): Void {}

	public function getGridRepresentation(): Array<Int> {
		return grid;
	}

	public function setAutoMode(auto: Bool): Void {
		autoMode = auto;

		for (j in 0...grid.length) {
			grid[j] = 0;
		}

		currentBlock.orientation = 0;
		currentBlock.x = 0;
		currentBlock.y = 0;
	}

	public function shouldTransition(worldState: WorldState): Bool {
		if (autoMode) return false;

		// Else, perform checks to see if the user has gotten stuck.

		return false;
	}

	private function collisionDetect(WorldState: WorldState) {

	}
	private function canAdvanceBlock(worldState: WorldState): Bool {
		// check under the block, if we can advance it
		if (autoMode) return true;


		return false;
	} 

	private function eraseBlock(worldState: WorldState) {
		for (y in 0...currentBlock.height) {
			var blockRowY = ((currentBlock.y + y));
			if (blockRowY < worldState.getGridRows()) {
				var blockIdx = blockRowY  * worldState.getGridColumns();
				for (x in 0...currentBlock.width) {
					grid[blockIdx + currentBlock.x + x] = 0;
				}
			}
		}
	}
	private function drawBlock(worldState: WorldState): Bool {
		var hadValidBlockRows: Bool = false;

		for (y2 in 0...currentBlock.height) {
			var blockRowY = ((currentBlock.y + y2));
			if (blockRowY < worldState.getGridRows()) {
				hadValidBlockRows = true;
				var blockIdx = blockRowY  * worldState.getGridColumns();
				for (x2 in 0...currentBlock.width) {
					var currentBlockDataIdx = y2 * currentBlock.width + x2;
					var currentBlockCol = currentBlock.data[currentBlockDataIdx] == 1 ? currentBlock.col : 0;

					grid[blockIdx + currentBlock.x + x2] = currentBlockCol;
				}
			}
		}

		return hadValidBlockRows;
	}
	private function advanceBlock(worldState: WorldState) {
		// currentblock must be moved.
		// First 'erase' the following row of stuff under the block.
		if (autoMode) {
			eraseBlock(worldState);
			currentBlock.y++;

			var hadValidBlockRows = drawBlock(worldState);

			if (!hadValidBlockRows) {
				// Mark block for deletion.
				currentBlock = blockTypes[Std.int(Math.random() * blockTypes.length)];
				currentBlock.x = Std.int(Math.random() * worldState.getGridColumns());
				currentBlock.y = 0;
				currentBlock.orientation = 0;

				if ((currentBlock.x + currentBlock.width) > worldState.getGridColumns()) {
					currentBlock.x = worldState.getGridColumns() - currentBlock.width;
				}
			}

			return;
		}

		// Not so auto mode.
	}

}