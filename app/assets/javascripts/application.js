// Author: Walter Schreppers
// This is a manifest file that'll be compiled into application.js, which will include all the file//= require jquery
//= require turbolinks
//= require bootstrap
//= require rails-ujs
//= require_tree .


// Description: Some quick and dirty js mostly for styling pages and allow
// inline invoice lines to work in the nested form of invoices.
function fix_layout(){
  console.log("documen height=", $(document).height() );
  console.log("window  height=", $(window).height() );
  
  $(".content-wrapper").css("min-height",$(document).height()+30 );
  $(".content-wrapper").css("height",$(document).height()+30 );
}


function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".fields").hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g");
  $(link).parent().before(content.replace(regexp, new_id));
  fix_layout();
}


$(document).on("click", "a.link_to_add_fields", function(e){
        e.preventDefault();
        var link = $(this);
        var association = $(this).data("association");
        var content = $(this).data("content");
        add_fields(link, association, content);
});

$(document).on("click", "a.link_to_remove_fields", function(e){
        e.preventDefault();
        var link = $(this);
        remove_fields(link);
});


$(document).on('turbolinks:load', function() {
	//fix footer should always be on bottom...
  setTimeout( function(){ 
    $(".content-wrapper").css("min-height",$(window).height()-50 );
    $(".main-footer").show();
  }
  ,200 );


  // highlight item in left menu with some vanilla js just for eye-candy ;)
  var menu = document.getElementsByClassName("sidebar-menu");
  if(menu && menu.length>0){
    var menu_items = menu[0].children;
    var url = window.location.href;
    for( var i in menu_items){
      var menu_item = menu_items[i];
      if( menu_item.children && menu_item.children.length>0)
        // better browser support but only highlight identical page
        // if( menu_item.children[0].href == url ){ 
        // nicer, also highlights subpages but includes only works in recent browsers
        if( url.includes(menu_item.children[0].href) ){ 
          menu_item.className = 'active'
        }
        else{
          menu_item.className = ''
        }
    }
  }
});

