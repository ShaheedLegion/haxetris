interface IGameScreenObject extends IGameObject {
	public function render(worldState: WorldState): Void;
	public function update(worldState: WorldState): Void;

	public function enterGameScreen(worldState: WorldState): Void;
	public function exitGameScreen(worldState: WorldState): Void;
	public function shouldTransition(worldState: WorldState): Bool;
}