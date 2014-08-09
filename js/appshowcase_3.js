var AppShowcase = (function() {
	
	var $el = $( '#app-wrap' ),
		// device element
		$device = $el.find( '.app-device' ),
		// the device image wrap
		$trigger = $device.children( 'a:first' ),
		// the screens
		$screens = $el.find( '.app-list > a' ),
		// the device screen image
		$screenImg = $device.find( 'img' ).css( 'transition', 'all 1s ease' ),
		// the device screen title
		$screenBtn = $( 'button' ),
		// navigation arrows
		$nav = $device.find( 'nav' ),
		$navPrev = $nav.children( 'span:first' ),
		$navNext = $nav.children( 'span:last' ),
		// current screen´s element index
		current = 0,
		// if navigating is in process
		animating = false,
		// total number of screens
		screensCount = $screens.length,
		// csstransitions support
		support = Modernizr.csstransitions,
		// transition end event name
		transEndEventNames = {
			'WebkitTransition' : 'webkitTransitionEnd',
			'MozTransition' : 'transitionend',
			'OTransition' : 'oTransitionEnd',
			'msTransition' : 'MSTransitionEnd',
			'transition' : 'transitionend'
		},
		transEndEventName = transEndEventNames[ Modernizr.prefixed( 'transition' ) ],
		// HTML Body element
		$body = $( 'body' ); 

	function init() {

		// navigate
		$navPrev.on( 'click', function() {
			navigate( 'prev' );
			return false;
		} );
		$navNext.on( 'click', function() {
			navigate( 'next' );
			return false;
		} );
	}

	function navigate( direction ) {

		if( animating ) {
			return false;
		}

		animating = true;
		
		if( direction === 'next' ) {
			current = current < screensCount - 1 ? ++current : 0;
		}
		else if( direction === 'prev' ) {
			current = current > 0 ? --current : screensCount - 1;
		}
		
		// next screen to show
		var $nextScreen = $screens.eq( current );

		if( support ) {

			// append new image to the device
			var $nextScreenImg = $( '<img src="' + $nextScreen.find( 'img' ).attr( 'src' ) + '"></img>' ).css( {
				transition : 'all 0.8s ease',
				opacity : 0,
				transform : direction === 'next' ? 'scale(1)' : 'translateX(-320px)'
			} ).insertBefore( $screenImg );

			// update button
      //

			setTimeout( function() {

				// current image fades out / new image fades in
				$screenImg.css( {
					opacity : 0,
					transform : direction === 'next' ? 'translateX(-320px)' : 'scale(1)' 
				} ).on( transEndEventName, function() { $( this ).remove(); } );

				$nextScreenImg.css( {
					opacity : 1,
					transform : direction === 'next' ? 'scale(1)' : 'translateX(0px)' 
				} ).on( transEndEventName, function() {
					$screenImg = $( this ).off( transEndEventName );
					animating = false;
				} );

			}, 25 );

		}
		else {
			// update image and title on the device
			$screenImg.attr( 'src', $nextScreen.find( 'img' ).attr( 'src' ) );
			$screenTitle.text( $nextScreen.find( 'span' ).text() );
			animating = false;
		}

	}

	return { init : init };

})();