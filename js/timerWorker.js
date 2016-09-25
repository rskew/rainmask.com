var interval = null;

var count = 0
self.addEventListener('message', function (e) {
    time = e.data;
    clearInterval(interval);
    interval = setInterval(function () {
        self.postMessage(count);
        count += 1;
    }, time);
});
