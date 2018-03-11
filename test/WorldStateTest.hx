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
class WorldStateTest 
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

		worldState = new WorldState(10, 20, 400, 800);
		worldState.resize(400, 800);

		Assert.isTrue(worldState.getGridRows() == 20);
		Assert.isTrue(worldState.getGridColumns() == 10);
		Assert.isTrue(worldState.getIntrinsicWidth() == 400);
		Assert.isTrue(worldState.getIntrinsicHeight() == 800);

		// Test single key press
		worldState.setKeyPressed(12);

		Assert.isTrue(worldState.consumeKeyPress() == 12);

		// Test keypress queue
		worldState.setKeyPressed(1);
		worldState.setKeyPressed(2);
		worldState.setKeyPressed(3);
		worldState.setKeyPressed(4);

		Assert.isTrue(worldState.consumeKeyPress() == 1);
		Assert.isTrue(worldState.consumeKeyPress() == 2);
		Assert.isTrue(worldState.consumeKeyPress() == 3);
		Assert.isTrue(worldState.consumeKeyPress() == 4);
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