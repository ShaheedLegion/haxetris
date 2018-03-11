import massive.munit.TestSuite;

import GridScreenTest;
import WorldStateTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */

class TestSuite extends massive.munit.TestSuite
{		

	public function new()
	{
		super();

		add(GridScreenTest);
		add(WorldStateTest);
	}
}
