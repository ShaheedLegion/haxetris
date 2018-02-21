class ScreenManager implements IGameObject {

	private var gameScreens: Array<IGameObject>;
	private var currentScreen: Int;

	public function new(worldState: WorldState) {
		gameScreens = new Array();
		gameScreens.push(new StartScreen(worldState));
		gameScreens.push(new GameScreen(worldState));
		gameScreens.push(new EndScreen(worldState));
		currentScreen = 0;
	}

	public function resize (newWidth: Int, newHeight: Int): Void {
		for (gameScreen in gameScreens) {
			gameScreen.resize(newWidth, newHeight);
		}
	}

	public function render(worldState: WorldState): Void {
		if (currentScreen >= 0 && currentScreen < gameScreens.length) {
			gameScreens[currentScreen].render(worldState);
		}
	}
	public function update(worldState: WorldState): Void {
		if (currentScreen >= 0 && currentScreen < gameScreens.length) {
			gameScreens[currentScreen].update(worldState);
		}
	}
	public function outputDebug(worldState: WorldState): Void {
		if (currentScreen >= 0 && currentScreen < gameScreens.length) {
			gameScreens[currentScreen].outputDebug(worldState);
		}
	}
}