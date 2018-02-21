import openfl.display.Sprite;

class EndScreen implements IGameObject {

	public function new(worldState: WorldState) {}

	public function resize (newWidth: Int, newHeight: Int): Void {}

	public function render(worldState: WorldState): Void {
		var canvas: Sprite = worldState.getPreparedCanvas();
		canvas.graphics.beginFill (0x0FF0FF, 1);
		canvas.graphics.drawRect (0, 0, worldState.getIntrinsicWidth(), worldState.getIntrinsicHeight());
		worldState.getGridScreen().render(worldState);
	}
	public function update(worldState: WorldState): Void {
		worldState.getGridScreen().update(worldState);
	}
	public function outputDebug(worldState: WorldState): Void {
		worldState.getGridScreen().outputDebug(worldState);
	}
}