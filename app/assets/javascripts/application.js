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

};

pageSpecificInits.searchResultsPage = function(jquery){

	var sideBar = jquery('.searchResultsSideBar');

	jquery('.adjustSearchLink').click(function(){
		sideBar.css({ right: '-100%' });
		sideBar.removeClass('break-2-hide');
		sideBar.animate({ right: '0%' });
	});

	jquery(window).resize(function(){
		sideBar.addClass('break-2-hide');
		sideBar.css({ right: '0%' });
	});

	jquery('.sideBarClose').click(function(){
		sideBar.animate({ right: '-100%' }, function(){
			sideBar.addClass('break-2-hide');
			sideBar.css({ right: '0%' });
		});
	});

};

pageSpecificInits.homePage = function(jquery){

	var alignHeights = function(box_1, box_2, wrap_1, wrap_2){

		if(box_1.outerHeight() > box_2.outerHeight()){
			wrap_1.outerHeight(box_1.outerHeight());
			wrap_2.outerHeight(box_1.outerHeight());
		}
		else{
			wrap_1.outerHeight(box_2.outerHeight());
			wrap_2.outerHeight(box_2.outerHeight());
		}
	};

	var onResize = function(){

		adjustContentPicSize();

		var breakstate = $('.breakstate').width();
		if(breakstate === 1050 || breakstate === 0){

			alignHeights(
				jquery(".homeContentInvite.homeContent.break-1-hide"), 
				jquery('.homeContentFollowed.homeContent'),
				jquery('.homeContentBox2 .bottom .left'), 
				jquery('.homeContentBox2 .bottom .right')
			);


			var box_1 = jquery(".homeContentBox1");
			var box_2 = jquery('.homeContentBox2');
			var wrap_1 = jquery('.homeContentWrapper > .left');
			var wrap_2 = jquery('.homeContentWrapper > .right');
			if(box_1.outerHeight() > box_2.outerHeight()){
				// console.log('left wins');
				var diff = box_1.outerHeight() - box_2.outerHeight();
				var h = jquery('.homeContentBox2 .homeContentResearch').outerHeight();
				console.log('diff: ' + diff);
				console.log('total: ' + h + diff);
				jquery('.homeContentBox2 .homeContentResearch').outerHeight(h + diff);
			}
			else{
				wrap_1.outerHeight(box_2.outerHeight());
				wrap_2.outerHeight(box_2.outerHeight());
			}

		}
		else{
			var h = jquery(".homeContentBox2 .bottom .left .homeContentFollowed").outerHeight();
			console.log(h);
			jquery('.homeContentBox2 .bottom .left').outerHeight(h);
			jquery('.homeContentWrapper > .left').outerHeight(jquery(".homeContentBox1").outerHeight());
			jquery('.homeContentWrapper > .right').outerHeight(jquery(".homeContentBox2").outerHeight());
		
		}
	}

	jquery(window).resize(onResize);

	onResize();

	var adjustContentPicSize = function(){

		var box = jquery('.homeContentPic');
		console.log('box');
		var pic = box.find('img');
		var ratio = function(o){ return o.width()/o.height() };
		if(ratio(box) > ratio(pic)){
			box.addClass('tallPic');
			box.removeClass('widePic');
		}
		else{
			box.addClass('widePic');
			box.removeClass('tallPic');
		}
	};

	adjustContentPicSize();
	
};