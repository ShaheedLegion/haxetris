import openfl.display.Sprite;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormatAlign;
import openfl.text.TextField;
import openfl.text.TextFormat;

class EndScreen implements IGameScreenObject {

	private var textFormat: TextFormat = new TextFormat();
	private var text: TextField = new TextField();

	public function new(worldState: WorldState) {
		var textFormat:TextFormat = new TextFormat();
		textFormat.font = "Arial";
		textFormat.size = 18;
		textFormat.color = 0x0000FF;
		textFormat.align = TextFormatAlign.CENTER;

		text.autoSize = TextFieldAutoSize.CENTER;
		text.selectable = false;
		text.multiline = true;
		text.defaultTextFormat = textFormat;

		var textString: String = " Oops you've died! \r";
		textString += " Use SpaceBar to go back \r";
		textString += " to the start screen \r";
		textString += " in order to play again! \r\r";

		text.text = textString;
	}

	public function resize (newWidth: Int, newHeight: Int): Void {}

	public function render(worldState: WorldState): Void {
		var canvas: Sprite = worldState.getPreparedCanvas();
		canvas.graphics.beginFill (0x040404, 1);
		canvas.graphics.drawRect (0, 0, worldState.getDisplayWidth(), worldState.getDisplayHeight());

		worldState.getGridScreen().render(worldState);
	}
	public function update(worldState: WorldState): Void {
		worldState.getGridScreen().update(worldState);
		text.x = worldState.getGridScreen().getGridX() +
		(worldState.getGridScreen().getGridWidth() / 2) - (text.width / 2);
		text.y = worldState.getGridScreen().getGridY() + 50;

		// TODO - scaling to match grid width / height.
	}
	public function outputDebug(worldState: WorldState): Void {
		worldState.getGridScreen().outputDebug(worldState);
	}

	public function enterGameScreen(worldState: WorldState): Void {
		worldState.getPreparedCanvas().addChild(text);
	}
	public function exitGameScreen(worldState: WorldState): Void {
		worldState.getPreparedCanvas().removeChild(text);
	}
	public function shouldTransition(worldState: WorldState): Bool {
		// Check the key state to see if we should transition.
		var lastKey = worldState.consumeKeyPress();
		if (lastKey == 32) return true;

		return false;
	}
}