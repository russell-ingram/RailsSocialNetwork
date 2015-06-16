$( document ).ready(function() {

  $('.addPastPosition').click(function(){
    $('.pastExperienceFormBox').append("<div class=\"formBoxField\"><div class=\"formBoxRow\"><div class=\"field field-col-2\"><input placeholder=\"Title\" type=\"text\" name=\"past_emp[title]\" id=\"past_emp_title\"></div><div class=\"field field-col-2\"><input placeholder=\"Company\" type=\"text\" name=\"past_emp[company]\" id=\"past_emp_company\"></div><div class=\"pastEmpDates pubLabel\"><div class=\"pastEmpDateLabel\">Start date</div><div class=\"field pastEmpDateBox\"><input placeholder=\"MM/YYYY\" type=\"text\" name=\"past_emp[start_date]\" id=\"past_emp_start_date\"></div><div class=\"pastEmpDateLabel\">End date</div><div class=\"field pastEmpDateBox\"><input placeholder=\"MM/YYYY\" type=\"text\" name=\"past_emp[end_date]\" id=\"past_emp_end_date\"></div></div><div class=\"pastEmpDescriptionBox field-area field-summary\"><textarea name=\"past_emp[description]\" placeholder=\"Description\"></textarea></div></div></div>");
  });

  $('.cmsImageUpload').click(function() {
    $('.customFileInput').trigger('click');
    $('.customFileInput').change(function(){
      readURL(this,'cms');
    });

  })

  $('#editPhotoUpload').click(function() {
    console.log('clicked');
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
          console.log(user.profile_pic_url);
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
  })


});
