var href = window.location.href
var pathes = href.split("/")
var playlist_id = pathes[pathes.length - 1]
var fullpath = "https://k2y.herokuapp.com/embed_playlists/" + playlist_id

var html = "<iframe src='" + fullpath + "' style='width:100%; height: 370px; margin: 0; padding: 0'></iframe>";
var wrapper = document.createElement('div');
wrapper.innerHTML = html;
var container = document.getElementsByClassName('container')[0]
document.body.insertBefore(wrapper, container)
