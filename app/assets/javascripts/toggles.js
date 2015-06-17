$( document ).ready(function() {



  $(".replyButton").click(function() {
    $('.replyForm').addClass('active');
  });

  $(".callButton").click(function() {
    $('.columnLayout').removeClass('layoutOption3');
    $('.columnLayout').removeClass('layoutOption2');
    $('.columnLayout').removeClass('layoutOption1');


    if ($(this).is('#callButton3')) {

      $('.callCol').each(function() {
        $(this).removeClass('col-layout-1');
        $(this).removeClass('col-layout-2');
        $(this).addClass('col-layout-3');
        $(this).show();
      })
      // $('.columnTag').each(function() {
      //   $(this).removeClass('column-12');
      //   $(this).removeClass('column-6');
      //   $(this).show();
      //   $(this).addClass('column-4');
      // });
      // $('.columnLayout').addClass('layoutOption3');
      $('.hiddenLayoutOptionField').val('3');
    }
    else if ($(this).is('#callButton2')) {

      $('.callCol').each(function() {
        $(this).removeClass('col-layout-1');
        $(this).removeClass('col-layout-3');
        $(this).addClass('col-layout-2');
        $(this).show();
      })

      $('.col-opt-3').each(function(){
        $(this).hide();
      });
      // $('.columnTag').each(function() {
      //   $(this).removeClass('column-12');
      //   $(this).removeClass('column-4');
      //   $(this).show();
      //   $(this).addClass('column-6');
      // });
      // $('.columnLayout').addClass('layoutOption2');
      $('.hiddenLayoutOptionField').val('2');
      // $('.columnOption3').hide();
    }
    else {
      $('.callCol').each(function() {
        $(this).removeClass('col-layout-3');
        $(this).removeClass('col-layout-2');
        $(this).addClass('col-layout-1');
      });

      $('.col-opt-2').each(function() {
        $(this).hide();
      });
      $('.col-opt-3').each(function(){
        $(this).hide();
      });
      // $('.columnTag').each(function() {
      //   $(this).removeClass('column-6');
      //   $(this).removeClass('column-4');
      //   $(this).show();
      //   $(this).addClass('column-12');
      // });
      // $('.columnLayout').addClass('layoutOption1');
      $('.hiddenLayoutOptionField').val('1');
      // $('.columnOption2').hide();
      // $('.columnOption3').hide();
    }

  })


  $('#pubButton1').click(function() {
    $("#radio1").prop("checked", true);
    $("#radio1").val(true);

    var unchecked = $('#radio2');
    unchecked.prop("checked", false);
    unchecked.val(false);
  });

  $('#pubButton2').click(function() {
    $("#radio2").prop("checked", true);
    $("#radio1").val(true);

    var unchecked = $('#radio1');
    unchecked.prop("checked", false);
    unchecked.val(false);
  });


  $('#callButton1').click(function() {
    $("#radio1").prop("checked", true);
    $("#radio1").val(true);


    $('#radio2').prop("checked", false);
    $('#radio2').val(false);
    $('#radio3').prop("checked", false);
    $('#radio3').val(false);
  });

  $('#callButton2').click(function() {
    $("#radio2").prop("checked", true);
    $("#radio2").val(true);

    $('#radio1').prop("checked", false);
    $('#radio1').val(false);
    $('#radio3').prop("checked", false);
    $('#radio3').val(false);
  });

  $('#callButton3').click(function() {
    $("#radio3").prop("checked", true);
    $("#radio3").val(true);

    $('#radio1').prop("checked", false);
    $('#radio1').val(false);
    $('#radio2').prop("checked", false);
    $('#radio2').val(false);
  });

  $('#sendAllButton').click(function() {
    if ($('#radioSendAll').is(':checked')) {
      $("#radioSendAll").prop("checked", false);
      $('.recipientsGroup').css("display","inline-block");
      $('.messageReplySingle').hide();
      $('#recipients_id').val('all');
    } else {
      $("#radioSendAll").prop("checked", true);
      $('.recipientsGroup').hide();
      $('.messageReplySingle').show();
      $('#recipients_id').val('');
    }

  });




});
