$( document ).ready(function() {

  $('.addPastPosition').click(function(){
    $('.pastExperienceFormBox').append("<div class=\"formBoxField\"><div class=\"formBoxRow\"><div class=\"field field-col-2\"><input placeholder=\"Title\" type=\"text\" name=\"past_emp[title]\" id=\"past_emp_title\"></div><div class=\"field field-col-2\"><input placeholder=\"Company\" type=\"text\" name=\"past_emp[company]\" id=\"past_emp_company\"></div><div class=\"pastEmpDates pubLabel\"><div class=\"pastEmpDateLabel\">Start date</div><div class=\"field pastEmpDateBox\"><input placeholder=\"MM/YYYY\" type=\"text\" name=\"past_emp[start_date]\" id=\"past_emp_start_date\"></div><div class=\"pastEmpDateLabel\">End date</div><div class=\"field pastEmpDateBox\"><input placeholder=\"MM/YYYY\" type=\"text\" name=\"past_emp[end_date]\" id=\"past_emp_end_date\"></div></div><div class=\"pastEmpDescriptionBox field-area field-summary\"><textarea name=\"past_emp[description]\" placeholder=\"Description\"></textarea></div></div></div>");
  });

  $('.cmsImageUpload').click(function() {
    console.log('clicked');
    $('.customFileInput').trigger('click');
    $('.customFileInput').change(function(){
      console.log('this');
      readURL(this,'cms');
    });

  })

  $('#editPhotoUpload').click(function() {
    console.log('clicked');
    $('.customFileInput').trigger('click');
    $('.customFileInput').change(function(){
      console.log('this');
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

});
