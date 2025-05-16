$(document).ready(function() {
  
  snpAPI("Login", "GetMobileLicenses")
    .finally(function() {
      $("#select-license-main .tab-body").removeClass("waiting");
    })
    .then(function(ansDO) {
      var list = ansDO.LicenseList;
      if ((list) && (list.length > 0)) {
        var $container = $("#select-license-pref"); 
        $container.removeClass("hidden");
        
        for (var i=0; i<list.length; i++) {
          var item = list[i];
          var $item = $("#common-templates .pref-item").clone().appendTo($container.find(".pref-item-list"));
          $item.addClass("pref-item-arrow");
          $item.attr("data-appnames", item.AppNames);
          $item.find(".pref-item-caption").text(item.Caption);
          $item.find(".pref-item-value").text(item.AvailableCount);
          
          $item.on(MOUSE_DOWN_EVENT, function() {
            selectedAppNames = $(this).attr("data-appnames");
            UIMob.showView(PKG_COMMON, "select-workstation");
          })
        }
      }
      else 
        $("#select-license-error").removeClass("hidden");
    })
    .catch(function(error) {
      $("#select-license-error").removeClass("hidden").text(error.message);
    });
});
