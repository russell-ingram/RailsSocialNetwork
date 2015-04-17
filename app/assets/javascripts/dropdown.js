$( document ).ready(function() {
  $( ".wrapper-dropdown" ).click(function() {
    var selectedDrop = $(this).find('.dropdown');

    if (selectedDrop.hasClass('active')) {
      $('.dropdown').removeClass('active');
    }
    else {
      $('.dropdown').removeClass('active');
      selectedDrop.addClass('active');
    }
  });
});
