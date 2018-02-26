interface IGridScreenController extends IGameObject {
	public function render(worldState: WorldState): Void;
	public function update(worldState: WorldState): Void;
	public function outputDebug(worldState: WorldState): Void;
	public function resize (newWidth: Int, newHeight: Int): Void;

	public function getGridRepresentation(): Array<Int>;
	public function setAutoMode(auto: Bool): Void;
	public function shouldTransition(worldState: WorldState): Bool;
	public function getScore(): Int;
	public function hadCollision(): Bool;
	public function hadRowScore(): Bool;
}