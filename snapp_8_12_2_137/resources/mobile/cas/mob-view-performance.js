UIMob.init("performance", function($view, params) {
  
  var $body = $view.find(".tab-body");
  
  BLCart.initCartDisplay($view.find(".cartdisplay-container"));
  loadPerfRecap();
  loadPerfProducts();
  
  function loadPerfRecap() {
    snpAPI("Performance", "Search",  {
      "PerformanceId": params.PerformanceId
    })
    .then(function(ansDO) {
      var list = (ansDO.PerformanceList || []);
      var perf = (list.length > 0) ? list[0] : {};
      $view.find(".header-event-name").text(perf.EventName);
      $view.find(".header-perfdatetime").text(formatShortDateTimeFromXML(perf.DateTimeFrom));
    });
  }

  function loadPerfProducts() {
    var $spinner = UIMob.createSpinnerClone().appendTo($body);
    snpAPI("Performance", "GetSellableProducts", {
      "PerformanceId": params.PerformanceId,
      "CatalogId": params.EventCatalogId,
      "ShopCartId": shopCart.ShopCartId
    })
    .finally(function() {
      $spinner.remove();
    })
    .then(function(ansDO) {
      var list = (ansDO.ProductList || []);
      renderProductList(list);
      // TODO: render prod families
    });
  }

  function renderProductList(list) {
    for (var i=0; i<list.length; i++) {
      var prod = list[i];
      var $btn = BLCatalog.createProdTypeButton({
        "ProductId": prod.ProductId,
        "ProductName": prod.ProductName,
        "Price": prod.Price,
        "BackgroundColor": prod.BackgroundColor,
        "ForegroundColor": prod.ForegroundColor,
        "ProfilePictureId": prod.ProfilePictureId,
        "PerformanceId": params.PerformanceId
      });
      
      $body.append($btn);
    }
  }
});
