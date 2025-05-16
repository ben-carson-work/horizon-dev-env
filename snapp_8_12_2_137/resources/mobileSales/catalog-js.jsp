<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v"%>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageMobileSales"
	scope="request" />

<script>
$(document).on("<%=pageBase.getEventMouseDown()%>",".breadcrumbNode",function() {
	if ($('#catalogContainer').hasClass("hidden")) {
	
	} else {
		if ($(this).hasClass('last')) {
    		
		} else {
			//$('.addtocartAttribute').addClass('hidden'); 
			var path = parseInt($(this).attr('data-id'));
    		renderFolder(catalog_path[path]);
    		if ((catalog_path.length-path)>0) {
    			var count = catalog_path.length;
    			if (count-(path+1)>0) {
    	    		for (var i=1; i<=(count-(path+1)); i++) {
    	    			catalog_path.pop();
    	    			breadcrumbPath['catalog'].pop();
    	    			$('#mainBreadcrumbsPath .breadcrumbNode').last().remove();
    	    			$('#mainBreadcrumbsPath .breadcrumbNode').last().addClass('last');
    	    		}
    			}
    		}
		}
	}
});
$(document).on("<%=pageBase.getEventMouseDown()%>",".infoProduct",function(e) {
	e.stopPropagation();
	product = JSON.parse(localStorage.getItem('Product_'+$(this).attr('rel')));
	//alert(JSON.stringify(product.AttributeItemList));
	//alert(localStorage.getItem('Product_'+$(this).attr('rel')));
	var image = '<v:config key="site_url"/>/repository?id='+product.ProfilePictureId+'&type=medium';
	if (product.ShowNameExt) {
		if (product.ProductNameExt) {
			var name = product.ProductNameExt;			
		} else {
			var name = product.ProductName;		
		}
	} else {
		var name = product.ProductName;		
	}
	var hasAttributes = false;
	if (product.AttributeItemList!= null) {
    	$.each(product.AttributeItemList,function(index,value) {
    		if(value.SelectionType>1) {
    			hasAttributes = true;
    			return false;
    		} else {
    			hasAttributes = false;
    		}
    		
    	});
	}
	var HtmlProduct = '<div class="productItemContainer product">'
								+ '<div class="productItemContent">'
								+ '<div class="productImage" style="background-image: url('
								+ image
								+ ');"></div>'
								+ '</div>'
								+ '</div>'
								+ '<div id="productDetails" class="scrolling">'
								+ '<div id="productName">'
								+ name;
								if (hasAttributes == true) {
									HtmlProduct += ' <i style="font-size:12px;">(with attributes)</i>';
								}
		HtmlProduct += 			'</div>'
								+ '<div id="productDesc">'
								+ ((product.RichDescList.length > 0) ? product.RichDescList[0].Description
										: "")
								+ '</div>'
								+ '<div class="button dialogClose">Close</div>'
								+ '<div class="productPrice">'
								+ currency.Symbol
								+ ' '
								+ product.PriceList[0].Price.formatMoney(currency.RoundDecimals, DecimalSeparator, ThousandSeparator) 
								+ '</div>';

						if (hasAttributes == false) {
							HtmlProduct += '<div class="button addtocart" rel="'+product.ProductId+'">Cart</div>';
						}

						HtmlProduct += '</div>';
						showDialog(name, HtmlProduct, false, '','');
					});
	$(document).on("click", '.dialogClose', function() {
		$('#dialogBG').hide();
	});
	$(document).on("<%=pageBase.getEventMouseDown()%>",'.addtocart', function() {
	//alert($(this).attr('rel'));
	
	addProductToCart($(this).attr('rel'));
	$('#dialogBG').hide();
  });
$(document).on("<%=pageBase.getEventMouseDown()%>",'.addtocartAttribute', function() {
	var rel = $(this).attr('rel');
	
	
	addProductToCartAttr($(this).attr('rel'));
	//$('#dialogBG').hide();
  });
  

  
$(document).on("click",'.product', function() {
	//alert($(this).attr('rel'));
	addProductToCart($(this).find('.productItemContent').attr('rel'));
  }); 
$(document).on("click",'.attributeItemContent', function() {
	//alert($(this).attr('rel'));
	//addProductToCart($(this).attr('rel'));
	
	//alert(attributeItemContent.html());
	
	if ( ( $(this).hasClass("selected") ) && ( !$(this).hasClass("mandatory") ) ) {
		$(this).removeClass("selected");
		$(this).parent().removeClass("selected");
		
	} else {
		$(this).parent().parent().find('.selected').removeClass("selected");
		//$(this).parent().parent().find('.attributeItemContent').removeClass("selected");
		$(this).addClass("selected");
		$(this).parent().addClass("selected");
	}
	
	var productId = $(this).parent().parent().parent().find('.addtocartAttribute').attr('rel');
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
		price = parseFloat(price+value.OptionalPrice);
		
	});	
	
	$('.addtocartAttribute[rel='+productId+'] span').html( currency.Symbol+' ' +price.formatMoney(currency.RoundDecimals, DecimalSeparator, ThousandSeparator));
	//alert(price);
  });
$(document).on("<%=pageBase.getEventMouseDown()%>","#mainHeaderBack", function() {
	if ($('#catalogContainer').hasClass("hidden")) {
		$('#cartContainer').addClass("hidden");
	   	$('#catalogContainer').removeClass('hidden');
	   	$('#mainHeaderCartButton').removeClass('hidden');
		$('#mainHeaderCheckoutButton').addClass('hidden');
		$('#transactionResultContainer').addClass('hidden');
		$('#checkoutContainer').addClass('hidden');
	   breadcrumb('','catalog','3');
	} else {
		catalog_path.pop();
		breadcrumbPath['catalog'].pop();
	   	$('#mainBreadcrumbsPath .breadcrumbNode').last().remove();
		$('#mainBreadcrumbsPath .breadcrumbNode').last().addClass('last');
		
	   	if (catalog_path.length == 0) {
	     	renderFolder(window.catalog);
	    } else {
	    	var folder = catalog_path[catalog_path.length-1];
	     	renderFolder(folder);
	   	}
	}
	refreshSaleButtons();
});
function renderMultipleCatalogs(WKId,MainCatalogId,CatalogIDs) {
	
	CatalogIDs = str.split(",");
	if ($('#'+WKId).length){
    } else {
		 $("#catalogContainer").append("<div class='catalog hidden' id='"+WKId+"'/>");
		 var div = $('#'+WKId);
		 
			 $.each(CatalogIDs, function( index, value ) {
				//alert(JSON.stringify(folder));

					addFolderButton(div, value);
			});
		
    }
	$(document).find('.catalog').addClass('hidden');
	$('#'+folder.CatalogId).removeClass('hidden');
  	currentFolder = folder;
  	refreshSaleButtons();
	   
}
function renderFolder(folder) {
	if ($('#'+folder.CatalogId).length){
    } else {
		 $("#catalogContent").append("<div class='catalog hidden' id='"+folder.CatalogId+"'/>");
		 var div = $('#'+folder.CatalogId);
		 if (folder.Nodes != null) {
			 $.each(folder.Nodes, function( index, value ) {
				//alert(JSON.stringify(folder));
				
				if (value.EntityType==12) {
				 	addProductButton(div, value);
				} else if (value.EntityType==5) {
				 	addEventButton(div, value);
				} else {
					addFolderButton(div, value);
				}
			});
		}
		$(div).append('<br clear="all" />');
    }
	$(document).find('.catalog').addClass('hidden');
	$('#'+folder.CatalogId).removeClass('hidden');
  	currentFolder = folder;
  	refreshSaleButtons();
	   
}
function renderAttributes(ProductId) {
	if ($('#attr'+ProductId).length){
    } else {
		product = JSON.parse(localStorage.getItem('Product_'+ProductId));
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
		//alert(JSON.stringify(product.AttributeItemList));
		 $("#catalogContent").append("<div class='catalog hidden' id='attr"+ProductId+"' rel='"+ProductId+"'/>");
		 var div = $('#attr'+product.ProductId);
		 $(div).append('<div class="button addtocartAttribute" rel="'+ProductId+'""><span></span><br/>Add to Cart</div>');
		 
		 var attributePrice = 0;
		 
		 if (product.AttributeItemList != null) {
			 $.each(product.AttributeItemList, function( index, value ) {
				
				if (value.SelectionType>1) {
				 	attributePrice = parseFloat( attributePrice + addAttributeButton  (div, value ) );
				}
				
			});
		}
		 //$(div).append('<div class="button addtocartAttribute" rel="'+ProductId+'"">Add to Cart</div>');
		$(div).append('<br clear="all" />');
		price = price+attributePrice;
		$('.addtocartAttribute[rel='+ProductId+'] span').html( currency.Symbol+' ' +price.formatMoney(currency.RoundDecimals, DecimalSeparator, ThousandSeparator));
    }
	
	$(document).find('.catalog').addClass('hidden');
	
	$('#attr'+ProductId).removeClass('hidden');
  	currentFolder = product;
  	refreshSaleButtons();
	   
}
function addFolderButton(target, folder) {
	 
  var image = '';
  if (folder.ProfilePictureId)
    image = '<v:config key="site_url"/>/repository?id='+folder.ProfilePictureId+'&type=medium';

	var btn = $('<div class="categoryItemContainer folder" />').appendTo(target);
	var categoryItemContent = $('<div class="categoryItemContent" />').appendTo(btn);
	 
	$('<div class="categoryImage" style="background-image: url('+image+');" />').appendTo(categoryItemContent);
	
	if (folder.ShowNameExt) {
		if (folder.CatalogNameExt) {
			var name = folder.CatalogNameExt;			
		} else {
			var name = folder.CatalogName;		
		}
	} else {
		var name = folder.CatalogName;		
	}
	
	$('<div class="categoryName">'+name+'</div>').appendTo(categoryItemContent);
	btn.addClass("enabled", (folder.Nodes.length > 0));
	btn.bind("click", function() {
			doclick = true;
			if (btn.hasClass("enabled") && doclick) {
				catalog_path.push(folder);
				renderFolder(folder);
				breadcrumb(folder.CatalogName, 'catalog', 1);
			}
		});
	}
	function addEventButton(target, folder) {
		//alert(JSON.stringify(folder));
		 var image = '';
		  if (folder.ProfilePictureId)
		    image = '<v:config key="site_url"/>/repository?id='+folder.ProfilePictureId+'&type=medium';

			var btn = $('<div class="categoryItemContainer folder" />').appendTo(target);
			var categoryItemContent = $('<div class="categoryItemContent" />').appendTo(btn);
			 
			$('<div class="categoryImage" style="background-image: url('+image+');" />').appendTo(categoryItemContent);
			$('<div class="categoryName">'+folder.CatalogName+'</div>').appendTo(categoryItemContent);
			btn.addClass("enabled", (folder.Nodes.length > 0));
			
	}
	var price = '';
	var attributes = '';
	function addProductButton(target, folder) {
		//var btn = addCatalogButton(target, "product", folder.CatalogName, "", folder.BackgroundColor,folder.ProfilePictureId);
		//alert(JSON.stringify(folder));
		product = JSON.parse(localStorage.getItem('Product_'+folder.EntityId));
		if (product.ShowNameExt) {
			if (product.ProductNameExt) {
				var name = product.ProductNameExt;			
			} else {
				var name = product.ProductName;		
			}
		} else {
			var name = product.ProductName;		
		}
		var btn = $('<div class="productItemContainer product" />').appendTo(target);
		if (product.AttributeItemList!= null) {
    		$.each(product.AttributeItemList,function(index,value) {
    			if(value.SelectionType>1) {
    				attributes = 'attributes';
    				btn.addClass('attributes');
    				btn.removeClass('product');
    				btn.bind("click", function() {
    					doclick = true;
    
    					if (doclick) {
    						catalog_path.push(folder);
    						renderAttributes(folder.EntityId);
    						//$('.addtocartAttribute').attr('rel',product.ProductId);
    						//$('.addtocartAttribute').removeClass('hidden');
    						breadcrumb(name, 'catalog', 1);
    					}
    					
    				});
    				return false;
    			} else {
    				attributes = '';
    			}
    		});
		}
		
		
		var image = '';
		if (folder.ProfilePictureId)
			image = '<v:config key="site_url"/>/repository?id='+ folder.ProfilePictureId + '&type=medium';

			$.each(folder.PriceList, function(index,value) {
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
			
			if (product.ShowNameExt) {
				if (product.ProductNameExt) {
					var name = product.ProductNameExt;			
				} else {
					var name = product.ProductName;		
				}
			} else {
				var name = product.ProductName;		
			}
			
		$(btn).append(
						'<div class="productItemContent" id="'+folder.EntityId+'" rel=\''+folder.EntityId+'\'>'
								+ '<div class="infoProduct button" rel="'+folder.EntityId+'">i</div>'
								+ '<div class="productImage" style="background-image: url('+ image + ');"></div>'
								+ '<div class="productName">'
								+ name
								+ '</div>'
								+ '<div class="productPriceContainer">'
								+
								'<span class="productQtyCart"></span>'
								+ '<span class="productPrice">'
								+ currency.Symbol
								+ ' '
								+ price.formatMoney(currency.RoundDecimals, DecimalSeparator, ThousandSeparator) + '</span>' +
								'</div>' + 
						'</div>');

	}
	function addAttributeButton(target, attribute) {
		//var btn = addCatalogButton(target, "product", folder.CatalogName, "", folder.BackgroundColor,folder.ProfilePictureId);
		//alert(JSON.stringify(attribute.OptionList));
		if (attribute.SelectionType>2) {
			var mandatory = 'mandatory';
		} else {
			var mandatory = '';
		}
		
		var price = 0;
		
		var attributecontainer = $('<div class="attributeContainer" rel="'+attribute.AttributeItemId+'" />').appendTo(target);
		$(attributecontainer).append('<h1>'+attribute.AttributeName+( (attribute.SelectionType>2) ? '*' : '' )+'</h1>');
		$.each(attribute.OptionList,function(index,value) {
			if (!value.OptionalPrice) {
				value.OptionalPrice = 0;
			}
			
			if (value.AttributeItemName==attribute.AttributeItemName) {
				var selected = 'selected';
				price = parseFloat(price+value.OptionalPrice);
			} else {
				var selected = '';
			}

			if (value.ShowNameExt) {
				if (value.AttributeItemNameExt) {
					var name = value.AttributeItemNameExt;			
				} else {
					var name = value.AttributeItemName;		
				}
			} else {
				var name = value.AttributeItemName;		
			}
			
			var btn = $('<div class="productItemContainer attribute '+selected+'" />').appendTo(attributecontainer);
			var image = '';
			if (value.ProfilePictureId) image = '<v:config key="site_url"/>/repository?id='+ value.ProfilePictureId + '&type=medium';		
			
			$(btn).append(
							'<div class="attributeItemContent '+selected+' '+mandatory+'" id="'+value.AttributeItemId+'" rel="'+value.AttributeItemId+'" data-attr=\''+JSON.stringify(value)+'\'>'
									+ '<div class="productImage" style="background-image: url('+ image + ');"></div>'
									+ '<div class="productName">'
									+ name
									+ '</div>'
									+ '<div class="productPriceContainer">'
									+ '<span class="productQtyCart"></span>'
									+ '<span class="productPrice">'
									+ currency.Symbol
									+ ' '
									+ value.OptionalPrice.formatMoney(currency.RoundDecimals, DecimalSeparator, ThousandSeparator) + '</span>' +
									'</div>' + 
							'</div>');
		});
		$(target).append('<br clear="all" />');
		
		return price;
	}
	
	function refreshSaleButtons() {
		if (catalog_path.length > 0) {
			$("#mainHeaderBack").removeClass('hidden');
			//$("#mainHeaderHome").removeClass('hidden');
		} else {
			if (!$("#mainHeaderBack").hasClass('hidden')) {
				$("#mainHeaderBack").addClass('hidden');
				//$("#mainHeaderHome").addClass('hidden');
			}
		}
		//alert(catalog_path.length);
	}
</script>