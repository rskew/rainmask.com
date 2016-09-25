var audioContext = new AudioContext()

var masterGain = audioContext.createGain(1);
masterGain.connect(audioContext.destination);

var mainBusGain = audioContext.createGain(1),
    dryGain = audioContext.createGain(1),
    wetGain = audioContext.createGain(0.4),
    reverb = audioContext.createConvolver();

mainBusGain.connect(dryGain);
dryGain.connect(masterGain);

// Get impulse response for Convolution Reverb
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

//var stereoImpulseUrl = "carpark_balloon_ir_stereo_24bit_44100.wav";
//var stereoImpulseUrl = "mine_site2_1way_mono.wav";
var stereoImpulseUrl = "st_andrews_church.wav";
loadAudio(reverb, stereoImpulseUrl);

mainBusGain.connect(reverb);
reverb.connect(wetGain);
wetGain.connect(masterGain);

// Create Noise Buffer
var bufferSize = audioContext.sampleRate,
    nBufs = 128+2,
    noiseBuffers = [];
for (var buf = 0; buf < nBufs; buf++) {
    var noiseBuffer = audioContext.createBuffer(1, bufferSize, audioContext.sampleRate),
        output = noiseBuffer.getChannelData(0),
        lastOut = 0.0;
    for (var i = 0; i < bufferSize; i++) {
        var white = Math.random() * 2 - 1;
        output[i] = (lastOut + ((0.001 * buf) * white)) /
                                 (1.00 + 0.001 * buf);
        lastOut = output[i];
        output[i] *= 3.5; // (roughly) compensate for gain
    }
    noiseBuffers[buf] = noiseBuffer;
}

// Create Background Noise
var bufferSize = audioContext.sampleRate * 4;
    backgroundNoiseBuffer = audioContext.createBuffer(2, bufferSize, audioContext.sampleRate);
for (var buf = 0; buf < 2; buf++) {
        output = backgroundNoiseBuffer.getChannelData(buf),
        lastOut = 0.0;
    for (var i = 0; i < bufferSize; i++) {
        var white = Math.random() * 2 - 1;
        output[i] = (lastOut + (0.02 * white)) /
                                 (1.00 + 0.02);
        lastOut = output[i];
        output[i] *= 3.5; // (roughly) compensate for gain
    }
}

var backgroundNoise = audioContext.createBufferSource();
    
backgroundNoise.buffer = backgroundNoiseBuffer;
backgroundNoise.loop = true;
backgroundNoise.start(0);

var backgroundNoiseGain = audioContext.createGain(0);
backgroundNoiseGain.gain.setValueAtTime(0.17, audioContext.currentTime);

backgroundNoise.connect(backgroundNoiseGain);
backgroundNoiseGain.connect(mainBusGain);

//var brownNoise = audioContext.createBufferSource();
//brownNoise.buffer = noiseBuffer;
//brownNoise.loop = true;
//
//var gainNode = audioContext.createGain(0);
//gainNode.connect(audioContext.destination);
//
//brownNoise.connect(gainNode);
//gainNode.gain.setValueAtTime(0, audioContext.currentTime);
//brownNoise.start(0);
//
//function fire( decayRate ) {
//    time = audioContext.currentTime;
//    gainNode.gain.setValueAtTime(1, time);
//    gainNode.gain.setTargetAtTime(0, time, decayRate);
//}


function newDrop (startTime, decayTime, pan) {

    var raindrop = audioContext.createBufferSource();

    var buf = Math.floor( Math.random() * (nBufs-2) );
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

    //var time = audioContext.currentTime;
    dropGain.gain.setValueAtTime(1, startTime);
    dropGain.gain.exponentialRampToValueAtTime(1e-10, startTime + decayTime);

    raindrop.stop(startTime + decayTime);

    //document.getElementById("thing1").innerHTML = audioContext.currentTime;
}


app.ports.backgroundNoisePort.subscribe(function (args) {
    var backgroundNoiseIntensity = args[0];
    backgroundNoiseGain.gain.setTargetAtTime(backgroundNoiseIntensity,
                                       audioContext.currentTime,
                                       0.2);
});


app.ports.togglePort.subscribe(function (args) {
    if (masterGain.gain.value > 0.5) {
        masterGain.gain.setTargetAtTime(0, audioContext.currentTime, 0.005);
    } else {
        masterGain.gain.setTargetAtTime(1, audioContext.currentTime, 0.005);
    }
});


app.ports.dryLevelPort.subscribe(function (args) {
    var dryLevel = args[0];
    dryGain.gain.setTargetAtTime(dryLevel,
                                 audioContext.currentTime,
                                 0.2);
});


app.ports.reverbLevelPort.subscribe(function (args) {
    var reverbLevel = args[0];
    wetGain.gain.setTargetAtTime(reverbLevel,
                                 audioContext.currentTime,
                                 0.2);
});


app.ports.masterVolumePort.subscribe(function (args) {
    var masterVolume = args[0];
    mainBusGain.gain.setTargetAtTime(masterVolume,
                                     audioContext.currentTime,
                                     0.2);
});


//var nextDrop = {decayTime : 1, pan : {x : 1, y : 1, z : 1}};
app.ports.raindropPort.subscribe(function (args) {
    var decayTime = args[0];
    var pan = args[1];

    newDrop (audioContext.currentTime, decayTime, pan);
    //nextDrop.decayTime = decayTime;
    //nextDrop.pan = pan;
});


// Timer

//var currentDropTime = audioContext.currentTime,
//    interArrivalTime = 1000./40,
//    nextDropTime = currentDropTime + interArrivalTime;
//
//var scheduleAheadTime = 30,
//    schedulingInterval = 5;
//
//function scheduleDrop() {
//    var startTime = nextDropTime;
//
//    newDrop (startTime, nextDrop.decayTime, nextDrop.pan);
//
//    currentDropTime = startTime;
//};
//
//function setupNextDrop() {
//    nextDropTime = currentDropTime + interArrivalTime;
//
//    app.ports.timerPort.send('giveNewDrop');
//};
//
//
//function scheduler () {
//    while (nextDropTime < audioContext.currentTime + scheduleAheadTime ) {
//        scheduleDrop();
//        setupNextDrop();
//    }
//}

if (typeof(timerWorker) == "undefined") {
    timerWorker = new Worker('js/timerWorker.js');
}
timerWorker.postMessage(1000./40);
//timerWorker.postMessage(schedulingInterval);
timerWorker.addEventListener('message', function (e) {
    //document.getElementById("thing2").innerHTML = e.data;
    app.ports.timerPort.send('tick');
    //scheduler();
});


app.ports.setTimerPort.subscribe(function (args) {
    var time = args[0];
    timerWorker.postMessage(time);
    //interArrivalTime = time;
});
