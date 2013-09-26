.pragma library

function round(original, places) {
    var a = Math.pow(10, places);
    return Math.round(original * a) / a;
}

function pad(num) {
     return (num < 10) ? ("0" + num) : num;
}
