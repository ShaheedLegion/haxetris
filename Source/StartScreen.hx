import openfl.display.Sprite;

class StartScreen implements IGameObject {

	public function new(worldState: WorldState) {}

	public function resize (newWidth: Int, newHeight: Int): Void {}
	public function render(worldState: WorldState): Void {
		var canvas: Sprite = worldState.getPreparedCanvas();
		canvas.graphics.beginFill (0x2F2F2F, 1);
		canvas.graphics.drawRect (0, 0, worldState.getDisplayWidth(), worldState.getDisplayHeight());

		worldState.getGridScreen().render(worldState);
	}
	public function update(worldState: WorldState): Void {
		worldState.getGridScreen().update(worldState);
	}
	public function outputDebug(worldState: WorldState): Void {
		worldState.getGridScreen().outputDebug(worldState);
	}
}