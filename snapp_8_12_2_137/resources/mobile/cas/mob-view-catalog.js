UIMob.init("catalog", function($view, params) {
  var catnav = [];
  
  BLCart.initCartDisplay($view.find(".cartdisplay-container"));
  
  var $spinner = UIMob.createSpinnerClone().appendTo($view.find(".catalog-container"));
  snpAPI("Catalog", "GetChildNodes", {Recursive: true})
    .finally(function() {
      $spinner.remove();
    })
    .then(function(ansDO) {
      catnav.push(ansDO);
      renderCatalogNode(ansDO);
    });
  
  $view.find(".btn-toolbar-back").click(function() {
    if (catnav.length > 1) {
      catnav.pop();
      renderCatalogNode(catnav[catnav.length - 1]);
    }
  });
  
  function renderCatalogNode(node) {
    var $list = $("<div class='btn-catalog-list'/>").appendTo($view.find(".catalog-container").empty());
    $(node.Nodes).each(function(index, child) {
      var $btn = null;
      var params = {
        "CatalogName": child.CatalogName,
        "ButtonDisplayType": child.ButtonDisplayType,
        "ProfilePictureId": child.ProfilePictureId,
        "BackgroundColor": child.BackgroundColor,
        "ForegroundColor": child.ForegroundColor
      };
      
      if ((child.CatalogType == LkSN.CatalogType.Catalog.code) || (child.CatalogType == LkSN.CatalogType.Folder.code)) {
        $btn = BLCatalog.createFolderButton(params);
        $btn.data("node", child);
        $btn.click(function() {
          var node = $(this).data("node");
          catnav.push(node);
          renderCatalogNode(node);
        });
      }
      else if (child.CatalogType == LkSN.CatalogType.Entity.code) {
        if (child.EntityType == LkSN.EntityType.ProductType.code) {
          params.ProductId = child.EntityId;
          params.Price = child.Price;
          $btn = BLCatalog.createProdTypeButton(params);
        }
        else if (child.EntityType == LkSN.EntityType.Event.code) {
          params.EventId = child.EntityId;
          $btn = BLCatalog.createEventButton(params);
          $btn.data("node", child);
          $btn.click(function() {
            var node = $(this).data("node");
            catnav.push(node);
            renderEventNode(node);
          });
        }
      }
      
      if ($btn)
        $list.append($btn);
      else 
        console.error("Unable to find proper button implementation for CatalogType='" + getLookupDesc(LkSN.CatalogType, child.CatalogType) + "' and EntityType='" + getLookupDesc(LkSN.EntityType, child.EntityType) + "'");
    }); 
    
    renderBreadCrumbs();
    
    return $list;
  }
  
  function renderEventNode(node) {
    UIMob.tabSlideView({
      container: $view.closest(".tab-content"),
      packageName: PKG_CAS, 
      viewName: "event",
      params: {
        "EventId": node.EntityId,
        "RootCatalogId": null,
        "EventCatalogId": node.CatalogId
      }
    });
  }
  
  function renderBreadCrumbs() {
    var $container = $view.find(".breadcrumb-container").empty();
    for (var i=0; i<catnav.length; i++) {
      var $item = $view.find(".templates .breadcrumb-item").clone().appendTo($container);
      $item.find(".breadcrumb-caption").text((i == 0) ? itl("@Common.Home") : catnav[i].CatalogName);
      
      $item.click(function() {
        var index = $(this).index();
        var node = catnav[index];
        catnav = catnav.slice(0, index + 1);
        renderCatalogNode(node);
      });
    }
  }

});
