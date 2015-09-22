// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery-ui/autocomplete
//= require jquery_ujs
//= require jquery-ui/datepicker
//= require local_time
//= require_tree .

$(function(){

	initPageSpecificRoutine();

});

function initPageSpecificRoutine(){
	var initRoutine = $('.pageWrap').data('js-init');
	if(initRoutine!==undefined){
		window.pageSpecificInits[initRoutine]($);
	}
}

var pageSpecificInits = {};

pageSpecificInits.newMessagePage = function(jquery){

  jquery('.newMessagesFormWrapper .formHeader .submit-field').click(function(){
    jquery('.newMessagesFormWrapper form .submit-field').click();
  });

};

pageSpecificInits.connectionsPage = function(jquery){

	jquery('.connectionRequest .buttonsBox .button').click(function(){

		if($(this).hasClass('accept')){
			$('.connectionButtonAccept input').click();
		}
		else if($(this).hasClass('ignore')){
			$('.connectionButtonReject input').click();
		}
		else if($(this).hasClass('full')){

		}

	});

}