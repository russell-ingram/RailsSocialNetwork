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

	this._intentionsPopUp(jquery);

};

pageSpecificInits.searchPeersPage = function(jquery){
	console.log('here');
	this._intentionsPopUp(jquery);
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

	var adjustContentPicSize = function(){

		var box = jquery('.homeContentPic');
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

	adjustContentPicSize();

	this._intentionsPopUp(jquery);
	
};

pageSpecificInits._intentionsPopUp = function(jquery){

	var associations = [[109, 664], [109, 665], [109, 666], [109, 667], [109, 668], [109, 669], [109, 670], [109, 671], [109, 672], [109, 673], [109, 674], [109, 675], [109, 676], [109, 677], [109, 678], [109, 679], [109, 680], [110, 681], [110, 667], [110, 670], [110, 682], [111, 669], [111, 683], [111, 667], [111, 676], [111, 684], [111, 666], [112, 667], [112, 684], [112, 685], [112, 682], [113, 669], [113, 668], [114, 686], [114, 669], [114, 687], [114, 684], [115, 684], [115, 688], [115, 667], [115, 689], [115, 690], [115, 691], [115, 670], [115, 681], [116, 692], [116, 685], [117, 681], [117, 670], [118, 667], [119, 693], [120, 667], [121, 684], [121, 677], [121, 694], [121, 681], [111, 670], [111, 695], [111, 696], [111, 697], [111, 698], [111, 699], [111, 700], [122, 667], [122, 668], [122, 670], [122, 694], [122, 701], [122, 702], [122, 687], [122, 666], [122, 684], [112, 703], [113, 704], [113, 705], [113, 696], [113, 706], [113, 703], [114, 694], [116, 707], [116, 703], [116, 708], [114, 709], [111, 710], [111, 711], [113, 712], [123, 713], [123, 714], [123, 668], [123, 715], [113, 709], [121, 716], [111, 668], [111, 701], [122, 677], [113, 707], [115, 717], [116, 718], [116, 719], [113, 720], [122, 711], [116, 668], [112, 681], [123, 667], [123, 721], [112, 722], [116, 723], [116, 724], [116, 725], [112, 726], [123, 727], [124, 728], [110, 729], [110, 730], [120, 731], [112, 732], [123, 733], [116, 734], [116, 735], [122, 736], [116, 737], [118, 670], [119, 738], [119, 686], [121, 670], [121, 687], [115, 739], [115, 740], [125, 741], [112, 707], [125, 742], [125, 743], [114, 683], [117, 744], [121, 678], [121, 712], [111, 745], [111, 677], [121, 711], [121, 746], [115, 747], [126, 666], [112, 668], [113, 683], [126, 739], [126, 668], [116, 748], [119, 749], [117, 750], [118, 690], [117, 751], [121, 705], [126, 667], [112, 752], [112, 753], [124, 754], [124, 755], [124, 756], [116, 684], [121, 676], [126, 684], [121, 757], [111, 758], [117, 759], [117, 760], [117, 761], [119, 762], [120, 763], [121, 764], [126, 765], [126, 748], [125, 766], [118, 666], [118, 684], [126, 767], [127, 669], [127, 768], [127, 684], [128, 768], [128, 704], [128, 684], [128, 769], [129, 713], [129, 770], [129, 677], [129, 667], [128, 669], [129, 771], [123, 772], [126, 670], [129, 773], [129, 774], [127, 775], [129, 772], [129, 776], [129, 727], [113, 672], [127, 777], [128, 778], [128, 779], [127, 780], [129, 715], [113, 781], [127, 668], [127, 782], [127, 783], [127, 784], [128, 785], [128, 786], [128, 787], [128, 788], [128, 789], [129, 668], [123, 771], [129, 790], [129, 791], [129, 714], [129, 753], [129, 792], [119, 793], [109, 697], [122, 669], [113, 794], [119, 795], [111, 796], [124, 797], [113, 670], [115, 798], [113, 799], [128, 795], [113, 699], [127, 793], [113, 800], [128, 793], [109, 801], [109, 802], [109, 803], [111, 804], [111, 805], [111, 806], [112, 807], [119, 808], [130, 809], [130, 810], [130, 811], [113, 686], [110, 741], [119, 812], [130, 813], [130, 814], [113, 804], [110, 807], [110, 815], [110, 816], [110, 817], [110, 818], [110, 819], [110, 820], [110, 821], [118, 822], [119, 823], [119, 824], [120, 807], [121, 825], [121, 826], [121, 807], [115, 805], [115, 746], [115, 827], [115, 828], [126, 829], [130, 670], [130, 682], [130, 830], [130, 821], [130, 831], [130, 832], [130, 833], [130, 834], [130, 820], [122, 835], [122, 801], [122, 836], [113, 837], [113, 838], [113, 839], [113, 840], [117, 841], [117, 842], [117, 843], [110, 844], [119, 845], [111, 709], [111, 846], [109, 847], [109, 848], [109, 849], [109, 694], [124, 850], [111, 851], [111, 852], [111, 853], [125, 854], [125, 855], [118, 856], [115, 856], [118, 857], [118, 858], [115, 857], [115, 858], [119, 859], [119, 860], [122, 861], [117, 862], [130, 863], [110, 864], [117, 865], [110, 866], [110, 867], [126, 868], [109, 853], [130, 869], [118, 726], [115, 870], [109, 687], [110, 871], [119, 871], [109, 872], [110, 873], [117, 873], [121, 874], [117, 875], [117, 876], [110, 877], [110, 878], [110, 879], [110, 875], [110, 876], [118, 880], [119, 879], [121, 769], [115, 881], [115, 882], [115, 883], [115, 884], [115, 885], [109, 886], [109, 887], [110, 888], [115, 682], [121, 889], [115, 890], [115, 891], [115, 892], [121, 893], [121, 894], [119, 895], [115, 896], [115, 897], [115, 898], [121, 899], [117, 900], [110, 900], [110, 901], [109, 894], [119, 902], [130, 903], [115, 904]];

	jquery('.fieldDropdown').click(function(e){
		var sectorId = $(e.target).data('sector-id');

		if(sectorId===undefined){
			jquery('[data-vendor-id]').show();
		}
		else{
			sectorId = parseInt(sectorId);
			var vendorIds = [];
			for(var i=0; i<associations.length; i++){
				var item = associations[i];
				if(item.length===2 && item[0]===sectorId){
					vendorIds.push(item[1]);
				}
			}

			jquery('[data-vendor-id]').hide();
			for(var i=0; i<vendorIds.length; i++){
				jquery('[data-vendor-id='+vendorIds[i]+']').show();
			}

		}
	});

}