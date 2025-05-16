<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v"%>

<%
PageMobileSales pageBase = (PageMobileSales) request.getAttribute("pageBase");
%>

<script type="text/javascript" id="catalog-js.jsp"> 
//# sourceURL=catalog-js.jsp
$(document).on(clickAction, ".breadcrumbNode", function () {
  if ($('#catalogContainer').hasClass("hidden")) {}
  else {
    if ($(this).hasClass('last')) {}
    else {
      //$('.addtocartAttribute').addClass('hidden');
      var path = parseInt($(this).attr('data-id'));
      renderFolder(catalog_path[path]);
      if ((catalog_path.length - path) > 0) {
        var count = catalog_path.length;
        if (count - (path + 1) > 0) {
          for (var i = 1; i <= (count - (path + 1)); i++) {
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

$(document).on(clickAction, ".infoProduct", function (e) {
  var description
  e.stopPropagation();
  product = JSON.parse(localStorage.getItem('Product_' + $(this).attr('rel')));

  if (product.ProfilePictureId != null) {
    var image = '<v:config key="site_url"/>/repository?id=' + product.ProfilePictureId + '&type=medium';
  }
  if (product.ShowNameExt) {
    if (product.ProductNameExt) {
      var name = product.ProductNameExt;
    } else {
      var name = product.ProductName;
    }
  } else {
    var name = product.ProductName;
  }
  if (product.RichDescList != null) {
    description = product.RichDescList[0].Description;
  } else {
    description = '';
  }
  var hasAttributes = false;
  if (product.AttributeItemList != null) {
    $.each(product.AttributeItemList, function (index, value) {
      if (value.SelectionType > 1) {
        hasAttributes = true;
        return false;
      } else {
        hasAttributes = false;
      }

    });
  }

  $('#myModal').find('.modal-header').html(name + '<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>');
  $('#myModal').find('.modal-body').html(description);
  $('#myModal').find('.modal-footer').html('');
  $('#myModal').modal();
});

$(document).on(clickAction, '.addtocartAttribute', function () {
  $('#floatingBarsGbg').show();
  var rel = $(this).attr('rel');
  addProductToCartAttr($(this).attr('rel'));
  $('#floatingBarsGbg').hide();
});

function adddatedproduct(ExpRule) {
  var startDatedProduct = null;
  productId = $('#datedproductId').val();
  addProductToCart(productId, null, null, datedProduct, startDatedProduct);
  $('#myModal').modal('toggle');
}
  
$(document).on(clickAction, '.attributeItemContent', function () {
  //alert($(this).attr('rel'));
  //addProductToCart($(this).attr('rel'));

  //alert(attributeItemContent.html());

  if (($(this).hasClass("selected")) && (!$(this).hasClass("mandatory"))) {
    $(this).removeClass("selected");
    $(this).parent().removeClass("selected");

  } else {
    $(this).parent().parent().find('.selected').removeClass("selected");
    //$(this).parent().parent().find('.attributeItemContent').removeClass("selected");
    $(this).addClass("selected");
    $(this).parent().addClass("selected");
  }

  var productId = $(this).parent().parent().parent().find('.attributeSummary').attr('rel');
  product = JSON.parse(localStorage.getItem('Product_' + productId));

  $.each(product.PriceList, function (index, value) {
    //alert(JSON.stringify(value));
    if ((!value.SaleChannelId) && (!value.performanceTypeId)) {
      price = value.Price;
    }
    if (SaleChannelId == '') {
      if ((!value.SaleChannelId) && (!value.performanceTypeId)) {
        price = value.Price;
        return false;
      }
    } else {

      if (value.SaleChannelId) {
        if ((value.SaleChannelId == SaleChannelId) && (!value.performanceTypeId)) {
          price = value.Price;
          return false;
        }
      }
    }
  });
  $.each($('#attr' + productId + ' .attributeItemContent.selected'), function (index, value) {
    var attrOptions = $(value).attr('data-attr');
    value = JSON.parse(attrOptions);
    price = parseFloat(price + value.OptionalPrice);

  });

  $('.attributeSummary[rel=' + productId + '] .productAttributePrice').html(currency.Symbol + ' ' + price.formatMoney(currency.RoundDecimals, DecimalSeparator, ThousandSeparator));

});

function renderMultipleCatalogs(WKId, MainCatalogId, CatalogIDs) {
  CatalogIDs = str.split(",");
  if ($('#' + WKId).length) {}
  else {
    $("#catalogContainer").append("<div class='catalog ' id='" + WKId + "'/>");
    var div = $('#' + WKId);

    $.each(CatalogIDs, function (index, value) {
      addFolderButton(div, value);
    });
  }

  $('#' + folder.CatalogId).removeClass('hidden');
  currentFolder = folder;
  refreshSaleButtons();
}


function renderFolder(folder) {
  if ($('#' + folder.CatalogId).length) {}
  else {
    $("#catalogContent").append("<div class='catalog' id='" + folder.CatalogId + "'/>");
    var div = $('#' + folder.CatalogId);
    if (folder.Nodes != null) {
      $.each(folder.Nodes, function (index, value) {
        if (value.EntityType == 12) {
          addProductButton(div, value);
        } else if (value.EntityType == 5) {
          addEventButton(div, value);
        } else {
          addFolderButton(div, value);
        }
      });
    }
    $(div).append('<br clear="all" />');
  }
  $(document).find('.catalog').addClass('hidden');
  $('#' + folder.CatalogId).removeClass('hidden');
  currentFolder = folder;
  refreshSaleButtons();
}

function renderAttributes(ProductId) {

  if ($('#attr' + ProductId).length) {}
  else {

    if (!localStorage.getItem('ProductEnt_' + ProductId)) {
      getProductEnt(productId);
    }

    product = JSON.parse(localStorage.getItem('ProductEnt_' + ProductId));

    $.each(product.PriceList, function (index, value) {
      if ((!value.SaleChannelId) && (!value.performanceTypeId)) {
        price = value.Price;
      }

      if (SaleChannelId == '') {
        if ((!value.SaleChannelId) && (!value.performanceTypeId)) {
          price = value.Price;
          return false;
        }
      } else {

        if (value.SaleChannelId) {
          if ((value.SaleChannelId == SaleChannelId) && (!value.performanceTypeId)) {
            price = value.Price;
            return false;
          }
        }
      }
    });

    $("#catalogContent").append("<div class='catalog hidden' id='attr" + ProductId + "' rel='" + ProductId + "'/>");
    var div = $('#attr' + product.ProductId);
    $(div).append('<div class="attributeSummary" rel="' + ProductId + '"><span style="width: 55%; padding: 0 10px; font-weight:bold; font-size:20px;">' + product.ProductName + '</span><span class="productAttributePrice" style="width: 15%; font-weight:bold; font-size:16px;"></span><button class="btn btn-primary addtocartAttribute" style="width: 25%;" rel="' + ProductId + '">Add to Cart</button></div>');

    var attributePrice = 0;

    if (product.AttributeItemList != null) {
      $.each(product.AttributeItemList, function (index, value) {

        if (value.SelectionType > 1) {
          attributePrice = parseFloat(attributePrice + addAttributeButton(div, value));
        }

      });
    }
    //$(div).append('<div class="button addtocartAttribute" rel="'+ProductId+'"">Add to Cart</div>');
    $(div).append('<br clear="all" />');
    price = price + attributePrice;
    $('.attributeSummary[rel=' + ProductId + '] .productAttributePrice').html(currency.Symbol + ' ' + price.formatMoney(currency.RoundDecimals, DecimalSeparator, ThousandSeparator));

  }

  $(document).find('.catalog').addClass('hidden');
  $('#catalogContainer').scrollTop(0);
  $('#attr' + ProductId).removeClass('hidden');

  currentFolder = product;
  refreshSaleButtons();

}

function addFolderButton(target, folder) {

  var image;
  var imgbgstyle;
  if (folder.ProfilePictureId) {
    image = '<v:config key="site_url"/>/repository?id=' + folder.ProfilePictureId + '&type=medium';
  } else {
    image = GenerateIconUrl(folder.IconName, "64");
    imgbgstyle = 'background-size: 50%;';
  }

  var bkgrndclr = "";
  if (folder.BackgroundColor) {
    bkgrndclr += 'style="background-color:#' + folder.BackgroundColor + ';"';
  }
  var frgrndclr = "";
  if (folder.ForegroundColor) {
    frgrndclr += 'style="color:#' + folder.ForegroundColor + ';"';
  }

  var btn = $('<div class="categoryItemContainer folder col-md-6 col-sm-6 col-xs-12" />').appendTo(target);
  var categoryItemContent = $('<div class="categoryItemContent" ' + bkgrndclr + ' />').appendTo(btn);

  $('<div class="categoryImage" style="background-image: url(' + image + '); ' + imgbgstyle + '"></div>').appendTo(categoryItemContent);

  if (folder.ShowNameExt) {
    if (folder.CatalogNameExt) {
      var name = folder.CatalogNameExt;
    } else {
      var name = folder.CatalogName;
    }
  } else {
    var name = folder.CatalogName;
  }

  $('<div class="categoryName col-md-8 col-sm-8 col-xs-9" ' + frgrndclr + ' >' + name + '</div>').appendTo(categoryItemContent);
  $('<div class="pref-item-arrow col-md-1 col-sm-1 col-xs-1"></div>').appendTo(categoryItemContent);
  btn.addClass("enabled", (folder.Nodes));
  btn.bind('click', function () {
    $('#catalogContainer').scrollTop(0);
    doclick = true;
    if (btn.hasClass("enabled") && doclick) {

      catalog_path.push(folder);
      renderFolder(folder);
      breadcrumb(folder.CatalogName, 'catalog', 1);
    }
  });
}
	
function addEventButton(target, event) {

  var image;
  var imgbgstyle;
  if (event.ProfilePictureId) {
    image = '<v:config key="site_url"/>/repository?id=' + event.ProfilePictureId + '&type=medium';
  } else {
    image = GenerateIconUrl(event.IconName, "64");
    imgbgstyle = 'background-size: 50%;';
  }

  var btn = $('<div class="eventItemContainer event col-md-6 col-sm-6 col-xs-12" data-EventId="' + event.EntityId + '" />').appendTo(target);
  var categoryItemContent = $('<div class="eventItemContent" />').appendTo(btn);

  $('<div class="eventImage" style="background-image: url(' + image + '); ' + imgbgstyle + '" />').appendTo(categoryItemContent);
  $('<div class="eventName  col-md-8 col-sm-8 col-xs-9">' + event.CatalogName + '</div>').appendTo(categoryItemContent);
  $('<div class="pref-item-arrow col-md-1 col-sm-1 col-xs-1"></div>').appendTo(categoryItemContent);

  btn.bind('click', function () {
    $('#catalogContainer').scrollTop(0);
    doclick = true;
    if (doclick) {
      mainactivity(mainactivity_step.event);
      populateEvent(event.EntityId);
      currentFolder = event;
    }
  });

}
	
	
var price = '';
var attributes = '';

function addProductButton(target, folder) {	
	var btn = $('<div class="productItemContainer product col-md-6 col-sm-6 col-xs-12 " />').appendTo(target);
	var image = '';
	var imgbgstyle = '';
	
	if (folder.ProfilePictureId) {
	  image = '<v:config key="site_url"/>/repository?id=' + folder.ProfilePictureId + '&type=medium';

	} else {
	  image = GenerateIconUrl(folder.IconName, "64");
	  imgbgstyle = 'background-size: 50%;';
	}
	
	price = null;

	$.each(folder.PriceList, function (index, value) {
	  //alert(JSON.stringify(value));
	  if ((!value.SaleChannelId) && (!value.performanceTypeId)) {
		  price = value.Price;
	  }
	  
	  if (SaleChannelId == '') {
			if ((!value.SaleChannelId) && (!value.performanceTypeId)) {
			  price = value.Price;
			  return false;
			}
	  } 
	  else {
			if (value.SaleChannelId) {
			  if ((value.SaleChannelId == SaleChannelId) && (!value.performanceTypeId)) {
					price = value.Price;
					return false;
			  }
			}
	  }
	});
		
	var name = folder.CatalogName;
	
	let priceStr = "";
	if (price)
		currency.Symbol + price.formatMoney(currency.RoundDecimals, DecimalSeparator, ThousandSeparator).replace('.00', '');

	$(btn).append(
	  '<div class="productItemContent" id="' + folder.EntityId + '" rel=\'' + folder.EntityId + '\' data-productId=\'' + folder.EntityId + '\'>'
	   + '<div class="productImage infoProduct" style="background-image: url(' + image + '); ' + imgbgstyle + '"  rel="' + folder.EntityId + '"></div>'
	   + '<div class="productDetails">'
	   + '<div class="productName" style="' + ((name.length > 20) ? "font-size:15px;" : '') + '">'
	   + name
	   + '</div>'
	  //+ '<div class="productPriceContainer">'
	   + '<span class="productPrice">'
	   + priceStr + '</span>'
	  //+ '</div>'
	   + '<br clear="all" />'
	   + ((folder.CatalogNameExt) ? '<div class="productDescription">' + folder.CatalogNameExt + '</div>' : '')
	   + '<span class="quantityInCart"> </span>'
	   + '</div>'
	   + '</div>');
	
	btn.find('.productDetails').bind('click', function() {
			$('#catalogContainer').scrollTop(0);
		      doclick = true;
		      if (doclick) {
				$('#floatingBarsGbg').show();
		        productId = folder.EntityId;
		        reqDO = {
		            Command: 'GetProductContents',
		            GetProductContents : {
		              ProductId : productId
		            }
		        };   
		        
		        vgsService('product',reqDO,true, function(ansDO) {
		          if (ansDO.Answer!=null) {
					localStorage.setItem('Product_'+productId,JSON.stringify(ansDO.Answer.GetProductContents.ProductContents));
		            product = JSON.parse(localStorage.getItem('Product_'+productId));
		            var renderattr = false;
		            if (product.Attributes!= null) {
		              $.each(product.Attributes,function(index,value) {
	
		                if(value.SelectionType>1) {
		                  renderAttributes(productId);
		                  renderattr = true;
						  $('#floatingBarsGbg').hide();
		                  return false;
		                } else {
		                  attributes = '';
		                }
		              });
		              if(renderattr) {
						$('#floatingBarsGbg').hide();
		                return false;
		              }
		            }
		            
		            if(typeof product['Entitlement'] !== 'undefined') {
		              if(product.Entitlement.ExpRule==8) {
		                var title = product.ProductName;
		                var msg = 'Please Select a date end for this product<br /><input type="hidden" name="productId" id="datedproductId" value="'+productId+'" /><input type="text" readonly name="endDatedProduct" id="endDatedProduct" /><script> $( "#endDatedProduct" ).datepicker({dateFormat: "yy-mm-dd",minDate : 0});</scr'+'ipt>';
		                var buttons = [<v:itl key="@Common.AddToCart" encode="JS"/>, <v:itl key="@Common.Cancel" encode="JS"/>];
									showMobileQueryDialog2(title, msg, buttons, function(index) {
		                  if (index == 0) {
		                      datedProduct = $('#datedProduct').val();
		                      if(datedProduct.length==0) {
		                        $('#datedProduct').focus();
		                        $('#datedProduct').css('border','1px solid red');
		                        return false;
		                      }
		                      addProductToCart(productId,null,null,datedProduct,null); 
												$('#floatingBarsGbg').hide();
		                  }
		                  return true;
		                });
		              } else if(product.Entitlement.ExpRule==9) {
		                var title = product.ProductName;
		                var msg = 'Please select validity date range<br /><input type="hidden" name="productId" id="datedproductId" value="'+productId+'" />'
		                + '<div  class="col-md-6 col-xs-12"><input type="text" readonly name="startDatedProduct" placeholder="From" id="startDatedProduct" /></div><script> $( "#startDatedProduct" ).datepicker({dateFormat: "yy-mm-dd",minDate : 0});'
		                + '</scr'+'ipt>'
		                + '<div  class="col-md-6 col-xs-12"><input type="text" readonly name="endDatedProduct" class="col-md-6 col-xs-12" placeholder="To" id="endDatedProduct" /></div><script> $( "#endDatedProduct" ).datepicker({dateFormat: "yy-mm-dd",minDate : 0});'
		                + '</scr'+'ipt><br clear="all" />';
		                var buttons = [<v:itl key="@Common.AddToCart" encode="JS"/>, <v:itl key="@Common.Cancel" encode="JS"/>];
		                showMobileQueryDialog2(title, msg, buttons, function(index) {
		                  if (index == 0) {
		                      var startDatedProduct = $('#startDatedProduct').val();
		                      var datedProduct = $('#endDatedProduct').val();
		                      if (startDatedProduct.length == 0) {
		                        $('#startDatedProduct').focus();
		                        $('#startDatedProduct').css('border', '1px solid red');
		                        return false;
		                      }
		                      if (datedProduct.length == 0) {
		                        $('#endDatedProduct').focus();
		                        $('#endDatedProduct').css('border', '1px solid red');
		                        return false;
		                      }
		                      addProductToCart(productId, null, null, datedProduct, startDatedProduct);
		                      $('#floatingBarsGbg').hide();
		                  }
		                  return true;
		                });
		              } else if(product.Entitlement.ExpRule==10) {
		                var title = product.ProductName;
		                var msg = 'Please Select a date for this product<br /><input type="hidden" name="productId" id="datedproductId" value="'+productId+'" /><input type="text" readonly name="datedProduct" id="datedProduct" /><script> $( "#datedProduct" ).datepicker({dateFormat: "yy-mm-dd",minDate : 0});</scr'+'ipt>';
		                var buttons = [<v:itl key="@Common.AddToCart" encode="JS"/>, <v:itl key="@Common.Cancel" encode="JS"/>];
		                showMobileQueryDialog2(title, msg, buttons, function(index) {
		                  if (index == 0) {
		                      datedProduct = $('#datedProduct').val();
		                      if(datedProduct.length==0) {
		                        $('#datedProduct').focus();
		                        $('#datedProduct').css('border','1px solid red');
		                        return false;
		                      }
		                      addProductToCart(productId,null,null,datedProduct,null); 
		                      $('#floatingBarsGbg').hide();
		                  }
		                  return true;
		                });
		              } else {
		                addProductToCart(productId);
						$('#floatingBarsGbg').hide();
		              }
		            } else {
		              addProductToCart(productId); 
		              $('#floatingBarsGbg').hide();
		            }
		          } else {
		          	$('#floatingBarsGbg').hide();
		          }
		        });
       }
     });
	
}

function addAttributeButton(target, attribute) {
  //var btn = addCatalogButton(target, "product", folder.CatalogName, "", folder.BackgroundColor,folder.ProfilePictureId);
  //alert(JSON.stringify(attribute.OptionList));
  if (attribute.SelectionType > 2) {
    var mandatory = 'mandatory';
  } else {
    var mandatory = '';
  }

  var price = 0;

  var attributecontainer = $('<div class="attributeContainer pref-section pref-item-list" rel="' + attribute.AttributeItemId + '" />').appendTo(target);
  $(attributecontainer).append('<h1>' + attribute.AttributeName + ((attribute.SelectionType > 2) ? '*' : '') + '</h1>');
  $.each(attribute.OptionList, function (index, value) {
    if (!value.OptionalPrice) {
      value.OptionalPrice = 0;
    }

    if (value.AttributeItemName == attribute.AttributeItemName) {
      var selected = 'selected';
      price = parseFloat(price + value.OptionalPrice);
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

    var btn = $('<div class="attributeItemContainer attribute ' + selected + '" />').appendTo(attributecontainer);
    var image = '';
    if (value.ProfilePictureId)
      image = '<v:config key="site_url"/>/repository?id=' + value.ProfilePictureId + '&type=medium';

    $(btn).append(
      '<div class="attributeItemContent pref-item ' + selected + ' ' + mandatory + '" style="display:flex;" id="' + value.AttributeItemId + '" rel="' + value.AttributeItemId + '" data-attr=\'' + JSON.stringify(value) + '\'>'
       + '<div class="attributeImage" style="background-image: url(' + image + ');"></div>'
       + '<div class="attributeItemInfo">'
       + '<div class="attributeName">'
       + name
       + '</div>'
       + '<div class="attributePriceContainer">'
       + '<span class="attributeQtyCart"></span>'
       + '<span class="attributePrice">'
       + currency.Symbol
       + ' '
       + value.OptionalPrice.formatMoney(currency.RoundDecimals, DecimalSeparator, ThousandSeparator)
       + '</span>'
       + '</div>'
       + '<div class="attributeSelection">'
       + '</div>'
       + '</div>' +
      '</div>');
  });
  //$(target).append('<br clear="all" />');

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