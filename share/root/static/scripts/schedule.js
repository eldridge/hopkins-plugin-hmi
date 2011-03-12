YUI().use('event', 'node', function(Y) {
	var degToRad = function (degrees) { return (Math.PI/180) * degrees };

	Y.on('available', function() {
		var ctx = Y.Node.getDOMNode(Y.one('#schedule')).getContext('2d');

		ctx.beginPath();
		ctx.moveTo(75, 50);
		ctx.lineTo(100, 75);
		ctx.lineTo(100, 25);
		//ctx.arc(100, 50, 12, degToRad(45), degToRad(300));
		ctx.fill();
		ctx.closePath();

		var grRed = ctx.createLinearGradient(1,1,1,10);
		grRed.addColorStop(0, '#f55');
		grRed.addColorStop(0.4, '#fff');
		grRed.addColorStop(0.6, '#ccc');
		grRed.addColorStop(1, '#f55');

		ctx.beginPath();
		roundRect(ctx, 300, 300, 200, 15, 5);
		ctx.strokeStyle = '#f00';
		ctx.fillStyle = grRed;
		ctx.lineWidth = 1.0;
		ctx.fill();
		ctx.stroke();
		ctx.closePath();

		ctx.fillRect(30, 30, 50, 50);
	}, '#schedule');



	/**
	* Draws a rounded rectangle using the current state of the canvas. 
	* If you omit the last three params, it will draw a rectangle 
	* outline with a 5 pixel border radius 
	* @param {CanvasRenderingContext2D} ctx
	* @param {Number} x The top left x coordinate
	* @param {Number} y The top left y coordinate 
	* @param {Number} width The width of the rectangle 
	* @param {Number} height The height of the rectangle
	* @param {Number} radius The corner radius. Defaults to 5;
	* @param {Boolean} fill Whether to fill the rectangle. Defaults to false.
	* @param {Boolean} stroke Whether to stroke the rectangle. Defaults to true.
	*/
	function roundRect(ctx, x, y, width, height, radius, fill, stroke) {
		ctx.moveTo(x + radius, y);
		ctx.lineTo(x + width - radius, y);
		ctx.quadraticCurveTo(x + width, y, x + width, y + radius);
		ctx.lineTo(x + width, y + height - radius);
		ctx.quadraticCurveTo(x + width, y + height, x + width - radius, y + height);
		ctx.lineTo(x + radius, y + height);
		ctx.quadraticCurveTo(x, y + height, x, y + height - radius);
		ctx.lineTo(x, y + radius);
		ctx.quadraticCurveTo(x, y, x + radius, y);
	}
});
