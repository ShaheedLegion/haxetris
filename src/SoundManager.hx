import openfl.media.Sound;
import openfl.Assets;

class SoundManager {
	private var sounds: Array<Sound>;

	public function new() {
		sounds = new Array();
	}

	public function addSound(name: String): Int {
		var sound = Assets.getSound(name, true);
		return sounds.push(sound) - 1;
	}

	public function stopSound(soundId: Int) {
		if (soundId >= 0 && soundId < sounds.length) {
			sounds[soundId].close();
		}
	}

	public function playSound(soundId: Int, loops: Int) {
		if (soundId >= 0 && soundId < sounds.length) {
			sounds[soundId].play(0, loops);
		}
	}
}