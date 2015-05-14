$( document ).ready(function() {

  $(".replyButton").click(function() {
    $('.replyForm').addClass('active');
  });

  $(".homepageLayoutImage").click(function() {
    $('.columnLayout').removeClass('layoutOption3');
    $('.columnLayout').removeClass('layoutOption2');
    $('.columnLayout').removeClass('layoutOption1');


    if ($(this).hasClass('layoutType3')) {
      $('.columnTag').each(function() {
        $(this).removeClass('column-12');
        $(this).removeClass('column-6');
        $(this).show();
        $(this).addClass('column-4');
      });
      $('.columnLayout').addClass('layoutOption3');
      $('.hiddenLayoutOptionField').val('3');
    }
    else if ($(this).hasClass('layoutType2')) {
      $('.columnTag').each(function() {
        $(this).removeClass('column-12');
        $(this).removeClass('column-4');
        $(this).show();
        $(this).addClass('column-6');
      });
      $('.columnLayout').addClass('layoutOption2');
      $('.hiddenLayoutOptionField').val('2');
      $('.columnOption3').hide();
    }
    else {
      $('.columnTag').each(function() {
        $(this).removeClass('column-6');
        $(this).removeClass('column-4');
        $(this).show();
        $(this).addClass('column-12');
      });
      $('.columnLayout').addClass('layoutOption1');
      $('.hiddenLayoutOptionField').val('1');
      $('.columnOption2').hide();
      $('.columnOption3').hide();
    }

  })



});
