import openfl.display.Sprite;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormatAlign;
import openfl.text.TextField;
import openfl.text.TextFormat;

class GameScreen implements IGameScreenObject {

	private var textFormat: TextFormat = new TextFormat();
	private var text: TextField = new TextField();
	private var soundId: Int;
	private var soundIdBlockHit: Int;
	private var soundIdRowScore: Int;
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

		text.text = "Score: ";
		soundManager = soundMan;
		soundId = soundManager.addSound("assets/korobeiniki_game.mp3");
		soundIdBlockHit = soundManager.addSound("assets/line-drop.mp3");
		soundIdRowScore = soundManager.addSound("assets/line-remove.mp3");
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

		if (worldState.getGridController().hadCollision()) {
			soundManager.playSound(soundIdBlockHit, 0);
		}
		if (worldState.getGridController().hadRowScore()) {
			soundManager.playSound(soundIdRowScore, 0);
		}

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
		worldState.getGridController().setAutoMode(false);
		worldState.getPreparedCanvas().addChild(text);
		soundManager.playSound(soundId, 1000);
	}
	public function exitGameScreen(worldState: WorldState): Void {
		worldState.getPreparedCanvas().removeChild(text);
		soundManager.stopSound(soundId);
	}

	public function shouldTransition(worldState: WorldState): Bool {
		return worldState.getGridController().shouldTransition(worldState);
	}
}