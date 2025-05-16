//# sourceURL=mob-dlg-datetime.js

$(document).ready(function() {
  window.UIMob.showDateTimePicker = showDateTimePicker; 
  
  /**
   * params = {
   *   Date: boolean,
   *   Time: boolean
   * }
   * 
   * Return XML format
   */
  function showDateTimePicker(params, callback) {
    params = (params || {});

    var $dlg = $("#common-templates .dlg-datetime").clone();
    
    var $days = $dlg.find(".dtpick-day");
    var $months = $dlg.find(".dtpick-month");
    var $years = $dlg.find(".dtpick-year");
    var $hours = $dlg.find(".dtpick-hour");
    var $minutes = $dlg.find(".dtpick-minute");
    
    for (var i=1; i<=31; i++) 
      $("<div class='dtpick-item'/>").appendTo($days).text(i);
    
    for (var i=1; i<=12; i++) 
      $("<div class='dtpick-item'/>").appendTo($months).text(fmtDateMonths[i - 1]);
    
    for (var i=1900; i<=2100; i++) 
      $("<div class='dtpick-item'/>").appendTo($years).text(i);
    
    for (var i=0; i<=23; i++) 
      $("<div class='dtpick-item'/>").appendTo($hours).text(i);
    
    for (var i=0; i<=59; i++) 
      $("<div class='dtpick-item'/>").appendTo($minutes).text(i);
    
    var $firstItem = $dlg.find(".dtpick-item").first();
    
    var ts = 0;
    function snap($list, localts) {
      console.log(localts + " / " + ts);
      if (ts == localts) {
        var h = $firstItem.outerHeight();
        var s = $list.scrollTop();
        var dirt = (s % h);
        if (dirt != 0) {
          if (dirt < (h / 2))
            dirt *= -1;
          $list.scrollTop(s + dirt);
        }
      }
    }

    $dlg.find(".dtpick-list").scroll(function(e) {
      var $list = $(this);
      var localts = (new Date()).getTime();
      ts = localts;
      setTimeout(function() {
        snap($list, localts);
      }, 1000);
    });
    
    
    UIMob.showDialog($dlg);
  }

});
