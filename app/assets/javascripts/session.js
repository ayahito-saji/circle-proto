var is_animate;
$(document).on('turbolinks:load', function(){
    if(($(window).height()<$(window).width()) && ($(window).width()>=480)) {
        var animation;
        var match = location.search.match(/a=(.*?)(&|$)/);
        if(match) animation = decodeURIComponent(match[1]);
        if(animation != 'none'){
            is_animate = true;
            $('.title-inner').css('top', '60%');
            $('.title-inner').css('opacity', '0');
            $('.title-outer').css('width', '100%');
            $('.body-outer').css('top', '10%');
            $('.body-outer').css('opacity', '0');

            $('.title-inner').animate({
                'top': '50%',
                'opacity': '1'
            }, {
                'duration': 500,
                'done': function(){
                    $('.title-outer').delay(1000).animate({
                        'width': '50%'
                    }, {
                        'duration': 1000,
                        'done': function(){
                            $('.body-outer').animate({
                                'top': '0%',
                                'opacity': '1'
                            }, {
                                'duration': 1000,
                                'done': function(){is_animate = false;}
                            })
                        }
                    })
                }
            })
        }else{
            $('.title-inner').css('top', '50%');
            $('.title-inner').css('opacity', '1');
            $('.title-outer').css('width', '50vw');
            $('.body-outer').css('top', '0%');
            $('.body-outer').css('opacity', '1');
        }
    }
});
$(window).on('turbolinks:load resize', function(){
    if(($(window).height()<$(window).width()) && ($(window).width()>=480)) {
        if(!is_animate) $('.title-outer').css('width', '50%');
        if($('.body-inner').css('height')>$('.body-outer').css('height')){
            $('.body-inner').css('top', '0');
            $('.body-inner').css('transform', 'translateY(0%) translateX(-50%)');
            $('.body-inner').css('webkitTransform', 'translateY(0%) translateX(-50%)');
        }else{
            $('.body-inner').css('top', '50%');
            $('.body-inner').css('transform', 'translateY(-50%) translateX(-50%)');
            $('.body-inner').css('webkitTransform', 'translateY(-50%) translateX(-50%)');
        }
    }else{
        $('.title-outer').css('width', '100%');
        $('.body-inner').css('transform', 'translateY(0%) translateX(0%)');
        $('.body-inner').css('webkitTransform', 'translateY(0%) translateX(0%)');
    }
});