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
	private var ROTATE: Int = 38;
	private var MOVE_RIGHT: Int = 39;
	private var MOVE_DOWN: Int = 40;
	private var rowsScore: Int = 0;
	private var userIsStuck: Bool;
	private var userStuckCounter: Int = 0;

	public function new(worldState: WorldState) {
		autoMode = true;
		userIsStuck = false;
		frameCounter = frameSkip;

		grid = new Array();
		var numGridLocations: Int = worldState.getGridColumns() * worldState.getGridRows();

		while (numGridLocations > 0) {
			grid.push(0);
			--numGridLocations;
		}

		blockTypes = new Array();
		var generators: Array<Dynamic> = new Array();

		generators.push(function(data: Array<Int>, orientation: Int): Void {
			while (data.length > 0) {
				data.pop();
			}
			// o, i - easy, never rotate.
			data.push(1);
			data.push(1);
			data.push(1);
			data.push(1);
		});
		generators.push(function(data: Array<Int>, orientation: Int): Void {
			while (data.length > 0) {
				data.pop();
			}
			switch (orientation) { //z
			case 0, 2:
				data.push(1);data.push(1);data.push(0);
				data.push(0);data.push(1);data.push(1);
			case 1, 3:
				data.push(0);data.push(1);
				data.push(1);data.push(1);
				data.push(1);data.push(0);
			}
		});
		generators.push(function(data: Array<Int>, orientation: Int): Void {
			while (data.length > 0) {
				data.pop();
			}
			switch (orientation) { // s
				case 0, 2:
					data.push(0);data.push(1);data.push(1);
					data.push(1);data.push(1);data.push(0);
				case 1, 3:
					data.push(1);data.push(0);
					data.push(1);data.push(1);
					data.push(0);data.push(1);
			}
		});
		generators.push(function(data: Array<Int>, orientation: Int): Void {
			while (data.length > 0) {
				data.pop();
			}
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
			while (data.length > 0) {
				data.pop();
			}
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
			while (data.length > 0) {
				data.pop();
			}
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
		blockTypes.push({width: 2, height: 2, orientation: 0, x: 0, y: 0, col: 0x00FFFF, generator: generators[0], data: new Array()});
		blockTypes.push({width: 3, height: 2, orientation: 0, x: 0, y: 0, col: 0x0000FF, generator: generators[1], data: new Array()});
		blockTypes.push({width: 3, height: 2, orientation: 0, x: 0, y: 0, col: 0xFFF000, generator: generators[2], data: new Array()});
		blockTypes.push({width: 1, height: 4, orientation: 0, x: 0, y: 0, col: 0x00FF00, generator: generators[0], data: new Array()});
		blockTypes.push({width: 2, height: 3, orientation: 0, x: 0, y: 0, col: 0xFFA500, generator: generators[3], data: new Array()});
		blockTypes.push({width: 2, height: 3, orientation: 0, x: 0, y: 0, col: 0xFFFF00, generator: generators[4], data: new Array()});
		blockTypes.push({width: 3, height: 2, orientation: 0, x: 0, y: 0, col: 0x551A8B, generator: generators[5], data: new Array()});

		for (block in blockTypes) {
			block.generator(block.data, block.orientation);
		}

		currentBlock = {
			width: 3, height: 2,
			orientation: 0,
			x: 0,
			y: 0,
			col: 0xF0F0FF,
			generator: generators[5],
			data: new Array()
		};
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

	private function shiftGridColumnsDown(worldState: WorldState, rowToRemove: Int) {
		var startRow: Int = rowToRemove;

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
		eraseBlock(worldState);
		var y = 0;

		while (y < worldState.getGridRows()) {
			var isGridRowFull: Bool = true;
			for (x in 0...worldState.getGridColumns()) {
				var gridIndex = y * worldState.getGridColumns() + x;
				if (grid[gridIndex] == 0) { isGridRowFull = false; }
			}

			if (isGridRowFull) {
				trace("Grid row is full!! " + y);
				shiftGridColumnsDown(worldState, y);
				userStuckCounter = 0;
				++rowsScore;
				y = 0; // restart loop to continue checking after rows have been dropped.
				continue;
			}
			++y;
		}

		// Check if the game has ended by traversing the topmost row of cells to see if any are filled.
		var isGridColumnFull: Bool = false;
		for (x in 0...worldState.getGridColumns()) {
				if (grid[x] != 0) {
					isGridColumnFull = true;
				}

			if (isGridColumnFull) {
				trace("Looks like the game has ended");
				++userStuckCounter;
			}
		}
		drawBlock(worldState);
		
		// If the topmost row stays 'filled' for 3 turns, then the user has died.
		if (userStuckCounter > 3) {
			userIsStuck = true;
		}
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
		currentBlock.generator(currentBlock.data, currentBlock.orientation);
		rowsScore = 0;
		userIsStuck = false;
		userStuckCounter = 0;
	}

	public function shouldTransition(worldState: WorldState): Bool {
		if (autoMode) {
			return false;
		}

		return userIsStuck;
	}

	// First alter the block coordinates, then call this function.
	private function canMoveBlockToPosition(worldState: WorldState, block: Block): Bool {
		if (autoMode) {
			return true; // In auto mode blocks fall "forever"
		}

		if (block.y + (block.height - 1) > (worldState.getGridRows() - 1)) {
			return false;
		}

		for (y in 0...block.height) {
			for (x in 0...block.width) {
				var blockIdx = ((block.y + y) * worldState.getGridColumns()) + (block.x + x);
				var worldGridBlockStatus = grid[blockIdx];
				var localGridBlockStatus = block.data[(y * block.width) + x];
				
				if (worldGridBlockStatus == 0 && localGridBlockStatus == 0) {
					continue;
				}

				if (worldGridBlockStatus != 0 && localGridBlockStatus != 0) {
					return false;
				}
			}
		}

		return true;
	}

	private function moveLeft(worldState: WorldState): Bool {
		if (currentBlock.x == 0) {
			return false;
		}

		var block: Block = {width: currentBlock.width, height: currentBlock.height,
		orientation: currentBlock.orientation, x: currentBlock.x, y: currentBlock.y, col: currentBlock.col,
		generator: currentBlock.generator, data: new Array()};

		blockCopy(currentBlock, block);

		--block.x;
		var canMoveLeft: Bool = canMoveBlockToPosition(worldState, block);

		if (canMoveLeft) {
			--currentBlock.x;
		}
		return canMoveLeft;
	}

	private function moveRight(worldState: WorldState): Bool {
		if (currentBlock.x + (currentBlock.width - 1) == worldState.getGridColumns() - 1) {
			return false;
		}

		var block: Block = {
			width: currentBlock.width,
			height: currentBlock.height,
			orientation: currentBlock.orientation,
			x: currentBlock.x,
			y: currentBlock.y,
			col: currentBlock.col,
			generator: currentBlock.generator,
			data: new Array()
		};

		blockCopy(currentBlock, block);

		++block.x;
		var canMoveRight: Bool = canMoveBlockToPosition(worldState, block);

		if (canMoveRight) {
			++currentBlock.x;
		}
		return canMoveRight;
	}

	private function moveDown(worldState: WorldState): Bool {
		if (autoMode) {
			// Remember to actually advance block if we are taking the autoMode shortcut.
			++currentBlock.y;
			return true;
		}
		if (currentBlock.y + (currentBlock.height - 1) == worldState.getGridRows() - 1) {
			return false;
		}

		var block: Block = {width: currentBlock.width, height: currentBlock.height,
		orientation: currentBlock.orientation, x: currentBlock.x, y: currentBlock.y, col: currentBlock.col,
		generator: currentBlock.generator, data: new Array()};

		blockCopy(currentBlock, block);

		++block.y;
		var canMoveDown: Bool = canMoveBlockToPosition(worldState, block);

		if (canMoveDown) {
			++currentBlock.y;
		}
		return canMoveDown;
	}

	private function rotateBlock(worldState: WorldState) {
		// rotate the current block - if possible to do so at this location.
		var block: Block = {width: currentBlock.width, height: currentBlock.height,
		orientation: currentBlock.orientation, x: currentBlock.x, y: currentBlock.y, col: currentBlock.col,
		generator: currentBlock.generator, data: new Array()};

		blockCopy(currentBlock, block);
		if (++block.orientation > 3) block.orientation = 0;

		var oldWidth = block.width;
		block.width = block.height;
		block.height = oldWidth;

		block.generator(block.data, block.orientation);

		var blockInsideBoundsWidth =  ((block.x + block.width - 1) <= worldState.getGridColumns() - 1);

		if (canMoveBlockToPosition(worldState, block) && blockInsideBoundsWidth) {
			blockCopy(block, currentBlock);
		}
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
			return false;
		}

		for (y2 in 0...currentBlock.height) {
			var blockRowY = ((currentBlock.y + y2));
			if (blockRowY < worldState.getGridRows()) {
				hadValidBlockRows = true;
				var blockIdx = blockRowY  * worldState.getGridColumns();
				for (x2 in 0...currentBlock.width) {
					var currentBlockDataIdx = y2 * currentBlock.width + x2;

					if (currentBlock.data[currentBlockDataIdx] == 1) {
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

		eraseBlock(worldState); // clear the block off the grid first.
		if (lastKey == MOVE_LEFT) {
			moveLeft(worldState);
		} else if (lastKey == MOVE_RIGHT) {
			moveRight(worldState);
		} else if (lastKey == ROTATE) {
			rotateBlock(worldState);
		} else if (lastKey == MOVE_DOWN) {
			moveDown(worldState);
		}

		var canBlockAdvance: Bool = moveDown(worldState);
		var isBlockStillVisible: Bool = drawBlock(worldState);

		var isStillValidBlock = (autoMode ? isBlockStillVisible : canBlockAdvance);
		if (!isStillValidBlock) {
			// Mark block for deletion.
			var newBlockType: Int = Std.int(Math.random() * blockTypes.length);

			blockCopy(blockTypes[newBlockType], currentBlock);
			currentBlock.x = Std.int(Math.random() * worldState.getGridColumns());
			currentBlock.y = 0;
			currentBlock.orientation = 0;

			currentBlock.generator(currentBlock.data, currentBlock.orientation);

			if ((currentBlock.x + currentBlock.width) > worldState.getGridColumns()) {
				currentBlock.x = worldState.getGridColumns() - currentBlock.width;
			}
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
		to.generator(to.data, to.orientation);
		if (to.data.length == 0) {
			throw ("BlockCopy to data length was 0 " + to.orientation);
		}
	}

	public function getScore(): Int {
		return rowsScore;
	}
}