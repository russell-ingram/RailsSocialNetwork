$( document ).ready(function() {

  // Need to refactor these to make more efficient using THIS,etc.

  var configs = {
    readOnly: false,
    formats: ['bold', 'italic', 'underline']
  }

  if ($('#editor').length) {

    var quill = new Quill('#editor',configs);
    var ta = $('#textAreaEditor');
    quill.addModule('toolbar', { container: '#toolbar' });
    var colCount1 = $('#newsCharacterLimit');

    quill.on('text-change',function(delta, source) {
      if (source == 'api') {
        return;
      }
      ta.val(quill.getHTML());
      var text = quill.getText();
      var remaining = 400 - text.length;
      colCount1.text('Character count: ' + remaining);
      if (remaining < 0) {
        colCount1.css('color', 'red');
      } else {
        colCount1.css('color', '#767676');
      }
    });

    quill.on('selection-change', function(range) {
      if (!range) {
        $("#toolbar").hide();
        colCount1.hide();

      } else {
        $("#toolbar").show();
        var text = quill.getText();
        var remaining = 400 - text.length;
        colCount1.text('Character count: ' + remaining);
        colCount1.show();
      }

    });

  }



  if ($('#editorCol1').length) {

    var quill2 = new Quill('#editorCol1', configs);
    var ta2 = $('#taCol1');
    quill2.addModule('toolbar', {container: '#toolbarCol1'});
    var colCount2 = $('#columnOneContentCount');
    quill2.on('text-change',function(delta, source) {
      if (source == 'api') {
        return;
      }
      ta2.val(quill2.getHTML());

      var text = quill2.getText();
      var remaining = 400 - text.length;
      colCount2.text('Character count: ' + remaining);
      if (remaining < 0) {
        colCount2.css('color', 'red');
      } else {
        colCount2.css('color', '#767676');
      }
    });

    quill2.on('selection-change', function(range) {
      if (!range) {
        $("#toolbarCol1").hide();
        colCount2.hide();
      } else {
        $("#toolbarCol1").show();
        var text = quill2.getText();
        var remaining = 400 - text.length;
        colCount2.text('Character count: ' + remaining);
        colCount2.show();
      }

    });

  }


  if ($('#editorCol2').length) {

    var quill3 = new Quill('#editorCol2', configs);
    var ta3 = $('#taCol2');
    quill3.addModule('toolbar', {container: '#toolbarCol2'});
    var colCount3 = $('#columnTwoContentCount');
    quill3.on('text-change',function(delta, source) {
      if (source == 'api') {
        return;
      }
      ta3.val(quill3.getHTML());

      var text = quill3.getText();
      var remaining = 400 - text.length;
      colCount3.text('Character count: ' + remaining);
      if (remaining < 0) {
        colCount3.css('color', 'red');
      } else {
        colCount3.css('color', '#767676');
      }
    });

    quill3.on('selection-change', function(range) {
      if (!range) {
        $("#toolbarCol2").hide();
        colCount3.hide();
      } else {
        $("#toolbarCol2").show();
        var text = quill3.getText();
        var remaining = 400 - text.length;
        colCount3.text('Character count: ' + remaining);
        colCount3.show();
      }

    });

  }


  if ($('#editorCol3').length) {

    var quill4 = new Quill('#editorCol3', configs);
    var ta4 = $('#taCol3');
    var colCount4 = $('#columnThreeContentCount');

    quill4.addModule('toolbar', {container: '#toolbarCol3'});

    quill4.on('text-change',function(delta, source) {
      if (source == 'api') {
        return;
      }
      ta4.val(quill4.getHTML());
      var text = quill4.getText();
      var remaining = 400 - text.length;

      colCount4.text('Character count: ' + remaining);
      if (remaining < 0) {
        colCount4.css('color', 'red');
      } else {
        colCount4.css('color', '#767676');
      }
    });

    quill4.on('selection-change', function(range) {
      if (!range) {
        $("#toolbarCol3").hide();
        colCount4.hide();
      } else {
        $("#toolbarCol3").show();
        var text = quill4.getText();
        var remaining = 400 - text.length;
        colCount4.text('Character count: ' + remaining);
        colCount4.show();
      }

    });

  }





});
