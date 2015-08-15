.pragma library

function round(original, places) {
    var a = Math.pow(10, places);
    return Math.round(original * a) / a;
}

function pad(num) {
     return (num < 10) ? ("0" + num) : num;
}

function trim (str){
    //http://blog.stevenlevithan.com/archives/faster-trim-javascript
    return str.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
}

function getQuotient (original) {
    return ( original | 0);
}

function getFraction(original) {
    return original - ( original | 0);
}


