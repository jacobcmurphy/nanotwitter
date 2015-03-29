
$(document).ready(function(){/* off-canvas sidebar toggle */

	$('[data-toggle=offcanvas]').click(function() {
		$(this).toggleClass('visible-xs text-center');
		$(this).find('i').toggleClass('glyphicon-chevron-right glyphicon-chevron-left');
		$('.row-offcanvas').toggleClass('active');
		$('#lg-menu').toggleClass('hidden-xs').toggleClass('visible-xs');
		$('#xs-menu').toggleClass('visible-xs').toggleClass('hidden-xs');
		$('#btnShow').toggle();
	});

	$(function () {
		$('.btnChangeXML').click(function () {
			hello = jQuery.get('/api/v1/tweets/recent', function(data) {
				var tweets = JSON.parse(data);
				tweets.forEach(function(element){
					var m = JSON.stringify(element);
					console.log(m);
					$('#txtDisplay').val(m);
				});
			}); 
			$('#txtDisplay').val(hello);
		});

	});

});


