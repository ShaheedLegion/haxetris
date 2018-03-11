package;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

import GridScreenController.Block;

/**
* Auto generated ScreensTest for MassiveUnit. 
* This is an example test class can be used as a template for writing normal and async tests 
* Refer to munit command line tool for more information (haxelib run munit)
*/
class GridScreenTest 
{
	private var timer:Timer;
	
	
	public function new() { }
	
	@BeforeClass
	public function beforeClass():Void { }
	
	@AfterClass
	public function afterClass():Void { }
	
	@Before
	public function setup():Void { }
	
	@After
	public function tearDown():Void { }
	
	
	@Test
	public function testExample():Void
	{
		var worldState: WorldState;
		var gridScreenController: GridScreenController;

		worldState = new WorldState(10, 20, 400, 800);
		worldState.resize(400, 800);

		gridScreenController = new GridScreenController(worldState);

		var block: Block = gridScreenController.getCurrentBlock();
		Assert.isTrue(block.width == 2);
		Assert.isTrue(block.height == 2);

		var grid: Array<Int> = gridScreenController.getGridRepresentation();
		Assert.isTrue(grid.length == (worldState.getGridRows() * worldState.getGridColumns()));

		// Auto mode is true by default - should never transition.
		Assert.isFalse(gridScreenController.shouldTransition(worldState));

		// Positioning logic is ignored when in auto mode, so it needs to be overriden.
		gridScreenController.setAutoMode(false);
	
		// Test the positioning logic for block placement.
		block.x = -12; // too far left
		block.y = 4;
		Assert.isFalse(gridScreenController.canMoveBlockToPosition(worldState, block));

		block.x = 22; // too far right
		block.y = 4;
		Assert.isFalse(gridScreenController.canMoveBlockToPosition(worldState, block));

		block.x = 4; // we can't place blocks too far up
		block.y = -14;
		Assert.isFalse(gridScreenController.canMoveBlockToPosition(worldState, block));

		block.x = 4; // too far down
		block.y = 40;
		Assert.isFalse(gridScreenController.canMoveBlockToPosition(worldState, block));

		block.x = 4; // just right
		block.y = 4;
		Assert.isTrue(gridScreenController.canMoveBlockToPosition(worldState, block));

		// Check block movement
		block.x = 0; // can't move left from leftmost edge
		block.y = 4;
		Assert.isFalse(gridScreenController.moveLeft(worldState, block));

		block.x = 1; // can move left from second column
		block.y = 4;
		Assert.isTrue(gridScreenController.moveLeft(worldState, block));

		block.x = 15; // can't move right from end
		block.y = 4;
		Assert.isFalse(gridScreenController.moveRight(worldState, block));

		block.x = 5; // can move right from middle
		block.y = 4;
		Assert.isTrue(gridScreenController.moveRight(worldState, block));

		block.x = 0; // can move down from top
		block.y = 0;
		Assert.isTrue(gridScreenController.moveDown(worldState, block));

		block.x = 0; // can't move down from bottom
		block.y = 20;
		Assert.isFalse(gridScreenController.moveDown(worldState, block));
	}
	
	@AsyncTest
	public function testAsyncExample(factory:AsyncFactory):Void
	{
		var handler:Dynamic = factory.createHandler(this, onTestAsyncExampleComplete, 300);
		timer = Timer.delay(handler, 200);
	}
	
	private function onTestAsyncExampleComplete():Void
	{
		Assert.isFalse(false);
	}
	
	
	/**
	* test that only runs when compiled with the -D testDebug flag
	*/
	@TestDebug
	public function testExampleThatOnlyRunsWithDebugFlag():Void
	{
		Assert.isTrue(true);
	}

}