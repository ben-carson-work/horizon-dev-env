<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% 
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); 
BOSessionBean boSession = pageBase.getSession();
String lastSaleId = pageBase.getBL(BLBO_ShopCart.class).findLastReservationId(boSession.getWorkstationId(), boSession.getUserAccountId());
boolean isCLC = pageBase.isVgsContext("CLC");
boolean isB2B = pageBase.isVgsContext("B2B");
%>

<script>
//# sourceURL=shopcart_js.jsp
  var CONTEXT_URL = <%=JvString.jsString(pageBase.getContextURL())%>;
  var SHOPCART_TIMEOUT_MINS = <%=rights.ShopCartTimeoutMins.isNull() ? null : rights.ShopCartTimeoutMins.getInt()%>;
  var shopCart = {};
  var applicablePromoRules = [];
  var validPaymentMethodIDs = null;
  var lastSaleId = null;
  
  var StepDir_Next = "NEXT";
  var StepDir_Back = "BACK";
  
  var Step_Selection = "Step_Selection";
  var Step_Promo = "Step_Promo";
  var Step_ItemAccount = "Step_ItemAccount";
  var Step_MediaInput = "Step_MediaInput";
  var Step_OwnerAccountSearch = "Step_OwnerAccountSearch";
  var Step_OwnerAccount = "Step_OwnerAccount";
  var Step_SaleChannel = "Step_SaleChannel";
  var Step_ShipAccount = "Step_ShipAccount";
  var Step_ValidateShopCart = "Step_ValidateShopCart";
  var Step_SaleSurvey = "Step_SaleSurvey";
  var Step_TransactionSurvey = "Step_TransactionSurvey";
  var Step_OrderConf = "Step_OrderConf";
  var Step_CheckOut = "Step_CheckOut";
  
  var saleFlowSteps = [
    Step_Selection,
    Step_Promo,
    Step_ItemAccount,
    Step_MediaInput,
    Step_OwnerAccountSearch,
    Step_OwnerAccount,
    Step_SaleChannel,
    Step_ShipAccount,
    Step_ValidateShopCart,
    Step_SaleSurvey,
    Step_TransactionSurvey,
    Step_OrderConf,
    Step_CheckOut
  ];

  
  $(document).ready(function() {
  
    <% if (pageBase.isVgsContext("B2B")) { %>
      function _checkUniqueTab() {
        if ($("#page-shopcart").length > 0) {
          if (browserTabId !== getCookie("browserTabId")) 
            doLogout();
          setTimeout(_checkUniqueTab, 1000);
        }
      }
      _checkUniqueTab();
    <% } %>
    
    var reqDO = {
      Command: "GetChildNodes",
      GetChildNodes: {
        CatalogTypes: "<%=LkSNCatalogType.Catalog.getCode()%>,<%=LkSNCatalogType.Folder.getCode()%>",
        Recursive: true,
        PresaleActive: true,
        TaxExemptActive: shopCart.TaxExempt
      }
    };
    
    vgsService("Catalog", reqDO, false, function(ansDO) {
      $("#catalog-container .item-container").removeClass("waiting");
      if ((ansDO.Answer) && (ansDO.Answer.GetChildNodes) && (ansDO.Answer.GetChildNodes.Nodes))
        recursiveRenderFolders(ansDO.Answer.GetChildNodes.Nodes, "#catalog-container .item-container", 0);
      
      var folders = $("#catalog-container .folder-item");
      if (folders.length > 0)
        $(folders[0]).click();
    });
    
    initShopCart();
    refreshShopcartTimer();
    setLastSaleId(<%=JvString.jsString(lastSaleId)%>);
    $("#btn-account").setClass("disabled", <%=!rights.Reservations.getOverallCRUD().canCreate()%>);
    $("#btn-handover").setClass("disabled", <%=!pageBase.getSession().getOrgAllowInventory()%>); 
    
    var saleId = location.hash.replace("#", "");
    if (saleId.length == 36) {
      location.hash = "";
      doLoadShopCart(saleId);
    }
  });
  
  window.onbeforeunload = function () {
    //doEmptyShopCart(true);
    if (isShopCartEmpty(shopCart))
      return null;
    else
      return itl("@Sale.BrowserExitShopCartMessage");
  };
  
  function initShopCart() {
    shopCart = {};
    renderCart(shopCart);
  }
  
  function setLastSaleId(saleId) {
    lastSaleId = saleId;
    $("#btn-lastres").setClass("disabled", lastSaleId == null);
  }
  
  $("#txt-search").keypress(function(e) {
    var code = (e.keyCode ? e.keyCode : e.which);
    if (code == KEY_ENTER) {
      var pnr = $(this).val().toUpperCase();
      $(this).val("");
      if (pnr != "") 
        doLoadShopCart(pnr);
    }
  });
  
  function onShopCartLastRes(btn) {
    if (!$(btn).is(".disabled")) 
      doLoadShopCart(lastSaleId);
  }
  
  function onShopCartAccount(btn) {
    if (!$(this).is(".disabled")) 
      doShowOwnerAccountDialog();
  }
  
  function onShopCartHandover(btn) {
    if (!$(this).is(".disabled")) 
      doShopCartHandoverDialog();
  }
  
  function onShowCartMenu(btn) {
    popupMenu("#cart-menu", btn, event);
  }
  
  function onSaleVoid(menu) {
    if (shopCart.Deletable) 
      asyncDialogEasy("../clc/shopcart/salevoid_dialog", "id=" + shopCart.Reservation.SaleId);
    else 
      showMessage(itl("@Reservation.CannotDeleteSaleError"));
  }
  
  function onAddCoupon(menu) {
    if (!$(this).hasClass("disabled")) {
	  var dlg = $("<div/>");
	  var lbl = $("<span/>").appendTo(dlg);
	  var txt = $("<input type='text' class='form-control' placeholder='<v:itl key="@Product.InsertBarcode"/>'/>").appendTo(dlg);
      var errorMsg = $("<div style='color: red; display: none;'><v:itl key='@Coupon.InvalidCode'/></div>").appendTo(dlg);

	  function btnCouponPickupOk() {
	    var code = txt.val();
	    if (!code || code.trim() == "")
	      errorMsg.show();
	    else {
    	  doAddCouponToCart(code);
	      dlg.dialog("close");  
	    }
	  }
	  
	  txt.keyup(function(event) {
	    if (event.keyCode == KEY_ENTER)
	      btnCouponPickupOk();
	  })
	  
	  dlg.dialog({
	    modal: true,
	    title: itl("@Product.CouponPickup"),
	    close: function() {
	      dlg.remove();
	    },
	    buttons: {
	      <v:itl key="@Common.Ok" encode="JS"/>: btnCouponPickupOk,
	      <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
	    }
	  });
    }
  }

  function doAddCouponToCart(couponCode) {
	doCmdShopCart({
	  Command: "AddCouponToCart",
	  AddCouponToCart: {
	     CouponCode: couponCode
	  }
	});
  }
  
  function renderTitle(container, iconName, profilePictureId, title, subtitle) {
    var urlo = addTrailingSlash(BASE_URL);
    if (profilePictureId)
      urlo += "repository?type=small&id=" + encodeURIComponent(profilePictureId);
    else
      urlo += "imagecache?size=62&name=" + encodeURIComponent(iconName);
    
    $(container).find(".title-image").css("background-image", "url('" + urlo + "')");
    $(container).find(".title-caption").text(title);
    
    $(container).find(".subtitle-caption").text((subtitle) ? subtitle : "");
  }
  
  function addFullTooltip(elem, jsp) {
    elem.find(".item-img").addClass("v-tooltip").attr("data-delay", "1000").attr("data-tooltip-url", CONTEXT_URL + "?page=widget&jsp=../common/shopcart/" + jsp);  
  }
  
  function renderNode(container, clazz, iconName, profilePictureId, caption, onclick, level) {
    var img = addTrailingSlash(BASE_URL) + "imagecache?size=32&name=" + encodeURIComponent(iconName);
    if (profilePictureId != null)
      img = addTrailingSlash(BASE_URL) + "repository?type=thumb&id=" + encodeURIComponent(profilePictureId);
    var elem = $($("#folder-template").html()).appendTo(container);
    elem.addClass(clazz);
    elem.addClass("noselect");
    elem.find(".item-img").attr("src", img);
    elem.find(".item-indent").css("left", (level*32) + "px");
    
    var divCaption = elem.find(".item-caption");
    divCaption.text(caption);
    
    elem.click(onclick);
    
    return elem;
  }
  
  function renderFolder(node, container, level) {
    var elem = renderNode(container, "folder-item", node.IconName, node.ProfilePictureId, node.CatalogName, folderClick, level);
    elem.attr("data-CatalogId", node.CatalogId);
    elem.data(node);
    
    elem.find(".folder-collapse").click(_setFolderStatusCollapsed);
    elem.find(".folder-explode").click(_setFolderStatusExploded);
    
    function _setFolderStatus(event, status) {
      elem.closest(".folder-container").attr("folder-status", status);
      event.stopPropagation();
    }

    function _setFolderStatusCollapsed(event) {
      _setFolderStatus(event, "collapsed");
    }

    function _setFolderStatusExploded(event) {
      _setFolderStatus(event, "exploded");
    }
  }
  
  function renderEvent(node) {
    var elem = renderNode("#event-container .item-container", "event-item", node.IconName, node.ProfilePictureId, node.CatalogName, eventClick, 0);
    elem.attr("data-EventId", node.EntityId);
    elem.attr("data-CatalogId", node.CatalogId);
    elem.data(node);
  }
  
  function renderProduct(node) {
    var elem = renderNode("#product-container .item-container", "product-item", node.IconName, node.ProfilePictureId, node.CatalogName, productClick, 0);
    elem.attr("data-ProductId", node.EntityId);
    elem.attr("data-EntityType", node.EntityType);
    elem.attr("data-Price", node.Price);
    elem.attr("data-HasDynamicOptions", node.HasDynamicOptions);
    elem.attr("data-VariablePrice", node.VariablePrice);
    elem.attr("data-VariablePriceMin", node.VariablePriceMin);
    elem.attr("data-VariablePriceMax", node.VariablePriceMax);
    elem.attr("data-VariableExpRule", node.VariableExpRule);
    elem.attr("data-VariableTBUWRule", node.VariableTBUWRule);
    
    <% if (!pageBase.getRights().PriceDisplayType.isLookup(LkSNPriceDisplayType.Hidden)) { %>
	      if (node.EntityType != <%=LkSNEntityType.PromoRule.getCode()%>) {
	        var divPrice = $("<div class='price-box'/>");
	        divPrice.html(node.VariablePrice ? "..." : formatCurr(node.DisplayPrice != null ? node.DisplayPrice : node.Price));
	        elem.find(".item-indent .item-caption").before(divPrice);
	      } 
    <% } %>
    
    addFullTooltip(elem, "product-tooltip&id=" + node.EntityId);
  }
  
  function renderPerfProduct(prod, performanceId) {
    var caption = (prod.ShowNameExt && (prod.ProductNameExt)) ? prod.ProductNameExt : prod.ProductName;
    var elem = renderNode("#product-container .item-container", "product-item", prod.IconName, prod.ProfilePictureId, caption, productClick, 0);
    elem.attr("data-ProductId", prod.ProductId);
    elem.attr("data-PerformanceId", performanceId);
    elem.attr("data-SeatCategoryId", prod.SeatCategoryId);
    elem.attr("data-Price", prod.Price);
    elem.attr("data-HasDynamicOptions", prod.HasDynamicOptions);
    elem.attr("data-VariablePrice", prod.VariablePrice);
    elem.attr("data-VariablePriceMin", prod.VariablePriceMin);
    elem.attr("data-VariablePriceMax", prod.VariablePriceMax);
    elem.attr("data-VariableExpRule", prod.VariableExpRule);
    elem.attr("data-VariableTBUWRule", prod.VariableTBUWRule);
    
    if (prod.QuantityMax) {
      elem.addClass("seat-item");
      elem.attr("data-seatquantityfree", prod.QuantityFree);
      renderAvailBox(elem, prod.QuantityFree, prod.QuantityMax, 0, prod.SeatCategoryColor);
    } 
    
    <% if (!pageBase.getRights().PriceDisplayType.isLookup(LkSNPriceDisplayType.Hidden)) { %>
      var divPrice = $("<div class='price-box'/>");
      divPrice.html(prod.VariablePrice ? "..." : formatCurr(prod.DisplayPrice!= null ? prod.DisplayPrice : prod.Price));
      elem.find(".item-indent .item-caption").before(divPrice);
    <% } %>

    addFullTooltip(elem, "product-tooltip&id=" + prod.ProductId);
  }
  
  function refreshAvailBox(box, qty, tot) {
    var $box = $(box);
    
    $box.each(function(index, elem) {
      var singleQty = qty;
      var $singleBox = $(elem);
      var $seatItem = $singleBox.closest(".seat-item");
      
      if ($seatItem.length > 0) {
        singleQty = Math.min(singleQty, parseInt($seatItem.attr("data-seatquantityfree")));
        $seatItem.attr("data-seatquantityfree", singleQty);
      }
      
      var perc = (tot == 0) ? 0 : (singleQty / tot * 100);
      var warnperc = parseInt($singleBox.attr("data-warnperc"));
      warnperc = ((warnperc) && !isNaN(warnperc)) ? warnperc : 20;
      $singleBox.find(".avail-quantity").text(singleQty);
      $singleBox.find(".avail-progress-split").css("width", perc + "%");
      $singleBox.setClass("avail-soldout", singleQty <= 0);
      $singleBox.setClass("avail-warn", (singleQty > 0) && (singleQty/tot*100 < warnperc));
    });
  }
  
  function renderAvailBox(container, qty, tot, warnperc, color) {
    var sStyle = (color) ? " style='background-color:" + color + "'" : "";
    var div = $("<div class='avail-box'/>");
    $("<div class='avail-quantity'/>").appendTo(div);
    $("<div class='avail-progressbar'><div class='avail-progress-split'" + sStyle + "/></div>").appendTo(div);
    div.attr("data-warnperc", warnperc);
    container.find(".item-caption").before(div);
    refreshAvailBox(div, qty, tot);
    return div;
  }
  
  function renderPerformance(perf) {
    var date = xmlToDate(perf.DateTimeFrom);
    var desc = formatTime(date, <%=pageBase.getRights().ShortTimeFormat.getInt()%>);
    if (perf.PerformanceDesc)
      desc += " - " + perf.PerformanceDesc;
    var elem = renderNode("#perf-container .item-container", "perf-item", "[font-awesome]clock", null, desc, perfClick, 0);
    elem.attr("data-PerformanceId", perf.PerformanceId);
    elem.data("performance", perf);
    
    if (perf.SeatAllocation) 
      renderAvailBox(elem.find(".item-indent"), perf.QuantityFree, perf.QuantityMax, perf.SoldOutWarnLimit);
  }
  
  function renderPerfDate(date) {
    var div = $("<div class='perf-date'/>").appendTo("#perf-container .item-container");
    div.text(formatDate(date, <%=pageBase.getRights().LongDateFormat.getInt()%>));
  }
  
  function renderPerfWarning() {
    var div = $("<div class='perf-warning'/>").appendTo("#perf-container .item-container");
    div.text(itl("@Performance.NoResultsForSelectedDate"));
  }
  
  function renderPerfSearching() {
    $("<div class='perf-searching waiting'/>").appendTo("#perf-container .item-container");
  }
  
  function renderNoElemFound(container, text) {
    var div = $("<div class='no-elem-found'/>").appendTo(container);
    div.text((text) ? text : itl("@Common.NoItems"));
  }

  function recursiveRenderFolders(nodes, container, level) {
    if (nodes) {
      for (var i=0; i<nodes.length; i++) {
        var node = nodes[i];
        var hasChildrenClass = ((node.Nodes || []).length <= 0) ? "" : "has-subfolders";
        var status = (level > 0) ? "collapsed" : "exploded" 
        
        var $folderContainer = $("<div class='folder-container " + hasChildrenClass + "' folder-status='" + status + "'></div>").appendTo(container);
        renderFolder(node, $folderContainer, level);

        var $subfolderContainer = $("<div class='subfolder-container'></div>").appendTo($folderContainer);
        recursiveRenderFolders(node.Nodes, $subfolderContainer, level + 1);
      }
    }
  }
  
  String.prototype.hashCode = function() {
    var hash = 0, i, chr, len;
    if (this.length == 0) return hash;
    for (i = 0, len = this.length; i < len; i++) {
      chr   = this.charCodeAt(i);
      hash  = ((hash << 5) - hash) + chr;
      hash |= 0; // Convert to 32bit integer
    }
    return hash;
  };
  
  function renderCartGroup(divList, item) {
    var groupHash = (item.GroupingDesc) ? item.GroupingDesc.hashCode() : 0;
    var elem = divList.children(".cart-group[data-GroupHash='" + groupHash + "']");
    if (elem.length == 0) {
      elem = $("<div class='cart-group'/>").appendTo(divList);
      elem.attr("data-GroupHash", groupHash);
      $("<div class='cart-group-title'/>").appendTo(elem).text(item.GroupingDesc);
    }
    return elem;
  }
  
  function renderCartItemButton(container, item, clazz, action, onclick) {
    clazz = (clazz) ? clazz : "";
    var div = $("<div class='v-button " + clazz + "'/>").appendTo(container);
    div.setClass("disabled", !isBtnActionEnabled(action));
    div.setClass("v-hidden", !isBtnActionVisible(action));
    if (div.hasClass("btn-qty"))
      div.append("<i class='fa fa-hashtag'></i>");
    if (div.hasClass("btn-del"))
      div.append("<i class='fa fa-trash-alt'></i>");
    if (div.hasClass("btn-min"))
      div.append("<i class='fa fa-minus'></i>");
    if (div.hasClass("btn-pls"))
      div.append("<i class='fa fa-plus'></i>");
    if (div.hasClass("btn-seat"))
      div.append("<i class='fa fa-loveseat'></i>");
    div.click(onclick)
    
    return div;
  }
  
  function renderCartItem(divList, item) {
    var group = renderCartGroup(divList, item);
    
    var elem = $("<div class='cart-item catalog-item'/>").appendTo(group);
    elem.data(item);
    elem.addClass("noselect");
    elem.setClass("selected", item.ShopCartItemId == shopCart.SelItemId);
    elem.attr("data-shopcartitemid", item.ShopCartItemId);
    var divMain = $("<div class='cart-item-main'/>").appendTo(elem);
    var divItems = $("<div class='cart-item-subitems'/>").appendTo(elem);
    
    var divData = $("<div class='cart-item-data'/>").appendTo(divMain);
    var divBtns = $("<div class='cart-item-btns'/>").appendTo(divMain);
    
    var divLine1 = $("<div class='cart-item-data-line line1'/>").appendTo(divData);
    var divData_L1 = $("<div class='cart-item-data-value data-value-l1'/>").appendTo(divLine1);
    var divData_R1 = $("<div class='cart-item-data-value data-value-r1'/>").appendTo(divLine1);
    
    var divLine2 = $("<div class='cart-item-data-line line2'/>").appendTo(divData);
    var divData_L2 = $("<div class='cart-item-data-value data-value-l2'/>").appendTo(divLine2);
    var divData_R2 = $("<div class='cart-item-data-value data-value-r2'/>").appendTo(divLine2);
    
    var netPrices = <%=rights.ShowNetPrices.getBoolean()%>;
    divData_L1.text(item.ProductName);
    divData_R1.html(formatCurr(netPrices ? item.TotalNetFull : item.TotalGrossFull));
    divData_L2.text(item.ProductCode);
    divData_R2.html(item.Quantity + " x " + formatCurr(netPrices ? item.UnitNetFull : item.UnitGrossFull));
    
    if (isVarDateItem(item)) {
      var tooltipURL = CONTEXT_URL + "?page=widget&jsp=../common/shopcart/variabledate_tooltip&ShopCartId=" + shopCart.ShopCartId + "&ShopCartItemId=" + item.ShopCartItemId;
      divData_L1.prepend("<span><i class='fa fa-calendar v-tooltip' style='cursor:help' data-delay='1000' data-tooltip-url='" + tooltipURL + "'></i>&nbsp;</span>");
    }

    renderCartItemButton(divBtns, item, "btn-qty hl-green", item.ActionPlus, cartItemQtyClick);
    renderCartItemButton(divBtns, item, "btn-pls hl-green", item.ActionPlus, cartItemPlsClick);
    renderCartItemButton(divBtns, item, "btn-min hl-green", item.ActionMinus, cartItemMinClick);
    renderCartItemButton(divBtns, item, "btn-del hl-red", item.ActionTrash, cartItemDelClick);
    
    var btnSeat = renderCartItemButton(divBtns, item, "btn-seat hl-green", item.ActionSeatMap, cartItemSeatClick);
    btnSeat.attr("title", calcItemSeatTitle(item));
    
    elem.click(function() {
      if (!$(this).hasClass("selected")) {
        $("#cart-block .cart-item").removeClass("selected");
        $(this).addClass("selected");
        shopCart.SelItemId = item.ShopCartItemId;
      }
      event.stopPropagation();
    });
    
    if (item.Items) 
      for (var i=0; i<item.Items.length; i++) 
        renderCartItem(divItems, item.Items[i]);

    return elem;
  }
  
  function isVarDateItem(item) {
    return ((item.ValidDateFrom) || (item.ValidDateTo));
  }
  
  function calcItemSeatTitle(item) {
    var title = "";
    if (item.ItemDetailList) {
      for (var i=0; i<item.ItemDetailList.length; i++) {
        var detail = item.ItemDetailList[i];
        if (detail.SeatList) {
          for (var k=0; k<detail.SeatList.length; k++)
            title += detail.SeatList[k].SeatName + "\n";
        }
      }
    }
    return title;
  }
  
  function cartItemQtyClick() {
    if (!$(this).hasClass("disabled")) {
      var item = $(".cart-item.selected").data();
      var dlg = $("<div/>");
      var lbl = $("<span/>").appendTo(dlg);
      var txt = $("<input type='number' class='form-control' value='" + item.Quantity + "' min='1' max='9999'/>").appendTo(dlg);

      lbl.text(itl("@Common.Quantity"));
      
      function btnQuantityEditOk() {
        var qty = parseInt(txt.val());
        qty = Math.max(0, Math.min(9999, qty));
        if (!isNaN(qty)) {
          doEditItemQuantity(item.ShopCartItemId, qty - item.Quantity);
          dlg.dialog("close");            
        }
      }
      
      txt.keyup(function(event) {
        if (event.keyCode == KEY_ENTER)
          btnQuantityEditOk();
      })
      
      dlg.dialog({
        modal: true,
        title: itl("@Common.EditQuantity"),
        close: function() {
          dlg.remove();
        },
        buttons: {
          <v:itl key="@Common.Ok" encode="JS"/>: btnQuantityEditOk,
          <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
        }
      });
    }
  }
  
  function doShowOwnerAccountDialog() {
    if (shopCart.AccountId == null) 
      asyncDialogEasy("../clc/shopcart/owneraccount_search_dialog", "step-to-checkout=false");
    else if (<%=rights.AccountPRSs.getOverallCRUD().canUpdate()%> && (shopCart.AccountEntityType == <%=LkSNEntityType.Person.getCode()%>)) 
      asyncDialogEasy("../clc/shopcart/owneraccount_dialog", "step-to-checkout=false&id=" + shopCart.AccountId);
    else 
      showMessage(itl("@Common.PermissionDenied"));
  }
  
  function doShopCartHandoverDialog() {
    asyncDialogEasy("account/account_inventory_product_dialog", "step-to-checkout=false");
  }
  
  function refreshCartAccount() {
    var accountId = shopCart.AccountId;        
    var accountName = shopCart.AccountName;
    var href = "doShowOwnerAccountDialog()";
    <% if (pageBase.isVgsContext("B2B")) { %>
      accountId = shopCart.ShipAccountId;        
      accountName = shopCart.ShipAccountName;
      href = "asyncDialogEasy('account/account_dialog', 'CallbackId=ShopCart-ShipAccount&id=" + ((accountId) ? accountId : "new") + "')";
    <% } %>
    
    var id = (accountId) ? accountId : "";
    var elem = $("<a href=\"javascript:" + href + "\"/>");
    if ((accountName) && (accountName.trim() != ""))
      elem.text(accountName);
    else
      elem.text(itl("@Account.AnonymousAccount"));
    $("#cart-guest-field .field-value").empty().append(elem);
  }
  
  function isShopCartEmpty(shopCart) {
    var emptyCart = (shopCart.Reservation.SaleId == null) && ($(".cart-item").length == 0);
    <% if (pageBase.isVgsContext("CLC")) { %>
      emptyCart = emptyCart && (shopCart.AccountId == null);
    <% } %>
    return emptyCart;
  }

  var oldSeatPerfList = [];
  
  function renderCart(shopCart) {
    var status = itl("@Reservation.StatusB2B_Open");
    shopCart.Reservation = (shopCart.Reservation) ? shopCart.Reservation : {};
    if (shopCart.Reservation.SaleStatus == <%=LkSNSaleStatus.Deleted.getCode()%>)
      status = itl("@Reservation.StatusB2B_Deleted");
    else if (shopCart.Reservation.Completed)
      status = itl("@Reservation.StatusB2B_Completed");
    else if (shopCart.Reservation.Paid)
      status = itl("@Reservation.StatusB2B_Committed");
    
    $("#cart-total-subtotal .field-value").html(formatCurr(shopCart.SubTotal));
    $("#cart-total-tax .field-value").html(formatCurr(shopCart.TotalTax));
    $("#cart-total-paid .field-value").html(formatCurr(shopCart.TotalPaid));
    $("#cart-total-due .field-value").html(formatCurr(shopCart.TotalDue));
    $("#btn-checkout").setClass("disabled", !isBtnActionEnabled(shopCart.ActionCheckOut));
    $("#btn-emptycart").setClass("disabled", !isBtnActionEnabled(shopCart.ActionEmptyCart));
    $("#btn-promo").setClass("v-hidden", !hasApplicablePromos());
    $("#cart-pnr-field .field-value").text(shopCart.Reservation.SaleCode);
    $("#cart-status-field .field-value").text(status);
    refreshCartAccount();

    var newSeatPerfList = oldSeatPerfList;
    var divList = $("#cart-block .item-container");
    divList.empty();
    if (shopCart.Items) {
      for (var i=0; i<shopCart.Items.length; i++) {
        var item = shopCart.Items[i];
        renderCartItem(divList, item);
        
        if ((item.SeatCategoryId) && (item.PerformanceList)) {
          for (var k=0; k<item.PerformanceList.length; k++) {
            var perf = item.PerformanceList[k];
            if (newSeatPerfList.indexOf(perf.PerformanceId) < 0) 
              newSeatPerfList.push(perf.PerformanceId);
          }
        }
      }
    }

    var trn = shopCart.Transaction || {};
    var $cartBlock = $("#cart-block"); 
    $cartBlock.setClass("special-trntype", (trn.TransactionType != null) && (trn.TransactionType != <%=LkSNTransactionType.Normal.getCode()%>));
    $cartBlock.find(".trntype-desc").text(trn.TransactionTypeDesc);
    
    var wasEmpty = $cartBlock.hasClass("empty-cart");
    var isEmpty = isShopCartEmpty(shopCart);
    $cartBlock.setClass("empty-cart", isEmpty);
    
    if (wasEmpty && !isEmpty)
      startShopcartTimerIfNeeded();

    var perflist = [];
    for (var i=0; i<oldSeatPerfList.length; i++) perflist.push(oldSeatPerfList[i]);
    for (var i=0; i<newSeatPerfList.length; i++) perflist.push(newSeatPerfList[i]);

    refreshSeatQuantities(perflist);
    oldSeatPerfList = newSeatPerfList;
  }
  
  function startShopcartTimerIfNeeded() {
    if (SHOPCART_TIMEOUT_MINS) { 
      var $timer = $("#shopcart-timer");
      $timer.data("data-start-ts", Date.now());
      doRefreshShopcartTimer();
    }
  }
  
  function refreshShopcartTimer() {
    if (SHOPCART_TIMEOUT_MINS) {
      try {
        doRefreshShopcartTimer();
      }
      finally {
        setTimeout(refreshShopcartTimer, 1000);
      }
    }
  }
  
  function doRefreshShopcartTimer() {
    var $timer = $("#shopcart-timer");
    var start = strToIntDef($timer.data("data-start-ts"), 0);
    if (start > 0) {
      var deltaSecs = parseInt((Date.now() - start) / 1000);
      var remaingSecs = (SHOPCART_TIMEOUT_MINS * 60) - deltaSecs;
      
      if (remaingSecs > 0) {
        $timer.text("(" + getSmoothTime(remaingSecs * 1000) + ")");
        $("#btn-emptycart").setClass("timer-alert", remaingSecs < 60);
      }
      else if (!$("#cart-block").hasClass("empty-cart")) {
        $timer.data("data-start-ts", null);
        $(".ui-dialog-content").dialog("close");

        doEmptyShopCart(true, function() {
          initShopCart();
          showMessage(itl("@Shopcart.ShopcartTimeoutWarn"));
        });
      }
    }
  }
  
  function refreshSeatQuantities(perflist) {
    if (perflist.length > 0) {
      var reqDO = {
        PerformanceIDs: perflist.join(","),
        EventCatalogId: $(".event-item.selected").attr("data-catalogId"),
        SeatAccount: {
          AccountId: shopCart.AccountId || <%=JvString.jsString(pageBase.getSession().getOrgAccountId())%>
        },
        SellableOnly: true,
        ReturnProducts: true
      }
      
      snpAPI.cmd("PERFORMANCE", "Search", reqDO).then(ansDO => {
        var perfs = (ansDO || {}).PerformanceList || [];
        for (const perf of perfs) {
          var $perfItem = $(".perf-item[data-PerformanceId='" + perf.PerformanceId + "']");
          $perfItem.data("performance", perf);
          refreshAvailBox($perfItem.find(".avail-box"), perf.QuantityFree, perf.QuantityMax);

          for (const perfProd of (perf.ProductList || [])) {
            var selector = ".product-item[data-performanceid='" + perf.PerformanceId + "'][data-productid='" + perfProd.ProductId + "'] .avail-box";
            refreshAvailBox(selector, perfProd.QuantityFree, perfProd.QuantityMax);
          }
        }
      });
    }
  }
  
  function hasApplicablePromos() {
    return (shopCart.HasApplicablePromos) ? shopCart.HasApplicablePromos : false;
  }
  
  function isBtnActionEnabled(action) {
    return (action) && (action.Enabled) && action.Enabled;
  }
  
  function isBtnActionVisible(action) {
    return (action) && (action.Visible) && action.Visible;
  }
  
  function setWaiting(container) {
    $(container).empty();
    $(container).addClass("waiting");
  }
  
  function folderClick() {
    $("#catalog-container .catalog-item").removeClass("selected");
    $(this).addClass("selected");

    var node = $(this).data();
    renderTitle("#event-block .block-title", node.IconName, node.ProfilePictureId, node.CatalogName, itl("@Event.Events"));
    renderTitle("#product-block .block-title", node.IconName, node.ProfilePictureId, node.CatalogName, itl("@Product.ProductTypes"));

    doLoadFolder($(this).attr("data-CatalogId"));
  }
  
  function eventClick() {
    $("#event-container .catalog-item").removeClass("selected");
    $(this).addClass("selected");
    $("#perf-container").removeClass("v-hidden");
    
    var node = $(this).data();
    renderTitle("#product-block .block-title", node.IconName, node.ProfilePictureId, node.CatalogName, itl("@Product.ProductTypes"));
    $("#product-container .item-container").empty();
    renderNoElemFound("#product-container .item-container", itl("@Performance.SelectPerformanceHint"));

    doSearchPerformances(true);
  }
  
  function perfClick() {
    $("#perf-container .catalog-item").removeClass("selected");
    var $perf = $(this);
    $perf.addClass("selected");
    
    var event = $("#event-container .event-item.selected").data();
    renderTitle("#product-block .block-title", event.IconName, event.ProfilePictureId, event.CatalogName, $perf.find(".item-caption").text());
    
    doSearchProducts($perf.data("performance"));
  }
  
  function isTransactionHandover() {
    var trn = shopCart.Transaction || {};
    return (trn.TransactionType != null) && (trn.TransactionType == <%=LkSNTransactionType.OrganizationInventoryHandover.getCode()%>);
  }
  
  function productClick() {
    var $this = $(this);
    if (shopCart.Editable == false) 
      showMessage(itl("@Reservation.ReservationNotEditable"));
    else if (isTransactionHandover()) 
      showMessage(itl("@Reservation.HandoverTransactionNotEditable"));
    else if ($this.attr("data-seatquantityfree") == "0")
      showIconMessage("warning", itl("@Seat.SoldOut"));
    else {
      var productId = $this.attr("data-ProductId");
      var entityType = $this.attr("data-EntityType");
      var performanceId = getNull($this.attr("data-PerformanceId"));
      var price = parseFloat($this.attr("data-Price")); 

      _addToCartBean = {
        Config: {
          HasDynamicOptions: parseBool($this.attr("data-HasDynamicOptions")),
          VarPrice: parseBool($this.attr("data-VariablePrice")),
          VarExp: parseInt($this.attr("data-VariableExpRule")),
          VarTBUW: parseInt($this.attr("data-VariableTBUWRule"))
        },
        BasePrice: price,
        ProductId: productId,
        EntityType: entityType,
        QuantityDelta: 1,
        QuantityUnit: 1,
        PerformanceId: performanceId
      };
       
      addCheckAddToCartValues({});
    }  
  }
  
  var _addToCartBean = {};
  
  function addCheckAddToCartValues(values) {
    _addToCartBean = Object.assign({}, _addToCartBean, values);
    
    if ((_addToCartBean.Config.VarPrice === true) && !(_addToCartBean.Price))
      showVariablePriceDialog();
    else if (!isNaN(_addToCartBean.Config.VarExp) && !(_addToCartBean.ValidFrom) && !(_addToCartBean.ValidTo))
      showVariableExpDialog();
    else if ((_addToCartBean.Config.HasDynamicOptions === true) && !(_addToCartBean.OptionIDs))
      showDynamicOptionDialog();
    else if (!isNaN(_addToCartBean.Config.VarTBUW) && !(_addToCartBean.FirstUsageFrom) && !(_addToCartBean.FirstUsageTo))
      showVariableTBUWDialog();
    else if (!isNaN(_addToCartBean.EntityType) && (_addToCartBean.EntityType == <%=LkSNEntityType.PromoRule.getCode()%>))
      doAddPromoToCart(_addToCartBean.ProductId);
    else 
      doAddToCart(_addToCartBean);
  }
  
  function showVariablePriceDialog() {
    var $this = $(this);
    inputDialog(itl("@Product.VariablePrice"), "", itl("@Product.Price"), "", false, function(value) {
      price = parseFloat((value) ? value : value.replace(",", "."));
      if (isNaN(price))
        throw itl("@Common.InvalidAmount");

      var minPrice = parseFloat($this.attr("data-VariablePriceMin"));
      var maxPrice = parseFloat($this.attr("data-VariablePriceMax"));
      if (!isNaN(minPrice) && (minPrice > price))
        throw itl("@Product.VariablePriceMinError", formatCurr(minPrice));
      if (!isNaN(maxPrice) && (maxPrice < price))
        throw itl("@Product.VariablePriceMaxError", formatCurr(maxPrice));
      
      addCheckAddToCartValues({"Price":price});
    });
  }
  
  function showVariableTBUWDialog() {
    asyncDialogEasy("../common/shopcart/variabledate_dialog", "FirstUsageRule=" + _addToCartBean.Config.VarTBUW);
  }  
  
  function showVariableExpDialog() {
    asyncDialogEasy("../common/shopcart/variabledate_dialog", "ExpirationRule=" + _addToCartBean.Config.VarExp);
  }
  
  function showDynamicOptionDialog() {
    asyncDialogEasy("../common/shopcart/options_dialog", "ProductId=" + _addToCartBean.ProductId + "&PerformanceId=" + (_addToCartBean.performanceId || "") + "&BasePrice=" + _addToCartBean.BasePrice);
  }
  
  function cartItemDelClick() {
    if (!$(this).hasClass("disabled")) {
      var item = $(this).closest(".cart-item").data();
      doRemoveItem(item.ShopCartItemId);
    }
  }
  
  function cartItemMinClick() {
    if (!$(this).hasClass("disabled")) {
      var item = $(this).closest(".cart-item").data();
      doEditItemQuantity(item.ShopCartItemId, -item.QuantityStep);
    }
  }
  
  function cartItemPlsClick() {
    if (!$(this).hasClass("disabled")) {
      var item = $(this).closest(".cart-item").data();
      doEditItemQuantity(item.ShopCartItemId, +item.QuantityStep);
    }
  }
  
  function cartItemSeatClick() {
    if (!$(this).hasClass("disabled")) {
      var item = $(this).closest(".cart-item").data();

      var seatIDs = [];
      var seatMapId = null;
      if (item.ItemDetailList) {
        for (var i=0; i<item.ItemDetailList.length; i++) {
          var detail = item.ItemDetailList[i];
          if (detail.SeatList) {
            for (var k=0; k<detail.SeatList.length; k++) {
              var seat = detail.SeatList[k];
              seatIDs.push(seat.SeatId);
              seatMapId = seatMapId || seat.SeatMapId;
            }
          }
        }
      }
      
      asyncDialogEasy("../common/shopcart/seatmap_dialog", "id=" + seatMapId + "&HoldId=" + shopCart.HoldId + "&ActiveCategoryId=" + item.SeatCategoryId + "&SeatIDs=" + seatIDs.join(","));
    }
  }
  
  $("#btn-checkout").click(function() {
    if (!$(this).hasClass("disabled")) {
      stepCallBack(Step_Selection, StepDir_Next);
//      if (shopCart.HoldId == null)
//        stepCallBack(Step_Selection, StepDir_Next);
//      else {
//        showWaitGlass();
//        doCmdShopCart({Command:"FreezeSeatHold"}, function(ansDO) {
//          hideWaitGlass();          
//          stepCallBack(Step_Selection, StepDir_Next);
//        });
//      }      
    }
  });
  
  $("#btn-emptycart").click(function() {
    if (!$(this).hasClass("disabled")) {
      confirmDialog(null, function() {
        doEmptyShopCart(true, function() {
          initShopCart();
        });
      });
    }
  });
  
  $("#btn-promo").click(function() {
    if (!$(this).hasClass("disabled")) {
      asyncDialogEasy("../common/shopcart/promo_dialog");
    }
  });
  
  $(document).on("ShopCart-ShipAccount", function(event, data) {
    doSetShipAccount(data.AccountId);
  });
  
  function calcPahTicketCount() {
    var result = 0;
    if ((shopCart) && (shopCart.Items)) {
      for (var i=0; i<shopCart.Items.length; i++) {
        var item = shopCart.Items[i];
        result += (item.GroupTicketOption == <%=LkSNGroupTicketOption.NoGroup.getCode()%>) ? item.Quantity : 1;
      }
    }
    return result;
  }
  
  function isStepNeeded(stepCode, stepDir) {
    var isTransactionTypeNormal = (shopCart.Transaction.TransactionType == <%=LkSNTransactionType.Normal.getCode()%>);
    var isTransactionTypeInventoryHandover = (shopCart.Transaction.TransactionType == <%=LkSNTransactionType.OrganizationInventoryHandover.getCode()%>);
    // Promo
    if (stepCode == Step_Promo)
      return isTransactionTypeNormal && shopCart.HasApplicablePromos;
    // ItemAccount
    else if (stepCode == Step_ItemAccount)
      return isTransactionTypeNormal && isItemAccountRequired();
    // MediaInput
    else if (stepCode == Step_MediaInput)
      return isTransactionTypeNormal && isMediaInputRequired();
    // OwnerAccountSearch
    else if (stepCode == Step_OwnerAccountSearch)
      return <%=isCLC%> && isTransactionTypeNormal && (shopCart.AccountId == null);// ((shopCart.AccountId == null) || ((shopCart.Reservation) && (shopCart.Reservation.SaleId == null)));
    // OwnerAccount
    else if (stepCode == Step_OwnerAccount) {
      <% boolean canEditPRS = rights.AccountPRSs.getOverallCRUD().canUpdate(); %>
      <% boolean canEditORG = rights.AccountORGs.getOverallCRUD().canCreate(); %>
      <% boolean canCreatePRS = rights.AccountPRSs.getOverallCRUD().canCreate(); %>
      <% if (isCLC && (canEditPRS || canEditORG)) { %>
        if (shopCart.AccountId == null)
          return isTransactionTypeNormal && <%=canCreatePRS%>;
        else {
          var isPRS = (shopCart.AccountEntityType == <%=LkSNEntityType.Person.getCode()%>);
          var isORG = (shopCart.AccountEntityType == <%=LkSNEntityType.Organization.getCode()%>);
          return isTransactionTypeNormal && ((isPRS && <%=canEditPRS%>) || (isORG && <%=canEditORG%>));
        }
      <% } %>
      return false;
    }
    // SaleChannel
    else if (stepCode == Step_SaleChannel) 
      return isTransactionTypeNormal && <%=isCLC%> && (shopCart.AccountSaleChannelId != null) && (shopCart.SaleChannelId != shopCart.AccountSaleChannelId);
    // ShipAccount
    else if (stepCode == Step_ShipAccount)
      return (isTransactionTypeNormal || isTransactionTypeInventoryHandover) && <%=isB2B%>;
    // ValidateShopCart
    else if (stepCode == Step_ValidateShopCart)
      return (stepDir == StepDir_Next);
    // SaleSurvey
    else if (stepCode == Step_SaleSurvey)
      return (shopCart.SaleSurveyIDs) && (shopCart.SaleSurveyIDs.length > 0);
    // TransactionSurvey
    else if (stepCode == Step_TransactionSurvey)
      return (shopCart.TransactionSurveyIDs) && (shopCart.TransactionSurveyIDs.length > 0);
    // All others
    else 
      return true;
  }
  
  function activateStep(stepCode, data) {
    var accountId = (shopCart.AccountId) ? shopCart.AccountId : "";
    var saleId = (shopCart.Reservation.SaleId) ? shopCart.Reservation.SaleId : "";
    
    // Selection
    if (stepCode == Step_Selection) {
      // Do Nothing
    }
    // Promo
    else if (stepCode == Step_Promo)
      asyncDialogEasy("../common/shopcart/promo_dialog", "step-to-checkout=true");
    // ItemAccount
    else if (stepCode == Step_ItemAccount)
      asyncDialogEasy("../common/shopcart/itemaccount_dialog");
    // MediaInput
    else if (stepCode == Step_MediaInput)
      asyncDialogEasy("../common/shopcart/mediainput_dialog");
    // OwnerAccountSearch
    else if (stepCode == Step_OwnerAccountSearch)  
      asyncDialogEasy("../clc/shopcart/owneraccount_search_dialog", "step-to-checkout=true");
    // OwnerAccount
    else if (stepCode == Step_OwnerAccount) 
      asyncDialogEasy("../clc/shopcart/owneraccount_dialog", "step-to-checkout=true&id=" + accountId);
    // SaleChannel
    else if (stepCode == Step_SaleChannel) 
      doStepSaleChannel(data);
    // ShipAccount
    else if (stepCode == Step_ShipAccount) 
      asyncDialogEasy("../b2b/shopcart/shipaccount_dialog");
    // ValidateShopCart
    else if (stepCode == Step_ValidateShopCart) 
      doStepValidateShopCart();
    // SaleSurvey
    else if (stepCode == Step_SaleSurvey) 
      asyncDialogEasy("../common/shopcart/survey_dialog", "SurveyType=<%=LkSNSurveyType.Sale.getCode()%>&SurveyIDs=" + shopCart.SaleSurveyIDs);
    // TransactionSurvey
    else if (stepCode == Step_TransactionSurvey) 
      asyncDialogEasy("../common/shopcart/survey_dialog", "SurveyType=<%=LkSNSurveyType.Transaction.getCode()%>&SurveyIDs=" + shopCart.TransactionSurveyIDs);
    // OrderConf
    else if (stepCode == Step_OrderConf) {
      var itemCount = 0;
      if (shopCart.Items) 
        for (var i=0; i<shopCart.Items.length; i++)
          itemCount += shopCart.Items[i].Quantity; 

      asyncDialogEasy("../common/shopcart/orderconf_dialog", 
          "SaleId=" + saleId + 
          "&AccountId=" + accountId + 
          "&AlreadyCommitted=" + shopCart.Reservation.Paid + 
          "&RestrictOpenOrder=" + shopCart.Reservation.RestrictOpenOrder +
          "&TotalDue=" + shopCart.TotalDue + 
          "&TotalAmount=" + shopCart.TotalAmount + 
          "&ItemCount=" + itemCount + 
          "&PahTicketCount=" + calcPahTicketCount());
    }
    // CheckOut
    else if (stepCode == Step_CheckOut)
      doStepCheckOut(data);
    else
      throw "Unhandled step code '" + stepCode + "'";
  }
  
  function stepCallBack(stepCode, stepDir, data) {  
    var idx = saleFlowSteps.indexOf(stepCode);
    var found = false;
    
    while (!found) {
      idx += (stepDir == StepDir_Back) ? -1 : 1;
      if ((idx >= 0) && (idx < saleFlowSteps.length)) 
        found = isStepNeeded(saleFlowSteps[idx], stepDir);
      else
        break;
    }
    
    if (found)
      activateStep(saleFlowSteps[idx], data);
  }
  
  function doStepSaleChannel(data) {
    confirmDialog(itl("@SaleChannel.ChangeRecalculateMessage"), 
      function() {
        doSetSaleChannel(shopCart.AccountSaleChannelId, true, function() {
          stepCallBack(Step_SaleChannel, StepDir_Next, data);
        });
      }, 
      function() {
        stepCallBack(Step_SaleChannel, StepDir_Next, data);
      }
    );      
  }
  
  function doStepValidateShopCart() {
    showWaitGlass();
    doCmdShopCart({Command:"ValidateShopCart"}, function(ansDO) {
      hideWaitGlass();
      if (ansDO.Answer.ValidateShopCart.ErrorCode) {
        if (ansDO.Answer.ValidateShopCart.ErrorCode == <%=LkSNValidateShopCartErrorCode.RestrictOpenOrder.getCode()%>)
    	    stepCallBack(Step_ValidateShopCart, StepDir_Next);
    	  else
            showMessage("[" + ansDO.Answer.ValidateShopCart.ErrorCode + "] " + ansDO.Answer.ValidateShopCart.ErrorMessage);
      }
      else {
	      if (ansDO.Answer.ValidateShopCart.ValidPaymentMethodList)
	       validPaymentMethodIDs = ansDO.Answer.ValidateShopCart.ValidPaymentMethodList.map(item => item.PaymentMethodId);
	      else
		      validPaymentMethodIDs = null;
	      
        stepCallBack(Step_ValidateShopCart, StepDir_Next);
      }  
    });
  }
  
  function doStepCheckOut(data) {
    var isTransactionTypeHandover = shopCart.Transaction.TransactionType == <%=LkSNTransactionType.OrganizationInventoryHandover.getCode()%>;
    var isAsyncPaymentType = ([<%=LkSNPaymentType.WebPayment.getCode()%>, <%=LkSNPaymentType.Membership.getCode()%>].indexOf(data.PaymentType) >= 0);
    var isAsyncPayment = isAsyncPaymentType && !isTransactionTypeHandover;
    
    if (!isAsyncPayment) {
      shopCart.Reservation.WishedApproval = data.ApproveReservation;
      shopCart.PreparePahDownload = data.PreparePahDownload;
      shopCart.CreateOrderConfirmation = data.CreateOrderConfirmation;
      shopCart.SendOrderConfirmation = data.SendOrderConfirmation;
      shopCart.IncludeOrderConfirmationTickets = data.IncludeTickets;
      shopCart.OrderDocTemplateId = data.DocTemplateId;
    }
    else
      shopCart.Reservation.SaleStatus = <%=LkSNSaleStatus.WaitingForPayment.getCode()%>;

    if (data.OrganizationInventoryBuild)
      shopCart.Transaction.TransactionType = <%=LkSNTransactionType.OrganizationInventoryBuild.getCode()%>;
    
    var reqDO = {
      Command: "InitTransaction",
      InitTransaction: {
        ShopCart: shopCart
      }
    };
    
    vgsService("Transaction", reqDO, false, function(ansDO) {
      var reqDO = ansDO.Answer.InitTransaction.Message.Request;    
      if (data.CommitReservation && !isAsyncPayment) {
        reqDO.Approved = true;
        reqDO.Paid = true;
        
        if (shopCart.TotalDue != 0) {
          var payDO = {
            PaymentMethodId: data.PaymentMethodId,
            MetaDataList: data.PaymentMetaDataList,
            PaymentAmount: shopCart.TotalDue
          };
          
          if (data.PaymentType == <%=LkSNPaymentType.Credit.getCode()%>) {
            payDO.CreditLine = {
              AccountId: shopCart.AccountId
            };
          }
          else if (data.PaymentType == <%=LkSNPaymentType.CreditCard.getCode()%>) {
            payDO.CreditCard = {
              AuthorizationCode: data.AuthorizationCode
            };
          }
          else if (data.PaymentType == <%=LkSNPaymentType.Intercompany.getCode()%>) {
            payDO.IntercompanyCostCenter = {
              IntercompanyCostCenterId: data.IntercompanyCostCenterId
            }
          }
          
          reqDO.PaymentList = [payDO];
        }
      }

      if ((shopCart.IncludeOrderConfirmationTickets || shopCart.PreparePahDownload || (shopCart.Transaction.TransactionType==<%=LkSNTransactionType.OrganizationInventoryBuild.getCode()%>)) && !isAsyncPayment) {
        reqDO.Approved = true;
        reqDO.Encoded = true;
        reqDO.Printed = true;
        reqDO.Validated = true;
      }
      else
        if (isTransactionHandover() && !shopCart.PreparePahDownload) {
          reqDO.Encoded = false;
          reqDO.Printed = false;
          reqDO.Validated = false;
        }
      var amount = shopCart.TotalDue;
      var accountId = (shopCart.AccountId) ? shopCart.AccountId : "";
      
      doPostTransaction(reqDO, function(trnRecap) {
        var saleId = trnRecap.SaleId;
        var saleCode = trnRecap.SaleCode;
        var orderConfData = data;
        if (orderConfData && orderConfData.CommitReservation && isAsyncPaymentType) {
          if (orderConfData.PaymentType == <%=LkSNPaymentType.Membership.getCode()%>)  
            doFolioCharge(saleId, saleCode, amount, orderConfData);
          else if (orderConfData.PaymentType == <%=LkSNPaymentType.WebPayment.getCode()%>) {
            if (typeof orderConfData.PaymentTokenId == 'undefined') 
              doWebPayment(saleId, orderConfData);
            else 
              doPayByToken(accountId, saleId, amount, orderConfData);
          }
          else
            throw "Async payment type \"" + orderConfData.PaymentType + "\" not handled";
        }
        else {
          refreshFolders();
          showTransactionRecapDialog({
            SaleId: saleId,
            SaleCode: saleCode,
            PahRelativeUrl: trnRecap.PahRelativeDownloadUrl
          });
        }
      });
    });
  }
  
  function doWebPayment(saleId, orderConfData) {
    var params =
          "SaleId=" + saleId + "&" +
          "PaymentMethodId=" + orderConfData.PaymentMethodId + "&" +
          "CreateOrderConfirmation=" + orderConfData.CreateOrderConfirmation + "&" +
          "SendOrderConfirmation=" + orderConfData.SendOrderConfirmation + "&" +
          "IncludeTickets=" + orderConfData.IncludeTickets + "&" +
          "PreparePahDownload=" + orderConfData.PreparePahDownload + "&" +
          "OrganizationInventoryBuild=" + orderConfData.OrganizationInventoryBuild + "&" +
          "OrderDocTemplateId=" + orderConfData.DocTemplateId;
      asyncDialogEasy("../common/shopcart/webpayment_dialog", params)
  }
  
  function doPayByToken(accountId, saleId, amount, data) {
    showWaitGlass();
    var reqDO = {
      Command: "PayByToken",
      PayByToken: {
        Sale: {
          SaleId: saleId
        },
        PaymentMethod: {
          PaymentMethodId: data.PaymentMethodId
        },
        PaymentAmount: amount,
        PaymentTokenId: data.PaymentTokenId,
        Transaction: {
          DeliveryOptions: {
            CreateOrderConfirmation: data.CreateOrderConfirmation,
            SendOrderConfirmation: data.SendOrderConfirmation,
            IncludeTickets: data.IncludeTickets,
            PreparePahDownload: data.PreparePahDownload,
            DocTemplate: {
              DocTemplateId: data.DocTemplateId
            }
          }
        }
      }
    }
    
    vgsService("Sale", reqDO, true, function(ansDO) {
      hideWaitGlass();

      var errorCode = 0;
      var errorMessage = getVgsServiceError(ansDO);
      if (errorMessage != null)
        errorCode = ansDO.Header.StatusCode;
      
      if (errorCode == 0) {
        showTransactionRecapDialog({
          SaleId: ansDO.Answer.PayByToken.TransactionRecap.SaleId,
          SaleCode: ansDO.Answer.PayByToken.TransactionRecap.SaleCode,
          PahRelativeUrl: ansDO.Answer.PayByToken.TransactionRecap.PahRelativeDownloadUrl,
          PaymentStatus: ansDO.Answer.PayByToken.PaymentStatus,
          AuthorizationCode: ansDO.Answer.PayByToken.AuthorizationCode,
          ErrorMessage: ansDO.Answer.PayByToken.ErrorMessage
        });
      }
      else {
        confirmDialog(errorMessage +  "\n\n" + itl("@Sale.TryAnotherPayment"), function() {
          asyncDialogEasy("../common/shopcart/webpayment_paybytoken_dialog", "SaleId=" + saleId + "&AccountId=" + accountId + "&Amount=" + amount + "&Data=" + encodeURIComponent(JSON.stringify(data)));
        });
      }
    });
  }
  
  function doFolioCharge(saleId, saleCode, amount, orderConfData) {
    snpAPI.cmd("Membership", "Charge", {
      "MembershipPlan": {
        "ProductId": orderConfData.Membership.MembershipPlanId
      },
      "Details": {
        "MembershipCardCode": orderConfData.Membership.MembershipCardCode,
        "Amount": amount,
        "Reference": saleCode,
        "MembershipCardParamList": orderConfData.Membership.ParamList
      }
    }, {
      "silent": true
    }).then(ansDO => {
      _saveFolioTransaction(2/*approved*/, (ansDO || {}).PaymentDataList, JSON.stringify(ansDO), function(trnAnsDO) {
        showTransactionRecapDialog({
          "SaleId": trnAnsDO.PostTransactionRecap.SaleId,
          "SaleCode": trnAnsDO.PostTransactionRecap.SaleCode,
          "PahRelativeUrl": trnAnsDO.PostTransactionRecap.PahRelativeDownloadUrl
        });
      });
    }).catch(error => {
      _saveFolioTransaction(3/*failed*/, null, JSON.stringify(error), function() {
        showIconMessage("warning", error);
      });
    });
    
    function _saveFolioTransaction(paymentStatus, paymentDataList, rawMessage, callback) {
      snpAPI.cmd("Transaction", "OrderPayment", {
        "Sale": {"SaleId": saleId},
        "Params": {
          "CreateOrderConfirmation": orderConfData.CreateOrderConfirmation,
          "SendOrderConfirmation": orderConfData.SendOrderConfirmation,
          "PreparePahDownload": orderConfData.PreparePahDownload,
          "IncludeOrderConfirmationTickets": orderConfData.IncludeTickets,
          "OrderDocTemplate": {"DocTemplateId": orderConfData.DocTemplateId}
        },
        "PaymentList": [{
          "PaymentStatus": paymentStatus,
          "PaymentMethodId": orderConfData.PaymentMethodId,
          "PaymentAmount": amount,
          "PaymentRawResponse": rawMessage,
          "PaymentDataList": paymentDataList,
          "Membership": {
            "MembershipPlanId": orderConfData.Membership.MembershipPlanId,
            "MembershipCardCode": orderConfData.Membership.MembershipCardCode,
            "MembershipCardCodeDisplay": orderConfData.Membership.MembershipCardCodeDisplay,
            "CardHolderName": orderConfData.Membership.CardHolderName
          }
        }]
      }).then(ansDO => callback(ansDO));
    }
  }
  
  function doPrintAtHome(relativeUrl) {
    window.open("<%=pageBase.getContextURL()%>" + relativeUrl);
    $(".recap-dialog").closest(".ui-dialog-content").dialog("close");
  }
  
  function isItemAccountRequired() {
    if (shopCart.Items) 
      for (var i=0; i<shopCart.Items.length; i++) 
        if (shopCart.Items[i].RequireAccount)
          return true;
    return false;
  }
  
  function itemRequiresMediaInput(shopCartItem) {
    if (shopCartItem) {
      console.log(shopCartItem.ProductId);
      if (stringToIntArray(shopCartItem.ProductFlags).indexOf(<%=LkSNProductFlag.RequireMediaInputOnCLC.getCode()%>) >= 0)
        return true;
    }
    return false; 
  }
  
  function isMediaInputRequired() {
    if (shopCart.Items)
      for (var i=0; i<shopCart.Items.length; i++)
        if (itemRequiresMediaInput(shopCart.Items[i]))
          return true;
    return false;
  }
  
  function doLoadFolder(catalogId) {
    setWaiting("#event-container .item-container");
    setWaiting("#product-container .item-container");
    $("#perf-container").addClass("v-hidden");

    var reqDO = {
      Command: "GetChildNodes",
      GetChildNodes: {
        ParentCatalogId: catalogId,
        CatalogTypes: "<%=LkSNCatalogType.Entity.getCode()%>",
        ShopCartId: shopCart.ShopCartId, 
        Recursive: false,
        PresaleActive: true,
        TaxExemptActive: shopCart.TaxExempt
      }
    };
    
    vgsService("Catalog", reqDO, false, function(ansDO) {
      $("#event-container .item-container").removeClass("waiting");
      $("#product-container .item-container").removeClass("waiting");
      var hasEvents = false;
      var hasProds = false;
      if ((ansDO.Answer) && (ansDO.Answer.GetChildNodes) && (ansDO.Answer.GetChildNodes.Nodes)) {
        var nodes = ansDO.Answer.GetChildNodes.Nodes;
        for (var i=0; i<nodes.length; i++) {
          if (nodes[i].EntityType == <%=LkSNEntityType.Event.getCode()%>) {
            renderEvent(nodes[i]);
            hasEvents = true;
          }
          else {
            renderProduct(nodes[i]);
            hasProds = true;
          }
        }
      }
      if (!hasEvents)
        renderNoElemFound("#event-container .item-container");
      if (!hasProds)
        renderNoElemFound("#product-container .item-container");
    });
  }

  var perfPage = 1;
  var perfRecPerPage = 50;
  var perfTotalRecCount = 0;
  var perfLoading = false;
  var perfLastDate = null;
  
  function doSearchPerformances(reset) {
    perfLoading = true;
    if (reset) {
      $("#perf-container .item-container").empty();
      perfPage = 1;
      perfLastDate = null;
    }
    else
      perfPage++;
    renderPerfSearching();
    
    var perfFilter = $("#txt-perf-filter");
    var fromDate = perfFilter.attr("data-DateFrom");
    var fromTime = perfFilter.attr("data-TimeFrom");
    var toTime = perfFilter.attr("data-TimeTo");
    var accountId = shopCart.AccountId || <%=JvString.jsString(pageBase.getSession().getOrgAccountId())%>;
    
    var reqDO = {
      EventId: $("#event-container .catalog-item.selected").attr("data-EventId"),
      EventCatalogId: $(".event-item.selected").attr("data-catalogId"),
      SeatAccount: {AccountId:accountId},
      FromDate: (fromDate) ? fromDate : null,
      FromTime: (fromTime) ? fromTime : null,
      ToTime: (toTime) ? toTime : null,
      SeatMinQuantity: perfFilter.attr("data-MinQuantity"),
      PresaleActive: true,
      SellableOnly: true,
      ReturnProducts: true,
      PagePos: perfPage,
      RecordPerPage: perfRecPerPage
    };
  
    snpAPI.cmd("Performance", "Search", reqDO, {"showWaitGlass":reset}).then(ansDO => {
      perfLoading = false;
      $("#perf-container .item-container .perf-searching").remove();
      var noPerformances = true;
      if (ansDO.PerformanceList) {
        perfTotalRecCount = ansDO.TotalRecordCount;
        if (perfTotalRecCount > 0) {
          noPerformances = false;
          var list = ansDO.PerformanceList;
          for (var i=0; i<list.length; i++) {
            var date = new Date(list[i].DateTimeFrom.substr(0,10) + "T00:00:00");
            if ((perfLastDate == null) || (perfLastDate.getFullYear() != date.getFullYear()) || (perfLastDate.getMonth() != date.getMonth()) || (perfLastDate.getDate() != date.getDate())) {
              if ((perfLastDate == null) && (list[i].DateTimeFrom.substr(0,10).indexOf(reqDO.FromDate) != 0))
                renderPerfWarning();
              renderPerfDate(date);
              perfLastDate = date;
            }
            renderPerformance(list[i]);
          }
        }
      }
      
      if (noPerformances)
        renderNoElemFound("#perf-container .item-container", itl("@Performance.NoPerformances"));
    });
  }

  function doSearchProducts(perf) {
    $("#product-container .item-container").empty();
    products = (perf || {}).ProductList || [];
    if (products.length == 0)
      renderNoElemFound("#product-container .item-container");
    else {
      for (var product of products) 
        renderPerfProduct(product, perf.PerformanceId);
    }
  }
  
  function refreshFolders() {
    var catalogId = $("#catalog-container .catalog-item.selected").attr("data-CatalogId");
    doLoadFolder(catalogId);
  }
  
  function getSelItem() {
    if ((shopCart) && (shopCart.Items) && (shopCart.SelItemId)) {
      for (var i=0; i<shopCart.Items.length; i++) {
        var item = shopCart.Items[i];
        if (item.ShopCartItemId == shopCart.SelItemId) 
          return item;
      }        
    }
    return null;
  }

  function doCmdShopCart(reqDO, callback) {
    reqDO.ShopCartId = shopCart.ShopCartId;
    reqDO.FillApplicablePromoList = true;
    vgsService("ShopCart", reqDO, true, function(ansDO) {
      var errorMsg = getVgsServiceError(ansDO)
      if (errorMsg) {
        if ((reqDO.Command == "EditItemQuantity") && (reqDO.EditItemQuantity.QuantityDelta > 0)) 
          $(".cart-item[data-shopcartitemid='" + reqDO.EditItemQuantity.ShopCartItemId + "'] .btn-pls").addClass("disabled");
        showIconMessage("warning", errorMsg);
      }
      else if (ansDO.Answer.ShopCart.Reservation.SaleStatus == <%=LkSNSaleStatus.WaitingForPayment.getCode()%>) {
        hideWaitGlass();
          showMessage(itl("@Sale.WaitingForPaymentOrderError"));
      }
      else {    
        shopCart = ansDO.Answer.ShopCart;
        applicablePromoRules = ansDO.Answer.ApplicablePromoRuleList;
        if (callback)
          callback(ansDO);
        renderCart(shopCart);
      }
    });
  }
  
  function doAddPromoToCart(productId) {
	doCmdShopCart({
      Command: "AddPromoToCart",
      AddPromoToCart: {
        ProductId: productId,
        Quantity: 1
      }
   });
  }
  
  function doAddToCart(addToCartBean) {
    doCmdShopCart({
      Command: "AddToCart",
      AddToCart: {
        ItemList: [{
          Product: {
            ProductId: addToCartBean.ProductId  
          },
           OptionIDs: addToCartBean.OptionIDs,
           PerformanceIDs: ((addToCartBean.PerformanceId == null) ? null : [addToCartBean.PerformanceId]),
           QuantityUnit: addToCartBean.QuantityUnit,
           QuantityDelta: addToCartBean.QuantityDelta,
           Price: addToCartBean.Price,
           ValidDateFrom: addToCartBean.ValidFrom,
           ValidDateTo: addToCartBean.ValidTo,
           FirstUsageFrom: addToCartBean.FirstUsageFrom,
           FirstUsageTo: addToCartBean.FirstUsageTo
        }]
      }
    }, function() {
      if (addToCartBean.QuantityDelta > 0) {
        var item = getSelItem();
        if (item) {
          if (item.VariableDescription) {
            inputDialog(itl("@Product.VariableDescription"), null, null, null, false, function(txt) {
              if (item.ItemDetailList) {
                for (var i=0; i<quantityDelta; i++) 
                  item.ItemDetailList[item.ItemDetailList.length - i - 1].Description = txt;
              }
            });
          }
        }
      }
    });
  }
  
  function doEditItemQuantity(shopCartItemId, quantityDelta) {
    doCmdShopCart({
      Command: "EditItemQuantity",
      EditItemQuantity: {
        ShopCartItemId: shopCartItemId,
        QuantityDelta: quantityDelta
      }
    });
  }
  
  function doRemoveItem(shopCartItemId) {
    doCmdShopCart({
      Command: "RemoveItem",
      RemoveItem: {
        ShopCartItemId: shopCartItemId
      }
    });
  }
  
  function doEmptyShopCart(holdReleaseIfNeeded, callback) {
    doCmdShopCart({
      Command: "EmptyShopCart",
      EmptyShopCart: {
        HoldReleaseIfNeeded: holdReleaseIfNeeded
      }
    }, function() {
      refreshFolders();
      if (callback)
        callback();
    });
  }
  
  function doSetOwnerAccount(accountId, callback) {
    var reqDO = {
      Command: "SetOwnerAccount",
      SetOwnerAccount: {
        AccountId: accountId
      }
    };
    
    doCmdShopCart(reqDO, function() {
      refreshFolders();
      if (callback)
        callback();
    });
  }
  
  function doSetShipAccount(accountId, callback) {
    var reqDO = {
      Command: "SetShipAccount",
      SetShipAccount: {
        AccountId: accountId
      }
    };
    
    doCmdShopCart(reqDO, function() {
      if (callback)
        callback();
    });
  }
  
  function doSetPortfolioAccount(shopCartItemId, detailPosition, accountId, callback) {
    var reqDO = {
      Command: "SetPortfolioAccount",
      SetPortfolioAccount: {
        ShopCartItemId: shopCartItemId,
        DetailPosition: detailPosition,
        AccountId: accountId
      }
    };
    
    doCmdShopCart(reqDO, function() {
      if (callback)
        callback();
    });
  }
  
  function doSetSaleChannel(saleChannelId, recalcPrices, callback) {
    var reqDO = {
      Command: "SetSaleChannel",
      SetSaleChannel: {
        SaleChannelId: saleChannelId,
        RecalcPrices: recalcPrices
      }
    };
    
    doCmdShopCart(reqDO, callback);
  }
  
  function doPostTransaction(reqDO, callbackFunction) {
    reqDO.WorkstationId = <%=JvString.jsString(pageBase.getSession().getWorkstationId())%>;
    reqDO.UserAccountId = <%=JvString.jsString(pageBase.getSession().getUserAccountId())%>;
    
    shopCart = {};
    initShopCart();

    doStrongLock(reqDO.SaleId, function() {
      showWaitGlass();
      vgsService("PostTransaction", reqDO, false, function(ansDO) {
        hideWaitGlass();
        callbackFunction(ansDO.Answer);
      });
    });
  }
  
  function doStrongLock(saleId, callback) {
    if (saleId == null) {
      if (callback)
        callback();
    }
    else {
      snpAPI.cmd("Lock", "AcquireLock", {
        "EntityType": <%=LkSNEntityType.Sale.getCode()%>,
        "EntityId": saleId,
        "WorkstationId": <%=JvString.jsString(pageBase.getSession().getWorkstationId())%>,
        "UserAccountId": <%=JvString.jsString(pageBase.getSession().getUserAccountId())%>,
        "StrongLock": true
      }).then(ansDO => callback());
    }
  }
  
  function doReleaseLock(saleId, callback) {
    var reqDO = {
      Command: "ReleaseLock",
      ReleaseLock: {
        EntityType: <%=LkSNEntityType.Sale.getCode()%>,
        EntityId: saleId
      }
    };
    
    vgsService("Lock", reqDO, false, callback);
  }
  
  function doLoadShopCart(saleCode) {
    showWaitGlass();

    var reqDO = {
      Command: "LoadShopCart",
      LoadShopCart: {
        SaleCode: saleCode,
        AcquireLock: true
      }
    };
    
    doCmdShopCart(reqDO, function(ansDO) {
      hideWaitGlass();
      var lockInfo = (ansDO.Answer.LoadShopCart) ? ansDO.Answer.LoadShopCart.LockInfo : null;
      if ((lockInfo) && (lockInfo.LockId)) {
        asyncDialogEasy("../common/shopcart/salelock_dialog", "SaleId=" + lockInfo.EntityId);
      }
      else {
        setLastSaleId(shopCart.Reservation.SaleId);
        refreshFolders();
        
        if (!shopCart.Editable)
          showMessage(itl("@Reservation.ReservationNotEditable"));
      }
    });
  }
  
  $("#PerfDateFilter-picker").change(function() {
    doSearchPerformances(true);
  });
  
  $("#txtFilterAvailMin").keypress(function(event) {
    if (event.keyCode == KEY_ENTER) 
      doSearchPerformances(true);
    else if ((event.keyCode < KEY_0) || (event.keyCode > KEY_9))  
      event.preventDefault();
  });
  
  $("#perf-container .item-container").scroll(function() {
    var perc = 100 * this.scrollTop / (this.scrollHeight-this.clientHeight);
    if (!perfLoading && (perc > 95) && (perfTotalRecCount > perfPage * perfRecPerPage))
      doSearchPerformances(false);
  });

</script>
