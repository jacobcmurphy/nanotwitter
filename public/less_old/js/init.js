/*
   Miniport by HTML5 UP
   html5up.net | @n33co
   Free for personal and commercial use under the CCA 3.0 license (html5up.net/license)
   */

(function($) {

	skel.init({
		reset: 'full',
	breakpoints: {
		'global':	{ range: '*', href: 'css/style.css' },
	'desktop':	{ range: '737-', href: 'css/style-desktop.css', containers: 1200, grid: { gutters: 25 } },
	'1000px':	{ range: '737-1200', href: 'css/style-1000px.css', containers: 960, grid: { gutters: 25 }, viewport: { width: 1080 } },
	'mobile':	{ range: '-736', href: 'css/style-mobile.css', containers: '100%!', grid: { collapse: true, gutters: 15 }, viewport: { scalable: false } }
	}
	});

	$(function() {

		var	$window = $(window),
		$body = $('body');

	// Disable animations/transitions until the page has loaded.
	$body.addClass('is-loading');

	$window.on('load', function() {
		$body.removeClass('is-loading');
	});

	// Forms (IE<10).
	var $form = $('form');
	
	// CSS polyfills (IE<9).
	if (skel.vars.IEVersion < 9)
		$(':last-child').addClass('last-child');

	// Scrolly.
	$window.load(function() {
		$('#postTweet').tweetbox({
			limit:140, 
			cb: function(tweet) {
				$.post( "/tweet", {"text":tweet,"user_id":1});
			}
		
		});

		$("#searchload").hide();
		$("#nouser").hide();
		$("#postTweet").hide();

		$("#search").on('propertychange change keyup input paste', function(){
			$("#searchload").show();
			$("#tweets").empty();
			var searchString = "/search/" + encodeURI(JSON.stringify($("#search").val()));
			$.get( searchString, function( response ){
				
				var latest = JSON.parse(response);
				for (var tweet in latest){
					$("#tweets").append(tweetToHtml(latest[tweet]));
				}
				if (latest.length==0){
					$("#tweets").empty();
					$("#tweets").append("No results");
				}
				$("#searchload").fadeOut(1000);
									
			});
			

		});

		

		$("#badpass").hide();
		$.get( "/all", function( response ){
			var latest = JSON.parse(response);
			for (var tweet in latest){
				$("#tweets").append(tweetToHtml(latest[tweet]));
			}
		});

		
		var x = parseInt($('.wrapper').first().css('padding-top')) - 15;
		// We need to access the form element
		var signInForm = document.getElementById("signIn");
		signInForm.addEventListener("submit", function (event) {
			event.preventDefault();
			email = signInForm.email.value;
			password = signInForm.password.value;
			$.post( "/login", {"email":email, "password":password}, function( response ) {
				response = JSON.parse(response);
				
				
				if (!response["email_exists"]){
					$("#nouser").show();
					$('html, body').delay(500).animate({
						scrollTop: $("#signup").offset().top
					}, 800);
					return;
				}
				if (!response["password_correct"]){
					$("#badpass").show();
					$('#signIn').effect("shake");
					form.email.value = "";
					form.password.value = "";
					return;
				}
				$('#signIn').hide("slow");
				$('#signup').hide();
				$('#signup_button').replaceWith("<li id=\"signup_button\"><a href=\"#signup\">Logout</a></li>");
				$('#postTweet').show("slow");

			});
		});

		var signUpForm = document.getElementById("signUp");
		signUpForm.addEventListener("submit", function (event) {
			event.preventDefault();
			console.log(form.email.value);
			username = signUpForm.username.value;
			email = signUpForm.email.value;
			password = signUpForm.password.value;
			$.post( "/register", {"username" : username, "email":email, "password":password}, function( response ) {
				console.log(JSON.stringify(response));
				
							});
		});



		$('#nav a, .scrolly').scrolly({
			speed: 1000,
			offset: x
		});

	});

	});

})(jQuery);

function tweetToHtml(tweet){
	var tweet_element = '<div class=\"4u\"><section class=\"box style1\"><span class=\"icon featured fa-comments-o\"></span><h3>';
	tweet_element += tweet["user_id"];
	tweet_element += "</h3><p>";
	tweet_element += tweet["text"];
	tweet_element += "</p></section></div>";
	return tweet_element;
}


