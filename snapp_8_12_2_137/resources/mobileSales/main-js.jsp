<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageMobileSales" scope="request"/>

<script>

var catalog_path = [];

var lastSequence =0;
var MainCatalogId = "";
var currency = '';
var catalog = new Array();
var OrderLocation = '';
var WorkstationName = '';
var SaleChannelId = '';
var demoMode = '';
var PaymentMethods = '';
var Person_RootCategoryId = '';
var AccountPRS_DefaultCategoryId = '';

var mainactivity_step = {idle:0, error:1, doInit:2, home:3, catalog:4, cart:5, lookup:6,checkout:7};
var mainactivityStep = mainactivity_step.idle;

	function doInit(wksId) {
	  workstationId = wksId;
	  reqDO = {
			Command : 'LoadEntWorkstation',
			LoadEntWorkstation: {
			  WorkstationId: workstationId
			}
    };   
	  vgsService('Workstation',reqDO,false, function(ansDO) {
		    promoUrl = ansDO.Answer.LoadEntWorkstation.Workstation.Rights.PromoURL;
		    window.promoTimer = ansDO.Answer.LoadEntWorkstation.Workstation.Rights.PromoTimer;
		   	
		    $('#wrap iframe').attr('src', promoUrl);
		    window.idleTime = 0;
		    if (1!=1) {
				var idleInterval = setInterval(timerIncrement, 1000);
		    }
		    $.each(ansDO.Answer.LoadEntWorkstation.Workstation.CurrencyList, function(index,value) {
		    	if (value.CurrencyType==1) {
		    		currency = value;
		    	}
		    }); 
			
		    //alertjson(ansDO.Answer.LoadEntWorkstation.Workstation);
		    //alertjson(ansDO.Answer.LoadEntWorkstation.Workstation.Rights);
		    
		    MainCatalogId = ansDO.Answer.LoadEntWorkstation.Workstation.Rights.MainCatalogId;
		    CatalogIDs = ansDO.Answer.LoadEntWorkstation.Workstation.Rights.CatalogIDs;
		    WorkstationName = ansDO.Answer.LoadEntWorkstation.Workstation.WorkstationName;
		    SaleChannelId = ansDO.Answer.LoadEntWorkstation.Workstation.SaleChannelId;
		    DecimalSeparator = ansDO.Answer.LoadEntWorkstation.Workstation.Rights.DecimalSeparator;
		    ThousandSeparator = ansDO.Answer.LoadEntWorkstation.Workstation.Rights.ThousandSeparator;
		    PaymentMethods = ansDO.Answer.LoadEntWorkstation.Workstation.PaymentMethodList;
		    
		    Person_RootCategoryId = ansDO.Answer.LoadEntWorkstation.Workstation.Person_RootCategoryId;
		    getCategoryTree(Person_RootCategoryId);
		    
		    AccountPRS_DefaultCategoryId = ansDO.Answer.LoadEntWorkstation.Workstation.Rights.AccountPRS_DefaultCategoryId;
   
		    demoMode = ansDO.Answer.LoadEntWorkstation.Workstation.Rights.PosDemoMode
		    
		    if (demoMode) {
		       	$(document).on('click','.tap',function() {
					//onCodeRead('8025E68A807304');
					onCodeRead('TABLETTEST');
				});
		    $('#version').prepend("DEMO MODE ");
			}
		    
		  $('#WkName').html(WorkstationName);
		    if (CatalogIDs) {
		    	CatalogIDs = CatalogIDs.split(",");
		    	if (MainCatalogId) {
   		    	if ($.inArray(MainCatalogId, CatalogIDs)==-1) {    		    	
   		    		CatalogIDs.splice(0, 0, MainCatalogId);
   		    	} 
		    	}
			    catalog = {
		    		CatalogId: workstationId,
		    		Nodes: {}
			    }
			    catalog['Nodes'] = new Array();
			    var counter = 0;
			    $.each(CatalogIDs, function(index,value) {
			    	
					var reqDO = {
				    	Command: 'loadEntCatalog',
				      	LoadEntCatalog : {
				        	CatalogId: value
				        }
					   };
				
				    vgsService('Catalog',reqDO,false, function(ansDO) {
				    	counter++;
				      //alert(JSON.stringify(ansDO.Answer.LoadEntCatalog.Catalog));
				      catalogChild = ansDO.Answer.LoadEntCatalog.Catalog;
				      //alert(JSON.stringify(catalogChild));
					  
				      var currentFolder = null;
				      catalog['Nodes'].push(catalogChild);
				      //renderFolder(catalog);

				      if (CatalogIDs.length<=counter) {
				    	  renderFolder(catalog)
				      }
				    });
				});
				
		    } else {
		    	if (MainCatalogId) {
		    	var reqDO = {
				    	Command: 'loadEntCatalog',
				      	LoadEntCatalog : {
				        	CatalogId: MainCatalogId
						}
				    };
				
				    vgsService('Catalog',reqDO,false, function(ansDO) {
				      //alert(JSON.stringify(ansDO.Answer.LoadEntCatalog.Catalog));
				      catalog = ansDO.Answer.LoadEntCatalog.Catalog;
				      var currentFolder = null;
				   	renderFolder(catalog); 
				    });
		    	}
		    }
			
		    updateTotals(0,0);
	    	checkEntityChange('12');
	    	checkEntityChange('5');
	    	mainactivity(mainactivity_step.home);
		  });
}
$(document).bind("touchmove", function(e) {
    e.preventDefault();
});
$(document).on("touchmove",'.scrolling', function(e) {
    e.stopPropagation();
});

$(document).on("click",'#mainHeaderCart',function (e) {
	e.stopPropagation();
	$('#catalogContainer').addClass('hidden');
	$('#mainHeaderCartButton').addClass('hidden');
	$('#mainHeaderCheckoutButton').removeClass('hidden');
	//$('#mainHeaderCart').addClass('hidden');
	updateTotals(totalitems,totals);
	$('#cartContainer').removeClass('hidden');
	mainactivity(mainactivity_step.cart);
	/*$('#mainBreadcrumbsPath').html(
			'<div class="breadcrumbNode last" data-id="'+catalog_path.length+'">'+
				'<span class="separator"></span>'+
				'<span class="breadcrumbsText">Cart</span>'+
			'</div>'
	);*/
});
$(document).on("click",'#mainHeaderCartButton',function (e) {
	e.stopPropagation();
	$('#catalogContainer').addClass('hidden');
	$('#mainHeaderCartButton').addClass('hidden');
	$('#mainHeaderCheckoutButton').removeClass('hidden');
	//$('#mainHeaderCart').addClass('hidden');
	updateTotals(totalitems,totals);
	$('#cartContainer').removeClass('hidden');
	mainactivity(mainactivity_step.cart);
	/*$('#mainBreadcrumbsPath').html(
			'<div class="breadcrumbNode last" data-id="'+catalog_path.length+'">'+
				'<span class="separator"></span>'+
				'<span class="breadcrumbsText">Cart</span>'+
			'</div>'
	);*/
});
$(document).on("<%=pageBase.getEventMouseDown()%>",'#settings',function () {
	sendCommand('Settings');
});
var title = false;
$(document).on("<%=pageBase.getEventMouseDown()%>",'#title',function () {
	if (title==false) {
		sendCommand('ShowActionBar');
		title = true;
	} else {
		sendCommand('HideActionBar');
		title = false;
	}
});

$(document).on("<%=pageBase.getEventMouseDown()%>",'.home',function () {
	catalog_path = [];
	breadcrumbPath= [];
	//alert(catalog_path.length);
	$('#mainBreadcrumbsPath').html("");
	$('#cartContainer').addClass("hidden");
	$('#mainHeaderCartButton').removeClass('hidden');
	$('#mainHeaderCheckoutButton').addClass('hidden');
	//alert(JSON.stringify(catalog));
	renderFolder(catalog);
	mainactivity(mainactivity_step.home);
});

function getCategoryTree(Person_RootCategoryId) {
	$('#floatingBarsGbg').show();
	var reqDO = {
	    	Command: 'LoadEntCategory',
	    	LoadEntCategory : {
	    		CategoryId: Person_RootCategoryId
			}
	  };
	
	vgsService('Category',reqDO,false, function(ansDO) {
     //alertjson(ansDO.Answer.LoadEntCategory);
     $('#floatingBarsGbg').hide();
     	if (ansDO.Answer!=null) {   			
   			localStorage.setItem('Category_'+ansDO.Answer.LoadEntCategory.Category.CategoryId,JSON.stringify(ansDO.Answer.LoadEntCategory.Category));
   			MaskIDs = ansDO.Answer.LoadEntCategory.Category.MaskIDs;
   			if (MaskIDs) {
   				MaskIDs = MaskIDs.split(',');
   	    		$(MaskIDs).each(function (index,MaskId) {
   	    			storeCategoryMask(MaskId); //function in this file
   	    		});
   			}
   			if (ansDO.Answer.LoadEntCategory.Category.CategoryList.length>0) {
   				parentMaskIDs = ansDO.Answer.LoadEntCategory.Category.MaskIDs;
   				var cattree = recursiveGetCategory(ansDO.Answer.LoadEntCategory.Category.CategoryList,ansDO.Answer.LoadEntCategory.Category.CategoryId); //function in this file
   				if (cattree)
   					setmask(); //function in registration-js.jsp
   			} 
   			else
   				setmask(); //function in registration-js.jsp
   		}
    });
}
var MaskIDs = '';
var parentMaskIDs = '';
function recursiveGetCategory(CategoryList,parentCategoryId) {
	//alertjson(CategoryList);
	$(CategoryList).each(function (index,value) {
		if (value.MaskIDs) {
			MaskIDs = value.MaskIDs.split(',');
    		$(MaskIDs).each(function (index,MaskId) {
    			storeCategoryMask(MaskId);
    		});
		} /*else {
			value.MaskIDs = parentMaskIDs;
		}*/
		value.parentCategoryId = parentCategoryId;
		if (value.CategoryList && (value.CategoryList.length>0)) 	
			recursiveGetCategory(value.CategoryList,value.CategoryId);
		
		localStorage.setItem('Category_'+value.CategoryId,JSON.stringify(value));		
	})
	return true;
}
function storeCategoryMask(MaskId) {
	var reqDO = {
    	Command: 'LoadEntMask',
    	LoadEntMask : {
    		MaskId: MaskId
    	}
    };

  vgsService('Metadata',reqDO,false, function(ansDO) {
   	//alertjson(ansDO.Answer.LoadEntMask);
  	localStorage.setItem('Mask_'+MaskId,JSON.stringify(ansDO.Answer.LoadEntMask.Mask));
  });
}

function checkEntityChange(type) {
	//localStorage.setItem('LastSequence'+type,0)
	$('#floatingBarsGbg').show();
	lastSequence = (localStorage.getItem('LastSequence'+type)!= null) ? localStorage.getItem('LastSequence'+type) : 0;
	//alert(lastSequence);		
	reqDO = {
			EntityTypes : type,
			LastSequence : lastSequence
	      };   
	//alert(JSON.stringify(reqDO));
	vgsService('entitychange',reqDO,false, function(ansDO) {
		if(ansDO.Answer!=null) {
		switch (type) {
		case "5":
			if(ansDO.Answer.EntityList!=null) {
				$.each(ansDO.Answer.EntityList, function(index,value) {
					if (value.InsertUpdate) {
						getEvent(value.EntityId);
					}
					localStorage.setItem('LastSequence'+type,value.Sequence)
				});
				if (ansDO.Answer.HasMoreData) {
					checkEntityChange('5');
				} else {
					//alert('finito');
					$('#floatingBarsGbg').hide();
				}
			}
			break;
		case "12":
			if(ansDO.Answer.EntityList!=null) {
				$.each(ansDO.Answer.EntityList, function(index,value) {
					if (value.InsertUpdate) {
						getProduct(value.EntityId);
					}
					localStorage.setItem('LastSequence'+type,value.Sequence)
				});
				
				if (ansDO.Answer.HasMoreData) {
					checkEntityChange('12');
				} else {
					//alert('finito');
					$('#floatingBarsGbg').hide();
				}
			}
			break;
		case "47":
			if(ansDO.Answer.EntityList!=null) {
				$.each(ansDO.Answer.EntityList, function(index,value) {
					getCatalog(value.EntityId);
					localStorage.setItem('LastSequence'+type,value.Sequence)
				});
				if (ansDO.Answer.HasMoreData) {
					checkEntityChange('47');
				}
			}
			LoadEntWorkstation();
			break;
		}
		} else {
			$('#floatingBarsGbg').hide();
		}
	});
	
}

function getProduct(productId) {
	
	reqDO = {
			Command: 'LoadEntProduct',
			LoadEntProduct : {
				ProductId : productId
			}
	      };   
	//alert(JSON.stringify(reqDO));
	vgsService('product',reqDO,true, function(ansDO) {
		
		if (ansDO.Answer!=null) {
			
			localStorage.setItem('Product_'+ansDO.Answer.LoadEntProduct.Product.ProductId,JSON.stringify(ansDO.Answer.LoadEntProduct.Product));
			//
			//alert(localStorage.getItem('Product_'+ansDO.Answer.LoadEntProduct.Product.ProductId));
		} else {
						
		}
	});	
}
function getCatalog(catalogId) {
	reqDO = {
			Command: 'LoadEntCatalog',
			LoadEntCatalog : {
				CatalogId : catalogId
			}
	      };   
	//alert(JSON.stringify(reqDO));
	vgsService('Catalog',reqDO,true, function(ansDO) {
		if (ansDO.Answer!=null) {
			//alert(JSON.stringify(ansDO.Answer));
			localStorage.setItem('Catalog_'+ansDO.Answer.LoadEntCatalog.Catalog.CatalogId,JSON.stringify(ansDO.Answer.LoadEntProduct.Catalog));
			
		} else {
						
		}
	});	
}
function getEvent(eventId) {
	reqDO = {
			Command: 'LoadEntEvent',
			LoadEntEvent : {
				EventId : eventId
			}
	      };   
	//alert(JSON.stringify(reqDO));
	vgsService('Event',reqDO,true, function(ansDO) {
		if (ansDO.Answer!=null) {
			localStorage.setItem('Event_'+ansDO.Answer.LoadEntEvent.Event.EventId,JSON.stringify(ansDO.Answer.LoadEntEvent.Event));
			//alert(JSON.stringify(ansDO.Answer));
		} else {
						
		}
	});	
}
function LoadEntWorkstation() {
	reqDO = {
			Command : 'LoadEntWorkstation',
			LoadEntWorkstation: {
				WorkstationId: workstationId
			}
	      };   
	vgsService('Workstation',reqDO,false, function(ansDO) {
		alert(JSON.stringify(ansDO.Answer.LoadEntWorkstation.Workstation));
		MainCatalogId = ansDO.Answer.LoadEntWorkstation.Workstation.Rights.MainCatalogId;
		localStorage.setItem("MainCatalogId", MainCatalogId);
		window.catalog =MainCatalogId;
		//alert(localStorage.getItem("Catalog_"+MainCatalogId));
	});
}
function showMessage(msg) {
    alert(msg);
}
function showDialog(Title,Htmlmsg,close,w,h) {
	$('#dialogContent').html('');
	if (close) {
		$(document).on("click",'#dialogBG',function() {
			hideDialog();
		});
	}
	
	$('#dialogBox').css('width',w);
	$('#dialogBox').css('height',h);
 
	$('#dialogTitle').html(Title);
	$('#dialogContent').html(Htmlmsg);
	$('#dialogBG').show();
}

function hideDialog() {
	$('#dialogBG').hide();
}

function lookup(type,barcode) {
	switch (type) {
	case "AccountId":
		reqDO = {
			Command : 'Lookup',
			Lookup: {
				AccountId:barcode
			}
	      }; 
		break;
	case "MediaCode" :
		reqDO = {
			Command : 'Lookup',
			Lookup: {
				MediaCode:barcode
			}
	      }; 
		break;
	}
	reqDO = {
		Command : 'Lookup',
		Lookup: {
			AccountId:barcode
		}
     };
	$('#floatingBarsGbg').show();
	  
	vgsService('Portfolio',reqDO,false, function(ansDO) {
		$('#floatingBarsGbg').hide();
		portfolioList = ansDO.Answer.Lookup.PortfolioList;
		
		return portfolioList;
	});	
}

var portfolioList = false;
function onCodeRead(barcode) {
	window.barcode = barcode;
	$('#wrap').addClass("hidden");
	window.idleTime = 0;
	hideDialog();
	switch (mainactivityStep) {
	    case mainactivity_step.checkout:
	    	
	    	reqDO = {
    			Command : 'Lookup',
    			Lookup: {
    				MediaCode: barcode
    			}
    	     };
    		
	    	window.MediaCode = barcode;
	    	$('#floatingBarsGbg').show();
    		  
    		vgsService('Portfolio',reqDO,true, function(ansDO) {
    			//alert(JSON.stringify(ansDO));
    			$('#floatingBarsGbg').hide();
    			
    			if (ansDO.Header.StatusCode==200) {
    				portfolioList = ansDO.Answer.Lookup.PortfolioList;
    				checkoutTapResults(portfolioList);
    			} else {
    				sendCommand("StopRFID");
    				var HtmlProduct = 	'<div id="productDetails" class="scrolling">'+
											'<div id="productName" style="text-align:center; padding:30px 0;">'+
												ansDO.Header.ErrorMessage+
											'</div>'+
											'<div class="button dialogClose" style="width:40%;margin:10px 25%;">Close</div>'+
										'</div>'
					showDialog('Error',HtmlProduct,true,'80%','250px');
    				
    				mainactivity(mainactivity_step.checkout);
    			}
    		});
	    	
	   	break;
	    case mainactivity_step.lookup:
	    	reqDO = {
    			Command : 'Lookup',
    			Lookup: {
    				MediaCode: barcode
    			}
    	     };
    		
	    	window.MediaCode = barcode;
	    	$('#floatingBarsGbg').show();
    		  
    		vgsService('Portfolio',reqDO,true, function(ansDO) {
    			$('#floatingBarsGbg').hide();
    			
    			if (ansDO.Header.StatusCode==200) {
    				portfolioList = ansDO.Answer.Lookup.PortfolioList;
    				
    				displayLookupResults(portfolioList);
    			} else {
    				
    				sendCommand("StopRFID");
    				var HtmlProduct = 	'<div id="productDetails" class="scrolling">'+
											'<div id="productName" style="text-align:center; padding:30px 0;">'+
												ansDO.Header.ErrorMessage+
											'</div>'+
											'<div class="button dialogClose" style="width:40%;margin:10px 25%;">Close</div>'+
										'</div>'
    				showDialog('Error',HtmlProduct,true,'80%','250px');
    				mainactivity(mainactivity_step.lookup);
    			}
    		});
	    	
	   	break;
	}
}

function getUniquid() {
	var s = [];
    var hexDigits = "0123456789abcdef";
    for (var i = 0; i < 36; i++) {
        s[i] = hexDigits.substr(Math.floor(Math.random() * 0x10), 1);
    }
    s[14] = "4";  // bits 12-15 of the time_hi_and_version field to 0010
    s[19] = hexDigits.substr((s[19] & 0x3) | 0x8, 1);  // bits 6-7 of the clock_seq_hi_and_reserved to 01
    s[8] = s[13] = s[18] = s[23] = "-";

    var uuid = s.join("");
    return uuid;
}

$(document).on('submit','#loginForm',function(){
	dologin('home');
	return false;
});

$(document).on("<%=pageBase.getEventMouseDown()%>", '.logout', function() {
	dologout();
});
//---------------- screen saver functions ------------------------------------------------

$(document).on("<%=pageBase.getEventMouseDown()%>",'.wrapBlocker',function(e) {
	e.stopPropagation();
	$('#wrap').addClass("hidden");
	window.idleTime = 0;
});

function timerIncrement()
{
	window.idleTime++;
  	if (window.idleTime > window.promoTimer) {
    	doPreload();
  	}
}

//Zero the idle timer on mouse movement.
$(this).mousemove(function(e){
	window.idleTime = 0;
	$('#wrap').addClass("hidden");
});
$(window).on("touchstart",function(e){
	window.idleTime = 0;
	$('#wrap').addClass("hidden");
});

function doPreload()
{
	$('#wrap').removeClass("hidden");	   
}


//----------------timer for screen saver functions ------------------------------------------------

function setVersion(version) {
	$('#version').html("v. "+version);
}
Number.prototype.formatMoney = function(c, d, t){
	var n = this, 
	    c = isNaN(c = Math.abs(c)) ? 2 : c, 
	    d = d == undefined ? "." : d, 
	    t = t == undefined ? "," : t, 
	    s = n < 0 ? "-" : "", 
	    i = parseInt(n = Math.abs(+n || 0).toFixed(c)) + "", 
	    j = (j = i.length) > 3 ? j % 3 : 0;
	   return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : "");
	 };
	 function alertjson(message) {
			alert(JSON.stringify(message,null,4));
		}
</script>





