// Author: Walter Schreppers
// Description: Some old-school js inline to add/remove nested form with invoice line fields
//              We also incorporate adminlte here for some quick styling of forms and pages.

//= require jquery
//= require turbolinks
//= require bootstrap
//= require rails-ujs
//= require_tree .


function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".fields").hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g");
  $(link).parent().before(content.replace(regexp, new_id));
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
  console.log("page ready");
});

