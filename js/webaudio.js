var audioContext = new AudioContext()

var masterGain = audioContext.createGain(1);
masterGain.connect(audioContext.destination);

var mainBusGain = audioContext.createGain(1),
    dryGain = audioContext.createGain(1),
    wetGain = audioContext.createGain(0.4),
    reverb = audioContext.createConvolver();

mainBusGain.connect(dryGain);
dryGain.connect(masterGain);

// Load impulse response for Convolution Reverb
function loadAudio(convolverNode, url) {
    var request = new XMLHttpRequest();
    request.open('GET', url, true);
    request.responseType = 'arraybuffer';

    request.onload = function() {
        audioContext.decodeAudioData(request.response, function(buffer) {
            convolverNode.buffer = buffer;
        });
    }
    request.send();
    
}

var stereoImpulseUrl = "st_andrews_church.wav";
loadAudio(reverb, stereoImpulseUrl);

mainBusGain.connect(reverb);
reverb.connect(wetGain);
wetGain.connect(masterGain);

// Create the noise buffers

[noiseBuffers, backgroundNoiseBuffers] = createNoiseBuffers();

var backgroundNoise = audioContext.createBufferSource();
    
backgroundNoise.buffer = backgroundNoiseBuffer;
backgroundNoise.loop = true;
backgroundNoise.start(0);

var backgroundNoiseGain = audioContext.createGain(0);
backgroundNoiseGain.gain.setValueAtTime(0.17, audioContext.currentTime);

backgroundNoise.connect(backgroundNoiseGain);
backgroundNoiseGain.connect(mainBusGain);


function newDrop (startTime, decayTime, pan) {

    var raindrop = audioContext.createBufferSource();

    var buf = Math.floor( Math.random() * (noiseBuffers.length - 2) );
    raindrop.buffer = noiseBuffers[buf];
    raindrop.loop = true;

    var startOffset = Math.random();
    raindrop.start(startTime, startOffset);

    var dropGain = audioContext.createGain(0);

    var dropPan = audioContext.createPanner();
    dropPan.setPosition(pan.x, pan.y, pan.z);

    raindrop.connect(dropGain);
    dropGain.connect(dropPan);
    dropPan.connect(mainBusGain);

    dropGain.gain.setValueAtTime(1, startTime);
    dropGain.gain.exponentialRampToValueAtTime(1e-10, startTime + decayTime);

    raindrop.stop(startTime + decayTime);
}


app.ports.backgroundNoiseLevelPort.subscribe(function (backgroundNoiseLevel) {
    backgroundNoiseGain.gain.setTargetAtTime(backgroundNoiseLevel,
                                       audioContext.currentTime,
                                       0.2);
});


app.ports.togglePort.subscribe(function (turnOnOrOff) {
    if (turnOnOrOff) {
        masterGain.gain.setTargetAtTime(1, audioContext.currentTime, 0.005);
    } else {
        masterGain.gain.setTargetAtTime(0, audioContext.currentTime, 0.005);
    }
});


app.ports.dropLevelPort.subscribe(function (dryLevel) {
    dryGain.gain.setTargetAtTime(dryLevel,
                                 audioContext.currentTime,
                                 0.2);
});


app.ports.reverbLevelPort.subscribe(function (reverbLevel) {
    wetGain.gain.setTargetAtTime(reverbLevel,
                                 audioContext.currentTime,
                                 0.2);
});


app.ports.masterVolumePort.subscribe(function (masterVolume) {
    mainBusGain.gain.setTargetAtTime(masterVolume,
                                     audioContext.currentTime,
                                     0.2);
});


app.ports.raindropPort.subscribe(function (args) {
    var startTime = args[0];
    var decayTime = args[1];
    var pan = args[2];

    newDrop (startTime, decayTime, pan);
    //document.getElementById("debug1").innerHTML = startTime;
    //document.getElementById("debug2").innerHTML = audioContext.currentTime;
});


if (typeof(timerWorker) == "undefined") {
    timerWorker = new Worker('js/timerWorker.js');
}
// Initialise worker
//  The worker will keep triggering the generation of raindrops, even when the
//  tab in inactive.
timerWorker.postMessage(1000./4);
timerWorker.addEventListener('message', function (e) {
    app.ports.timerPort.send(audioContext.currentTime);
    //document.getElementById("debug2").innerHTML = audioContext.currentTime;
    //document.getElementById("debug3").innerHTML = e.data[1];
});


app.ports.setTimerPort.subscribe(function (time) {
    timerWorker.postMessage(time);
});


function visible (yesno) {
    app.ports.visibilityPort.send(yesno);
};
