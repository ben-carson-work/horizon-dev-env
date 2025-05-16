<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v"%>

<% PageMobileSales pageBase = (PageMobileSales)request.getAttribute("pageBase"); %>

<script type="text/javascript" id="cart-js.jsp" >
//# sourceURL=cart-js.jsp
$(document).on(clickAction,'.plus-btn', function(e) {
	e.stopPropagation();
	ShopCartItemId = $(this).attr("data-ShopCartitemId");

  ShopCart = localStorage.getItem('ShopCart');

  reqDO = {
    Command : 'EditItemQuantity',
    EditItemQuantity : {
      ShopCartItemId : ShopCartItemId,
      QuantityDelta: 1
      },
    FillApplicablePromoList : 1
  };

  if (ShopCart) {
    //reqDO['Shopcart'] = new Array();
    reqDO.ShopCart = JSON.parse(ShopCart);
  }
  
  //alert(JSON.stringify(reqDO));
  vgsService('ShopCart', reqDO, true,function(ansDO) {

    if (ansDO.Answer != null) {
      totalitems=0;
      console.log(JSON.stringify(ansDO.Answer.ShopCart.Items));
      localStorage.setItem('ShopCart', JSON.stringify(ansDO.Answer.ShopCart));
      localStorage.setItem('CartItems', JSON.stringify(ansDO.Answer.ShopCart.Items));
      
      ShopCart = ansDO.Answer.ShopCart;
      CartItems = ansDO.Answer.ShopCart.Items;
      
      populateCart(ShopCart);
    } else {

    }
  });
});
$(document).on(clickAction,'.minus-btn', function(e) {
	e.stopPropagation();
	ShopCartItemId = $(this).attr("data-ShopCartitemId");

  ShopCart = localStorage.getItem('ShopCart');

  reqDO = {
    Command : 'EditItemQuantity',
    EditItemQuantity : {
      ShopCartItemId : ShopCartItemId,
      QuantityDelta: -1
      },
    FillApplicablePromoList : 1
  };

  if (ShopCart) {
    //reqDO['Shopcart'] = new Array();
    reqDO.ShopCart = JSON.parse(ShopCart);
  }
  
  //alert(JSON.stringify(reqDO));
  vgsService('ShopCart', reqDO, true,function(ansDO) {

    if (ansDO.Answer != null) {
      totalitems=0;
      console.log(JSON.stringify(ansDO.Answer.ShopCart.Items));
      localStorage.setItem('ShopCart', JSON.stringify(ansDO.Answer.ShopCart));
      localStorage.setItem('CartItems', JSON.stringify(ansDO.Answer.ShopCart.Items));
      
      ShopCart = ansDO.Answer.ShopCart;
      CartItems = ansDO.Answer.ShopCart.Items;
      
      populateCart(ShopCart);
    } else {

    }
  });
});


$(document).on(clickAction,'.del-btn', function(e) {
	e.stopPropagation();
	ShopCartItemId = $(this).attr("data-ShopCartitemId");

	ShopCart = localStorage.getItem('ShopCart');

  reqDO = {
    Command : 'RemoveItem',
    RemoveItem : {
      ShopCartItemId : ShopCartItemId
      },
    FillApplicablePromoList : 1
  };

  if (ShopCart) {
    //reqDO['Shopcart'] = new Array();
    reqDO.ShopCart = JSON.parse(ShopCart);
  }
  
  //alert(JSON.stringify(reqDO));
  vgsService('ShopCart', reqDO, true,function(ansDO) {

    if (ansDO.Answer != null) {
      totalitems=0;
      //console.log(JSON.stringify(ansDO.Answer.ShopCart.Items));
      localStorage.setItem('ShopCart', JSON.stringify(ansDO.Answer.ShopCart));
      localStorage.setItem('CartItems', JSON.stringify(ansDO.Answer.ShopCart.Items));
      ShopCart = ansDO.Answer.ShopCart;
      CartItems = ansDO.Answer.ShopCart.Items;
      
      populateCart(ShopCart);
      
    } else {

    }
  });
});

$(document).on(clickAction,'#mainHeaderClearCart', function(e) {
  var title = 'Empty Cart?';
  var msg = 'Are you sure you want to empty your shopcart?';
  var buttons = [<v:itl key="@Common.Yes" encode="JS"/>, <v:itl key="@Common.Cancel" encode="JS"/>];
  showMobileQueryDialog2(title, msg, buttons, function(index) {
    if (index == 0) {
      e.stopPropagation();
      ShopCartItemId = $(this).attr("data-ShopCartitemId");
      ShopCart = localStorage.getItem('ShopCart');
      reqDO = {
        Command : 'EmptyShopCart',
        EmptyShopCart : {
          HoldReleaseIfNeeded : 'true'
          },
        FillApplicablePromoList : 1
      };
      if (ShopCart) {
        //reqDO['Shopcart'] = new Array();
        reqDO.ShopCart = JSON.parse(ShopCart);
      }
      //alert(JSON.stringify(reqDO));
      vgsService('ShopCart', reqDO, true,function(ansDO) {
        if (ansDO.Answer != null) {
          totalitems=0;
          //console.log(JSON.stringify(ansDO.Answer.ShopCart.Items));
          localStorage.setItem('ShopCart', JSON.stringify(ansDO.Answer.ShopCart));
          localStorage.setItem('CartItems', JSON.stringify(ansDO.Answer.ShopCart.Items));
          ShopCart = ansDO.Answer.ShopCart;
          CartItems = ansDO.Answer.ShopCart.Items;
          populateCart(ShopCart);
          if ($('.checkoutRows').html() !== "")
        	  populateCheckoutCart();
          mainactivity(mainactivity_step.catalog);
        } else {
        }
      });
      $(document).find('.quantityInCart').html('');
    }
   return true;
  });
});

function populateCart(ShopCart) {
  $('.cartRows').html("");
  $(document).find('.quantityInCart').text('');
  $.each(ShopCart.Items, function(index,value) {
   console.log(JSON.stringify(value));
    if(showNetPrices) {
      Price = value.TotalNetFull.toFixed(2);
    } else {
      Price = value.TotalGrossFull.toFixed(2);
    }
    var image;
    var imgbgstyle;

    if(!value.ProfilePictureId) {
      image = GenerateIconUrl(value.IconName,"64");
      imgbgstyle = 'background-size: 80%;';
    } else {
      image = '<v:config key="site_url"/>/repository?id='+value.ProfilePictureId+'&type=medium';
    }
    
    var attrhtml='';
    var ValidDateTo ='';
    var ValidDateFrom ='';
    if(value.ItemDetailList) {
      if(value.ItemDetailList[0].ValidDateFrom)
      ValidDateFrom = <v:itl key="@Common.ValidFrom" encode="JS"/>+" "+formatDate(xmlToDate(value.ItemDetailList[0].ValidDateFrom), <%=pageBase.getRights().ShortDateFormat.getInt()%>);
      if(value.ItemDetailList[0].ValidDateTo)
      ValidDateTo = <v:itl key="@Common.ValidTo" encode="JS"/>+" "+formatDate(xmlToDate(value.ItemDetailList[0].ValidDateTo), <%=pageBase.getRights().ShortDateFormat.getInt()%>);
    }
    if(value.OptionList) { 
      $.each(value.OptionList,function(attributeKey,attributeValue) {
        attrhtml = attrhtml+attributeValue.AttributeItemName+", ";
        });
      attrhtml = attrhtml.substring(0, attrhtml.length - 2);
    }
    var product2 = JSON.parse(localStorage.getItem('Product_'+value.ProductId));
    
    //var form = getForm(product.AccountCategoryId,savedData);
    if(product2) {
    	
    	if(product2.RequireAccount)
    	{
    		getCategoryTree(product2.AccountCategoryId);
    	}
    }
    
    var performanceText='';
    if(value.PerformanceList) {
      
      $.each(value.PerformanceList,function(performanceKey,performanceValue) {
        performanceText = formatDate(xmlToDate(performanceValue.DateTimeFrom), <%=pageBase.getRights().ShortDateFormat.getInt()%>)+" "+formatTime(xmlToDate(performanceValue.DateTimeFrom), <%=pageBase.getRights().ShortTimeFormat.getInt()%>)+"<br />"+formatDate(xmlToDate(performanceValue.DateTimeTo), <%=pageBase.getRights().ShortDateFormat.getInt()%>)+" "+formatTime(xmlToDate(performanceValue.DateTimeTo), <%=pageBase.getRights().ShortTimeFormat.getInt()%>);
        });
      //performance = performance.substring(0, performance.length - 2);
    }
    $('.cartRows')
    .append('<tr class="item pref-item product-'+value.ProductId+' " data-id="'+value.ProductId+'" data-ShopCartItemId="'+value.ShopCartItemId+'" data-attr="">'
            + '<td class="productImage rowicon"><img src="'
            + image
            + '"</td>'
            + '<td class="cartProductName" rel="'+value.ProductId+'" style="'+((value.ProductName.length > 40) ? "font-size:15px;" : '')+'; line-height: 20px;">'
            + '<div>' + value.ProductName + '</div>' 
            + ((attrhtml != '')? '<div><span style="font-size:11px">'+attrhtml+'</span></div>' : "")
            + ((ValidDateFrom != '')? '<div><span style="font-size:11px">'+ValidDateFrom+'</span></div>' : "")
            + ((ValidDateTo != '')? '<div><span style="font-size:11px">'+ValidDateTo+'</span></div>' : "")
            + ((performanceText != '')? '<div><span style="font-size:11px">'+performanceText+'</span></div>' : "")
            + '</td>'
            + '<td class="cartItemUnitPrice">'
            + value.UnitAmount.toFixed(2)
            + '</td>'
            + '<td class="quantity">'+value.Quantity+'</td>'
            + "<td class='buttons'>"
            + "<div class='minus-btn btn btn-primary v-click "+((value.ActionMinus.Enabled) ? "enabled" : "disabled") +"' data-ShopCartitemId='"+value.ShopCartItemId+"'>-</div>"
            + "<div class='plus-btn btn btn-primary v-click "+((value.ActionPlus.Enabled) ? "enabled" : "disabled") +"' data-ShopCartitemId='"+value.ShopCartItemId+"'>+</div>"
            + "</td>"
            + '<td class="cartItemPrice">'+Price+'</td>' + '</tr>');
    var buttons = $("<td class='delete'/>").appendTo($('.cartRows').find("tr[data-ShopCartItemId='" + value.ShopCartItemId + "']"));
    if(value.ActionTrash.Enabled) {
      var btnDel = $("<div class='del-btn btn btn-primary v-click enabled' data-ShopCartitemId='"+value.ShopCartItemId+"'>x</div>").appendTo(buttons);
    }
    totalitems = totalitems + value.Quantity;
    updateItemsInCart(value.ProductId,value.Quantity);
  });
  
  totals = ShopCart.TotalAmount;
  updateTotals(totalitems, totals);
  if(totalitems>0) {
    $('#mainHeaderClearCart').removeClass('disabled');
    $('#mainHeaderContinue').removeClass('disabled');
  } else {
    $('#mainHeaderClearCart').addClass('disabled');
    $('#mainHeaderContinue').addClass('disabled');
  }
  
 
  switch (mainactivityStep) {
  case mainactivity_step.mediaAssoc:
    mainactivity(mainactivity_step.home);
    break;
  }
}
var cartRowClass="even";
var cart = [];
var totals = 0;
var totalitems = 0;
$(document).on(clickAction,".cartProductName",   function() {

    product = JSON.parse(localStorage.getItem('Product_'
        + $(this).attr('rel')));
    //alert(localStorage.getItem('Product_'+$(this).attr('rel')));
    if (product.ProfilePictureId) {
      var image = '<v:config key="site_url"/>/repository?id='
          + product.ProfilePictureId + '&type=medium';
    }
    var HtmlProduct = '<div class="productItemContainer product">'
        + '<div class="productItemContent">'
        + '<div class="productImage" style="background-image: url('
        + image
        + ');"></div>'
        + '</div>'
        + '</div>'
        + '<div id="productDetails">'
        + '<div id="productName">'
        + product.ProductName
        + '</div>'
        + '<div id="productDesc">'
        + ((product.RichDescList.length > 0) ? product.RichDescList[0].Description : "")
        + '</div>'
        + '<div class="button dialogClose">Close</div>'
        + '<div class="productPrice">'
        + currency.Symbol
        + ' '
        + product.PriceList[0].formatMoney(currency.RoundDecimals,
            DecimalSeparator, ThousandSeparator) + '</div>' + '</div>'

    showDialog(product.ProductName, HtmlProduct, false, '', '');
  });
  var CartItems;
  
  function addProductToCart(productId,performanceId,quantity,endDatedProduct,startDatedProduct,options) {
    var attr = '';
    var attr2 = '';
    
    //product = JSON.parse(localStorage.getItem('Product_' + productId));
    //var item = $("#cartContent .item").filter(".product-" + product.ProductId);
    if(!quantity==null) {
      quantity= 1;
    }
    if(!endDatedProduct) {
      var endDatedProduct;
    } else {
      var endDatedProduct=formatDate2(endDatedProduct,'Y,m,d',"-")+"T00:00:00";
    }
    if(!startDatedProduct) {
      var startDatedProduct;
    } else {
      var startDatedProduct=formatDate2(startDatedProduct,'Y,m,d',"-")+"T00:00:00";
    }
    
    var ShopCart = localStorage.getItem('ShopCart');
    if(!options) {
      var options=null;
    }
    var reqDO = {
      Command : 'AddToCart',
      AddToCart : {
        ProductId : productId,
        PerformanceId : performanceId,
        QuantityDelta : quantity,
        OptionIDs: options,
        ValidDateFrom:startDatedProduct,
        ValidDateTo:endDatedProduct
      },
      FillApplicablePromoList : 1
    };

    if (ShopCart) {
      //reqDO['Shopcart'] = new Array();
      reqDO.ShopCart = JSON.parse(ShopCart);
    }
    
    //alert(JSON.stringify(reqDO));
    vgsService('ShopCart', reqDO, true,function(ansDO) {
      if (ansDO.Answer != null) {
        totalitems = 0;
        console.log(ansDO.Answer.ShopCart);
        localStorage.setItem('ShopCart', JSON.stringify(ansDO.Answer.ShopCart));
        localStorage.setItem('CartItems', JSON.stringify(ansDO.Answer.ShopCart.Items));
        ShopCart = ansDO.Answer.ShopCart;
        CartItems = ansDO.Answer.ShopCart.Items;
        populateCart(ShopCart);
      } else {
  
      }
    });
  }
  
  function updateItemsInCart(productId,quantity) {
    $(document).find("[data-productId='" + productId + "']").find('.quantityInCart').text("# "+quantity);
  }

  function addProductToCartAttr(productId) {
    price = '';
    var attrHtml = '';
    var attr = '';
    var attr2 = '';
    product = JSON.parse(localStorage.getItem('Product_' + productId));
    
    $.each($('#attr' + productId + ' .attributeItemContent.selected'),function(index, value) {
        var attrOptions = $(value).attr('data-attr');
        value = JSON.parse(attrOptions);
        attr += value.AttributeItemId;
        attr2 += value.AttributeItemId + ",";
      });
    attr2 = attr2.substring(0, attr2.length - 1);

    addProductToCart(productId,null,1,null,null,attr2);
    return false;
    
  }
  function updateTotals(totalitems, totals) {

    $('#mainHeaderCartItems').html(totalitems + ' item' + ((totalitems > 1) ? 's' : '') + ' in cart');
    $('#mainHeaderCartTotal').html(
        currency.Symbol
            + ' '
            + totals.formatMoney(currency.RoundDecimals, DecimalSeparator,
                ThousandSeparator));
    $('.cartTotalQuantity').html("# " + totalitems);
    $('.miniCartItemsValue').html("# " + totalitems);
    $('.miniCartSubTotalValue').html(
        currency.Symbol
            + ' '
            + totals.formatMoney(currency.RoundDecimals, DecimalSeparator,
                ThousandSeparator));
    $('.miniCartTotalValue').html(
        currency.Symbol
            + ' '
            + totals.formatMoney(currency.RoundDecimals, DecimalSeparator,
                ThousandSeparator));
    if (totalitems == 0) {
      $('#mainHeaderCart').addClass('disabled');
      $('#mainHeaderCartButton').addClass('disabled');
      $('#mainHeaderCheckoutButton').addClass('disabled');
      $('.cartTotals').addClass('hidden');
    } else {
      $('#mainHeaderCart').removeClass('disabled');
      $('#mainHeaderCartButton').removeClass('disabled');
      $('#mainHeaderCheckoutButton').removeClass('disabled');
      $('.cartTotals').removeClass('hidden');
    }
  }
  function getProductQuantity(ProductId, attr) {

    var cartItemQty = $(
        "#cartContent .item.product-" + ProductId + ".attr-" + attr
            + " .quantity").html();
    return cartItemQty;
  }
  function setProductQuantity(ProductId, attr, quantity, task) {
    var unitPrice = $(
        "#cartContent .item.product-" + ProductId + ".attr-" + attr
            + " .cartItemUnitPrice").html();
    $(
        "#cartContent .item.product-" + ProductId + ".attr-" + attr
            + " .quantity").html(quantity);
    $("#" + ProductId + " .productQtyCart").html("# " + quantity);
    $(
        "#cartContent .item.product-" + ProductId + ".attr-" + attr
            + " .cartItemPrice").html((quantity * unitPrice).toFixed(2));

  }
</script>
