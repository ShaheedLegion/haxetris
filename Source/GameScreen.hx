import openfl.display.Sprite;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormatAlign;
import openfl.text.TextField;
import openfl.text.TextFormat;

class GameScreen implements IGameScreenObject {

	private var textFormat: TextFormat = new TextFormat();
	private var text: TextField = new TextField();

	public function new(worldState: WorldState) {
		var textFormat:TextFormat = new TextFormat();
		textFormat.font = "Arial";
		textFormat.size = 18;
		textFormat.color = 0xFF00FF;
		textFormat.align = TextFormatAlign.CENTER;

		text.autoSize = TextFieldAutoSize.CENTER;
		text.selectable = false;
		text.multiline = true;
		text.defaultTextFormat = textFormat;

		text.text = "Score: ";
	}

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

		text.text = "Score: " + worldState.getGridController().getScore();
		text.x = worldState.getGridX() +
		(worldState.getGridWidth() / 2) - (text.width / 2);
		text.y = worldState.getGridY() + 16;
	}
	public function outputDebug(worldState: WorldState): Void {
		worldState.getGridScreen().outputDebug(worldState);
	}

	public function enterGameScreen(worldState: WorldState): Void {
		// The player has started the game.
		// Init the grid - again.
		// Since the grid is the main component of haxtris.
		worldState.getGridController().setAutoMode(false);
		worldState.getPreparedCanvas().addChild(text);
	}
	public function exitGameScreen(worldState: WorldState): Void {
		worldState.getPreparedCanvas().removeChild(text);
	}

	public function shouldTransition(worldState: WorldState): Bool {
		return worldState.getGridController().shouldTransition(worldState);
	}
}