
$(document).ready(function(){/* off-canvas sidebar toggle */

	$('[data-toggle=offcanvas]').click(function() {
		$(this).toggleClass('visible-xs text-center');
		$(this).find('i').toggleClass('glyphicon-chevron-right glyphicon-chevron-left');
		$('.row-offcanvas').toggleClass('active');
		$('#lg-menu').toggleClass('hidden-xs').toggleClass('visible-xs');
		$('#xs-menu').toggleClass('visible-xs').toggleClass('hidden-xs');
		$('#btnShow').toggle();
	});
});

$(function () {
	$('.btnChangeXML').click(function () {
		hello = jQuery.get('/api/v1/tweets/recent', function(data) {
		//	alert(JSON.parse(data));
			//console.log(data);
			var stuff = JSON.parse(data);
			alert(JSON.parse(stuff[0]));
			JSON.parse(data).forEach(function(element){
				console.log(JSON.parse(element));
			});
		}); 
		$('#txtDisplay').val(hello);
	});

});

