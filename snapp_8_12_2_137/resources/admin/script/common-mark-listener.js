$(document).ready(function() {
  const CLASSNAME = "common-mark";
  const INITIALIZED = "common-mark-initialized"; 
  const reader = new commonmark.Parser();
  const writer = new commonmark.HtmlRenderer();
  
  jQuery.fn.commonMark = function(plainText) {
    var parsedText = writer.render(reader.parse(plainText)); 
    $(this).html(parsedText);
  };

  snpObserver.registerListener(CLASSNAME, INITIALIZED, function($node) {
    var plainText = $node.attr("data-rawtext");
    if (plainText) {
      var parsedText = writer.render(reader.parse(plainText)); 
      $node.html(parsedText);
      $node.addClass("common-mark-initialized");
    }
  });
});
