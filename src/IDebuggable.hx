// IDebuggable interface is useful for adding in debug information that should be printed onto the screen.
// At this point it's not connected to anything - I'll connect it in revision 2.
interface IDebuggable {
	public function outputDebug(worldState: WorldState): Void;
}