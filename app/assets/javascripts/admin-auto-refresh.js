$(function() {
var sPath = window.location.pathname;
    var sPage = sPath.substring(sPath.lastIndexOf('/') + 1);
    if (sPage == 'orders'){
        setTimeout("location.reload(true);", 10000);
    }
})
