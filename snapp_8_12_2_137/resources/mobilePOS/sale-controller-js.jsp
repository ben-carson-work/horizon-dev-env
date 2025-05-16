<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v"%>
<% PageMobileSales pageBase = (PageMobileSales)request.getAttribute("pageBase"); %>

<script type="text/javascript" id="sale-controller-js.jsp" >

	var breadcrumbPath = new Array();
	
	$(document).ready(function() {
     localStorage.removeItem('ShopCart');
     localStorage.removeItem('PrintMediaTemplateList');
		 mainactivity(mainactivity_step.doInit);
	});
	var mainactivity_step = {
		idle : 0,
		error : 1,
		doInit : 2,
		home : 3,
		catalog : 4,
		cart : 5,
		lookup : 6,
		checkout : 7,
		mediaAssoc : 8,
		event: 9,
	  eventProducts: 10,
	  account: 11,
    info: 12,
    walletPayment: 13,
    lookupMedia : 14
	};
	var mainactivityStep = mainactivity_step.idle;

	function mainactivity(step) {
		mainactivityStep = step;
		
		switch (mainactivityStep) {
		case mainactivity_step.idle:
			sendCommand("StopRFID");
			break;
		case mainactivity_step.doInit:
			$('.page').addClass('hidden'); //hide all pages
      doInit();
			sendCommand("StopRFID");
			sendCommand('HideActionBar');
			break;
		case mainactivity_step.home:
		  $('.formNavigation').hide();
		  $('#mainHeaderCart').removeClass('hidden');
      $('#mainHeaderBack').removeClass('hidden');
      $('#mainHeaderCartButton').removeClass('hidden');
      $('#mainHeaderClearCart').removeClass('hidden');
      $('#mainHeaderContinue').removeClass('hidden');
		  if(totalitems>0) {
        $('#mainHeaderClearCart').removeClass('disabled');
        $('#mainHeaderContinue').removeClass('disabled');
      } else {
        $('#mainHeaderClearCart').addClass('disabled');
        $('#mainHeaderContinue').addClass('disabled');
      }
			$('.page').addClass('hidden'); //hide all pages
			$('#catalogContainer').removeClass('hidden');
      $('#mainBody').removeClass('hidden');
      $('#mainHeaderCart').removeClass('hidden');
		  $('#eventContainer').addClass("hidden");
		  $('#mainHeaderContinue > span').removeClass();
		  $('#mainHeaderContinue span').addClass('shopCartIcon');
		  $('.miniCartContainer').removeClass('hidden');
      $('.mainHeaderText').addClass('hidden');
		  $(document).find('div.active-tab').removeClass('active-tab');
      $('.goToCatalog ').addClass('active-tab');
		  $('#mainContent').unbind('scroll');
			sendCommand("StopRFID");
			$('#mainHeaderContinue').removeClass('keyboardopen');
      $('#mainHeaderBack').parent().removeClass('hidden');
      $('#tab-header-redeem-manual').addClass('hidden');
			break;
		case mainactivity_step.catalog:
      $('#mainHeaderClearCart').removeClass('hidden');
      $('#mainHeaderContinue').removeClass('hidden');
      $('.formNavigation').hide();
		  if(totalitems>0) {
		    $('#mainHeaderClearCart').removeClass('disabled');
		    $('#mainHeaderContinue').removeClass('disabled');
		  } else {
		    $('#mainHeaderClearCart').addClass('disabled');
		    $('#mainHeaderContinue').addClass('disabled');
		  }
		  
			$('.page').addClass('hidden'); //hide all pages
			$('#catalogContainer').removeClass('hidden');
			$('#eventContainer').addClass('hidden');
			$('#mainBody').removeClass('hidden');
			$('#mainHeaderCart').removeClass('hidden');
			$('#mainHeaderContinue > span').removeClass();
			$('#mainHeaderContinue > span').addClass('shopCartIcon');
			$(document).find('div.active-tab').removeClass('active-tab');
      $('.goToCatalog ').addClass('active-tab');
      refreshSaleButtons();
			sendCommand("StopRFID");
			$('.miniCartContainer').removeClass('hidden');
      $('.mainHeaderText').addClass('hidden');
      $('#mainHeaderContinue').removeClass('keyboardopen');
      $('#mainHeaderBack').parent().removeClass('hidden');
      $('#tab-header-redeem-manual').addClass('hidden');
			break;
		case mainactivity_step.cart:
		  $('.formNavigation').hide();
      $('#mainHeaderClearCart').removeClass('hidden');
      $('#mainHeaderContinue').removeClass('hidden');
		  if(totalitems>0) {
		    $('#mainHeaderClearCart').removeClass('disabled');
		    $('#mainHeaderContinue').removeClass('disabled');
		  } else {
		    $('#mainHeaderClearCart').addClass('disabled');
		    $('#mainHeaderContinue').removeClass('disabled');
		  }
		  $('.miniCartContainer').removeClass('hidden');
      $('.mainHeaderText').addClass('hidden');
		  $('#mainHeaderContinue').removeClass('disabled');
			$('.page').addClass('hidden');//hide all pages
			$('#mainBody').removeClass('hidden');
			$('#cartContainer').removeClass('hidden');
			$(document).find('div.active-tab').removeClass('active-tab');
			$('.goToShopcart ').addClass('active-tab');
			$('#mainHeaderContinue > span').removeClass();
			$('#mainHeaderContinue > span').addClass('mediaIcon');
			$('#mainHeaderBack').removeClass('hidden');
			breadcrumb('Cart', 'cart', 0);
			sendCommand("StopRFID");
			$('#mainHeaderContinue').removeClass('keyboardopen');
      $('#mainHeaderBack').parent().removeClass('hidden');
      $('#tab-header-redeem-manual').addClass('hidden');
			break;
		case mainactivity_step.checkout:
		  $('.formNavigation').hide();
		  populateCheckoutCart();
			$('.page').addClass('hidden'); //hide all pages
			$('#checkoutContainer').removeClass('hidden');
			$('#mainBody').removeClass('hidden');
      $('#mainHeaderClearCart').removeClass('hidden');
      $('#mainHeaderContinue').removeClass('hidden');
			$('#mainHeaderCartButton').removeClass('hidden');
			$('#mainHeaderCheckoutButton').addClass('hidden');
			$('.miniCartContainer').removeClass('hidden');
      $('.mainHeaderText').addClass('hidden');
			$('#checkoutContainer #tapResults').addClass("hidden");
				$('#beforepay').removeClass('hidden');
				$('.tap').addClass('hidden');
				$('#operatorCheckout').addClass('hidden');
				sendCommand("StopRFID");

			breadcrumb('Checkout', 'checkout', 0);
			$('#mainHeaderContinue').removeClass('keyboardopen');
      $('#mainHeaderBack').parent().removeClass('hidden');
      $('#tab-header-redeem-manual').addClass('hidden');
  		break;
		case mainactivity_step.lookup:
		  
		  $('.formNavigation').hide();
			$('.page').addClass('hidden'); //hide all pages
			sendCommand("StartRFID");
			$('#mainBody').removeClass('hidden');
			$('#lookupContainer #lookupResults').addClass("hidden");
			$('#lookupContainer .tap').removeClass('hidden');
			$('#lookupContainer').removeClass('hidden');
			$('#mainHeaderBack').addClass('hidden');
			$('#mainHeaderCart').addClass('hidden');
      $('#mainHeaderCartButton').addClass('hidden');
      $('#mainHeaderClearCart').addClass('hidden');
      $('#mainHeaderContinue').removeClass('hidden');
      $('.miniCartContainer').addClass('hidden');
      $('.mainHeaderText').removeClass('hidden');
      $(document).find('div.active-tab').removeClass('active-tab');
      $('.goToLookup ').addClass('active-tab');
      $('#mainHeaderContinue > span').removeClass();
      $('#mainHeaderContinue > span').addClass('keyboardIcon');
      $('#mainHeaderContinue').removeClass('disabled');
      initLookupMedia();
			//onCodeRead('8025E68A807304');
			$('#mainHeaderContinue').removeClass('keyboardopen');
      $('#mainHeaderBack').parent().removeClass('hidden');
      $('#tab-header-redeem-manual').addClass('hidden');
			break;
		  case mainactivity_step.lookupMedia:
      
	    $('#lookupContainer').find('#frm-medialookup-media-template').remove();
	    $('#lookupContainer').find('#frm-medialookup-ticket-template').remove();
	    $('#lookupContainer').find('#frm-medialookup-usages-template').remove();
	    $('#lookupContainer').find("#frm-medialookup-medias-template").remove();
	    $('#lookupContainer').find("#frm-medialookup-tickets-template").remove();
	    
	    $('#mainHeaderContinue').removeClass('keyboardopen');
	    $('.mainHeaderText').removeClass('hidden');
      $('#mainHeaderBack').parent().removeClass('hidden');
      $('#tab-header-redeem-manual').addClass('hidden');  
      //initLookupMedia();
      //onCodeRead('8025E68A807304');
      break;
    case mainactivity_step.account:
      $('.page').addClass('hidden'); //hide all pages
      $('#mainBody').removeClass('hidden');
      $('#registrationContainer').removeClass('hidden');
      $('#mainHeaderCart').addClass('hidden');
      $('#mainHeaderBack').addClass('hidden');
      $('#mainHeaderCartButton').addClass('hidden');
      $('#mainHeaderClearCart').addClass('hidden');
      $('#mainHeaderContinue').addClass('hidden');
      $('.miniCartContainer').addClass('hidden');
      $('.mainHeaderText').addClass('hidden');
      $(document).find('div.active-tab').removeClass('active-tab');
      $('.goToAccount ').addClass('active-tab');
      var rootCategory = JSON.parse(localStorage.getItem('Category_'+Person_RootCategoryId));
      populateSelect(rootCategory,1); 
      $('#mainHeaderContinue').removeClass('keyboardopen');
      $('#mainHeaderBack').parent().removeClass('hidden');
      $('#tab-header-redeem-manual').addClass('hidden');
      break;
		case mainactivity_step.transactionResult:
		  $('.formNavigation').hide();
			$('.page').addClass('hidden');
			$('#transactionResultContainer').removeClass('hidden');
			$('#mainBody').removeClass('hidden');
			$('#mainHeaderCartButton').addClass('hidden');
			breadcrumb('Transaction Result', 'transaction', 0);
			sendCommand("StopRFID");
			$('.miniCartContainer').removeClass('hidden');
      $('.mainHeaderText').addClass('hidden');
      $('#mainHeaderContinue').removeClass('keyboardopen');
      $('#mainHeaderBack').parent().removeClass('hidden');
      $('#tab-header-redeem-manual').addClass('hidden');
      $('#mainHeaderClearCart').addClass('disabled');
      $('#mainHeaderContinue').addClass('disabled');
			break;
		case mainactivity_step.mediaAssoc:
		  $('#mainHeaderContinue').addClass('disabled');
		  $('.page').addClass('hidden');
      $('#mediaContainer').removeClass('hidden');
      $('#mainBody').removeClass('hidden');
      $('#mainHeaderCartButton').addClass('hidden');
      $('#mainHeaderContinue > span').removeClass();
      $('#mainHeaderContinue > span').addClass('cashRegisterIcon');
      breadcrumb('Transaction Result', 'transaction', 0);
      sendCommand("StopRFID");
      populateMediaAssoc();
      $('.miniCartContainer').removeClass('hidden');
      $('.mainHeaderText').addClass('hidden');
      $('#mainHeaderContinue').removeClass('keyboardopen');
      $('#mainHeaderBack').parent().removeClass('hidden');
      $('#tab-header-redeem-manual').addClass('hidden');
      break;
  	case mainactivity_step.event:
  	  $('.formNavigation').hide();
  	  //alert('event');
      $('.page').addClass('hidden');
      $('#eventContainer').removeClass('hidden');
      $('#mainBody').removeClass('hidden');
      $('#catalogContainer').addClass('hidden');
      $('#mainHeaderContinue > span').removeClass();
      $('#mainHeaderContinue > span').addClass('shopCartIcon');
      breadcrumb('Transaction Result', 'transaction', 0);
      sendCommand("StopRFID");
      $('.miniCartContainer').removeClass('hidden');
      $('.mainHeaderText').addClass('hidden');
      $('#mainHeaderContinue').removeClass('keyboardopen');
      $('#mainHeaderBack').parent().removeClass('hidden');
      $('#tab-header-redeem-manual').addClass('hidden');
      break;
  	case mainactivity_step.eventProducts:

      break;
  	case mainactivity_step.info:
  	  $('.page').addClass('hidden'); //hide all pages
      $('#mainBody').removeClass('hidden');
      $('#infoContainer').removeClass('hidden');
      $('#mainHeaderCart').addClass('hidden');
      $('#mainHeaderBack').addClass('hidden');
      $('#mainHeaderCartButton').addClass('hidden');
      $('#mainHeaderClearCart').addClass('hidden');
      $('#mainHeaderContinue').addClass('hidden');
      $(document).find('div.active-tab').removeClass('active-tab');
      $('.goToInfo ').addClass('active-tab');
      $('.miniCartContainer').addClass('hidden');
      $('.mainHeaderText').addClass('hidden');
      $('#mainHeaderContinue').removeClass('keyboardopen');
      $('#mainHeaderBack').parent().removeClass('hidden');
      $('#tab-header-redeem-manual').addClass('hidden');
      break;
    }   
	}
	
	$(document).on(clickAction,"#mainHeaderBack", function() {
	  
  	  switch (mainactivityStep) {
  	    
  	    case mainactivity_step.home:
  	      if ($('#catalogContainer').hasClass("hidden")) {
  	        $('#cartContainer').addClass("hidden");
  	        $('#catalogContainer').removeClass('hidden');
  	        $('#eventContainer').addClass('hidden');
  	        $('#mainHeaderCartButton').removeClass('hidden');
  	        $('#mainHeaderCheckoutButton').addClass('hidden');
  	        $('#transactionResultContainer').addClass('hidden');
  	        $('#checkoutContainer').addClass('hidden');
  	         //breadcrumb('','catalog','3');
  	      } else {
  	        catalog_path.pop();
  	        /*breadcrumbPath['catalog'].pop();
  	          $('#mainBreadcrumbsPath .breadcrumbNode').last().remove();
  	        $('#mainBreadcrumbsPath .breadcrumbNode').last().addClass('last');
  	        */
  	          if (catalog_path.length == 0) {
  	            renderFolder(window.catalog);
  	          } else {
  	            var folder = catalog_path[catalog_path.length-1];
  	            renderFolder(folder);
  	          }
  	      }
  	      break;
  	    case mainactivity_step.catalog:
  	      if ($('#catalogContainer').hasClass("hidden")) {
  	        $('#cartContainer').addClass("hidden");
  	        $('#catalogContainer').removeClass('hidden');
  	        $('#eventContainer').addClass('hidden');
  	        $('#mainHeaderCartButton').removeClass('hidden');
  	        $('#mainHeaderCheckoutButton').addClass('hidden');
  	        $('#transactionResultContainer').addClass('hidden');
  	        $('#checkoutContainer').addClass('hidden');
  	         //breadcrumb('','catalog','3');
  	      } else {
  	        catalog_path.pop();
  	        /*breadcrumbPath['catalog'].pop();
  	          $('#mainBreadcrumbsPath .breadcrumbNode').last().remove();
  	        $('#mainBreadcrumbsPath .breadcrumbNode').last().addClass('last');
  	        */
  	          if (catalog_path.length == 0) {
  	            renderFolder(window.catalog);
  	          } else {
  	            var folder = catalog_path[catalog_path.length-1];
  	            renderFolder(folder);
  	          }
  	      }
  	      break;
  	    case mainactivity_step.cart:
  	      mainactivity(mainactivity_step.catalog);
  	      break;
  	    case mainactivity_step.event:
  	      mainactivity(mainactivity_step.catalog);
  	      break;
  	    case mainactivity_step.eventProducts:
  	      mainactivity(mainactivity_step.event);
					$('#ProductContainer').removeClass('active');
					// Reload Performances ???
					var eventId = $('#eventId').val();
					getPerformances(eventId);
					//
  	      break;
  	    
  	    case mainactivity_step.checkout:
  	      mainactivity(mainactivity_step.cart);
  	      break;
  	    case mainactivity_step.mediaAssoc:
  	      if(codereaded) {
  	        if (confirm('You have media already associated, in this way you will lost them, do you want to continue?')) {
  	          var arr = [];
              for (var i = 0; i < localStorage.length; i++){
                if (localStorage.key(i).substring(0,14) == 'ticketAccount_') {
                    arr.push(localStorage.key(i));
                }
              }
              for (var i = 0; i < arr.length; i++) {
                localStorage.removeItem(arr[i]);
              }
              mainactivity(mainactivity_step.cart);              
            }
  	      } else {
  	         mainactivity(mainactivity_step.cart);
  	      }
          break;
  	    case mainactivity_step.transactionResult:
  	      mainactivity(mainactivity_step.catalog);
  	      break;
  	    case mainactivity_step.lookupMedia:
          mainactivity(mainactivity_step.lookupMedia);
          $(this).addClass('hidden');
          $('#lookupContainer').find('#pref-medialookup-template').removeClass('hidden');
          break;
  	  }	 
	});

	$(document).on(clickAction,'#mainHeaderContinue',function (e) {	  
	  e.stopPropagation();
	  e.stopImmediatePropagation();
	  
	  switch (mainactivityStep) {
		  case mainactivity_step.home:
		    mainactivity(mainactivity_step.cart);
		    break;
		  case mainactivity_step.catalog:
		    mainactivity(mainactivity_step.cart);
		    break;
		  case mainactivity_step.cart:
		    mainactivity(mainactivity_step.mediaAssoc);
		    break;
		  case mainactivity_step.event:
		    mainactivity(mainactivity_step.cart);
		    break;
		  case mainactivity_step.eventProducts:
		    mainactivity(mainactivity_step.cart);
		    break;
		  case mainactivity_step.mediaAssoc:
		    mainactivity(mainactivity_step.checkout);
		    break;
		  case mainactivity_step.transactionResult:
		    mainactivity(mainactivity_step.catalog);
		    break;
		  case mainactivity_step.lookup:
		    if($(this).hasClass('keyboardopen')) {
		      $(this).removeClass('keyboardopen');
          $('.mainHeaderText').removeClass('hidden');
          $('#mainHeaderBack').parent().removeClass('hidden');
          $('#tab-header-redeem-manual').addClass('hidden');
		    } else {
		      $(this).addClass('keyboardopen');
          $('.mainHeaderText').addClass('hidden');
          $('#mainHeaderBack').parent().addClass('hidden');
          $('#tab-header-redeem-manual').removeClass('hidden');
		    }
		    break;
		  case mainactivity_step.lookupMedia:
        if($(this).hasClass('keyboardopen')) {
          $(this).removeClass('keyboardopen');
          $('.mainHeaderText').removeClass('hidden');
          $('#mainHeaderBack').parent().removeClass('hidden');
          $('#tab-header-redeem-manual').addClass('hidden');
        } else {
          $(this).addClass('keyboardopen');
          $('.mainHeaderText').addClass('hidden');
          $('#mainHeaderBack').parent().addClass('hidden');
          $('#tab-header-redeem-manual').removeClass('hidden');
        }
        break;
	  }
	});

	function breadcrumb(title, branch, level) {
		if (level == 0) {
			breadcrumbPath[branch] = new Array();
			breadcrumbPath[branch].push(title);

			$('#mainBreadcrumbsPath').html(
					'<div class="breadcrumbNode last" data-id="'+branch+'">'
							+ '<span class="separator"></span>'
							+ '<span class="breadcrumbsText">' + title
							+ '</span>' + '</div>');
		} else if (level == 3) {
			
			$('#mainBreadcrumbsPath').html("");

			$.each(breadcrumbPath[branch], function(index, value) {
				
				$('#mainBreadcrumbsPath').append(
						'<div class="breadcrumbNode" data-id="'+parseFloat(index)+'">'
								+ '<span class="separator"></span>'
								+ '<span class="breadcrumbsText">' + value
								+ '</span>' + '</div>');
			});

			$('#mainBreadcrumbsPath .breadcrumbNode').last().addClass('last');

		} else {
			if (!(branch in breadcrumbPath)) {
				breadcrumbPath[branch] = new Array();
			}
			breadcrumbPath[branch].push(title);

			$('#mainBreadcrumbsPath .breadcrumbNode').last().removeClass('last');
			$('#mainBreadcrumbsPath').append(
					'<div class="breadcrumbNode last" data-id="'+parseFloat(breadcrumbPath[branch].length-1)+'">'
							+ '<span class="separator"></span>'
							+ '<span class="breadcrumbsText">' + title
							+ '</span>' + '</div>');
		}
		
	}
	function getUrlVars() {
		var vars = {};
		var parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi,
				function(m, key, value) {
					vars[key] = value;
				});
		return vars;
	}
	var app = getUrlVars()['app'];
</script>





