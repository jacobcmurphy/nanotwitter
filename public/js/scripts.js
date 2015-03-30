
$(document).ready(function(){/* off-canvas sidebar toggle */

	$('[data-toggle=offcanvas]').click(function() {
		$(this).toggleClass('visible-xs text-center');
		$(this).find('i').toggleClass('glyphicon-chevron-right glyphicon-chevron-left');
		$('.row-offcanvas').toggleClass('active');
		$('#lg-menu').toggleClass('hidden-xs').toggleClass('visible-xs');
		$('#xs-menu').toggleClass('visible-xs').toggleClass('hidden-xs');
		$('#btnShow').toggle();
	});
	jQuery.get('/api/v1/tweets/recent', function(data) {
		var tweetBox = document.getElementById('tweets');
		JSON.parse(data).forEach(function(element){
			tweetBox.innerHTML = tweetBox.innerHTML + element.text + "<br><hr>";
		});
	}); 
});

$(function () {
	$('.signIn').click(function () {
		$.post( "/login", function( data ) {
			alert( "Data Loaded: " + data );
		}).fail(function(data) {
    alert( JSON.stringfy(data) );
  });
	});

});

