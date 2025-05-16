<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageMobileSales" scope="request"/>

<script>
$(document).on("<%=pageBase.getEventMouseDown()%>",'.plus-btn', function(e) {
	e.stopPropagation();
	rel = $(this).attr("rel");

	var productId = new Array();
	productId = rel.split("_");
	
		
	
	    setProductQuantity(productId[0],productId[1], parseFloat(getProductQuantity(productId[0],productId[1])) + 1);
	    unitPrice = $("#cartContent .item.product-" + productId[0]+ ".attr-"+productId[1]+" .cartItemUnitPrice").html();
	    totalitems = totalitems + 1;
		totals = parseFloat(totals) + parseFloat(unitPrice);
	
		updateTotals(totalitems,totals);
});
$(document).on("<%=pageBase.getEventMouseDown()%>",'.minus-btn', function(e) {
	e.stopPropagation();
	rel = $(this).attr("rel");

	var productId = new Array();
	productId = rel.split("_");
	//if (getProductQuantity(productId)>1) {
    	setProductQuantity(productId[0],productId[1], parseFloat(getProductQuantity(productId[0],productId[1])) - 1);
    	unitPrice = $("#cartContent .item.product-" + productId[0]+ ".attr-"+productId[1]+" .cartItemUnitPrice").html();
    	totalitems = totalitems - 1;
		totals = parseFloat(totals) - parseFloat(unitPrice);
		updateTotals(totalitems,totals);
		if (parseFloat(getProductQuantity(productId[0],productId[1])) - 1 < 0) {
			var item = $("#cartContent .item").filter(".product-" + productId[0]+".attr-"+productId[1]);
			$("#"+ productId[0]+ " .productQtyCart").html("");
			item.remove();
		}
		
	//}
});
$(document).on("<%=pageBase.getEventMouseDown()%>",'.del-btn', function(e) {
	e.stopPropagation();
	rel = $(this).attr("rel");

	var productId = new Array();
	productId = rel.split("_");
	
	itemPrice = $("#cartContent .item.product-" + productId[0]+ ".attr-"+productId[1]+" .cartItemPrice").html();
	itemQty = $("#cartContent .item.product-" + productId[0]+ ".attr-"+productId[1]+ " .quantity").html();
	setProductQuantity(productId[0],productId[1], 0);
	totalitems = totalitems - itemQty;
	totals = parseFloat(totals) - parseFloat(itemPrice);
	updateTotals(totalitems,totals);
	var item = $("#cartContent .item").filter(".product-" + productId[0]+".attr-"+productId[1]);
	
	$("#"+ productId[0]+ " .productQtyCart").html("");
	
	item.remove();
});
var cartRowClass="even";
var cart = [];
var totals = 0;
var totalitems = 0;
$(document).on("<%=pageBase.getEventMouseDown()%>",".cartProductName",function() {
	
	product = JSON.parse(localStorage.getItem('Product_'+$(this).attr('rel')));
	//alert(localStorage.getItem('Product_'+$(this).attr('rel')));
	if (product.ProfilePictureId) {
		var image = '<v:config key="site_url"/>/repository?id='+product.ProfilePictureId+'&type=medium';
	}
	var HtmlProduct = 	'<div class="productItemContainer product">'+
							'<div class="productItemContent">'+
								'<div class="productImage" style="background-image: url('+image+');"></div>'+
							'</div>'+
						'</div>'+
						'<div id="productDetails">'+
							'<div id="productName">'+
								product.ProductName+
							'</div>'+
							'<div id="productDesc">'+
								((product.RichDescList.length>0) ? product.RichDescList[0].Description : "")+	
							'</div>'+
							'<div class="button dialogClose">Close</div>'+
							'<div class="productPrice">'+currency.Symbol+' '+product.PriceList[0].formatMoney(currency.RoundDecimals, DecimalSeparator, ThousandSeparator)+'</div>'+
						'</div>'
	
	showDialog(product.ProductName, HtmlProduct ,false,'','' );
});
function addProductToCart(productId) {
	var attr='';
	var attr2 = '';
	product = JSON.parse(localStorage.getItem('Product_'+productId));
	var item = $("#cartContent .item").filter(".product-" + product.ProductId);
	if (item.length == 0) {
		$.each(product.PriceList, function(index,value) {
			//alert(JSON.stringify(value));
			if ( ( !value.SaleChannelId)  && (!value.performanceTypeId) ) {
					price = value.Price;
			}
			if (SaleChannelId=='') {
				if ( ( !value.SaleChannelId)  && (!value.performanceTypeId) ) {
					price = value.Price;
					return false;
				}
			} else {
				
				if (value.SaleChannelId) {
					if (( value.SaleChannelId == SaleChannelId) && (!value.performanceTypeId) ) {
						price = value.Price;
						return false;
					}
				}
			}
		});
		if (cartRowClass=="even") {
			cartRowClass = "even";
		} else {
			cartRowClass = "even";
		}
		if (product.ProfilePictureId) {
			var image = '<v:config key="site_url"/>/repository?id='+product.ProfilePictureId+'&type=medium';
		}
		var item = $('.cartRows').append(
				'<tr class="item '+cartRowClass+' product-'+product.ProductId+' attr-'+attr+'" data-id="'+product.ProductId+'" data-attr="'+attr2+'">'+
					'<td class="productImage"><img src="'+image+'"</td>'+
					'<td class="cartProductName" rel="'+product.ProductId+'">'+((product.ProductName.length>30) ? product.ProductName.substr(0,10)+"..." : product.ProductName)+'</td>'+
					'<td class="cartItemUnitPrice">'+price.toFixed(2)+'</td>'+
					'<td class="quantity">0</td>'+
					"<td class='buttons'><div class='minus-btn button v-click enabled' rel='"+product.ProductId+"_"+attr+"'>-</div><div class='plus-btn button v-click enabled' rel='"+product.ProductId+"_"+attr+"'>+</div></td>"+
					'<td class="cartItemPrice"></td>'+
				'</tr>');
		var buttons = $("<td class='delete'/>").appendTo('.product-'+product.ProductId+'.attr-'+attr);
	    var btnDel = $("<div class='del-btn button v-click enabled' rel='"+product.ProductId+"_"+attr+"'>x</div>").appendTo(buttons);
	    //var btnMinus = $("<div class='minus-btn button v-click enabled' rel='"+product.ProductId+"'>-</div>").appendTo(buttons);
	    //var btnPlus = $("<div class='plus-btn button v-click enabled' rel='"+product.ProductId+"'>+</div>").appendTo(buttons);
	    
		item.data('product',product);
		setProductQuantity(product.ProductId,attr, parseFloat(getProductQuantity(product.ProductId,attr)) + 1);
	} else {
		setProductQuantity(product.ProductId,attr, parseFloat(getProductQuantity(product.ProductId,attr)) + 1);
	}
	totalitems = totalitems + 1;
	totals = parseFloat(totals) + parseFloat(price.toFixed(2));
	updateTotals(totalitems,totals);
	
	var imgtodrag = $("#"+product.ProductId+" .productImage");
	//var imgtodrag = $("#cartContent .item.product-" + product.ProductId).find("img").eq(0);
    if (imgtodrag) {
        imgclone = imgtodrag.clone()
            .offset({
            top: imgtodrag.offset().top,
            left: imgtodrag.offset().left
        })
            .css({
            'opacity': '0.5',
                'position': 'absolute',
                'height': '150px',
                'width': '150px',
                'z-index': '100',
               'background-size': 'contain',
            	'background-repeat': 'no-repeat'
        })
            .appendTo($('body'))
            .animate({
            'top': $('#mainHeaderCartButton').offset().top + 10,
                'left': $('#mainHeaderCartButton').offset().left + 10,
                'width': 75,
                'height': 75
        }, 800);
        
        imgclone.animate({
            'width': 0,
                'height': 0
        }, function () {
            $(this).detach()
        });
    }
}
function addProductToCartAttr(productId) {
	price = '';
	var attrHtml = '';
	var attr = '';
	var attr2 = '';
	product = JSON.parse(localStorage.getItem('Product_'+productId));
	$.each(product.PriceList, function(index,value) {
		//alert(JSON.stringify(value));
		if ( ( !value.SaleChannelId)  && (!value.performanceTypeId) ) {
				price = value.Price;
		}
		if (SaleChannelId=='') {
			if ( ( !value.SaleChannelId)  && (!value.performanceTypeId) ) {
				price = value.Price;
				return false;
			}
		} else {
			
			if (value.SaleChannelId) {
				if (( value.SaleChannelId == SaleChannelId) && (!value.performanceTypeId) ) {
					price = value.Price;
					return false;
				}
			}
		}
	});
	$.each($('#attr'+productId+ ' .attributeItemContent.selected'),function(index,value){
		var attrOptions = $(value).attr('data-attr');
		value = JSON.parse(attrOptions);
		//if (value.ProfilePictureId) {
		//	var image = '<v:config key="site_url"/>/repository?id='+value.ProfilePictureId+'&type=medium';
		//	attrHtml += '<img style="width:30px;" src="'+image+'" />';
		//}
		if (value.ShowNameExt) {
			if (value.AttributeItemNameExt) {
				var name = value.AttributeItemNameExt;			
			} else {
				var name = value.AttributeItemName;		
			}
		} else {
			var name = value.AttributeItemName;		
		}
		attrHtml += "<span style='font-size:12px;'><i>"+name+"</i></span>,";
		
		price = parseFloat(price+value.OptionalPrice);
		//attrHtml += '<img style="width:30px;" src="'+image+'" />';
		
		attr += value.AttributeItemId;
		attr2 += value.AttributeItemId+","; 
	});	
	attrHtml = attrHtml.substring(0, attrHtml.length - 1);

	product = JSON.parse(localStorage.getItem('Product_'+productId));
	var item = $("#cartContent .item").filter(".product-" + product.ProductId+'.attr-'+attr);
	if (item.length == 0) {
		if (cartRowClass=="even") {
			cartRowClass = "even";
		} else {
			cartRowClass = "even";
		}
		
		
		if (product.ProfilePictureId) {
			var image = '<v:config key="site_url"/>/repository?id='+product.ProfilePictureId+'&type=medium';
		}
		
		var item = $('.cartRows').append(
				'<tr class="item '+cartRowClass+' product-'+product.ProductId+' attr-'+attr+'" data-id="'+product.ProductId+'" data-attr="'+attr2+'">'+
					'<td class="productImage"><img src="'+image+'" /></td>'+
					'<td class="cartProductName" rel="'+product.ProductId+'">'+((product.ProductName.length>30) ? product.ProductName.substr(0,10)+"..." : product.ProductName)+'<br/>'+attrHtml+'</td>'+
					'<td class="cartItemUnitPrice">'+price.toFixed(2)+'</td>'+
					'<td class="quantity">0</td>'+
					"<td class='buttons'><div class='minus-btn button v-click enabled' rel='"+product.ProductId+"_"+attr+"'>-</div><div class='plus-btn button v-click enabled' rel='"+product.ProductId+"_"+attr+"'>+</div></td>"+
					'<td class="cartItemPrice"></td>'+
				'</tr>');
		var buttons = $("<td class='delete'/>").appendTo('.product-'+product.ProductId+'.attr-'+attr);
	    var btnDel = $("<div class='del-btn button v-click enabled' rel='"+product.ProductId+"_"+attr+"'>x</div>").appendTo(buttons);
	    //var btnMinus = $("<div class='minus-btn button v-click enabled' rel='"+product.ProductId+"'>-</div>").appendTo(buttons);
	    //var btnPlus = $("<div class='plus-btn button v-click enabled' rel='"+product.ProductId+"'>+</div>").appendTo(buttons);
	    
		item.data('product',product);
		setProductQuantity(product.ProductId,attr, parseFloat(getProductQuantity(product.ProductId,attr)) + 1);
	} else {
		setProductQuantity(product.ProductId,attr, parseFloat(getProductQuantity(product.ProductId,attr)) + 1);
	}
	totalitems = totalitems + 1;
	totals = parseFloat(totals) + parseFloat(price.toFixed(2));
	updateTotals(totalitems,totals);
	
	var imgtodrag = $("#"+product.ProductId+" .productImage");
	//var imgtodrag = $("#cartContent .item.product-" + product.ProductId).find("img").eq(0);
    if (imgtodrag) {
        imgclone = imgtodrag.clone()
            .offset({
            top: imgtodrag.offset().top,
            left: imgtodrag.offset().left
        })
            .css({
            'opacity': '0.5',
                'position': 'absolute',
                'height': '150px',
                'width': '150px',
                'z-index': '100',
               'background-size': 'contain',
            	'background-repeat': 'no-repeat'
        })
            .appendTo($('body'))
            .animate({
            'top': $('#mainHeaderCartButton').offset().top + 10,
                'left': $('#mainHeaderCartButton').offset().left + 10,
                'width': 75,
                'height': 75
        }, 800);
        
        imgclone.animate({
            'width': 0,
                'height': 0
        }, function () {
            $(this).detach()
        });
    }
}
function updateTotals(totalitems,totals) {
	
	$('#mainHeaderCartItems').html(totalitems+' item'+((totalitems>1) ? 's': '')+' in cart');
	$('#mainHeaderCartTotal').html(currency.Symbol+' '+totals.formatMoney(currency.RoundDecimals, DecimalSeparator, ThousandSeparator));
	$('.cartTotalQuantity').html("# "+totalitems);
	$('.cartTotalPrice').html(currency.Symbol+' '+totals.formatMoney(currency.RoundDecimals, DecimalSeparator, ThousandSeparator));
	if (totalitems==0) {
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
function getProductQuantity(ProductId,attr) {
	
	var cartItemQty = $("#cartContent .item.product-" + ProductId+ ".attr-"+attr+" .quantity").html();
	return cartItemQty;
}
function setProductQuantity(ProductId,attr, quantity,task) {
		var unitPrice = $("#cartContent .item.product-" + ProductId+ ".attr-"+attr+" .cartItemUnitPrice").html();
	    $("#cartContent .item.product-" + ProductId+ ".attr-"+attr+" .quantity").html(quantity);
	    $("#"+ ProductId+ " .productQtyCart").html("# "+quantity);
	    $("#cartContent .item.product-" + ProductId+ ".attr-"+attr+" .cartItemPrice").html((quantity*unitPrice).toFixed(2));

}
</script>
