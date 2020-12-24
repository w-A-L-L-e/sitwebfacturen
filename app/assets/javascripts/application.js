// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require turbolinks
//= require bootstrap
//= require rails-ujs
//= require_tree .


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


$(document).ready( function(){
	//$("#header").fadeIn();
	//this could solve double load issues, needs further testing
	//document.addEventListener("turbolinks:before-visit", function() {
	//	Turbolinks.clearCache();
	//});
});

$(document).on('turbolinks:load', function() {
	//fix footer should always be on bottom...
  setTimeout( function(){ 
    $(".content-wrapper").css("min-height",$(window).height()-70 );
    $(".main-footer").show();
  }
  ,1 );

});
