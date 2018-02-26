import openfl.display.Sprite;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormatAlign;
import openfl.text.TextField;
import openfl.text.TextFormat;

class EndScreen implements IGameScreenObject {

	private var textFormat: TextFormat = new TextFormat();
	private var text: TextField = new TextField();
	private var soundId: Int;
	private var soundManager: SoundManager;

	public function new(worldState: WorldState, soundMan: SoundManager) {
		var textFormat:TextFormat = new TextFormat();
		textFormat.font = "Arial";
		textFormat.size = 18;
		textFormat.color = 0xFF00FF;
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
		soundManager = soundMan;
		soundId = soundMan.addSound("assets/korobeiniki_end.mp3");
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
		text.x = worldState.getGridX() +
		(worldState.getGridWidth() / 2) - (text.width / 2);
		text.y = worldState.getGridY() + 50;
	}

	public function outputDebug(worldState: WorldState): Void {
		worldState.getGridScreen().outputDebug(worldState);
	}

	public function enterGameScreen(worldState: WorldState): Void {
		worldState.getPreparedCanvas().addChild(text);
		worldState.getGridController().setAutoMode(true);
		soundManager.playSound(soundId, 1000);
	}

	public function exitGameScreen(worldState: WorldState): Void {
		worldState.getPreparedCanvas().removeChild(text);
		soundManager.stopSound(soundId);
	}

	public function shouldTransition(worldState: WorldState): Bool {
		// Check the key state to see if we should transition.
		return (worldState.consumeKeyPress() == 32);
	}
}