import openfl.display.Sprite;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormatAlign;
import openfl.text.TextField;
import openfl.text.TextFormat;

class StartScreen implements IGameScreenObject {

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

		var textString: String = " Welcome to HaxTris \r";
		textString += " Use SpaceBar to start \r";
		textString += " Up arrow to rotate \r";
		textString += " Left and Right Arrows to move. \r";

		// TODO - Add mobile support for next release.
		//textString += " Down to drop your block. \r\r";

		// TODO - Add + test mobile support.
		//textString += " On mobile swipe up/down/left/right. \r\r";
		//textString += " Hit SpaceBar or swipe up to start.";

		text.text = textString;

		soundManager = soundMan;
		soundId = soundMan.addSound("assets/korobeiniki_start.mp3");
	}

	public function resize (newWidth: Int, newHeight: Int): Void {}

	public function render(worldState: WorldState): Void {
		var canvas: Sprite = worldState.getPreparedCanvas();
		canvas.graphics.beginFill (0x0C0C0C, 1);
		canvas.graphics.drawRect (0, 0, worldState.getDisplayWidth(), worldState.getDisplayHeight());

		worldState.getGridScreen().render(worldState);
	}

	public function update(worldState: WorldState): Void {
		worldState.getGridController().update(worldState);
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
		soundManager.playSound(soundId, 0);
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