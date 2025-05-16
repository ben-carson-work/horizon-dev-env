class StepRecapController extends StepController {
  constructor() {
    super();
    
    $("#step-recap .kiosk-header-title").attr("data-itl", "@StepRecap.Title");
    $("#step-recap .kiosk-header-subtitle").attr("data-itl", "@StepRecap.Subtitle");
    $(document).on("kiosk-shopcart-change", () => this._onShopCartChange());
  }
  
  activate() {
    super.activate();
    this.$ui.removeClass("has-addons");
    this._renderRecap(KIOSK_CONTROLLER.shopCart);

    KIOSK_CONTROLLER.apiShopCart("GetUpsellOptions").then(ansDO => {
      let options = (ansDO.UpsellOptions || {}).CartAddOnList || [];
      this._renderUpsellCartOptions(options);
    });
  }
    
  updateDisplayButtons() {
    super.updateDisplayButtons();
    
    let backText = KIOSK_UI_CONTROLLER.itl("@StepRecap.BackButtonCaption");
    if (this._isUpgradeOrPerformanceTransaction(KIOSK_CONTROLLER.shopCart?.Transaction?.TransactionType)) {
      backText = KIOSK_UI_CONTROLLER.itl("@StepRecap.BackButtonPerfCaption");
    }
    this.displayController.$back.text(backText);
    
    this.displayController.$next.text(KIOSK_UI_CONTROLLER.itl("@StepRecap.NextButtonCaption"));
  }
  
  backClick() {
    const transactionType = KIOSK_CONTROLLER.shopCart?.Transaction?.TransactionType
    
    if (this._isUpgradeOrPerformanceTransaction(transactionType)) {
      KIOSK_CONTROLLER.apiShopCart("EmptyShopCart")
        .then(() => this.transactionController.jumpToStep("CHANGE-PERFORMANCE"));
    }
    else
      this.transactionController.stepBack();
  }
  
  _isUpgradeOrPerformanceTransaction(transactionType) {
    return [16, 51].includes(transactionType);
  }

  _renderRecap(shopCart) {
    let $container = this.$ui.find("#recap-items").empty();
    const transactionType = shopCart.Transaction.TransactionType;

    for (const item of shopCart.Items || []) {
      this._renderRecapItem($container, item, transactionType);
    }
  }

  _renderRecapItem($container, item, transactionType) {
    item.PerformamceList = item.PerformanceList || [];
    const itemModel = {
      "shopCartItem": item,
      "productId": item.ProductId,
      "performanceId": (item.PerformamceList.length == 0) ? null : item.PerformamceList[0].PerformanceId,
      "title": item.ProductName,
      "subtitle": this._getPerformanceDesc(item),
      "unitAmount": item.UnitAmount,
      "totalAmount": item.TotalAmount,
      "quantity": item.Quantity
    };

    const allowQtyChange = !this._isUpgradeOrPerformanceTransaction(transactionType);

    const $item = this._addItemUI($container, itemModel, allowQtyChange);

    if (item.Items) {
    const $subitem = $item.find(".recap-subitem");
    for (const subItem of item.Items || [])
      this._renderRecapItem($subitem, subItem, transactionType);
    }
    
  }
  
  _getPerformanceDesc(item) {
    let list = item.PerformanceList || [];
    let perf = (list.length <= 0) ? null : list[0];
    if (perf == null)
      return "";
    else 
      return perf.EventName + " - " + formatDate(perf.DateTimeFrom) + " " + formatTime(perf.DateTimeFrom); 
  }
  
  _renderUpsellCartOptions(options) {
    let $container = this.$ui.find("#addon-items").empty();
    this.$ui.setClass("has-addons", options.length > 0);
    
    for (const option of options) {
      let item = this._findShopCartItem(KIOSK_CONTROLLER.shopCart.Items, option.TargetProduct.ProductId, option.Price);
      if (item == null) {
        this._addItemUI($container, {
          "productId": option.TargetProduct.ProductId,
          "title": option.TargetProduct.ProductName,
          "unitAmount": option.Price,
          "totalAmount": 0,
          "quantity": 0
        }, true);
      }
    }
  }
  
  _addItemUI($container, model, allowQuantityChange=true) {
    let $item = $("#recap-templates .recap-item-line").clone();
    $item.data("model", model);
    $item.find(".recap-item-title").text(model.title);
    $item.find(".recap-item-subtitle").text(model.subtitle);
    $item.find(".recap-item-quantity-value").text(model.quantity);
    $item.find(".recap-item-unitamount-value").text(formatCurr(model.unitAmount));
    $item.find(".recap-item-totalamount-value").text(formatCurr(model.totalAmount));
    
    if (allowQuantityChange) {
      $item.find(".qty-plus-btn").click(() => this._onQuantityClick($item, +1));
      $item.find(".qty-minus-btn").click(() => this._onQuantityClick($item, -1));
    } else {
      $item.find(".qty-plus-btn").addClass("hidden");
      $item.find(".qty-minus-btn").addClass("hidden");
    }
    
    $container.append($item);
    
    return $item;
  }
    
  _findShopCartItemById(items, shopCartItemId) {
      for (const item of items || []) {
          if (item.ShopCartItemId === shopCartItemId) return item;
          const found = item.Items && this._findShopCartItemById(item.Items, shopCartItemId);
          if (found) return found;
      }
      return null;
  };
  
  _findShopCartItem(items, productId, unitAmount) {
      for (const item of items || KIOSK_CONTROLLER.shopCart.Items || []) {
          if ((item.ProductId == productId) && (item.UnitAmount == unitAmount)) return item;
          const found = item.Items && this._findShopCartItem(item.Items, productId, unitAmount);
          if (found) return found;
      }
      return null;
  };
  
  _onShopCartChange() {
    this.displayController.$next.setClass("disabled", KIOSK_CONTROLLER.isShopCartEmpty());
    if (this.active) {
      this.$ui.find(".recap-item-line").each((index, elem) => {
        let $item = $(elem);
        let model = $item.data("model");
        if (model) {
          let shopCartItem = this._findShopCartItemById(KIOSK_CONTROLLER.shopCart.Items, (model.shopCartItem || {}).ShopCartItemId);
          model.shopCartItem = shopCartItem;
          model.quantity = (shopCartItem) ? shopCartItem.Quantity : 0;
          model.totalAmount = (shopCartItem) ? shopCartItem.TotalAmount : 0;
          $item.find(".recap-item-quantity-value").text(model.quantity); 
          $item.find(".recap-item-totalamount-value").text(formatCurr(model.totalAmount)); 
        }
      });
    }
  }
    
  _onQuantityClick($item, quantityDelta) {
    let model = $item.data("model");
    
    if ((model.quantity == 0) && (quantityDelta > 0))
      this._addToCart(model);
    else if ((model.quantity == 1) && (quantityDelta < 0))
      this._removeItem(model);
    else
      this._editItemQuantity(model, quantityDelta);
  }
  
  _addToCart(model) {
    KIOSK_CONTROLLER.apiShopCart("AddToCart", {
      "ItemList": [{
        "Product": {
          "ProductId": model.productId          
        },
        "PerformanceIDs": model.performanceId,
        "QuantityDelta": 1
      }]
    }).then(ansDO => {
      model.shopCartItem = this._findShopCartItemById(KIOSK_CONTROLLER.shopCart.Items, ansDO.ShopCartItemIDs[0]);
      this._onShopCartChange();
    });
  }
  
  _removeItem(model) {
    let shopCartItem = model.shopCartItem;
    if (shopCartItem) {
      KIOSK_UI_CONTROLLER.showConfirm({
        "message": "Do you want to remove '" + model.title + "'?"
      }).then(() => {
        KIOSK_CONTROLLER.apiShopCart("RemoveItem", {"ShopCartItemId":shopCartItem.ShopCartItemId});
        model.shopCartItem = null;
      });
    }
  }
  
  _editItemQuantity(model, quantityDelta) {
    let shopCartItem = model.shopCartItem;
    if (shopCartItem) {
      KIOSK_CONTROLLER.apiShopCart("EditItemQuantity", {
        "ShopCartItemId": shopCartItem.ShopCartItemId,
        "QuantityDelta": quantityDelta
      });
    } 
  }

}
