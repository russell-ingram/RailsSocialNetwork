$( document ).ready(function() {
  pastPositionsVisible = 0;
  $(".pastPositionBox").each(function() {
    if ($(this).hasClass('active')) {
      pastPositionsVisible ++;
    }
    console.log(pastPositionsVisible);
  })
  $('.addPastPosition').off().on('click',function(){
    if (pastPositionsVisible < 2) {
      $("#pastExp1").show();
      pastPositionsVisible++;
      console.log(pastPositionsVisible);
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

  $('#editPhotoUpload').click(function() {
    $('.customFileInput').trigger('click');
    $('.customFileInput').change(function(){
      readURL(this, 'profile');
    });

  })

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
      $(".myConnsList").empty();
      for (i in data) {
        var user = data[i];
        var pic = '';

        if (user.profile_pic_url.url !== null) {
          pic = '<img src="'+user.profile_pic_url.url+'">';
        } else {
          var num = Math.floor(Math.random() * (10 - 1) + 1);
          pic = '<img src="/assets/avatar-icons/avatar_0'+num+'.svg"';
        };
        var connBox = '<div class="myConnection"><div class="myConnWrapper"><div class="myConnProfilePic"><a href="/profile/'+user.id+'">'+pic+'</a></div><div class="myConnInfo"><div class="myConnName"><a href="/profile/'+user.id+'">'+user.first_name+' '+user.last_name+'</a></div><div class="myConnCompany">'+user.employer+'</div><div class="myConnIndustry">'+user.industry+'</div></div><div class="myConnMessage userActionsSidebar"><div class="userListAction"><a href="/admin/edit_user/'+user.id+'">review</a></div><div class="userListAction deleteAction"><a data-confirm="Are you sure you would like to delete this user?" href="/admin/delete/'+user.id+'">delete</a></div><div class="userListAction"><a href="/messages/new/'+user.id+'">send message</a></div></div></div></div>'
        $('.myConnsList').append(connBox);
      }
    })
  });

  $('#searchUsersInput').keyup(function(event){
    if(event.keyCode == 13) {
      $('#searchUsersButton').click();
    }
  });

  $('.searchTagClose').off().on('click',function() {
    $(this).parent().next().val('');
    $(this).parent().remove();
    $('#searchEdit').click();
  });

  $('.spendingTagClose').off().on('click',function() {
    var index = $(this).attr('name');
    var oldStr = $('#resultsFieldTagsField').val();
    console.log(oldStr);
    var oldArr = JSON.parse(oldStr);
    console.log(oldArr);
    console.log(oldArr.length);
    if (oldArr.length > 1) {
      var newArr = oldArr.splice(index - 1, 1);
      var newStr = JSON.stringify(newArr);
      $('#resultsFieldTagsField').val(newStr);
    } else {
      $('#resultsFieldTagsField').val('');
    }



    $(this).parent().remove();
    $('#searchEdit').click();
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

  $('#searchAddFavButton').off().on('click', function() {

    var data = $(this).attr('data');
    var name = $("#saved_search_name").val();
    if (name.length > 30) {
      var n = 30 - name.length;
      name = name.slice(0, n);
    }
    $.post('/search/add_favorite',{"searchData": data, "name":name},function(data) {

      $('.searchResultsFollowButton').html("ADDED TO FOLLOWED SEARCHES <div class='icon icon-icon-check'></div> ");
      $('.searchResultsFollowButton').addClass('inactive');
      // console.log(data);
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
      console.log(props_string);
      if (props_string !== "null, ") {
        props_string = props_string.slice(0,-2);
      }
      if (props_string.length === 0 && !intentions) {
        props_string = "<i>No filters selected.</i>";
      }
      console.log(props_string.length);
      if (intentions && props_string !== "") {
        var searchElem = '<div class="favSearch"><div class="favSearchHeader">'+data.name+'</div><div class="favSearchParams">'+props_string+'<br><i> Intention filters used. </i></div><div class="numOfPeers">'+data.peers+' Peers <div class="icon icon-fwd-arrow"></div></div></div>';
      } else if (intentions) {
        var searchElem = '<div class="favSearch"><div class="favSearchHeader">'+data.name+'</div><div class="favSearchParams"><i> Intention filters used. </i></div><div class="numOfPeers">'+data.peers+' Peers <div class="icon icon-fwd-arrow"></div></div></div>';
      } else {
        var searchElem = '<div class="favSearch"><div class="favSearchHeader">'+data.name+'</div><div class="favSearchParams">'+props_string+'</div><div class="numOfPeers">'+data.peers+' Peers <div class="icon icon-fwd-arrow"></div></div></div>';

      }

      $('.savedSearchTab').prepend(searchElem);
    })

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



      var newIntention = '<div class="addedSpendingIntention"><div class="elemNum">'+searchCounter+'</div><div class="addedSpendingIntentionLeft"><div class="addedSpendingIntentionHeader">'+searchCounter+'.</div><div class="addedSpendingIntentionText">'+intention+'</div><div class="addedSpendingIntentionText">•</div><div class="addedSpendingIntentionText">'+sector+'</div><div class="addedSpendingIntentionText">•</div><div class="addedSpendingIntentionText">'+vendor+'</div></div><div class="addedSpendingIntentionDelete"><div class="icon icon-icon-close"></div></div></div>'
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
    // need to add an elem counter?
    var newIntention = '<div class="searchSideBarSpending"><div class="searchSidebarDropdownLeft"><div class="searchSideBarSpendingHeader">Spending Intention</div><div class="searchSideBarSpendingInfo">'+intention+'  •  '+sector+'  •  '+vendor+'</div></div><div class="searchTagClose spendingTagClose"><div class="icon icon-icon-close"></div></div></div>';

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
    json[num-1] = "";
    $('#resultsField').val(JSON.stringify(json));
    searchCounter--;
    if (searchCounter < 1) {
      $('.spendingIntentions').hide();
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
      console.log(url);
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

  $('.inviteButton').off().on('click', function() {
    window.location.href = "mailto:user@example.com?subject=Check%20out%20FITO&body=Link%20goes%20here";
  });



});
