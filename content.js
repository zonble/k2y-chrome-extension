function() {
	var href = window.location.href
	var pathes = href.split("/")
	var playlist_id = pathes[pathes.length - 1]
	var fullpath = "https://k2y.herokuapp.com/playlists/" + playlist_id

	var html = "<div class='container'><a href='" + fullpath + "' style='font-size:22pt'>Play the playlist using Youtube.</a></div>";
	var wrapper = document.createElement('div');
	wrapper.innerHTML = html;
	var container = document.getElementsByClassName('container')[0]
	document.body.insertBefore(wrapper, container)
}()
