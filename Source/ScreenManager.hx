class ScreenManager implements IGameObject {

	private var gameScreens: Array<IGameScreenObject>;
	private var currentScreen: Int;

	public function new(worldState: WorldState) {
		gameScreens = new Array();
		gameScreens.push(new StartScreen(worldState));
		gameScreens.push(new GameScreen(worldState));
		gameScreens.push(new EndScreen(worldState));
		currentScreen = 0;

		gameScreens[currentScreen].enterGameScreen(worldState);
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
		// Check if we need to transition.
		if (currentScreen >= 0 && currentScreen < gameScreens.length) {
			if (gameScreens[currentScreen].shouldTransition(worldState)) {
				gameScreens[currentScreen].exitGameScreen(worldState);

				// Check if we need to roll over to beginning.
				currentScreen++;
				if (currentScreen > gameScreens.length - 1) {
					currentScreen = 0;
				}
				gameScreens[currentScreen].enterGameScreen(worldState);
			}
			gameScreens[currentScreen].update(worldState);
		}
	}
	public function outputDebug(worldState: WorldState): Void {
		if (currentScreen >= 0 && currentScreen < gameScreens.length) {
			gameScreens[currentScreen].outputDebug(worldState);
		}
	}
}