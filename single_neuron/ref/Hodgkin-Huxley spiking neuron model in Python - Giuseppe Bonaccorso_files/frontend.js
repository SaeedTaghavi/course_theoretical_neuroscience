jQuery(document).ready(function(){window.mbt_email_updates_submit=function(element){var element=jQuery(element);element.find('input[type="submit"]').attr('disabled','disabled');element.find('.mbt-email').attr('disabled','disabled');jQuery.post(ajaxurl,{action:'mbt_email_updates_submit',email:element.find('.mbt-email').val(),post_id:element.find('.mbt-postid').val(),},function(response){element.html('<div class="mbt-book-email-updates-message">'+response+'</div>');});return false;}
if(jQuery('.mbt-display-mode-landingpage .mbt-book-menu').length){jQuery(window).scroll(function(event){var scroll=jQuery(window).scrollTop();if(scroll==0){jQuery('.mbt-book-menu').removeClass('mbt-book-menu-overlap');}else{jQuery('.mbt-book-menu').addClass('mbt-book-menu-overlap');}});jQuery('.mbt-book-menu-button').click(function(){jQuery('.mbt-book-menu-sections').toggleClass('mbt-book-menu-expanded');});jQuery(document).click(function(e){if(e.target!=jQuery('.mbt-book-menu-button')[0]){jQuery('.mbt-book-menu-sections').removeClass('mbt-book-menu-expanded');}});jQuery('.mbt-book-menu-sections a, .mbt-book-purchase-button').click(function(){var target=jQuery(this.hash);target=target.length?target:jQuery('[name='+this.hash.slice(1)+']');if(target.length){jQuery('html, body').stop().animate({scrollTop:target.offset().top-jQuery('.mbt-book-menu-container').height()-jQuery('#wpadminbar').height()},1000);return false;}});}});