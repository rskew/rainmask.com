//// Create buffers of noise for raindrops and for background noise

function createNoiseBuffers () {
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

    return [noiseBuffers, backgroundNoiseBuffer];
};
