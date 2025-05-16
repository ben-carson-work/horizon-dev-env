var original_allowInteraction = $.ui.dialog.prototype._allowInteraction;
$.ui.dialog.prototype._allowInteraction = function(event) {
  return original_allowInteraction(event) || ($(event.target).parent("#v-combo-content").length > 0);
};

$(document).ready(function() {
  var originalVal = $.fn.val;
  $.fn.val = function(value) {
    var $this = $(this);
    var combo = $this.is(".v-combo") ? $this : null;
    if (typeof value != 'undefined') {
      if (combo == null)
        return originalVal.call(this, value);
      else {
        combo.vcombo_setSelItemId(value);
        return $this;
      }
    }
    else if (combo == null) 
      return originalVal.call(this);
    else {
      var selItem = combo.vcombo_getSelItem();
      return (selItem == null) ? null : selItem.ItemId;
    }
  };
});

function removeVComboContent() {
  $("#v-combo-content").remove();
}

$(window).mousedown(removeVComboContent);

$(window).keydown(function(event) {
  event = event || window.event;
  if (event.keyCode == KEY_ESC)
    removeVComboContent();
});

jQuery.fn.vcombo = function(params) {
  var combo = $(this);
  if (!combo.hasClass("v-combo")) {
    params = (params) ? params : {};
    params.delay = isNaN(parseInt(params.delay)) ? 200 : parseInt(params.delay); 
    params.minLength = isNaN(parseInt(params.minLength)) ? 1 : parseInt(params.minLength); 
    combo.data("params", params);
    
    combo.addClass("v-combo form-control").append("&nbsp;");
    $("<div class='v-combo-icon'/>").appendTo(combo);
    $("<div class='v-combo-name'/>").appendTo(combo);
    var btn = $("<div class='v-combo-btn'/>").appendTo(combo);
    
    combo.click(function() {
      if (!combo.hasClass("disabled")) 
        combo.vcombo_open();
    });
    
    btn.click(function() {
      if (!combo.hasClass("disabled")) {
        if (combo.hasClass("selected")) {
          combo.vcombo_setSelItem(null);
          event.stopPropagation();
        };
      }
    });
  }
  
  if (params.DefaultItemId) 
    combo.vcombo_setSelItemId(params.DefaultItemId);
  
  return combo;
};

jQuery.fn.vcombo_open = function() {
  var combo = $(this).closest(".v-combo");
  var params = combo.data("params");
  var comboOffset = combo.offset();
  
  var divCont = $("#v-combo-content");
  if (divCont.length == 0)
    divCont = $("<div id='v-combo-content'/>").appendTo("body");
  
  var txtSearch = $("<input type='text' class='v-combo-txt'/>").appendTo(divCont);
  txtSearch.attr("placeholder", itl("@Common.FullSearch"));
  var divList = $("<div class='v-combo-itemlist'/>").appendTo(divCont);

  divCont.width(combo.width());
  
  txtSearch.focus();
  txtSearch.keydown(function(event) {
    event = event || window.event;
    if (event.keyCode == KEY_ESC) {
      removeVComboContent();
      event.stopPropagation();
    }
    else if (event.keyCode == KEY_DOWN) {
      var sel = divList.find(".selected");
      var next = sel.next();
      if (next.length > 0) {
        sel.removeClass("selected");
        next.addClass("selected");
        
        var scroll = next.position().top + next.outerHeight(true) - divList.height(); 
        if (scroll > 0) 
          divList.scrollTop(scroll);
      }
      event.stopPropagation();
      event.preventDefault();
    }
    else if (event.keyCode == KEY_UP) {
      var sel = divList.find(".selected");
      var prev = sel.prev();
      if (prev.length > 0) {
        sel.removeClass("selected");
        prev.addClass("selected");
        
        if (prev.position().top < divList.scrollTop()) 
          divList.scrollTop(prev.position().top);
      }
      event.stopPropagation();
      event.preventDefault();
    }
    else if (event.keyCode == KEY_ENTER) {
      combo.vcombo_setSelItem(divList.find(".selected").data("item"));
      event.stopPropagation();
      event.preventDefault();
    }
  });
  
  var searchText = "";
  txtSearch.keyup(function() {
    if (txtSearch.val() != searchText) {
      searchText = txtSearch.val();
      clearTimeout(combo.data("timer"));
      if (searchText.length < params.minLength)
        divList.empty();
      else {
        combo.data("timer", setTimeout(function() {
          doVComboSearch(combo, divCont, searchText);
        }, params.delay));
      }
    }
  });

  divCont.css({
    "top": (comboOffset.top + combo.outerHeight(true)) + "px",
    "left": comboOffset.left + "px",
    "width": combo.outerWidth() + "px"
  });
  
  divCont.mousedown(function(event) {
    event = event || window.event;
    event.stopPropagation();
  });
};

jQuery.fn.vcombo_setSelItem = function(item) {
  var combo = $(this);
  var oldItem = combo.data("item");
  combo.data("item", item);
  if (item) {
    combo.addClass("selected");
    combo.find(".v-combo-icon").css("background-image", "url('" + getVComboIconURL(item.IconName, item.ProfilePictureId) + "')");
    combo.find(".v-combo-icon").setClass("foricon", (!item.ProfilePictureId));
    combo.find(".v-combo-icon").setClass("forpic", (item.ProfilePictureId));
    combo.find(".v-combo-name").html(item.ItemName);
    combo.find(".v-combo-code").html(item.ItemCode);
  }
  else {
    combo.removeClass("selected");
    combo.find(".v-combo-icon").css("background-image", "none");
    combo.find(".v-combo-name").empty();
    combo.find(".v-combo-code").empty();
  }
  removeVComboContent();

  var oldItemId = (oldItem) ? oldItem.ItemId : null;
  var newItemId = (item) ? item.ItemId : null;
  if (oldItemId != newItemId) {
    var params = combo.data("params");
    if ((params) && (params.onPickup))
      params.onPickup(item);
  }
};

jQuery.fn.vcombo_getSelItem = function(item) {
  return $(this).data("item");
};

jQuery.fn.vcombo_setSelItemId = function(itemId) {
  var combo = $(this);
  if (itemId) {
    var reqDO = prepareVComboRequest(combo.data("params"), null);
    reqDO.EntityId = itemId;
    
    vgsService("FullTextLookup", reqDO, false, function(ansDO) {
      if ((ansDO.Answer) && (ansDO.Answer.ItemList) && (ansDO.Answer.ItemList.length > 0)) 
        combo.vcombo_setSelItem(ansDO.Answer.ItemList[0]);      
    });
  }
  else
    combo.vcombo_setSelItem(null);      
};

jQuery.fn.vcombo_getSelItemId = function(item) {
  var item = $(this).data("item");
  return (item) ? item.ItemId : null;
};

function getVComboIconURL(iconName, profilePictureId) {
  return BASE_URL + "/" + ((profilePictureId) ? "repository?type=thumb&id=" + profilePictureId : "imagecache?size=28&name=" + encodeURI(iconName));
}

function prepareVComboRequest(params, txt) {
  return {
    EntityType: params.EntityType,
    FullText: txt,
    Event: params.EventParams,
    Product: params.ProductParams,
    Mask: params.MaskParams,
    Account: params.AccountParams,
    PromoRule: params.PromoRuleParams,
    SaleChannel: params.SaleChannelParams
  };
}

function doVComboSearch(combo, divCont, txt) {
  var divList = divCont.find(".v-combo-itemlist");
  vgsService("FullTextLookup", prepareVComboRequest(combo.data("params"), txt), false, function(ansDO) {
    if (divCont.find(".v-combo-txt").val() == txt) {
      divList.empty();
      for (var i=0; i<ansDO.Answer.ItemList.length; i++) {
        var item = ansDO.Answer.ItemList[i];
        var divItem = $("<div class='v-combo-item'/>").appendTo(divList);
        var divName = $("<div class='v-combo-item-name'/>").appendTo(divItem);
        var divCode = $("<div class='v-combo-item-code'/>").appendTo(divItem);
        divName.html(item.ItemName);
        divCode.html(item.ItemCode);
        
        if (i == 0)
          divItem.addClass("selected");
        
        $("<div class='v-combo-item-icon " + ((item.ProfilePictureId) ? "forpic" : "foricon") + "' style='background-image:url(\"" + getVComboIconURL(item.IconName, item.ProfilePictureId) + "\")'/>").appendTo(divItem);
        
        divItem.data("item", item);
        divItem.click(function() {
          combo.vcombo_setSelItem($(this).data("item"));
        });
      }
    }
  });
}
