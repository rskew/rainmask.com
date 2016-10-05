// source for this: http://greensock.com/forums/topic/9059-cross-browser-to-detect-tab-or-window-is-active-so-animations-stay-in-sync-using-html5-visibility-api/

// main visibility API function 
// use visibility API to check if current tab is active or not
var vis = (function(){
    var stateKey, 
        eventKey, 
        keys = {
                hidden: "visibilitychange",
                webkitHidden: "webkitvisibilitychange",
                mozHidden: "mozvisibilitychange",
                msHidden: "msvisibilitychange"
    };
    for (stateKey in keys) {
        if (stateKey in document) {
            eventKey = keys[stateKey];
            break;
        }
    }
    return function(c) {
        if (c) document.addEventListener(eventKey, c);
        return !document[stateKey];
    }
})();


// check if current tab is active or not
vis(function(){

    if(vis()){

        // tween resume() code goes here    
        setTimeout(function(){            
            console.log("tab is visible - has focus");
            visible(true); // visible defined in webaudio.js
        },300);     

    } else {
        
        // tween pause() code goes here
        console.log("tab is invisible - has blur");      
        visible(false);
    }
});
