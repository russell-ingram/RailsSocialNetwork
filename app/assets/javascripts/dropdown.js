$( document ).ready(function() {

  $(document).on('click', function() {
    $('.wrapper-dropdown').removeClass('active');
    $('.wrapper-dropdown').find('.dropdown').removeClass('active');
  });

  var onDropDownClicked = function(event) {
    event.stopPropagation();
    if ($(this).hasClass('active')) {
      $('.wrapper-dropdown').removeClass('active');
      $('.wrapper-dropdown').trigger('deactivated');
    } else {
      $('.wrapper-dropdown').removeClass('active');
      $(this).addClass('active');
      $('.wrapper-dropdown').trigger('activated');
    }




    var selectedDrop = $(this).find('.dropdown');
    var selectedLabel = $(this).find('.ddLabel');
    if (selectedDrop.hasClass('active')) {
      $('.dropdown').removeClass('active');
    }
    else {
      $('.dropdown').removeClass('active');
      selectedDrop.addClass('active');
    }

    $(".filterOption").off().on('click',function() {
      var option = $(this).text();
      var shorter = '';
      var filterType = $(this).parent().parent().attr('name');
      selectedLabel.text(option);
      // sortFilter(option, filterType);

    });

    $(".fieldOption").off().on('click', function () {
      var option = $(this).text();
      l = 18;
      if ($(this).hasClass('resultsOption')) {
        l = 30;
      } else if ($(this).hasClass('bigOption')) {
        l = 22;
      }

      if (option.length > l) {
        shorter = option.slice(0,l);
        selectedLabel.text(shorter + '...');
      } else {
        selectedLabel.text(option);
      }
      var input = selectedLabel.parent().next();
      input.val(option);
      if (selectedLabel.hasClass('searchDDLabel') || selectedLabel.hasClass('ddNoPref')) {
        if (option === 'No preference') {
          selectedLabel.removeClass('active');
          input.val('');

        } else {
          selectedLabel.addClass('active');
        }
      }

    });

    if (selectedDrop.hasClass('searchDropdown')) {
      var top = $(this).parent().parent()
      if (top.hasClass('active')){
        top.removeClass('active');
      } else {
        $('.searchSideBarDropdown').removeClass('active');
        top.addClass('active');
      }

    }




  };

  $(document).on('click', ".wrapper-dropdown" , onDropDownClicked);
  $(document).on('click', ".searchSideBarDropdown" , function(event){
    onDropDownClicked.call($(this).find('.wrapper-dropdown'), event);
  });


  function sortFilter(type, filterType) {
    if (filterType === 'admin') {
      $.get('/admin/get_users/'+type, function(data) {
        $(".myConnsList").empty();
        for (i in data) {
          var user = data[i].user;
          var work = data[i].work;
          var pic = '';
          if (user.profile_pic_url.url) {
            pic = '<img src="'+user.profile_pic_url.url+'">';
          } else {
            var num = Math.floor(Math.random() * (10-1)+1);
            var pic = '<img src="/assets/avatar-icons/avatar_0' + num+'">';
          };
          var connBox = '<div class="myConnection"><div class="myConnWrapper"><div class="myConnProfilePic"><a href="/profile/'+user.id+'">'+pic+'</a></div><div class="myConnInfo"><div class="myConnName"><a href="/profile/'+user.id+'">'+user.first_name+' '+user.last_name+'</a></div><div class="myConnCompany">'+work.company+'</div><div class="myConnIndustry">'+work.job_title + ', '+work.industry+ ', '+ work.enterprise_size +'</div></div><div class="myConnMessage userActionsSidebar"><div class="userListAction"><a href="/admin/edit_user/'+user.id+'">review</a></div><div class="userListAction deleteAction"><a href="#ex'+i+'" rel="modal:open">DELETE</a></div><div class="userListAction"><a href="/messages/new/'+user.id+'">send message</a></div></div></div></div><div id="ex'+i+'" class="addIntentionModal" style="display:none;"><div class="formBox searchFormBox formBoxModal confirmModalBox"><div class="formHeader">CONFIRM DELETE</div><div class="modalBody"><div class="modalIntentions"><div class="myConnProfilePic"><a href="/profile/'+user.id+'">'+pic+'</a></div></div><div class="modalIntentionsRight"><div class="deleteUserModalInfo">Are you sure you would like to delete '+user.first_name + ' ' + user.last_name +'?</div><div class="modalDoneButton"><a href="/admin/delete/'+user.id+'">Confirm</a></div></div></div></div></div>';
          $('.myConnsList').append(connBox);
        }
      });
    } else if (filterType === 'connection') {
      $.get('/connections/all/' +type, function(data) {
        $('.connsRefillableWrapper').empty();
        for (i in data) {
          var user = data[i].user;
          var work = data[i].work;
          var pic = '';
          if (user.profile_pic_url.url) {
            pic = '<img src="'+user.profile_pic_url.url+'">';
          } else {
            var num = Math.floor(Math.random() * (10-1)+1);
            var pic = '<img src="/assets/avatar-icons/avatar_0' + num+'">';
          };
          var connBox = '<div class="myConnection"><div class="myConnWrapper"><div class="myConnProfilePic"><a href="/profile/'+user.id+'">'+pic+'</a></div><div class="myConnInfo"><div class="myConnName"><a href="/profile/'+user.id+'">' + user.first_name + ' ' + user.last_name +'</a></div><div class="myConnCompany">'+work.company+'</div><div class="myConnIndustry">'+work.job_title+', '+work.industry+', '+work.enterprise_size+'</div></div><div class="myConnMessage"><a href="/messages/new/'+user.id+'">MESSAGE<div class="icon icon-fwd-arrow"></div></a></div></div></div>';
          $('.connsRefillableWrapper').append(connBox);






        }


      });
    } else if (filterType === "message") {

    }


  }

  function msgFilter(type) {

  }


  $(document).on('click', '#messageToggle a',function() {
    $.get(this.href, null, null, 'script');

    return false;
  });


  $(document).on('click', ".searchMultiselectDropdown" , function(event) {
      event.stopPropagation();
  });
  $(document).on('click', ".searchMultiselectDropdownResult" , function(event) {
      event.stopPropagation();
  });


});


