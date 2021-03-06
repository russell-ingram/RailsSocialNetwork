$( document ).ready(function() {
  pastPositionsVisible = 0;
  $(".pastPositionBox").each(function() {
    if ($(this).hasClass('active')) {
      pastPositionsVisible ++;
    }
  })
  $('.addPastPosition').off().on('click',function(){
    if (pastPositionsVisible < 2) {
      $("#pastExp1").show();
      pastPositionsVisible++;
    } else if (pastPositionsVisible === 2) {
      $("#pastExp2").show();
      $('.addPastPosition').hide();
      pastPositionsVisible++;
    }
  });

  $('.cmsImageUpload').click(function() {
    $('.customFileInput').trigger('click');
    $('.customFileInput').change(function(){
      readURL(this,'cms');
    });

  })

  $('.cmsImageUpload').hover(function() {

    toggleEditImageIcon(this, 'show');

  },function() {

    toggleEditImageIcon(this, 'hide');

  })

  $('#editPhotoUpload').click(function() {
    $('.customFileInput').trigger('click');
    $('.customFileInput').change(function(){
      readURL(this, 'profile');
    });

  })

  function toggleEditImageIcon(button, state){

    var btn = $(button);

    var isAddImageIconShowing = btn.find('.add .userUploadIcons').css('display')!=='table';

    if(isAddImageIconShowing){
      btn.find('.overlay')[state]();
      btn.find('.cmsImageUploadButtonEdit')[state]();
      btn.find('.cmsImageUploadButtonEdit .userUploadIcons')[state]();
    }
  }

  function readURL(input,type) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();

      reader.onload = function (e) {
        if (type === 'cms') {
          $('.cmsImageUploadButton').css('background-image', 'url(' + e.target.result + ')');
        }
        else if (type === 'profile') {
          $('.photoUploadBox').css('background-image', 'url(' + e.target.result + ')');
        }


          $('.userUploadIcons').hide();
      }
      // $('.deletePhoto').show();

      reader.readAsDataURL(input.files[0]);
    }
  }

  $('#searchUsersButton').off().on('click',function() {
    var x = $('#searchUsersInput').val();

    $.get('/admin/users/search?term='+x, function(data) {
      $(".fullUserList").empty();
      $('html, body').animate({
          scrollTop: $("#createdAccounts").offset().top
      }, 500);

      for (i in data) {
        var user = data[i];
        var pic = user.profile_pic_url;

        var connBox = '<div class="myConnection"><div class="myConnWrapper"><div class="myConnProfilePic"><a href="/profile/'+user.id+'"><img src="'+pic+'"></a></div><div class="myConnInfo"><div class="myConnName"><a href="/profile/'+user.id+'">'+user.first_name+' '+user.last_name+'</a></div><div class="myConnCompany">'+user.employer+'</div><div class="myConnIndustry">'+ user.job_title + ', '+  user.industry+', '+user.enterprise_size +'</div></div><div class="myConnMessage userActionsSidebar"><div class="userListAction"><a href="/admin/edit_user/'+user.id+'">review</a></div><div class="userListAction deleteAction"><a data-confirm="Are you sure you would like to delete this user?" href="/admin/delete/'+user.id+'">delete</a></div><div class="userListAction"><a href="/messages/new/'+user.id+'">send message</a></div></div></div></div>'
        $('.fullUserList').append(connBox);
      }
      $('.messagesPagination').hide();
    })
  });

  $('#searchUsersInput').keyup(function(event){
    if(event.keyCode == 13) {
      $('#searchUsersButton').click();
    }
  });

  $('.bubbleTagClose').off().on('click',function() {
    $(this).parent().next().attr('value', '');
    $(this).parent().next().val('');
    $(this).parent().remove();
    $('#searchEdit').click();
  });

  $(document).on('click', '.spendingTagClose', function() {

    var index = $(this).attr('name');

    if ($(this).hasClass('sidebarTag')) {
      var oldStr = $('#resultsField').val();
      var oldArr = JSON.parse(oldStr);
      if (oldArr.length > 1) {
        var newArr = oldArr.splice(index, 1);
        var newStr = JSON.stringify(oldArr);
        $('#resultsField').val(newStr);
      } else {
        $('#resultsField').val('');
      }
      // not updating automatically on close
      // $('#submitSearch').click();
    } else {

      var oldStr = $('#resultsFieldTagsField').val();
      var oldArr = JSON.parse(oldStr);
      if (oldArr.length > 1) {
        var newArr = oldArr.splice(index, 1);
        var newStr = JSON.stringify(oldArr);
        $('#resultsFieldTagsField').val(newStr);
      } else {
        $('#resultsFieldTagsField').val('');
      }
      $('#searchEdit').click();

    }


    $(this).parent().remove();


  });

  $('.formSearchButton').off().on('click', function() {
    $('#submitSearch').click();
  });
  $('.updateSearchButton').off().on('click', function() {
    $('#submitSearch').click();
  });
  $('.fixIt').off().on('click', function() {
    $('#submitSearch').click();
  });

  $('.searchSideBarTab').off().on('click',function() {
    var tab = $(this)
    var text = tab.text();
    $('.searchSideBarTab').removeClass('active');
    tab.addClass('active');
    if (text === "Followed") {
      $('.currentSearchTab').hide();
      $('.savedSearchTab').show();
    } else {
      $('.currentSearchTab').show();
      $('.savedSearchTab').hide();
    }
  });

  var underSavedLimit = true
  $('#saved_search_name').on('input', function(delta, source) {
    var text = $('#saved_search_name').val();
    var remaining = 30 - text.length;

    $('.namedSearchCounter').text('Characters remaining: ' + remaining);
    if (remaining <0) {
      $('.namedSearchCounter').css('color', 'red');
      underSavedLimit = false;
      $('#searchAddFavButton').find('a').attr('rel','');
    } else {
      $('.namedSearchCounter').css('color', '#797C7F');
      underSavedLimit = true;
      $('#searchAddFavButton').find('a').attr('rel','modal:close');
    }

  });

  $('#searchAddFavButton').off().on('click', function() {
    if (underSavedLimit) {
      var data = $(this).attr('data');
      var name = $("#saved_search_name").val();
      if (name.length > 30) {
        var n = 30 - name.length;
        name = name.slice(0, n);
      }
      $.post('/search/add_favorite',{"searchData": data, "name":name},function(data) {

        $('.searchResultsFollowButton').html("ADDED TO FOLLOWED SEARCHES <div class='icon icon-icon-check'></div> ");
        $('.searchResultsFollowButton').addClass('inactive');
        var props_string = '';
        var intentions = false;
        $.each(data,function(k,v) {

          if (v !== '') {

            if (k === 'industry' || k === 'enterprise' || k === 'region' || k === 'country' || k === 'organization_type' ) {
              props_string += v + ', ';
            }
            if (k === 'results') {
              intentions = true;
            }
          }
          if (v === true) {
            if (k === 'clevel') {
              props_string += 'C-Level, ';
            }
            if (k === 'executive' || k === 'president' || k === 'director' || k === 'principal' || k === 'head' || k === 'senior' || k === 'lead' || k === 'manager' || k === 'architect' || k === 'infrastructure' || k === 'engineer' || k === 'consultant' || k === 'security' || k === 'analyst' || k === 'administrator' || k ==='risk' ) {
              var cap = k.charAt(0).toUpperCase() + k.substring(1);
              props_string += cap + ', ';
            }
          }
        });
        if (props_string !== "null, ") {
          props_string = props_string.slice(0,-2);
        }
        if (props_string.length === 0 && !intentions) {
          props_string = "<i>No filters selected.</i>";
        }
        if (intentions && props_string !== "") {
          var searchElem = '<div class="favSearch"><div class="favSearchHeader">'+data.name+'</div><div class="favSearchParams">'+props_string+'<br><i> Intention filters used. </i></div><div class="numOfPeers">'+data.peers+' Peers <div class="icon icon-fwd-arrow"></div></div></div>';
        } else if (intentions) {
          var searchElem = '<div class="favSearch"><div class="favSearchHeader">'+data.name+'</div><div class="favSearchParams"><i> Intention filters used. </i></div><div class="numOfPeers">'+data.peers+' Peers <div class="icon icon-fwd-arrow"></div></div></div>';
        } else {
          var searchElem = '<div class="favSearch"><div class="favSearchHeader">'+data.name+'</div><div class="favSearchParams">'+props_string+'</div><div class="numOfPeers">'+data.peers+' Peers <div class="icon icon-fwd-arrow"></div></div></div>';

        }

        $('.savedSearchTab').prepend(searchElem);
      })
    }

  });




  var searchCounter = 0;

  $('#modalDoneButton').off().on('click', function() {
    var hasValues = true;
    var vendor = $('#intention_vendor').val();
    var sector = $('#intention_sector').val();
    var intention = $("#intention_intention").val();

    if (intention === "" && sector === "" && vendor === "") {
      hasValues = false;
    }

    if (hasValues) {
      searchCounter++;
      var h = $('.searchFormBox').height();

      $('.searchFormBox').height(h+60);


      intention = intention.charAt(0).toUpperCase() + intention.slice(1).toLowerCase();
      if (intention === "") {
        intention = "Any";
      }
      if (sector === "") {
        sector = "Any";
      }
      if (vendor === "") {
        vendor = "Any";
      }

      var newIntObj = {
        "intention": intention,
        "vendor": vendor,
        "sector": sector
      };



      var newIntention = '<div class="addedSpendingIntention"><div class="elemNum" id="elemNum'+searchCounter+'">'+searchCounter+'</div><div class="addedSpendingIntentionLeft"><div class="addedSpendingIntentionHeader">'+searchCounter+'.</div><div class="addedSpendingIntentionText">'+intention+'</div><div class="addedSpendingIntentionText">•</div><div class="addedSpendingIntentionText">'+sector+'</div><div class="addedSpendingIntentionText">•</div><div class="addedSpendingIntentionText">'+vendor+'</div></div><div class="addedSpendingIntentionDelete"><div class="icon icon-icon-close"></div></div></div>'
      var jsonResults = $('#resultsField').val();
      if (jsonResults && jsonResults !== "") {
        var oldObj = JSON.parse(jsonResults);

        oldObj.push(newIntObj);
        var newObj = JSON.stringify(oldObj);
        $('#resultsField').val(newObj);
      } else {
        var newObjStr = JSON.stringify([newIntObj]);
        $('#resultsField').val(newObjStr);
      }
      $('.spendingIntentions').show();
      var h = $('.searchFormBox').height();
      $('.searchFormBox').height(h+30);
      $('.spendingIntentionsOptions').append(newIntention);
      resetModalValues();
    }



  });


  $('#modalSideBarDoneButton').off().on('click', function() {
    searchCounter++;
    // var h = $('.searchFormBox').height();

    // $('.searchFormBox').height(h+60);

    var vendor = $('#intention_vendor').val();
    var sector = $('#intention_sector').val();
    var intention = $("#intention_intention").val();
    intention = intention.charAt(0).toUpperCase() + intention.slice(1).toLowerCase();
    if (intention === "") {
      intention = "Any";
    }
    if (sector === "") {
      sector = "Any";
    }
    if (vendor === "") {
      vendor = "Any";
    }

    var newIntObj = {
      "intention": intention,
      "vendor": vendor,
      "sector": sector
    };
    var index = $('.sideBarIntentions').children().last().find('.sidebarTag').attr('name');
    var indexPlus = parseInt(index) + 1;
    // need to add an elem counter?
    var newIntention = '<div class="searchSideBarSpending"><div class="searchSidebarDropdownLeft"><div class="searchSideBarSpendingHeader">Spending Intention</div><div class="searchSideBarSpendingInfo">'+intention+'  •  '+sector+'  •  '+vendor+'</div></div><div class="searchTagClose spendingTagClose sidebarTag" name="'+ indexPlus +'"" ><div class="icon icon-icon-close"></div></div></div>';

    // for submitting new params?

    var jsonResults = $('#resultsField').val();
    if (jsonResults && jsonResults !== "") {
      var oldObj = JSON.parse(jsonResults);

      oldObj.push(newIntObj);
      var newObj = JSON.stringify(oldObj);
      $('#resultsField').val(newObj);
    } else {
      var newObjStr = JSON.stringify([newIntObj]);
      $('#resultsField').val(newObjStr);
    }
    $('.spendingIntentionsOptions').append(newIntention);
    resetModalValues();



  });



  $('.spendingIntentions').on('click','.addedSpendingIntentionDelete', function() {

    var h = $('.searchFormBox').height();
    $('.searchFormBox').height(h-60);

    var num = $(this).parent().find('.elemNum').text();
    num = parseInt(num);
    $(this).parent().remove();
    var results = $('#resultsField').val();
    var json = JSON.parse(results);
    json.splice((num-1), 1);
    $('#resultsField').val(JSON.stringify(json));
    searchCounter--;
    if (searchCounter < 1) {
      $('.spendingIntentions').hide();
      $('#resultsField').val('');
    }
    for (i = num + 1; i <= searchCounter + 1; i++) {
      if (i !== num) {
        var numId = $('#elemNum'+i);
        var header = numId.next().find('.addedSpendingIntentionHeader');
        var headerText = (i-1) + '.';
        header.text(headerText);
        numId.text(i - 1);
        var y = 'elemNum' + (i-1);
        numId.attr("id",y);

      }
    }


  })

  function resetModalValues () {

    var input1 = $("#intention_sector");
    var input2 = $("#intention_vendor");

    input1.prev().find('.ddLabel').text("Search sector");
    input2.prev().find('.ddLabel').text("Search vendors");

    input1.val("");
    input2.val("");
    $("#intention_intention").val("");


    $(".intentionSelectModal").each(function(i) {
      var icon = $(this).find('.icon')
      if (i === 0) {
        icon.removeClass('icon-selection-false');
        icon.addClass('icon-selection-true');
        $(this).addClass('active');
      } else {
        icon.removeClass('icon-selection-true');
        icon.addClass('icon-selection-false');
        $(this).removeClass('active');
      }

    });



  }




  $(".intentionSelectModal").off().on('click', function() {
    $(".intentionSelectModal").removeClass('active');
    $(".intentionSelectModal").each(function(i) {
      var icon = $(this).find('.icon')
      icon.removeClass('icon-selection-true');
      icon.addClass('icon-selection-false');
    })
    $(this).addClass('active');
    $(this).find('.icon').removeClass('icon-selection-false');
    $(this).find('.icon').addClass('icon-selection-true');
    var choice = $(this).find('.intentionModalText').text();
    $('#intention_intention').val(choice);
  });

  $(".fsmLeft").off().on('click', function() {
    var link = $(this).attr('data');
    $(location).attr('href', link);
  });

  $(document).on('click', '#searchBtnIcon', function() {
    if ($('.searchIconInput').hasClass('active')) {
      var input = $('#searchBarInput').val();
      var url = '/messages?name='+input;
      $.get(url, null, null, 'script');
    } else {
      $('.searchIconInput').addClass('active');
    }

  });

  $(document).on('keyup', '#searchBarInput', function() {
    if(event.keyCode == 13) {
      $('#searchBtnIcon').click();
    }
  });


  $(document).on('click', '#toggleRightSearch', function() {
    if ($('.searchConnsInput').hasClass('active')) {
      var input = $('#searchConnsInput').val();
      var url = '/connections?name='+input;
      $.get(url, null, null, 'script');
    } else {
      $('.searchConnsInput').addClass('active');
    }

  });

  $(document).on('keyup', '#searchConnsInput', function() {
    if(event.keyCode == 13) {
      $('#toggleRightSearch').click();
    }
  });

  $('#inviteButton').off().on('click', function() {
    var name = $(this).attr('data');

  });

  $(".onboardSubmitLogin").off().on('click', function() {
    $("#onboardSubmitLogin").click();
  });

  $(".linkedFinalize").off().on('click', function() {
    window.location.href = "/home";
  });


  $(".onboardChangePassword").off().on('click', function () {
    var id = $('#onboardSubmitChangePassword').attr('data');
    var pw = $('#password_field').val();
    var confirm = $('#confirm_password_field').val();
    var fail_msg = '';
    var passed = false;

    if (pw === '' || confirm === '') {
      fail_msg = 'Please enter a password.'
    } else if (pw !== confirm) {
      fail_msg = 'Passwords do not match.'
    } else if (pw.length < 8) {
      fail_msg = 'Password must be at least eight (8) characters long.'
    } else if (pw.search(/[A-Z]/) == -1) {
      fail_msg = 'Password must contain at least one capital letter.'
    } else if (pw.search(/[\@\!\#\$\%\^\&\*\_\-]/) == -1) {
      fail_msg = 'Password must contain at least one special character.'
    } else if (pw.search(/[^a-zA-Z0-9\!\@\#\$\%\^\&\*\_]/) != -1) {
      fail_msg = 'Password can only contain letters, numbers, and the specified special characters.'
    } else {
      passed = true;
    }

    if (passed) {
      $.post('/onboarding/edit_user/'+id, {"password": pw}, function(data) {
        $('.onboardFormMain').hide();
        $('.onboardFormMainDetails').show();
        $('.onboardFormHeaderSecondary').hide();
        $('.onboardFormHeaderMain').text("Confirm your account details");
        $('.icon-icon-onboarding-account-details').addClass('active');
        var before = $('.circleProgressBar').find('.active');
        var after = before.next();
        before.removeClass('active');
        after.addClass('active');
        $('.onboardWrap').addClass('active');
      })
    } else {
      $('.onboardWarning').text(fail_msg);

    }
  })

  $('.onboardUserDetailsSubmit').off().on('click', function () {
    var id = $('#onboardSubmitChangePassword').attr('data');
    var user = {
      'first_name': $('#first_name_field').val(),
      'last_name': $('#last_name_field').val(),
      'company': $('#onboard_company').val(),
      'industry' : $('#onboard_industry').val(),
      'enterprise_size' : $('#onboard_enterprise').val(),
      'region' : $('#onboard_region').val(),
      'country' : $('#onboard_country').val(),
      'public' : $('#onboard_public').val()
    }

    $.post('/onboarding/edit_user/'+id, user, function(data) {
        $('.icon-icon-in').addClass('active');
        var before = $('.circleProgressBar').find('.active');
        var after = before.next();
        before.removeClass('active');
        after.addClass('active');
        $('.onboardFormLinkedIn').show();
        $('.onboardFormMainDetails').hide();
        $('.onboardFormHeaderMain').text('Connect with Linked In');
        $('.onboardFormHeaderSecondary').text('Connect with your LinkedIn Account To Import your professional details');
        $('.onboardFormHeaderSecondary').show();
        $('.onboardWrap').removeClass('active');
        $(document).scrollTop(0);
    });
  })

// disable standard form submits with enter key in onboarding
  $('#confirm_password_field').on('keypress', function(e){
    if(event.keyCode == 13) {
      event.stopPropagation();
      $('.onboardChangePassword').click();
      return false;
    }
  });
  $('#password_field').on('keypress', function(e){
    if(event.keyCode == 13) {
      event.stopPropagation();
      $('.onboardChangePassword').click();
      return false;
    }
  });
  $('.onboardFormMainDetails').on('keypress', function(e) {
    if(event.keyCode == 13) {
      event.stopPropagation();
      return false;
    }
  });

  $('.confirmConnectButton').off().on('click', function() {
    var data = $(this).attr('data');
    var msg = $(this).parent().find('.connectMessage').val();
    var index = $(this).attr('data-index');
    var url = '/friendships/'+data + '/';
    var elem = '#connect'+index;
    var elemAnon = '#connectAnon'+index;
    $(elem).prev().find('.connectAction').html('<div>PENDING<span class="icon icon-fwd-arrow"></span></div>');
    $(elemAnon).prev().find('.connectAction').html('<div>PENDING<span class="icon icon-fwd-arrow"></span></div>');

    $.post(url, {'message': msg}, function(data) {

    });
  });

  $('.confirmConnectButtonProfile').off().on('click', function() {
    var data = $(this).attr('data');
    var msg = $(this).parent().find('.connectMessage').val();
    var url = '/friendships/'+data;
    var elem = $('.profileConnect');
    $(elem).replaceWith('<div class="profileButton profilePending">PENDING</div>');

    $.post(url, {'message': msg}, function(data) {


    });
  });

  $('.confirmConnectButtonHome').off().on('click', function() {
    var data = $(this).attr('data');
    var msg = $(this).parent().find('.connectMessage').val();
    var index = $(this).attr('data-index');
    var url = '/friendships/'+data;
    var elem = '.connectElem'+index;
    var html = '<a href="/profile/'+ data +'">pending <div class="icon icon-fwd-arrow"></div></a>';
    $(elem).html(html);

    $.post(url, {'message': msg}, function(data) {

    });
  });

  $('.confirmSendInviteButton').off().on('click', function() {
    var id = $(this).attr('data');
    var msg = $(this).parent().find('.connectMessage').val();
    var url = '/requests/'+id+'/send_invite/';

    $.post(url, {'message': msg}, function(data) {
      // window.location.reload();
    });
  });

  $(".resetChangePassword").off().on('click', function () {
    var id = $('#resetSubmitChangePassword').attr('data');
    var pw = $('#password_field').val();
    var confirm = $('#confirm_password_field').val();

    if (pw === confirm) {
      $.post('/onboarding/edit_user/'+id, {"password": pw}, function(data) {
       window.location.href = "/home"
      })
    } else {
      $('.onboardWarning').text("Passwords do not match.");

    }
  });

  $('.newMsgBtnSend').off().on('click', function() {
    if ($('#admin_recipients').val() === '') {
      $('ul.tagit').css('border-color','red');
      $(document).scrollTop(0);
      event.stopPropagation();
      return false;
    }
    if ($('#recipients').val() === '') {
      $('ul.tagit').css('border-color','red');
      $(document).scrollTop(0);
      event.stopPropagation();
      return false;
    }
  })

  $('.homeSendInviteButton').off().on('click', function() {
    var id = $(this).attr('data-id');
    var email = $(this).parent().find('#sendInviteConnectMsg').val();
    var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;

    if (!email.match(re)) {
      $('#sendInviteConnectMsg').css('border-color','red');
      return false;
    } else {
      var url = '/requests/'+id+'/user_send_invite';

      $.post(url, {'email': email}, function(data) {

      });
    }


  })

});
