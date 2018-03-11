interface IGameObject extends IResizeable extends IDebuggable {
	public function render(worldState: WorldState): Void;
	public function update(worldState: WorldState): Void;
}