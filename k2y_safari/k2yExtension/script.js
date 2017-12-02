if (window.top === window) {
	document.addEventListener("DOMContentLoaded", function(event) {
		var url = window.location.href
		var matches = url.match(/(http|https):\/\/([a-zA-Z0-9]+).kkbox.com(\/[a-z][a-z]|)(\/[a-z][a-z]|)\/playlist\/([a-zA-Z0-9\\_\\-]+)(#[a-zA-Z0-9]+|)/)
		if (matches.length == 0) {
			return
		}
		var playlist_id = matches[5]

		var fullpath = "https://k2y.herokuapp.com/embed_playlists/" + playlist_id

		var html = "<iframe src='" + fullpath + "' style='width:100%; height: 370px; margin: 0; padding: 0'></iframe>";
		var wrapper = document.createElement('div');
		wrapper.innerHTML = html;
		var container = document.getElementsByClassName('container')[0]
		document.body.insertBefore(wrapper, container)
	});
}
