jQuery.noConflict()(function($){$(document).ready(function(){function backToTopButton(){var
$scrollTopBtn=$('#back_top');if($scrollTopBtn.hasClass('visible-button')){$scrollTopBtn.removeClass('visible-button');}
$(window).scroll(function(){if($(window).scrollTop()>0){$scrollTopBtn.addClass('visible-button');}else{$scrollTopBtn.removeClass('visible-button');}});$scrollTopBtn.on('click',function(){$('html:not(:animated), body:not(:animated)').animate({scrollTop:0},0);return false;});}
backToTopButton();});});