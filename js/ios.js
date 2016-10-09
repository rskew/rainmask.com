// IOS requires touch interaction to unmute sound
window.addEventListener('touchstart', function() {

	var source = audioContext.createBufferSource();
	source.buffer = backgroundNoiseBuffer;
    source.loop = true;

	source.connect(audioContext.destination);

    source.noteOn(1);
    source.start(0);

}, false);
