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

	pageSpecificInits.global($);
	initPageSpecificRoutine($);

});

function initPageSpecificRoutine(jquery){
	var initRoutine = jquery('[data-js-init]').data('js-init');
	if(initRoutine!==undefined){
		window.pageSpecificInits[initRoutine](jquery);
	}
}

var pageSpecificInits = {};

pageSpecificInits.messagesPage = function(jquery){
	jquery('.miniImg').tooltipster({ theme: 'tooltipster-miniimg' });
	$('.miniImg').hover(function(){

		$(this).find('img').addClass('on');
	},function(){
		$(this).find('img').removeClass('on');
	})
	$('.miniImg').click(function(){
		$(this).find('a').click();
	})
}

pageSpecificInits.newMessagePage = function(jquery){

  jquery('.newMessagesFormWrapper .formHeader .submit-field').click(function(){
    jquery('.newMessagesFormWrapper form .submit-field').click();
  });

  jquery('[placeholder]').focus(function(){
  	$(this).data('placeholder', $(this).attr('placeholder'));
  	$(this).attr('placeholder', '');
  });

  jquery('[placeholder]').blur(function(){
  	$(this).attr('placeholder', $(this).data('placeholder'));
  });  

};

pageSpecificInits.createMessagePage = function(jquery){

  jquery('[placeholder]').focus(function(){
  	$(this).data('placeholder', $(this).attr('placeholder'));
  	$(this).attr('placeholder', '');
  });

  jquery('[placeholder]').blur(function(){
  	$(this).attr('placeholder', $(this).data('placeholder'));
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
	this._initFirstLetterSearch(jquery, '.wrapperFieldDropdown.forSector');
	this._initFirstLetterSearch(jquery, '.wrapperFieldDropdown.forVendor');
	this._initFirstLetterSearch(jquery, '.wrapperFieldDropdown.forCountry');

};

pageSpecificInits.searchPeersPage = function(jquery){
	this._intentionsPopUp(jquery);
	this._initFirstLetterSearch(jquery, '.wrapperFieldDropdown.forSector');
	this._initFirstLetterSearch(jquery, '.wrapperFieldDropdown.forVendor');
	this._initFirstLetterSearch(jquery, '.wrapperFieldDropdown.forCountry');
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

	var adjustConnectionBoxHeight = function(){

		var breakstate = jquery('.breakstate').width();

		if(breakstate === 1050){
			var w = $('.homeConnectionProfile').outerWidth();
			jquery('.homeConnectionProfile').outerHeight(w);
			jquery('.homeConnectionPic').outerHeight(w);
		}
		else if(breakstate === 0){

			jquery('.homeConnectionProfile').outerHeight(170);
			jquery('.homeConnectionPic').outerHeight(170);
		}
		else {

			jquery('.homeConnectionProfile').outerHeight(187);
			jquery('.homeConnectionPic').outerHeight(187);

		}
	};

	var onResize = function(){

		adjustContentPicSize();
		adjustConnectionBoxHeight();

		var breakstate = jquery('.breakstate').width();
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
				var h = box_1.find('.homeContentResearch').outerHeight();
				console.log('diff: ' + diff);
				console.log('total: ' + h + diff);
				box_2.find('.homeContentResearch').outerHeight(h + diff);
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
	adjustConnectionBoxHeight();

	this._intentionsPopUp(jquery);
	this._initFirstLetterSearch(jquery, '.wrapperFieldDropdown.forCountry');
	this._initFirstLetterSearch(jquery, '.wrapperFieldDropdown.forSector');
	this._initFirstLetterSearch(jquery, '.wrapperFieldDropdown.forVendor');

};

pageSpecificInits._intentionsPopUp = function(jquery){

	var associations = [[1, 2], [1, 5], [1, 1], [1, 3], [1, 4], [1, 6], [1, 7], [1, 8], [1, 9], [1, 10], [1, 11], [1, 12], [1, 13], [1, 236], [1, 14], [1, 15], [1, 16], [3, 26], [3, 3], [3, 7], [3, 36], [12, 6], [12, 224], [12, 3], [12, 13], [12, 53], [12, 1], [14, 3], [14, 53], [14, 130], [14, 36], [16, 6], [16, 4], [19, 59], [19, 6], [19, 25], [19, 53], [8, 53], [8, 251], [8, 3], [8, 80], [8, 52], [8, 277], [8, 7], [8, 26], [22, 196], [22, 130], [2, 26], [2, 7], [4, 3], [5, 56], [6, 3], [7, 53], [7, 236], [7, 23], [7, 26], [12, 7], [12, 109], [12, 110], [12, 17], [12, 295], [12, 113], [12, 114], [13, 3], [13, 4], [13, 7], [13, 23], [13, 112], [13, 127], [13, 25], [13, 1], [13, 53], [14, 132], [16, 146], [16, 74], [16, 110], [16, 148], [16, 132], [19, 23], [22, 135], [22, 132], [22, 195], [19, 120], [12, 111], [12, 266], [16, 73], [20, 172], [20, 173], [20, 4], [20, 177], [16, 120], [7, 226], [12, 4], [12, 112], [13, 236], [16, 135], [8, 81], [22, 198], [22, 189], [16, 147], [13, 266], [22, 4], [14, 26], [20, 3], [20, 175], [14, 131], [22, 190], [22, 193], [22, 194], [14, 55], [20, 174], [15, 139], [3, 35], [3, 37], [6, 70], [14, 133], [20, 176], [22, 192], [22, 197], [13, 126], [22, 191], [4, 7], [5, 57], [5, 59], [7, 7], [7, 25], [8, 78], [8, 79], [10, 39], [14, 135], [10, 93], [10, 223], [19, 224], [2, 258], [7, 14], [7, 73], [12, 115], [12, 236], [7, 266], [7, 286], [8, 82], [9, 1], [14, 4], [16, 224], [9, 78], [9, 4], [22, 89], [5, 58], [2, 254], [4, 52], [2, 244], [7, 74], [9, 3], [14, 134], [14, 136], [15, 140], [15, 141], [15, 142], [22, 53], [7, 13], [9, 53], [7, 72], [12, 116], [2, 238], [2, 27], [2, 28], [5, 60], [6, 71], [7, 241], [9, 215], [9, 89], [10, 92], [4, 1], [4, 53], [9, 248], [17, 6], [17, 160], [17, 53], [18, 160], [18, 146], [18, 53], [18, 76], [21, 172], [21, 186], [21, 236], [21, 3], [18, 6], [21, 270], [20, 178], [9, 7], [21, 237], [21, 245], [17, 164], [21, 178], [21, 188], [21, 174], [16, 9], [17, 161], [18, 170], [18, 220], [17, 162], [21, 177], [16, 149], [17, 4], [17, 163], [17, 285], [17, 291], [18, 165], [18, 166], [18, 167], [18, 168], [18, 169], [21, 4], [20, 270], [21, 262], [21, 187], [21, 173], [21, 136], [21, 179], [5, 62], [1, 17], [13, 6], [16, 151], [5, 61], [12, 117], [15, 143], [16, 7], [8, 83], [16, 278], [18, 61], [16, 113], [17, 62], [16, 150], [18, 62], [1, 18], [1, 19], [1, 20], [12, 118], [12, 84], [12, 119], [14, 38], [5, 65], [11, 96], [11, 97], [11, 98], [16, 59], [3, 39], [5, 63], [11, 99], [11, 105], [16, 118], [3, 38], [3, 40], [3, 41], [3, 42], [3, 43], [3, 297], [3, 293], [3, 44], [4, 235], [5, 64], [5, 66], [6, 38], [7, 256], [7, 75], [7, 38], [8, 84], [8, 286], [8, 85], [8, 86], [9, 90], [11, 7], [11, 36], [11, 100], [11, 44], [11, 101], [11, 102], [11, 103], [11, 104], [11, 293], [13, 128], [13, 18], [13, 129], [16, 152], [16, 153], [16, 124], [16, 154], [2, 29], [2, 30], [2, 250], [3, 45], [5, 67], [12, 120], [12, 121], [1, 21], [1, 265], [1, 22], [1, 23], [15, 144], [12, 122], [12, 123], [12, 24], [10, 95], [10, 94], [4, 229], [8, 229], [4, 54], [4, 261], [8, 54], [8, 261], [5, 68], [5, 69], [13, 228], [2, 32], [11, 106], [3, 48], [2, 31], [3, 46], [3, 47], [9, 91], [1, 24], [11, 107], [4, 55], [8, 272], [1, 25], [3, 219], [5, 219], [1, 289], [3, 33], [2, 33], [7, 77], [2, 214], [2, 284], [3, 49], [3, 50], [3, 51], [3, 214], [3, 284], [4, 263], [5, 51], [7, 76], [8, 247], [8, 221], [8, 274], [8, 234], [8, 273], [1, 275], [1, 213], [3, 264], [8, 36], [7, 239], [8, 271], [8, 282], [8, 87], [7, 232], [7, 267], [5, 242], [8, 88], [8, 243], [8, 259], [7, 292], [2, 34], [3, 34], [3, 281], [1, 267], [5, 216], [11, 108], [8, 240]];

	jquery('.fieldDropdown.forSector').click(function(e){
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

			jquery('.fieldDropdown.forVendor').click();
			jquery('.fieldDropdown.forVendor .fieldOption').eq(0).click();

			setTimeout(function(){

				jquery('.modalSectionHeader.intentionsHeader').click();

			}, 100);

		}

	});

}

pageSpecificInits._initFirstLetterSearch = function(jquery, elementWithTabIndex){

	/*

	param explain:

		elementWithTabIndex is the selector of a container ...

			1) that has the tabindex='1' attribute
			2) and it should contain something like:

				<ul>

					<li data-initial="a">..
					<li data-initial="a">..
					<li data-initial="b">..
					...

	*/

	var sel = elementWithTabIndex;

	jquery(sel).keypress(function(e){

		var key = e.keyCode;
		var character = String.fromCharCode(key);
		var group = jquery(this).find('ul li[data-initial='+character+']');

		if(group.length > 0){

			var addToPos = group.first().position().top;
			var currPos = jquery(sel).find('ul').scrollTop();
			jquery(sel).find('ul').scrollTop(currPos + addToPos);

		}

	});

};

pageSpecificInits.loginPage = function(jquery){

	jquery('.loginField input').keypress(function(e){

		var key = e.keyCode;

		if(key===13){

		    $('.fitoLandingSignInSubmit').click();
		    return false;

		}

	});

};

pageSpecificInits.profilePage = function(jquery){

	jquery('.connectedIcon').click(function(){

		jquery('.profileButton.profileDeleted a').click()

	}).hover(function(){

		if($('.breakstate').width()!==700){
			jquery('.unfriendText').show();
		}

	},function(){

		if($('.breakstate').width()!==700){
			jquery('.unfriendText').hide();
		}

	});
};

pageSpecificInits.myProfilePage = function(jquery){

	jquery('.updateIcon').click(function(){

		$('.updateButton a').click();
	});

};

pageSpecificInits.global = function(jquery){
	var blue_links = $('a').map(function(i, element){ if($(element).css('color')==='rgb(62, 178, 204)') return $(element) });
	$(blue_links).each(function(){
		$(this).addClass('blue-link');
	});
	$('.mailMenuIcon').hover(function(){
		$(this).find('img').eq(0).hide();
		$(this).find('img').eq(1).show();
	},function(){
		$(this).find('img').eq(0).show();
		$(this).find('img').eq(1).hide();
	})
}
