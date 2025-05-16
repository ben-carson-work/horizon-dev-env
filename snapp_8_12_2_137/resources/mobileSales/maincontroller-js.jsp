<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
  pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v"%>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageMobileSales"
  scope="request" />

<script>
	var breadcrumbPath = new Array();

	$(document).ready(function() {
    //localStorage.clear();
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
		checkout : 7
	};
	var mainactivityStep = mainactivity_step.idle;

	function mainactivity(step) {
		mainactivityStep = step;
		switch (mainactivityStep) {
		case mainactivity_step.idle:
			sendCommand("StopRFID");
			break;
		case mainactivity_step.doInit:
			localStorage.removeItem("AccountId");

			$('.page').addClass('hidden'); //hide all pages


 //comment to test on pc, uncomment to use on device
				NativeBridge.call("getDeviceId", ["firstArgument"], function (serial) {
					 	doInit(serial);
			 		});

				NativeBridge.call("getAppVersion", ["firstArgument"], function (version) {
				  setVersion(version);
			});
				

/*
 //uncomment to test on pc
			doInit("59155A90-8A06-26CF-00E0-0152A28741C8"); //pass a wkId
			setVersion('8.0');

			sendCommand("StopRFID");
			sendCommand('HideActionBar');
*/
			break;
		case mainactivity_step.home:
			$('#mainBody').addClass('hidden');
			$('.page').addClass('hidden'); //hide all pages

			//check if is in operator mode or not
			if (app == "guest") {
				$('#appSalesGuestContainer').removeClass('hidden');
			} else {
				$('#appSalesOperatorContainer').removeClass('hidden');
				if (!localStorage.getItem('AccountId')) {
					$('#loginBg').removeClass('hidden');
				}
			}

			sendCommand("StopRFID");

			break;

		case mainactivity_step.catalog:

			$('.page').addClass('hidden'); //hide all pages

			$('#catalogContainer').removeClass('hidden');
			$('#mainBody').removeClass('hidden');
			$('#mainHeaderCartButton').removeClass('hidden');
			$('#mainHeaderCheckoutButton').addClass('hidden');
			
			
			$('#mainHeaderCart').removeClass('hidden');
			
			sendCommand("StopRFID");

			break;

		case mainactivity_step.cart:

			$('.page').addClass('hidden');//hide all pages

			$('#mainBody').removeClass('hidden');
			$('#cartContainer').removeClass('hidden');
			breadcrumb('Cart', 'cart', 0);
			sendCommand("StopRFID");

			break;

		case mainactivity_step.checkout:

			$('.page').addClass('hidden'); //hide all pages

			$('#checkoutContainer').removeClass('hidden');
			$('#mainBody').removeClass('hidden');
			$('#mainHeaderCartButton').removeClass('hidden');
			$('#mainHeaderCheckoutButton').addClass('hidden');
			
			$('#checkoutContainer #tapResults').addClass("hidden");
			
			if (localStorage.getItem("AccountId")) {

				if (OrderLocation == "") {
					$('.tap').addClass('hidden');
					$('#beforepay').removeClass('hidden');
					$('#operatorCheckout').removeClass('hidden');
					sendCommand("StopRFID");
				} else {
					$('#beforepay').addClass('hidden');
					$('.tap').removeClass('hidden');

					$('#operatorCheckout').addClass('hidden');
					sendCommand("StartRFID");

				}
			} else {
				$('#beforepay').removeClass('hidden');
				$('.tap').addClass('hidden');
				$('#operatorCheckout').addClass('hidden');
				sendCommand("StopRFID");
			}
			/*
			var paymenthtml = '';
			$.each(PaymentMethods, function(a,b) {
				//alertjson(b);
				paymenthtml += 	"<div class='paymentType'>"+
									"<div class='paymentIcon '>"+
									"</div>"+
									b.PluginName+	
								"</div>"
			});
			$('.paymentContainer').html(paymenthtml);
			*/
			breadcrumb('Checkout', 'checkout', 0);

			break;

		case mainactivity_step.lookup:

			$('.page').addClass('hidden'); //hide all pages

			sendCommand("StartRFID");
			$('#mainBody').removeClass('hidden');
			$('#lookupContainer #lookupResults').addClass("hidden");
			$('#lookupContainer .tap').removeClass('hidden');

			$('#lookupContainer').removeClass('hidden');
			
			$('#mainHeaderCart').addClass('hidden');
			$('#mainHeaderCartButton').addClass('hidden');
			
			//onCodeRead('8025E68A807304');

			break;

    case mainactivity_step.account:

      $('.page').addClass('hidden'); //hide all pages

      $('#mainBody').removeClass('hidden');
      $('#registrationContainer').removeClass('hidden');
      
      $('#mainHeaderCart').addClass('hidden');
      $('#mainHeaderCartButton').addClass('hidden');
      
      break;

		case mainactivity_step.transactionResult:

			$('.page').addClass('hidden');
			$('#transactionResultContainer').removeClass('hidden');
			$('#mainBody').removeClass('hidden');
			$('#mainHeaderCartButton').addClass('hidden');
			breadcrumb('Transaction Result', 'transaction', 0);
			sendCommand("StopRFID");

			break;

		}
	}

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





