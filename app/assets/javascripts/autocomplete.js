$( document ).ready(function() {

  $('#recipients').tagit({
    autocomplete: {
      source: $('#recipients').data('autocomplete-source'),
      autoFocus: true,
      minLength: 3,
      select: function(e, ui) {
        $(this).val(ui.item.value)
        $('.newMsgFormControlHidden').val(function(i,v) {

          if (v === "") {
            return ui.item.user_id;
          }
          else {

            return v + "," + ui.item.user_id;
          }

        });
        $(".ui-autocomplete-input").removeAttr('placeholder');
        tagitTag();
        return false
      }
    },
    afterTagRemoved: function() {
      var l = $('#recipients').tagit("assignedTags");
      if (l.length === 0) {
        $(".ui-autocomplete-input").attr('placeholder', 'To:');

      }
    },
    removeConfirmation: true,
    caseSensitve: false,
    allowSpaces: true,
    placeholderText: 'To:'
  });

  function tagitTag () {

    $('#recipients').tagit({
      autocomplete: {
       source: $('#recipients').data('autocomplete-source'),
        autoFocus: true,
        minLength: 3,
        select: function(e, ui) {
          ($(this).val(ui.item.value))
          $(".ui-autocomplete-input").removeAtrr('placeholder');
          return false
        }
      },
      afterTagRemoved: function() {
        var l = $('#recipients').tagit("assignedTags");
        if (l.length === 0) {
          $(".ui-autocomplete-input").attr('placeholder', 'To:');

        }
      },
      allowSpaces: false,
      removeConfirmation: true,
      caseSensitve: false,
      placeholderText: "To:"
    });
  }


  $('#admin_recipients').tagit({
    autocomplete: {
     source: $('#admin_recipients').data('autocomplete-source'),
      autoFocus: true,
      minLength: 3,
      select: function(e, ui) {
        ($(this).val(ui.item.value))
        $('.newMsgFormControlHidden').val(function(i,v) {

          if (v === "") {
            return ui.item.user_id;
          }
          else {

            return v + "," + ui.item.user_id;
          }

        });
        $(".ui-autocomplete-input").removeAttr('placeholder');
        tagitTagAll();
        return false
      }
    },
    afterTagRemoved: function() {
      var l = $('#admin_recipients').tagit("assignedTags");
      if (l.length === 0) {
        $(".ui-autocomplete-input").attr('placeholder', 'To:');

      }
    },
    removeConfirmation: true,
    caseSensitve: false,
    allowSpaces: true,
    placeholderText: 'To:'
  });

  function tagitTagAll () {

    $('#admin_recipients').tagit({
      autocomplete: {
       source: $('#admin_recipients').data('autocomplete-source'),
        autoFocus: true,
        minLength: 3,
        select: function(e, ui) {

          return false
        }
      },
      afterTagRemoved: function() {
        var l = $('#admin_recipients').tagit("assignedTags");
        if (l.length === 0) {
          $(".ui-autocomplete-input").attr('placeholder', 'To:');

        }
      },
      allowSpaces: false,
      removeConfirmation: true,
      caseSensitve: false,
      placeholderText: null
    });
  }


  $('#searchUsersInput').autocomplete({
    source: '/admin/users/autocomplete',
    autoFocus: true,
    minLength: 3,
    select: function(e, ui) {
      ($(this).val(ui.item.value));
      $('#searchUsersButton').click();
      return false;
    }
  })

})
