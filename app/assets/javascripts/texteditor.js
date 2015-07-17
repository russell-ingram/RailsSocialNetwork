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

    quill.on('text-change',function(delta, source) {
      if (source == 'api') {
        return;
      }
      ta.val(quill.getHTML());
      console.log(ta.val());
    });

    quill.on('selection-change', function(range) {
      if (!range) {
        $("#toolbar").hide();
      } else {
        $("#toolbar").show();
      }

    });

  }



  if ($('#editorCol1').length) {

    var quill2 = new Quill('#editorCol1', configs);
    var ta2 = $('#taCol1');
    quill2.addModule('toolbar', {container: '#toolbarCol1'});

    quill2.on('text-change',function(delta, source) {
      if (source == 'api') {
        return;
      }
      ta2.val(quill2.getHTML());
      console.log(ta2.val());
    });

    quill2.on('selection-change', function(range) {
      if (!range) {
        $("#toolbarCol1").hide();
      } else {
        $("#toolbarCol1").show();
      }

    });

  }


  if ($('#editorCol2').length) {

    var quill3 = new Quill('#editorCol2', configs);
    var ta3 = $('#taCol2');
    quill3.addModule('toolbar', {container: '#toolbarCol2'});

    quill3.on('text-change',function(delta, source) {
      if (source == 'api') {
        return;
      }
      ta3.val(quill3.getHTML());
      console.log(ta3.val());
    });

    quill3.on('selection-change', function(range) {
      if (!range) {
        $("#toolbarCol2").hide();
      } else {
        $("#toolbarCol2").show();
      }

    });

  }


  if ($('#editorCol3').length) {

    var quill4 = new Quill('#editorCol3', configs);
    var ta4 = $('#taCol3');
    quill4.addModule('toolbar', {container: '#toolbarCol3'});

    quill4.on('text-change',function(delta, source) {
      if (source == 'api') {
        return;
      }
      ta4.val(quill4.getHTML());
      console.log(ta4.val());
    });

    quill4.on('selection-change', function(range) {
      if (!range) {
        $("#toolbarCol3").hide();
      } else {
        $("#toolbarCol3").show();
      }

    });

  }





});
