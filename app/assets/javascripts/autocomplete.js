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
            console.log(ui.item.user_id);
            return ui.item.user_id;
          }
          else {

            return v + "," + ui.item.user_id;
          }

        });
        console.log($('.newMsgFormControlHidden').val());
        tagitTag();
        return false
      }
    },
    removeConfirmation: true,
    caseSensitve: false,
    allowSpaces: true,
    placeholderText: 'To:'
  });


  function tagitTag () {
    console.log("TAGGED IT");

    $('#recipients').tagit({
      autocomplete: {
       source: $('#recipients').data('autocomplete-source'),
        autoFocus: true,
        minLength: 3,
        select: function(e, ui) {
          ($(this).val(ui.item.value))
          console.log('hello');

          return false
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
