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
      $('.checkBoxIcon').removeClass('icon-selection-true');
      $('.checkBoxIcon').addClass('icon-selection-false');
      $('.checkBoxIcon').css("color","#cbd0d2");
      $('.tagit-choice-editable').each(function() {
        $(this).remove();
      })
    } else {
      $("#radioSendAll").prop("checked", true);
      $('.recipientsGroup').hide();
      $('.messageReplySingle').show();
      $('#recipients_id').val('');
      $('.checkBoxIcon').removeClass('icon-selection-false');
      $('.checkBoxIcon').addClass('icon-selection-true');
      $('.checkBoxIcon').css("color","#3eb2cc");
    }

  });

  $(".searchBarHomeAdvancedOptions").on('click', function() {
    var row = $('.homePageAdvancedRow');
    var icon = $('.searchBarHomeAdvancedOptions').children();
    if (row.hasClass('active')) {
      row.removeClass('active');
      icon.removeClass('icon-icon-close');
      icon.addClass('icon-icon-add');
    } else {
      row.addClass('active');
      icon.removeClass('icon-icon-add');
      icon.addClass('icon-icon-close');
    }

  })

  // $('.mailMenuIcon').click(function() {
  //   if ($('.mailMenuIcon').hasClass('active')) {
  //     $('.mailMenuIcon').removeClass('active');
  //     $('.mailMenuDrop').removeClass('active');
  //   } else {
  //     $('.mailMenuIcon').addClass('active');
  //     $('.mailMenuDrop').addClass('active');
  //   }
    // $('.mailMenuDrop').show();
  // })





});
