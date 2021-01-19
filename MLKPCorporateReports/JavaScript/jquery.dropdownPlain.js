$(function(){

    $("ul.dropdown li").hover(function(){
    
        $(this).addClass("hover");
        $('ul:first',this).css('visibility', 'visible');
//        $('li', this).css('visibility', 'hidden');
    
    }, function(){
    
        $(this).removeClass("hover");
        $('ul:first',this).css('visibility', 'hidden');
//          $('li', this).css('visibility', 'hidden');
    });
    
    $("ul.dropdown li ul li:has(ul)").find("a:first").append(" &raquo; ");
   // $("##header").frameAnimation({hoverMode:false, repeat:-1});

});



