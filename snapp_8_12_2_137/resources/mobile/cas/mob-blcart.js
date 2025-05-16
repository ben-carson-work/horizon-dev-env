//# sourceURL=mob-blcart.js
var shopCart = {};

$(document).ready(function() {
  window.BLCart = {
    "isWorking": isWorking,
    "isShopCartEmpty": isShopCartEmpty,
    "isTransactionType": isTransactionType,
    "isSaleFlowType": isSaleFlowType,
    "isOpenTab": isOpenTab,
    "initCartDisplay": initCartDisplay,
    "shopCartAPI": shopCartAPI,
    "addToCart": addToCart,
    "emptyShopCart": emptyShopCart,
    "startNewSale": startNewSale,
    "getCartQuantity": getCartQuantity // Return quantity in cart for a given ProductId
  };
  
  var working = false;
  var reqStack = [];
  var cartQuantities = {};
  
  function isWorking() {
    return working;
  }
  
  function setWorking(value) {
    working = value;
    $(document).trigger("ShopCartWorkingChange", {"working":working});
  }
  
  function addRequestStack(command, params) {
    reqStack.push({
      "Command": command,
      "Params": params
    });

    if (!isWorking()) 
      processRequestStack();
  }
  
  function processRequestStack() {
    if (reqStack.length > 0) {
      var item = reqStack[0];
      if (reqStack.length == 1)
        reqStack = [];
      else
        reqStack = reqStack.slice(1, reqStack.length);
      
      shopCartAPI(item.Command, item.Params)
        .then(function(ans) {
          processRequestStack(); 
        })
        .catch(function(error) {
          console.error(error);
          reqStack = [];
          UIMob.showMessage(error.message);
        });
    }
  }

  function shopCartAPI(command, commandDO) {
    return new Promise(function(resolve, reject) {
      var reqDO = {
        "Command": command,
        "ShopCartId": shopCart.ShopCartId
      };
      reqDO[command] = commandDO;

      setWorking(true);
      snpAPI("ShopCart", null, reqDO)
        .finally(function() {
          setWorking(false);
        })
        .then(function(ans) {
          shopCart = ans.Answer.ShopCart;
          triggerShopCartQuantityEvent();
          $(document).trigger("ShopCartChange");
          
          resolve();
        })
        .catch(function(error) {
          reject(error);
        });
    });
  }
  
  function initCartDisplay(displayContainer) {
    UIMob.loadView(PKG_CAS, "cartdisplay", function($viewCartDisplay) {
      $(displayContainer).append($viewCartDisplay);
      UIMob.initView($viewCartDisplay);
    });
  }

  function triggerShopCartQuantityEvent() {
    var qtys = {};
    
    function _recursiveApplyQuantities(items) {
      items = (items || []);
      for (var i=0; i<items.length; i++) {
        var item = items[i];
        qtys[item.ProductId] = (qtys[item.ProductId] || 0) + item.Quantity;
      }
    }

    _recursiveApplyQuantities(shopCart.Items);
    cartQuantities = qtys;
    $(document).trigger("ShopCartQuantityChange", qtys);
  }

  function isShopCartEmpty() {
    var items = shopCart.Items || [];
    var privcard = shopCart.MembershipTicket || {};
    
    return 
      (items.length == 0) && 
      (shopCart.AccountId == null) &&
      (privcard.TicketId == null);
  }
  
  function isTransactionType(transactionType) {
    var trn = shopCart.Transaction || {};
    return (trn.TransactionType === transactionType);
  } 
  
  function isSaleFlowType(saleFlowType) {
    return (shopCart.SaleFlowType === saleFlowType);
  }
  
  function isOpenTab() {
    return ((shopCart.CreateNewTab === true) || (shopCart.Opentab.OpentabId != null));
  }
  
  function addToCart(params) {
    addRequestStack("AddToCart", params);
  }
  
  function emptyShopCart(params) {
    addRequestStack("EmptyShopCart", params);
  }
  
  function getCartQuantity(productId) {
    return strToIntDef(cartQuantities[productId], 0);
  }
  
  function startNewSale() {
    shopCart = {};
    triggerShopCartQuantityEvent();
    $(document).trigger("ShopCartChange");
  }
});