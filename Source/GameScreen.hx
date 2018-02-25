import openfl.display.Sprite;

class GameScreen implements IGameScreenObject {

	public function new(worldState: WorldState) {}

	public function resize (newWidth: Int, newHeight: Int): Void {}

	public function render(worldState: WorldState): Void {
		var canvas: Sprite = worldState.getPreparedCanvas();
		canvas.graphics.beginFill (0x080808, 1);
		canvas.graphics.drawRect (0, 0, worldState.getDisplayWidth(), worldState.getDisplayHeight());

		worldState.getGridScreen().render(worldState);
	}
	public function update(worldState: WorldState): Void {
		worldState.getGridController().update(worldState);
		worldState.getGridScreen().update(worldState);
	}
	public function outputDebug(worldState: WorldState): Void {
		worldState.getGridScreen().outputDebug(worldState);
	}

	public function enterGameScreen(worldState: WorldState): Void {
		// The player has started the game.
		// Init the grid - again.
		// Since the grid is the main component of haxtris.
		worldState.getGridController().setAutoMode(false);
	}
	public function exitGameScreen(worldState: WorldState): Void {}

	public function shouldTransition(worldState: WorldState): Bool {
		return worldState.getGridController().shouldTransition(worldState);
	}
}