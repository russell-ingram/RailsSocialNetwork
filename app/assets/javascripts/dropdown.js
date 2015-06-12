$( document ).ready(function() {
  $( ".wrapper-dropdown" ).click(function() {
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
      console.log(option);
      selectedLabel.text(option);
      sortFilter(option);

    });

    $(".fieldOption").off().on('click', function () {
      var option = $(this).text();
      console.log(option);
      selectedLabel.text(option);
      var input = selectedLabel.parent().next();
      input.val(option);
      console.log(input);

    })

  });


  function sortFilter(type) {
    $.get('/admin/get_users/'+type, function(data) {
      $(".myConnsList").empty();
      for (i in data) {
        var user = data[i];
        var pic = '';
        if (user.profile_pic_url) {
          // console.log(user.profile_pic_url);
          pic = '<img src="'+user.profile_pic_url.url+'">';
        };
        var connBox = '<div class="myConnection"><div class="myConnWrapper"><div class="myConnProfilePic"><a href="/profile/'+user.id+'">'+pic+'</a></div><div class="myConnInfo"><div class="myConnName"><a href="/profile/'+user.id+'">'+user.first_name+' '+user.last_name+'</a></div><div class="myConnCompany">'+user.employer+'</div><div class="myConnIndustry">'+user.industry+'</div></div><div class="myConnMessage userActionsSidebar"><div class="userListAction"><a href="/admin/edit_user/'+user.id+'">review</a></div><div class="userListAction deleteAction"><a data-confirm="Are you sure you would like to delete this user?" href="/admin/delete/'+user.id+'">delete</a></div><div class="userListAction"><a href="/messages/new/'+user.id+'">send message</a></div></div></div></div>'
        $('.myConnsList').append(connBox);
      }
    })

  }


});
