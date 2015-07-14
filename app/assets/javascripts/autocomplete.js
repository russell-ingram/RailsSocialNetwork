$( document ).ready(function() {

  // $('#recipients').autocomplete({
  //   source: $('#recipients').data('autocomplete-source'),
  //   autoFocus: true,
  //   select: function(e, ui) {
  //     ($(this).val(ui.item.value))
  //     $('.newMsgFormControlHidden').val(ui.item.user_id);
  //     console.log($('.newMsgFormControlHidden').val())
  //     return false
  //   }
  // });


  $('#recipients').tagit({
    autocomplete: {
      source: $('#recipients').data('autocomplete-source'),
      autoFocus: true,
      minLength: 3,
      select: function(e, ui) {
        ($(this).val(ui.item.value))
        $('.newMsgFormControlHidden').val(function(i,v) {

          if (v === "") {
            // console.log(ui.item.user_id);
            return ui.item.user_id;
          }
          else {

            return v + "," + ui.item.user_id;
          }

        });
        // console.log($('.newMsgFormControlHidden').val());
        $(".ui-autocomplete-input").removeAttr('placeholder');
        tagitTag();
        return false
      }
    },
    beforeTagAdded: function (e, ui) {
      console.log(ui);
      console.log(e);
    },
    removeConfirmation: true,
    caseSensitve: false,
    allowSpaces: true,
    placeholderText: 'To:'
  });

  function tagitTag () {
    // console.log("TAGGED IT");

    $('#recipients').tagit({
      autocomplete: {
       source: $('#recipients').data('autocomplete-source'),
        autoFocus: true,
        minLength: 3,
        select: function(e, ui) {
          ($(this).val(ui.item.value))
          console.log('hello');
          $(".ui-autocomplete-input").removeAtrr('placeholder');
          return false
        }
      },
      allowSpaces: false,
      removeConfirmation: true,
      caseSensitve: false,
      placeholderText: ""
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
            console.log(ui.item.user_id);
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
    removeConfirmation: true,
    caseSensitve: false,
    allowSpaces: true,
    placeholderText: 'To:'
  });

  function tagitTagAll () {
    console.log("TAGGED IT");

    $('#admin_recipients').tagit({
      autocomplete: {
       source: $('#admin_recipients').data('autocomplete-source'),
        autoFocus: true,
        minLength: 3,
        select: function(e, ui) {
          // ($(this).val(ui.item.value))
          // console.log('hello');

          return false
        },
      },
      beforeTagAdded: function (e, ui) {
        console.log()
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

  // var stuff = [
  //   'Russ', 'Max', 'Jeremy'
  // ]

  // $('#recipients').devbridgeAutocomplete({
  //   serviceUrl: '/recipients',
  //   minChars: 3,
  //   autoSelectFirst: true,
  //   showNoSuggestionNotice: "No results found!"

  // })

})
