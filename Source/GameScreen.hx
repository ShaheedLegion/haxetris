import openfl.display.Sprite;

class GameScreen implements IGameScreenObject {

	public function new(worldState: WorldState) {}

	public function resize (newWidth: Int, newHeight: Int): Void {}

	public function render(worldState: WorldState): Void {
		var canvas: Sprite = worldState.getPreparedCanvas();
		canvas.graphics.beginFill (0x1A1A1A, 1);
		canvas.graphics.drawRect (0, 0, worldState.getDisplayWidth(), worldState.getDisplayHeight());

		worldState.getGridScreen().render(worldState);
	}
	public function update(worldState: WorldState): Void {
		worldState.getGridScreen().update(worldState);
	}
	public function outputDebug(worldState: WorldState): Void {
		worldState.getGridScreen().outputDebug(worldState);
	}

	public function enterGameScreen(worldState: WorldState): Void {
		// The player has started the game.
		// Init the grid - again.
		// Since the grid is the main component of haxtris.
	}
	public function exitGameScreen(worldState: WorldState): Void {}
	public function shouldTransition(worldState: WorldState): Bool {
		var lastKey = worldState.consumeKeyPress();
		if (lastKey == 32) return true;

		return false;
	}
}