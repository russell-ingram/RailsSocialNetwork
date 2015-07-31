$( document ).ready(function() {


  $(".replyButton").click(function() {
    $('.replyForm').addClass('active');
  });

  $(".callButton").click(function() {

    var myBtn = $(this);
    $(".callButton").each(function() {
      $(this).find('.pubBoxIcon').removeClass('icon-selection-true');
      $(this).find('.pubBoxIcon').addClass('icon-selection-false');
    });
    $(this).find('.pubBoxIcon').removeClass('icon-selection-false')
    $(this).find('.pubBoxIcon').addClass('icon-selection-true');
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
      $('.hiddenLayoutOptionField').val('2');
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


  $('.pubButton').click(function() {
    var radio = $(this).find('.pubInputCheck');
    var radio2;
    var input;
    if ($(this).is('#pubButton1')) {
      radio2 = $(this).next().find('.pubInputCheck');
      input = $(this).next().next();
      input.val("false");
    } else {
      radio2 = $(this).prev().find('.pubInputCheck');
      input = $(this).next();
      input.val("true");
    }


    radio.prop("checked", true);
    radio.val(true);
    radio.next().find('.pubBoxIcon').removeClass('icon-selection-false');
    radio.next().find('.pubBoxIcon').addClass('icon-selection-true');
    radio.next().find('.pubBoxIcon').addClass('active');
    radio2.next().find('.pubBoxIcon').removeClass('icon-selection-true');
    radio2.next().find('.pubBoxIcon').removeClass('active');
    radio2.next().find('.pubBoxIcon').addClass('icon-selection-false');

    var unchecked = $('#radio2');
    radio2.prop("checked", false);
    radio2.val(false);

  });

  // $('#pubButton2').click(function() {
  //   $("#radio2").prop("checked", true);
  //   $("#radio1").val(true);

  //   $("#radio2").next().find('.pubBoxIcon').removeClass('icon-selection-false');
  //   $("#radio2").next().find('.pubBoxIcon').addClass('icon-selection-true');
  //   $("#radio2").next().find('.pubBoxIcon').addClass('active');
  //   $("#radio1").next().find('.pubBoxIcon').removeClass('icon-selection-true');
  //   $("#radio1").next().find('.pubBoxIcon').removeClass('active');
  //   $("#radio1").next().find('.pubBoxIcon').addClass('icon-selection-false');

  //   var unchecked = $('#radio1');
  //   unchecked.prop("checked", false);
  //   unchecked.val(false);
  // });


  // $('#callButton1').click(function() {
  //   $("#radio1").prop("checked", true);
  //   $("#radio1").val(true);


  //   $('#radio2').prop("checked", false);
  //   $('#radio2').val(false);
  //   $('#radio3').prop("checked", false);
  //   $('#radio3').val(false);
  // });

  // $('#callButton2').click(function() {
  //   $("#radio2").prop("checked", true);
  //   $("#radio2").val(true);

  //   $('#radio1').prop("checked", false);
  //   $('#radio1').val(false);
  //   $('#radio3').prop("checked", false);
  //   $('#radio3').val(false);
  // });

  // $('#callButton3').click(function() {
  //   $("#radio3").prop("checked", true);
  //   $("#radio3").val(true);

  //   $('#radio1').prop("checked", false);
  //   $('#radio1').val(false);
  //   $('#radio2').prop("checked", false);
  //   $('#radio2').val(false);
  // });

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

  $('.currentPostButton').click(function() {
    var btn = $(this).find(".radioSendAll");
    var icon = $(this).find(".checkBoxIcon");
    if (btn.is(':checked')) {
      btn.prop("checked", false);
      icon.removeClass('icon-selection-true');
      icon.addClass('icon-selection-false');
      // icon.css("color","#cbd0d2");
      $(this).next().val('false');
    } else {
      btn.prop("checked", true);
      $('.checkBoxIcon').each(function() {
        if ($(this).hasClass('icon-selection-true')) {
          $(this).removeClass('icon-selection-true');
          $(this).addClass('icon-selection-false');
          // $(this).css("color","#cbd0d2");
          $(this).next().val('false');
        }
      })
      icon.removeClass('icon-selection-false');
      icon.addClass('icon-selection-true');
      // icon.css("color","#3eb2cc");
      $(this).next().val('true');
    }

  });



  $(".searchBarHomeAdvancedOptions").on('click', function() {
    var row = $('.homePageAdvancedRow');
    var icon = $('.searchBarHomeAdvancedOptions').children();
    if (row.hasClass('active')) {
      row.removeClass('active');
      icon.removeClass('icon-icon-dash');
      icon.addClass('icon-icon-add');
    } else {
      row.addClass('active');
      icon.removeClass('icon-icon-add');
      icon.addClass('icon-icon-dash');
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

  $(".profileTabLabel").off().on('click', function() {
    if ($(this).hasClass('infoTab')) {
      $('.profileInformationTab').addClass('active');
      $('.infoTab').addClass('active');
      $('.profileConnectionsTab').removeClass('active');
      $('.connTab').removeClass('active');
    } else {
      $('.profileInformationTab').removeClass('active');
      $('.infoTab').removeClass('active');
      $('.profileConnectionsTab').addClass('active');
      $('.connTab').addClass('active');
    }
  });

  $('.showAllMessages').off().on('click', function() {
    if ($('.showAllMessages').hasClass('active')) {
      $(this).removeClass('active');
      $(".sft").text('SHOW FULL THREAD');
      $('.hiddenReply').each(function() {
        $(this).removeClass('active');
      })
    } else {
      $(this).addClass('active');
      $(".sft").text('HIDE FULL THREAD');
      $('.hiddenReply').each(function() {
        $(this).addClass('active');
      })
    }
  });


  $('.menuIconOptions').off().on('click', function() {
    $('.logoutDrop').toggle();
    var icon = $('.menuIconOptions');
    if (icon.hasClass('active')) {
      icon.removeClass('active');
    } else {
      icon.addClass('active');
    }
  });

  $('.settingsDropItem').off().on('click', function() {
    $('.settingsDropWrapper').toggle();
  })

  $('.dropDivIcon').off().on('click', function() {
    var i = $(this)
    if (i.hasClass('icon-selection-true')) {
      i.removeClass('icon-selection-true');
      i.addClass('icon-selection-false');
    } else {
      i.addClass('icon-selection-true');
      i.removeClass('icon-selection-false');
    }
  })

  $('.profileConnected').hover(
    function() {
      $(this).addClass('profileDeleted');
      $(this).removeClass('profileConnected');
      var button = '<a href="#deleteUser" rel="modal:open">UNFRIEND</a>';
      $(this).html(button);
    },
    function() {
      $(this).removeClass('profileDeleted');
      $(this).addClass('profileConnected');
      $(this).html('CONNECTED');
    }
  );


});
