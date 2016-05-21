var got = require('got');
var urlList = [];

var url = encodeURIComponent('https://www.wine.com.br/vinhos/toro-loco-tempranillo-2014/prod12845.html');


function sendRequests() {
	for (var i = 20; i > 0; i--) {
		var request = got('http://159.203.126.167:8100?force=true&fetch_url=' + url);
		urlList.push(request);
	}

	Promise.all(urlList)
		.then((req) => {
			sendRequests();
			console.log(req[0]);
		})
		.catch((err) => {
			sendRequests();
			console.log(err);
		});
}

sendRequests();
