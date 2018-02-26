typedef Block = {
	var width: Int; // width in grid columns.
	var height: Int; // width in grid rows.
	var orientation: Int; // orientation - in [up ... right]
	var x: Int; // position in grid columns.
	var y: Int; // position in grid rows.
	var col: UInt; // color of block type.
	var generator: Array<Int> -> Int -> Void; // generator function.
	var data: Array<Int>; // generated data from given generator function.
}

class GridScreenController implements IGridScreenController {
	private var autoMode: Bool;
	private var grid: Array<Int>;
	private var currentBlock: Block;
	private var blockTypes: Array<Block>;
	private var frameSkip: Int = 16;
	private var frameCounter: Int;
	private var MOVE_LEFT: Int = 37;
	private var MOVE_RIGHT: Int = 39;
	private var ROTATE: Int = 38;
	private var rowsScore: Int = 0;

	public function new(worldState: WorldState) {
		autoMode = true;
		frameCounter = frameSkip;

		grid = new Array();
		var numGridLocations: Int = worldState.getGridColumns() * worldState.getGridRows();

		while (numGridLocations > 0) {
			grid.push(0);
			--numGridLocations;
		}

		trace("Number of items in grid - " + grid.length);

		blockTypes = new Array();
		var generators: Array<Dynamic> = new Array();

		generators.push(function(data: Array<Int>, orientation: Int): Void {
			while (data.length > 0) { data.pop(); }
			// o, i - easy, never rotate.
			data.push(1);
			data.push(1);
			data.push(1);
			data.push(1);
		});
		generators.push(function(data: Array<Int>, orientation: Int): Void {
			while (data.length > 0) { data.pop(); }
			switch (orientation) { //z
			case 0:
			case 2:
				data.push(1);data.push(1);data.push(0);
				data.push(0);data.push(1);data.push(1);

			case 1:
			case 3:
				data.push(0);data.push(1);
				data.push(1);data.push(1);
				data.push(1);data.push(0);
			}
		});
		generators.push(function(data: Array<Int>, orientation: Int): Void {
			while (data.length > 0) { data.pop(); }
			switch (orientation) { // s
				case 0:
				case 2:
					data.push(0);data.push(1);data.push(1);
					data.push(1);data.push(1);data.push(0);
				case 1:
				case 3:
					data.push(1);data.push(0);
					data.push(1);data.push(1);
					data.push(0);data.push(1);
			}
		});
		generators.push(function(data: Array<Int>, orientation: Int): Void {
			while (data.length > 0) { data.pop(); }
			switch (orientation) { // l
				case 0:
					data.push(1);data.push(0);
					data.push(1);data.push(0);
					data.push(1);data.push(1);
				case 1:
					data.push(1);data.push(1);data.push(1);
					data.push(1);data.push(0);data.push(0);
				case 2:
					data.push(1);data.push(1);
					data.push(0);data.push(1);
					data.push(0);data.push(1);
				case 3:
					data.push(0);data.push(0);data.push(1);
					data.push(1);data.push(1);data.push(1);
			}
		});
		generators.push(function(data: Array<Int>, orientation: Int): Void {
			while (data.length > 0) { data.pop(); }
			switch (orientation) { // j
				case 0:
					data.push(0);data.push(1);
					data.push(0);data.push(1);
					data.push(1);data.push(1);
				case 1:
					data.push(1);data.push(0);data.push(0);
					data.push(1);data.push(1);data.push(1);
				case 2:
					data.push(1);data.push(1);
					data.push(1);data.push(0);
					data.push(1);data.push(0);
				case 3:
					data.push(1);data.push(1);data.push(1);
					data.push(0);data.push(0);data.push(1);
			}
		});
		generators.push(function(data: Array<Int>, orientation: Int): Void {
			while (data.length > 0) { data.pop(); }
			switch (orientation) { // t
				case 0:
					data.push(1);data.push(1);data.push(1);
					data.push(0);data.push(1);data.push(0);
				case 1:
					data.push(0);data.push(1);
					data.push(1);data.push(1);
					data.push(0);data.push(1);
				case 2:
					data.push(0);data.push(1);data.push(0);
					data.push(1);data.push(1);data.push(1);
				case 3:
					data.push(1);data.push(0);
					data.push(1);data.push(1);
					data.push(1);data.push(0);
			}
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
			block.generator(block.data, block.orientation);
		}

		currentBlock = {width: 3, height: 2, orientation: 0, x: 0, y: 0, col: 0xF0F0FF, generator: generators[5], data: new Array()};
		blockCopy(blockTypes[0], currentBlock);
	}

	public function render(worldState: WorldState): Void {}
	public function update(worldState: WorldState): Void {
		// When in auto mode, collission detection is off - so blocks float all the way down the screen.
		--frameCounter;
		if (frameCounter <= 0) {
			advanceBlock(worldState);
			frameCounter = frameSkip;
			if (!autoMode) {
				gridSweep(worldState);
			}
		}
	}
	public function outputDebug(worldState: WorldState): Void {}
	public function resize (newWidth: Int, newHeight: Int): Void {}

	private function dropGridRow(worldState: WorldState, rowToDrop: Int) {
		var startRow: Int = rowToDrop;
		while (startRow > 0) {
			for (x in 0...worldState.getGridColumns()) {
				var gridIndex = startRow * worldState.getGridColumns() + x;
				var gridPrevIndex = (startRow - 1) * worldState.getGridColumns() + x;
				grid[gridIndex] = grid[gridPrevIndex];
			}
			--startRow;
		}
	}
	private function gridSweep(worldState: WorldState) {
		// check the grid for any complete rows.
		// need to figure a way around checking the current block.
		// Work from the bottom of the grid upwards.
		eraseBlock(worldState);
		var filledRows: Array<Int> = new Array();

		for (y in 0...worldState.getGridRows()) {
			var isGridRowFull: Bool = true;
			for (x in 0...worldState.getGridColumns()) {
				var gridIndex = y * worldState.getGridColumns() + x;
				if (grid[gridIndex] == 0) { isGridRowFull = false; }
			}

			if (isGridRowFull) {
				trace("Grid row is full!! " + y);
				filledRows.push(y);
				++rowsScore;
			}
		}

		if (rowsScore > 0) {
			trace("Got grid score - " + rowsScore);
			for (rowToErase in filledRows) {
				dropGridRow(worldState, rowToErase);
			}
		}

		drawBlock(worldState);
	}

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

	private function canAdvanceBlock(worldState: WorldState, block: Block): Bool {
		if (autoMode) return true; // In auto mode blocks fall "forever"

		var blockRowY = block.y;
		var newBlockY = blockRowY + 1;
		if ((blockRowY + (block.height - 1)) == worldState.getGridRows() - 1) {
			return false;
		}

		if ((newBlockY + (block.height - 1)) == worldState.getGridRows()) {
			return false;
		}

		for (x in 0...block.width) {
			for (y in 0...block.height) {
				var blockIdx = ((newBlockY + y) * worldState.getGridColumns()) + (block.x + x);
				var worldGridBlockStatus = grid[blockIdx];
				var localGridBlockStatus = block.data[(y * block.width) + x];
				
				if (worldGridBlockStatus == 0 && localGridBlockStatus == 0) { continue; }

				if (worldGridBlockStatus != 0 && localGridBlockStatus != 0) {
					return false;
				}
			}
		}

		return true;
	}
	private function moveLeft(worldState: WorldState) {
		if (currentBlock.x == 0) return;

		var canMoveLeft: Bool = true;
		for (y in 0...currentBlock.height) {
			var blockRowY = ((currentBlock.y + y));
			if (blockRowY < worldState.getGridRows()) {
				var blockIdx = blockRowY  * worldState.getGridColumns();
				var newBlockX = currentBlock.x - 1;

				var worldGridBlockStatus = grid[blockIdx + newBlockX];
				var localGridBlockStatus = currentBlock.data[y * currentBlock.width];
				if (worldGridBlockStatus == 0) { continue; }
				if (localGridBlockStatus == 0) { continue; }

				if (worldGridBlockStatus != 0 && localGridBlockStatus != 0) {
					canMoveLeft = false;
				}
			}
		}
		if (canMoveLeft) {
			eraseBlock(worldState);
			--currentBlock.x;
		}
	}
	private function moveRight(worldState: WorldState) {
		if (currentBlock.x + (currentBlock.width - 1) == worldState.getGridColumns() - 1) {
			return;
		}

		var canMoveRight: Bool = true;
		for (y in 0...currentBlock.height) {
			var blockRowY = ((currentBlock.y + y));
			if (blockRowY < worldState.getGridRows()) {
				var blockIdx = blockRowY  * worldState.getGridColumns();
				var newBlockX = currentBlock.x + currentBlock.width + 1;

				var worldGridBlockStatus = grid[blockIdx + newBlockX];
				var localGridBlockStatus = currentBlock.data[(y * currentBlock.width) + currentBlock.width - 1];
				if (worldGridBlockStatus == 0) { continue; }
				if (localGridBlockStatus == 0) { continue; }

				if (worldGridBlockStatus != 0 && localGridBlockStatus != 0) {
					canMoveRight = false;
				}
			}
		}
		if (canMoveRight) {
			eraseBlock(worldState);
			++currentBlock.x;
		}
	}

	private function rotateBlock(worldState: WorldState) {
		// rotate the current block - if possible.
		
		var block: Block = {width: currentBlock.width, height: currentBlock.height,
		orientation: currentBlock.orientation, x: currentBlock.x, y: currentBlock.y, col: currentBlock.col,
		generator: currentBlock.generator, data: new Array()};

		blockCopy(currentBlock, block);
		if (++block.orientation > 3) block.orientation = 0;

		var oldWidth = block.width;
		block.width = block.height;
		block.height = oldWidth;

		block.generator(block.data, block.orientation);
		--block.y; // move the block backwards to see if it can rotate in place.

		eraseBlock(worldState);
		if (canAdvanceBlock(worldState, block)) {
			blockCopy(block, currentBlock);
		}
		drawBlock(worldState);
	}

	private function eraseBlock(worldState: WorldState) {
		for (y in 0...currentBlock.height) {
			var blockRowY = ((currentBlock.y + y));
			if (blockRowY < worldState.getGridRows()) {
				var blockIdx = blockRowY  * worldState.getGridColumns();
				for (x in 0...currentBlock.width) {
					if (currentBlock.data[y * currentBlock.width + x] == 1) {
						grid[blockIdx + currentBlock.x + x] = 0;
					}
				}
			}
		}
	}
	private function drawBlock(worldState: WorldState): Bool {
		var hadValidBlockRows: Bool = false;

		if (currentBlock.y >= worldState.getGridRows()) {
			trace("Current block isn't valid!! " + currentBlock.y);
			return false;
		}

		for (y2 in 0...currentBlock.height) {
			var blockRowY = ((currentBlock.y + y2));
			if (blockRowY < worldState.getGridRows()) {
				hadValidBlockRows = true;
				var blockIdx = blockRowY  * worldState.getGridColumns();
				for (x2 in 0...currentBlock.width) {
					var currentBlockDataIdx = y2 * currentBlock.width + x2;

					if ( currentBlock.data[currentBlockDataIdx] == 1) {
						grid[blockIdx + currentBlock.x + x2] = currentBlock.col;
					}
				}
			}
		}

		return hadValidBlockRows;
	}
	private function advanceBlock(worldState: WorldState) {
		// The user is playing - consume input.
		var lastKey = worldState.consumeKeyPress();

		if (lastKey == MOVE_LEFT) {
			moveLeft(worldState);
		} else if (lastKey == MOVE_RIGHT) {
			moveRight(worldState);
		} else if (lastKey == ROTATE) {
			rotateBlock(worldState);
		}

		eraseBlock(worldState);
		var canBlockAdvance: Bool = canAdvanceBlock(worldState, currentBlock);
		var isStillValidBlock: Bool = true;
		if (autoMode || canBlockAdvance) {
			eraseBlock(worldState);
			currentBlock.y++;

			isStillValidBlock = drawBlock(worldState);
		}

		if (!autoMode && !canBlockAdvance) {
			// Do not erase the current block position.
			drawBlock(worldState);
			isStillValidBlock = false;
		}

		if (!isStillValidBlock) {
			// Mark block for deletion.
			blockCopy(blockTypes[Std.int(Math.random() * blockTypes.length)], currentBlock);
			currentBlock.x = Std.int(Math.random() * worldState.getGridColumns());
			currentBlock.y = 0;
			currentBlock.orientation = 0;
			currentBlock.generator(currentBlock.data, currentBlock.orientation);

			if ((currentBlock.x + currentBlock.width) > worldState.getGridColumns()) {
				currentBlock.x = worldState.getGridColumns() - currentBlock.width;
			}
			trace("Generated new block! " + currentBlock.y);
		}
	}

	private function blockCopy(from: Block, to: Block) {
		to.width = from.width; // width in grid columns.
		to.height = from.height; // width in grid rows.
		to.orientation = from.orientation; // orientation - in [up ... right]
		to.x = from.x; // position in grid columns.
		to.y = from.y; // position in grid rows.
		to.col = from.col; // color of block type.
		to.generator = from.generator; // generator function.
		to.data = new Array(); // generated data from given generator function.
		to.generator(to.data, from.orientation);
	}

	public function getScore(): Int {
		return rowsScore;
	}
}