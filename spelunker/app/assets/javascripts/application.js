// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

$(document).ready(function() {
  $("#sketch-container a.block").hover(function(e) {
    // get the image data
    if(this.dataset.smallUrl) {
      var img = document.createElement('img');  
      img.className = 'popover';
      img.src = this.dataset.smallUrl;
      //img.style = "top: " + e.pageY + "px; left: " + e.pageX + "px";
      img.style.top = e.pageY + 'px';
      img.style.left = e.pageX + 'px';
      document.body.appendChild(img);  
    }

    // find the id
    var thingId = this.dataset.thingId;
    $("#accession-"+thingId).addClass('highlight');
  }, function() {
    $(".popover").remove();
    $(".accession").removeClass('highlight');
  });

  $("#accessions .accession").hover(function(e) {
    var thingId = this.dataset.thingId;
    $("#thing-"+thingId).addClass('forcehover');

    var thing = $("#thing-"+thingId)[0];

    if(thing.dataset.smallUrl) {
      var img = document.createElement('img');  
      img.className = 'popover';
      img.src = thing.dataset.smallUrl;
      //img.style = "top: " + e.pageY + "px; left: " + e.pageX + "px";
      img.style.top = e.pageY + 'px';
      img.style.left = e.pageX + 'px';
      document.body.appendChild(img);  
    }
  }, function(e) {
    $(".popover").remove();
    $(".accession").removeClass('highlight');
    $(".block").removeClass('forcehover');
  });
});
