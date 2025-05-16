$(document).ready(function() {
  var $srcbox = $("#side-menu");
  var $srctxt = $srcbox.find(".side-menu-search-txt");
  var $sidemenu =  $srcbox.find(".side-menu");
  
  function _activateSearch() {
    $srcbox.attr("data-status", "focused");
    $srctxt.val("").focus();
  }
  
  function _deactivateSearch(immediate) {
    /* 
    If you click a menu link, it will trigger the onblur on the text field, causing the menu to return to normal state, and causing the click on the link to fail.
    Doing a "setTimeout" will prevent this wrong behaviour
    */
    setTimeout(function() {
      $srcbox.attr("data-status", "normal");
      $srcbox.removeClass("search-mode");
    }, (immediate === true) ? 0 : 200);
  }
  
  $srcbox.find(".side-menu-search-normal").click(_activateSearch);
  $srctxt.blur(_deactivateSearch);

  $srctxt.keydown(function(e) {
    if (e.keyCode == KEY_ESC)
      _deactivateSearch(true);
  });
  
  $srctxt.keyup(function(e) {
    var text = $(this).val().trim();
    $srcbox.setClass("search-mode", (text.length > 0));
    if (text.length > 0) {
      var words = $(this).val().split(" ");
      for (var i=0; i<words.length; i++)
        words[i] = words[i].trim().toLowerCase();
      
      function _match($li) {
        var alias = $li.find("a").first().find(".ab-label").text();
        if ((alias == undefined) || (alias == null) || (alias == ""))
          return false;
        alias = alias.toLowerCase();
        for (var i=0; i<words.length; i++)
          if ((words[i] != "") && (alias.indexOf(words[i]) < 0))
            return false;
        return true;
      }

      var $lis = $sidemenu.find("li").removeClass("search-match").find("ul li");
      $lis.each(function(index, elem) {
        var $li = $(elem);
        $li.setClass("search-match", _match($li));
      });
      
      var $match = $lis.filter(".search-match");
      $match.parents("li").addClass("search-match");
      $match.find("li").addClass("search-match");
    }
  });

  $(window).keydown(function(e) {
    if (e.keyCode == KEY_F3) {
      e.preventDefault();
      e.stopPropagation();
      _activateSearch();
    }
  });
  
  $(document).on("click", "#adminnavbar li", function() {
    $("#adminnavbar li").addClass("collapsed").removeClass("expanded");
    $(this).closest("li").removeClass("collapsed").addClass("expanded");
  });

});
