$( document ).ready(function() {

  $('.addPastPosition').click(function(){
    $('.pastExperienceFormBox').append("<div class=\"formBoxField\"><div class=\"formBoxRow\"><div class=\"field field-col-2 fieldCol2First\"><input placeholder=\"Title\" type=\"text\" name=\"past_emp[title]\" id=\"past_emp_title\"></div><div class=\"field field-col-2\"><input placeholder=\"Company\" type=\"text\" name=\"past_emp[company]\" id=\"past_emp_company\"></div><div class=\"pastEmpDates pubLabel\"><div class=\"pastEmpDateLabel\">Start date</div><div class=\"field pastEmpDateBox\"><input placeholder=\"MM/YYYY\" type=\"text\" name=\"past_emp[start_date]\" id=\"past_emp_start_date\"></div><div class=\"pastEmpDateLabel\">End date</div><div class=\"field pastEmpDateBox\"><input placeholder=\"MM/YYYY\" type=\"text\" name=\"past_emp[end_date]\" id=\"past_emp_end_date\"></div></div><div class=\"pastEmpDescriptionBox field-area field-summary\"><textarea name=\"past_emp[description]\" placeholder=\"Description\"></textarea></div></div></div>");
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
        if (user.profile_pic_url) {
          pic = '<img src="'+user.profile_pic_url.url+'">';
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
  })

  $('.searchTagClose').on('click',function() {
    $(this).parent().remove();
  });

  $('.formSearchButton').off().on('click', function() {
    $('#submitSearch').click();
  });
  $('.updateSearchButton').off().on('click', function() {
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
    // $('#searchFavNameField').addClass('active');
    var data = $(this).attr('data');

    $.post('/search/add_favorite',{"searchData": data},function(data) {
      // $('#searchFavNameField').removeClass('active');
      $('#searchAddFavButton').html("Search saved! <i class='fa fa-check'></i> ")
      $('#searchAddFavButton').css('color', '#00CC00');
    })
  });

  var searchCounter = 0;

  $('.modalDoneButton').off().on('click', function() {
    searchCounter++;
    var h = $('.searchFormBox').height();

    $('.searchFormBox').height(h+60);

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


  })

  function resetModalValues () {

    var input1 = $("#intention_sector");
    var input2 = $("#intention_vendor");

    input1.prev().find('.ddLabel').text("Search infrastructure");
    input2.prev().find('.ddLabel').text("Search vendors");

    input1.val("");
    input2.val("");
    $("#intention_intention").val("");


    $(".intentionSelectModal").each(function(i) {
      var icon = $(this).find('.icon')
      if (i === 0) {
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
    $(this).find('.icon').addClass('icon-selection-true');
    var choice = $(this).find('.intentionModalText').text();
    $('#intention_intention').val(choice);
  })

});
