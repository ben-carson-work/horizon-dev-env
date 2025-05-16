$(document).ready(function() {
  "use strict";

  $(document).on("view-create", ".apt-view[data-view='special-product']", _onViewCreate);
  
  function _onViewCreate() {
    var $view = $(this);
    var $apt = $view.closest(".apt");
    var apt = $apt.data("apt") || {};
    var status = $apt.data("status") || {};
    var valres = status.LastValidateResult || {};

    ACM.addClickHandler($view.find(".apt-tool-close"), _onToolClick_Close);

    
    var $lineTemplate = $view.find(".templates .apt-line-product");
    var $list = $view.find(".apt-left-container");
    $list.empty();
    $(apt.SpecialProductList).each(function(index, product) {
      var $line = $lineTemplate.clone().appendTo($list);
      $line.data("product", product);
      $line.click(_onProductClick);
      $line.text("[" + product.ProductCode + "] " + product.ProductName);
    });
  }

  function _onProductClick() {
    var $product = $(this);
    var $apt = $product.closest(".apt");
    ACM.useSpecialProduct($apt, $product.data("product"), function() {
      ACM.setActiveView($apt, "main");
    });
  }
  
  function _onToolClick_Close(event, ui) {
    ACM.setActiveView(ui.$apt, "main");
  }
});