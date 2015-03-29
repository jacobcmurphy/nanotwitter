
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
		hello = jQuery.get('/', function(data) {
			alert(data);
			//process text file line by line
			$('#div').html(data.replace('n','<br />'));
			}); 
		$('#txtDisplay').val(hello);
	});

});

