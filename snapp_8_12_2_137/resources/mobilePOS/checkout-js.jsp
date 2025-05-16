<%@page import="com.vgs.snapp.lookup.LkSNUploadType"%>
<%@page import="com.vgs.snapp.lookup.LkSNPaymentStatus"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.LkSNPaymentType"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<% PageMobileSales pageBase = (PageMobileSales)request.getAttribute("pageBase"); %>

<script type="text/javascript" id="checkout-js.jsp" >

var DriverClassAlias;
var mediaPrintList = [];

$(document).on('click','#mainHeaderCheckoutButton' , function() {
	$('#mainHeaderBack').addClass("hidden");
	//$('.tap').removeClass('hidden');
	$('#tapResults').addClass("hidden");
	OrderLocation="";

	mainactivity(mainactivity_step.checkout);
});

$(document).on("<%=pageBase.getEventMouseDown()%>",'.pay' , function() {
	doTransaction();
});



function populateCheckoutCart() {
  var ShopCart = JSON.parse(localStorage.getItem('ShopCart'));
  
  $('.checkoutRows').html("");
  
  $.each(ShopCart.Items, function(index,value) {

	  var price; 
    if(showNetPrices) {
      price = value.TotalNetFull.toFixed(2);
    } else {
      price = value.TotalGrossFull.toFixed(2);
    }
    var image;
    var imgbgstyle;
    if (value.ProfilePictureId) {
      image = '<v:config key="site_url"/>/repository?id='+value.ProfilePictureId+'&type=medium';
    } else {
      image = GenerateIconUrl(value.IconName,"64");
      imgbgstyle = 'background-size: 80%;';
    }
    var totalitems = 0;
    $('.checkoutRows').append('<tr class="pref-item  product-'+value.ProductId+' " data-id="'+value.ProductId+'" data-ShopCartItemId="'+value.ShopCartItemId+'" data-attr="">'
            + '<td class="productImage"><img src="'
            + image
            + '"</td>'
            + '<td class="cartProductName" rel="'+value.ProductId+'" style="font-size:15px; line-height: 20px;">'
            + value.ProductName
            + '</td>'
            + '<td class="cartItemUnitPrice" style="font-size:20px;">' // Changed font size to 20px
            + value.UnitAmount.toFixed(2)
            + '</td>'
            + '<td class="quantity" style="font-size:20px;">'+value.Quantity+'</td>' // Changed font size to 20px
            + '<td class="cartItemPrice" style="font-size:20px;">'+price+'</td>' // Changed font size to 20px
            + '</tr>');
    totalitems = totalitems + value.Quantity;
    });

  
  $('.paymentMethodList').html('');
  
  $.each(PaymentMethods, function(a,payMethod) {
 
 if(payMethod.PluginSettings!=null) {
	 
	 var Authorizer = JSON.parse(payMethod.PluginSettings).Authorizer;
 } else {
	 var Authorizer = '';
 }
    var paymentMethodHtml = $("<div class='col-md-4 col-xs-4 text-center paymentMethod card' data-Authorizer='"+Authorizer+"' data-paymentName='"+payMethod.PluginName+"' data-driverClassAlias='"+payMethod.DriverClassAlias+"'data-paymentMethodId='"+payMethod.PluginId+"' data-paymentType='"+payMethod.PaymentMethodDetails.PaymentType+"'></div>").appendTo('.paymentMethodList');
    $('<img src="' + GenerateIconUrl(payMethod.IconName,"64") + '" class="img-responsive" />').appendTo(paymentMethodHtml);
    var paymentmethod = $("<h3>"+payMethod.PluginName+"</h3>").appendTo(paymentMethodHtml);  
    //if (payMethod.PaymentMethodDetails.PaymentType == <%=LkSNPaymentType.Cash.getCode()%>) {
    //}  
  });
}
var paymentType
var paymentName
var paymentMethodId
var DriverClassAlias
$(document).on(clickAction, '.paymentMethod', function() {
  paymentType = $(this).attr('data-paymentType');
  paymentName = $(this).attr('data-paymentName');
  paymentMethodId = $(this).attr('data-paymentMethodId');
  authorizer = $(this).attr('data-authorizer');
  DriverClassAlias = $(this).attr('data-driverClassAlias');  
  switch (paymentType) {
    case '<%= LkSNPaymentType.Cash.getCode() %>': //Cash
      validateShopCart(paymentType, paymentName, paymentMethodId);
      break;
    case '<%= LkSNPaymentType.CreditCard.getCode() %>': //CreditCard
      if(authorizer==1) {
		    var title = 'Authorization Code';
		    var msg = 'Please insert Authorization Code<br/><input type="text" id="authcode" />';
		    var buttons = [<v:itl key="@Common.Cancel" encode="JS"/>,<v:itl key="Send" encode="JS"/>];
		    showMobileQueryDialog2(title, msg, buttons, function(index) {
		      	if (index == 0) {
			        sendCommand("StopRFID");
			        return true;
			    } else if (index ==1) {
			    	var authcode = $('#authcode').val();
			    	if(authcode=='') {
			    		return true;
			    	}
			    	validateShopCart(paymentType, paymentName, paymentMethodId,'','',authcode);
			    }
		      	 return true;
		    });
	  }
    else {
      // ??????

    }
      break;
    case '<%= LkSNPaymentType.Wallet.getCode() %>': //Wallet
      var title = 'Wallet payment';
      var msg = 'Please tap the media on the back <br/><span class="lookupWalletError" style="color:red;font-size:18px"></span>';
      var buttons = [<v:itl key="@Common.Cancel" encode="JS"/>];
      showMobileQueryDialog2(title, msg, buttons, function(index) {
          if (index == 0) {
            sendCommand("StopRFID");
            return true;
        }
        return true;
      });
      sendCommand("StartRFID");
      mainactivity(mainactivity_step.walletPayment);
      break;
    case '<%= LkSNPaymentType.Credit.getCode() %>': //Credit
        var title = 'Account';
        var msg = 'Please insert Account Code<br/><input type="text" id="creditaccountcode" />';
        var buttons = [<v:itl key="@Common.Cancel" encode="JS"/>,<v:itl key="Send" encode="JS"/>];
        showMobileQueryDialog2(title, msg, buttons, function(index) {
            if (index == 0) {
              sendCommand("StopRFID");
              return true;
          } else if (index ==1) {
            var accountcode = $('#creditaccountcode').val();
            var reqDO = {
                          Command: "Search",
                          Search: {
                            PayOnCreditOnly: true,
                            RecordPerPage: 99,
                            PagePos: 1,
                            FullText: accountcode
                          }
                        };
            if(accountcode=='') {
                return true;
            }
            vgsService('Account', reqDO, false,function(ansDO) {
              if(ansDO.Answer != null){
                if (ansDO.Answer.Search.TotalRecordCount == 1) {
                    var AccId = ansDO.Answer.Search.AccountList[0].AccountId;
                    validateShopCart(paymentType, paymentName, paymentMethodId,'','','',AccId);
                }
                else {
                  alert('Invalid Account Code');
                  return true;
                }
              }
              else {
                alert('something went wrong!, please try again.');
                return true;
              }
            });
          }
              return true;
        });
      break;

    default:
      var title = 'Not Ready!';
      var msg = 'This Payment Method is Not Available Yet.';
      var buttons = [<v:itl key="@Common.Cancel" encode="JS"/>];
      showMobileQueryDialog2(title, msg, buttons, function(index) {
	      	return true;
	    });
      break;
  }

});
function doHoldWalletPayment(mediaCode) {
  var reqDO = {
      Command : 'HoldWalletPayment',
      HoldWalletPayment: {
        MediaCode: mediaCode,
        Amount: totals
      }
    };
  vgsService('Portfolio', reqDO, true,function(ansDO) {
    
    if (((ansDO.Header.StatusCode==200)) && (ansDO.Answer != null)) {
      validateShopCart(paymentType,paymentName,paymentMethodId,ansDO.Answer.HoldWalletPayment.PortfolioSlotHoldId,mediaCode);
      $(".mobile-dialog-layover").remove();
    } else {
      $('.lookupWalletError').html(ansDO.Header.ErrorMessage);
    }
  }); 
}
// function syncPayment(PaymentType,PaymentName,PaymentMethodId) {
// 	  var ShopCart = JSON.parse(localStorage.getItem('ShopCart'));
// 	  ShopCart.PreparePahDownload = true;
	  
// 	  var reqDO = {
// 	      Command : 'ValidateShopCart'
// 	    };
// 	  if (ShopCart) {
// 	    reqDO.ShopCart = ShopCart;
// 	  }
// 	//  alert(JSON.stringify(reqDO));
// 	  vgsService('ShopCart', reqDO, false,function(ansDO) {
// 	    if (((ansDO.Header.StatusCode==200)) && (ansDO.Answer != null)) {
// 	      var reqDO = {
// 	        Command : 'InitTransaction',
// 	        InitTransaction: {
// 	          ShopCart: ansDO.Answer.ShopCart
// 	        }
// 	      };
// 	      //alert(JSON.stringify(reqDO));
// 	      vgsService('Transaction', reqDO, false,function(ansDO) {
// 	        if (ansDO.Answer != null) {
// 	          var msgRequest = JSON.stringify(ansDO.Answer.InitTransaction.Message);
// 	          msgRequest = JSON.parse(msgRequest);
//             msgRequest['Request']['Paid'] = true;
//             msgRequest['Request']['Approved'] = true;
	          
//             var payment = {
//               PaymentMethodId: PaymentMethodId,
<%--               PaymentStatus: <%=LkSNPaymentStatus.Approved.getCode()%>, --%>
//               PaymentAmount:totals,
//             }
	            
//             msgRequest['Request']['PaymentList'] = new Array();
//             msgRequest['Request']['PaymentList'].push(payment);
	          
// 	          msgRequest['Request']['Approved'] = true;
// 	          msgRequest['Request']['Encoded'] = true;
// 	          msgRequest['Request']['Printed'] = false;
// 	          msgRequest['Request']['Validated'] = false;
		          
// 	          uploadTransaction(msgRequest);
// 	        } else {
// 	        }
// 	      });  
// 	    } else {
// 	    }
// 	  });  
// }

function uploadTransaction(msgRequest, callback) {
    UploadId = getUniquid().toString().toUpperCase();
    var reqDO = {
      Command: 'Add',
      Add: {
        UploadId: UploadId,
        UploadType: <%=LkSNUploadType.PostTransaction.getCode()%>,
        MsgRequest: JSON.stringify(msgRequest)
      }
    };   

    vgsService('Upload', reqDO, false,function(ansDO) {
      if (ansDO.Answer != null) {
        UploadId = ansDO.Answer.Add.UploadId;
        checkUploadStatus(UploadId,PaymentType, callback);
      } else {
      }
    });  
}

function validateShopCart(PaymentType,PaymentName,PaymentMethodId,PortfolioSlotHoldId,MediaCode,authcode,creditaccount) {
  var isAsyncPayment = false;

  var ShopCart = JSON.parse(localStorage.getItem('ShopCart'));
  ShopCart.PreparePahDownload = true;
  
  var reqDO = {
		  Command : 'ValidateShopCart'
    };
  if (ShopCart) {
    reqDO.ShopCart = ShopCart;
  }
//  alert(JSON.stringify(reqDO));
  vgsService('ShopCart', reqDO, false,function(ansDO) {
    if (((ansDO.Header.StatusCode==200)) && (ansDO.Answer != null)) {
    	var reqDO = {
        Command : 'InitTransaction',
        InitTransaction: {
          ShopCart: ansDO.Answer.ShopCart
        }
      };
      console.log('Validateion - Result');
      console.log((JSON.stringify(reqDO)));
      console.log('Validateion - Result');

      vgsService('Transaction', reqDO, false,function(ansDO) {
        if (ansDO.Answer != null) {
          var msgRequest = JSON.stringify(ansDO.Answer.InitTransaction.Message);
          msgRequest = JSON.parse(msgRequest);
          
          if (PaymentType == <%=LkSNPaymentType.Cash.getCode()%>) {
            isAsyncPayment = false;
            msgRequest['Request']['Paid'] = true;
            msgRequest['Request']['Approved'] = true;
            
          } else if (PaymentType == <%=LkSNPaymentType.CreditCard.getCode()%>) {
        	  
        	  if(!authcode) {
            	isAsyncPayment = true;
            	msgRequest['Request']['Paid'] = false;
            	msgRequest['Request']['Approved'] = false;
            	var CreditCard = {}
        	  } else {
        		isAsyncPayment = false;
              	msgRequest['Request']['Paid'] = true;
              	msgRequest['Request']['Approved'] = true;  
              	 var CreditCard = {
            			 AuthorizationCode:authcode
                     }
        	  }
          } else if (PaymentType == <%=LkSNPaymentType.Wallet.getCode()%>) {
            isAsyncPayment = false;
            msgRequest['Request']['Paid'] = true;
            msgRequest['Request']['Approved'] = true;
            var Wallet = {
                MediaCode:MediaCode,
                PortfolioSlotHoldId:PortfolioSlotHoldId
            }
          } else if (paymentType == <%= LkSNPaymentType.Credit.getCode() %>)
          {
            if(!creditaccount) {
            	isAsyncPayment = true;
            	msgRequest['Request']['Paid'] = false;
            	msgRequest['Request']['Approved'] = false;
            	var CreditLine = {}
        	  } else {
        		isAsyncPayment = false;
              	msgRequest['Request']['Paid'] = true;
              	msgRequest['Request']['Approved'] = true;  
              	 var CreditLine = {
            			 AccountId:creditaccount
                     }
        	  }
          } else if (PaymentType == <%=LkSNPaymentType.Wallet.getCode()%>) {
            isAsyncPayment = false;
            msgRequest['Request']['Paid'] = true;
            msgRequest['Request']['Approved'] = true;
            var Wallet = {
                MediaCode:MediaCode,
                PortfolioSlotHoldId:PortfolioSlotHoldId
            }
          }
          msgRequest['Request']['UserAccountId'] = '<%=JvString.escapeHtml(pageBase.getSession().getUserAccountId())%>';
          msgRequest['Request']['AccountId'] = '';
          if(!isAsyncPayment) {
            var payment = {
              PaymentType: PaymentType,
              PaymentName: PaymentName,
              PaymentMethodId: PaymentMethodId,
              PaymentStatus: <%=LkSNPaymentStatus.Approved.getCode()%>,
              PaymentAmount:totals,
              CurrencyAmount:totals,
              CurrencyISO:currency.ISOCode,
              ExchangeRate:1,
              Change: false
            }
            if (PaymentType == <%=LkSNPaymentType.CreditCard.getCode()%>) {
            	 payment.CreditCard = new Array();
                 payment.CreditCard = CreditCard;
            }
            if (PaymentType == <%=LkSNPaymentType.Credit.getCode()%>) {
            	 payment.CreditLine = new Array();
               payment.CreditLine = CreditLine;
            }
            if(Wallet) {
              payment.Wallet = new Array();
              payment.Wallet = Wallet;
            }
            //alert(totals);
            msgRequest['Request']['PaymentList'] = new Array();
            msgRequest['Request']['PaymentList'].push(payment);
          }
          
          if (!isAsyncPayment) {
            msgRequest['Request']['Approved'] = true;
            msgRequest['Request']['Encoded'] = true;
            msgRequest['Request']['Printed'] = true;
            msgRequest['Request']['Validated'] = true;
          } else {
            msgRequest['Request']['Approved'] = false;
            msgRequest['Request']['Encoded'] = false;
            msgRequest['Request']['Printed'] = false;
            msgRequest['Request']['Validated'] = false;
          }
          
          UploadId = getUniquid().toString().toUpperCase();
          var reqDO = {
            Command: 'Add',
            Add: {
              UploadId: UploadId,
              UploadType: <%=LkSNUploadType.PostTransaction.getCode()%>,
              MsgRequest: JSON.stringify(msgRequest)
            }
          };   

          vgsService('Upload', reqDO, false,function(ansDO) {
            if (ansDO.Answer != null) {
              UploadId = ansDO.Answer.Add.UploadId;
              checkUploadStatus(UploadId,PaymentType,'',authcode);
            } else {
            }
          });  
        } else {
        }
      });  
    } else {
    }
  });  
}

function showTransactionResults(TransactionId,type) {
	if (type=="ok") {
		//alert(TransactionId);
		var reqDO = {
				Command: 'Load',
				Load: {
					TransactionId: TransactionId
				}
		  }; 
		//alert(JSON.stringify(reqDO));
		vgsService('Transaction',reqDO,false, function(ansDO) {
			//alert(JSON.stringify(ansDO.Answer.Load.Transaction));
			
			mainactivity(mainactivity_step.transactionResult);
			$("#transactionResultContent .thumb").css("background-image","url('<v:image-link name="[font-awesome]check|CircleGreen" size="100"/>')");
			$("#transactionResultContent .text").html("Transaction Completed<br /><b>Code: </b>"+ansDO.Answer.Load.Transaction.SaleCode);
			$('#transactionResultContainer').removeClass('hidden');
			
			//portfolioList = lookup('AccountId',ansDO.Answer.Load.Transaction.SaleAccountId);
			//portfolioList = lookup('MediaCode',window.barcode);
			//if (!localStorage.getItem('AccountId')) {
				
			
			
			//} 
			localStorage.removeItem('ShopCart');
			totalitems = 0;
			totals = 0;
			updateTotals(totalitems,totals);
			$('.cartRows').html("");
			$('.productQtyCart').html("");
			OrderLocation = '';
			$('#location').val("");
			$('#note').val("");
				//alert(JSON.stringify(portfolioList));
			var arr = []; // Array to hold the keys
		// Iterate over localStorage and insert the keys that meet the condition into arr
		for (var i = 0; i < localStorage.length; i++){
		    if (localStorage.key(i).substring(0,14) == 'ticketAccount_') {
		        arr.push(localStorage.key(i));
		    }
		}

		// Iterate over arr and remove the items by key
		for (var i = 0; i < arr.length; i++) {
		    localStorage.removeItem(arr[i]);
		}
		});
	} else {
		mainactivity(mainactivity_step.transactionResult);
		$("#transactionResultContent .thumb").css("background-image","url('<v:image-link name="[font-awesome]times|CircleRed" size="100"/>')");
		$("#transactionResultContent .text").html("Transaction Failed");
		$('#transactionResultContainer').removeClass('hidden');
	}
}

function checkUploadStatus (uploadId, PaymentType, callback, authcode) {
 
  var reqDO = {
		Command: 'Status',
		Status: {
			UploadId: uploadId
		}
  };
  
	vgsService('Upload',reqDO,false, function(ansDO) {
		UploadStatus = ansDO.Answer.Status.UploadStatus;
		if (UploadStatus<3){
			checkUploadStatus(uploadId,PaymentType)
		} else if (UploadStatus==3) {
      if (callback) {
        callback(ansDO.Answer.Status);
      }
      var saleId = ansDO.Answer.Status.PostTransactionRecap.SaleId;
      var transactionId = ansDO.Answer.Status.EntityId;
      var saleCode = ansDO.Answer.Status.SaleCode;
	          
      if(PaymentType) {
  			if(PaymentType==<%=LkSNPaymentType.Cash.getCode()%>) {
  				printTickets(saleId, transactionId,saleCode);
  				//printReceipt(transactionId);
  			  showTransactionResults(transactionId,"ok");
  			} else if(PaymentType==<%=LkSNPaymentType.CreditCard.getCode()%>){
  			  if(authcode!=null) {
  			  	CreditCardPayment(totals,saleId);
  			  } else {
  				printTickets(saleId, transactionId,saleCode);
    			showTransactionResults(transactionId,"ok");
  			  }
  			} else if(PaymentType==<%=LkSNPaymentType.Wallet.getCode()%>){
  			  printTickets(saleId, transactionId,saleCode);
  			  showTransactionResults(transactionId,"ok");
        }
        else if(PaymentType==<%=LkSNPaymentType.Credit.getCode()%>){
          printTickets(saleId, transactionId,saleCode);
          showTransactionResults(transactionId,"ok");
        }
    			$(document).find('.quantityInCart').text('');
    			//showTransactionResults(ansDO.Answer.Status.EntityId,"ok");
    		} else if (UploadStatus>3) {
    			var saleId = ansDO.Answer.Status.EntityId;
    		}
      }
	});
	
}

function checkoutTapResults(portfolioList) {

	$('#checkoutContainer .tap').addClass("hidden");
	$('#checkoutContainer #tapResults').removeClass("hidden");

	$.each(portfolioList, function(index, value) {
			$('#tapResultsContent').html("");
			var lookupresults = $('<table class="checkoutLookupResults" />').appendTo('#tapResultsContent');
			if (value.AccountProfilePictureId!=null) {
				lookupresults.append('<tr><td class="label"></td><td class="value ftright"><img src="'+"<v:config key='site_url'/>/repository?id="
                + value.AccountProfilePictureId
                + '&type=small" /></td></tr>');
			}
			lookupresults.append('<tr><td class="label">Name</td><td class="value ftright">'+value.AccountName+'</td></tr>');
			lookupresults.append('<tr><td class="label">Balance</td><td class="value ftright">'+value.WalletBalance.formatMoney(currency.RoundDecimals, DecimalSeparator, ThousandSeparator)+' '+currency.Symbol+'</td></tr>');
			if (value.WalletCreditLimit>0) {
				lookupresults.append('<tr><td class="label">Credit Limit</td><td class="value ftright">'+value.WalletCreditLimit.formatMoney(currency.RoundDecimals, DecimalSeparator, ThousandSeparator)+' '+currency.Symbol+'</td></tr>');
				if (parseFloat(value.WalletBalance + value.WalletCreditLimit)>0) {
					var availableBalance = parseFloat(value.WalletBalance + value.WalletCreditLimit);
				} else {
					var availableBalance = 0;
				}
				lookupresults.append('<tr><td class="label">Available Balance</td><td style="font-size:25px" class="value ftright">'+availableBalance.formatMoney(currency.RoundDecimals, DecimalSeparator, ThousandSeparator)+' '+currency.Symbol+'</td></tr>');
			}
			lookupresults.append('<tr><td class="label">Total pay</td><td style="font-size:25px" class="value ftright"facebo>'+totals.formatMoney(currency.RoundDecimals, DecimalSeparator, ThousandSeparator)+' '+currency.Symbol+'</td></tr>');
			lookupresults.append('<tr><td class="label">New Balance after payment</td><td class="value ftright '+((parseFloat(value.WalletBalance-totals)>0) ? '':'negative') +'">'+parseFloat(value.WalletBalance-totals).formatMoney(currency.RoundDecimals, DecimalSeparator, ThousandSeparator)+' '+currency.Symbol+'</td></tr>');
			
			window.AccountId = value.AccountId;
			window.PortfolioId = value.PortfolioId;

			if (parseFloat(value.WalletBalance) >= totals) {
				$('#checkoutContainer .pay').removeClass('disabled');
			} else if(parseFloat(value.WalletBalance + value.WalletCreditLimit)>=totals) {
				$('#checkoutContainer .pay').removeClass('disabled');
			} else {
				$('#checkoutContainer .pay').addClass('disabled');
			}
	});

}

function printTickets(saleId, transactionId) {
  var totalTicketsToPrint;
  var sequence = 0; 
  localStorage.removeItem('PrintMediaTemplateList');
  var reqDO = {
        Command: 'GetParsedNotPrintedMedias',
        GetParsedNotPrintedMedias: {
        	  SaleId: saleId
          }
      };

  //alert(JSON.stringify(reqDO));
  vgsService('Sale', reqDO, false,function(ansDO) {
    //alert(JSON.stringify(ansDO.Answer.GetParsedNotPrintedMedias));
    
    if (ansDO.Answer != null) {
    
      if(ansDO.Answer.GetParsedNotPrintedMedias != null) {
        totalTicketsToPrint = ansDO.Answer.GetParsedNotPrintedMedias.PrintMediaTemplateList.length;
      }
      if(totalTicketsToPrint>0) {
        
        var PrintMediaTemplateList = ansDO.Answer.GetParsedNotPrintedMedias.PrintMediaTemplateList;
        //alert(JSON.stringify(PrintMediaTemplateList));
  // 			$.each(ansDO.Answer.GetParsedNotPrintedMedias.PrintMediaTemplateList, function(index, value) {
  // 			  //alert(JSON.stringify(value));
  // 			  alert('printing Ticket '+parseInt(index+1));
  // 				setTimeout(function() {NativeBridge.call("Print", [ value.DriverList, value.DocData], function(succesfull, errorMsg) {
  // 				 //alert(JSON.stringify(value));
  // 	        if (!succesfull)
  // 	          alert(errorMsg);
  // 	      });
  // 				},5000*index);
  // 				//TODO: gestire la pausa per consentire all'operatore di strappare il biglietto
  // 				if (index==(count-1)) {
  // 				  setTimeout(function() {printReceipt(transactionId);},(5000*count)+1000);
  // 				}
  // 			});
  			
  			localStorage.setItem('PrintMediaTemplateList',JSON.stringify(PrintMediaTemplateList));
  			
  			//printReceipt(transactionId);
  			
  			printEachTicket(0,totalTicketsToPrint,transactionId,saleId);
			
  			if(totalTicketsToPrint>1) {
  			  
  			  
  			  /*$('#myModal').find('.modal-header').html('Printing');
    			$('#myModal').find('.modal-body').html('<button class="printNext btn btn-primary btn-block" data-saleId ="'+saleId+'" data-transactionId ="'+transactionId+'" data-printedTicket="0" data-totalTicketToPrint="'+totalTicketsToPrint+'">Print Next</button>');
    			$('#myModal').find('.modal-footer').hide();
          $('#myModal').modal({
            backdrop: 'static',
            keyboard: false
          });*/
  			}
			} else {
			  printReceipt(transactionId);
			}
		  //TODO: upload della transazione di tipo PrintMedia 57	
    }
  });
}

$(document).on(clickAction,'.printNext',function(e) {
  e.stopPropagation();
  e.stopImmediatePropagation();
  var sequence = $(this).attr('data-printedTicket');
  var totalTicketsToPrint = $(this).attr('data-totalTicketToPrint');
  var transactionId = $(this).attr('data-transactionId');
  var saleId = $(this).attr('data-saleId');
  //alert(parseInt(sequence)+1);
  printEachTicket(parseInt(sequence)+1,totalTicketsToPrint,transactionId,saleId);
  $(this).attr('data-printedTicket',parseInt(sequence)+1);
});

function activateTickets(msgRequest, callback) {
   var reqDO = {
     Command: 'MediaPrintComplete',
     MediaPrintComplete: msgRequest
   };   

   vgsService('Transaction', reqDO, false,function(ansDO) {
     if ((ansDO.Answer == null) || (ansDO.Header.StatusCode!=200)) {
       var errorMsg = <v:itl key="@Media.MediaActivationError" encode="JS"/>;
       var title = <v:itl key="@Media.NotActive" encode="JS"/>;
       var buttons = [<v:itl key="Ok" encode="JS"/>];
       showMobileQueryDialog2(title, errorMsg, buttons, function(index){
       	return true;
			});
     }
   });  
}

function printEachTicket(i,totalTicketsToPrint,transactionId,saleId) {
  //alert(i+" "+totalTicketsToPrint);
  var PrintMediaTemplateList = JSON.parse(localStorage.getItem('PrintMediaTemplateList'));
  //alertjson(PrintMediaTemplateList);
  NativeBridge.call("Print", [ PrintMediaTemplateList[i].PrintMediaTemplate.DriverList, PrintMediaTemplateList[i].PrintMediaTemplate.DocData], function(succesfull, errorMsg) {
    //alert(JSON.stringify(value));
    //alert(PrintMediaTemplateList[i].MediaId);
    
     if (!succesfull) {
       alert(errorMsg);
     } else {
       mediaPrintList.push({"MediaId": PrintMediaTemplateList[i].MediaId, "DocTemplateId" : PrintMediaTemplateList[i].PrintMediaTemplate.DocTemplateId});
     }

     if(parseInt(i)+1==totalTicketsToPrint) {
       //$('#myModal').modal('hide');
       
       var printMediaComplete = {
						'Sale': {
							'SaleId': saleId
						},
          	  'MediaPrintSuccessList': mediaPrintList
       };
       
       activateTickets(printMediaComplete);
       
       //setTimeout(function() {printReceipt(transactionId);},3000);
       var title = 'Print Receipt';
       var msg = 'Print Receipt';
       var buttons = [<v:itl key="Print Receipt" encode="JS"/>];
       showMobileQueryDialog2(title, msg, buttons, function(index) {
         if (index == 0) {
           printReceipt(transactionId);
           return true;
       }
       return true;
       });
       localStorage.clear('PrintMediaTemplateList');
       mediaPrintList = [];
     } else {
       //alert('ancora');
     
       var title = 'Print Next Ticket';
       var msg = 'Print Ticket #'+parseInt(parseInt(i)+2)+' of '+totalTicketsToPrint;
       var buttons = [<v:itl key="Print Next" encode="JS"/>];
       showMobileQueryDialog2(title, msg, buttons, function(index) {
         if (index == 0) {
          // var sequence = $(this).attr('data-printedTicket');
           //var totalTicketsToPrint = $(this).attr('data-totalTicketToPrint');
           //var transactionId = $(this).attr('data-transactionId');
           //var saleId = $(this).attr('data-saleId');
           //alert(parseInt(sequence)+1);
           printEachTicket(parseInt(i)+1,totalTicketsToPrint,transactionId,saleId);
           //$(this).attr('data-printedTicket',parseInt(sequence)+1);
           return true;
       }
       return true;
       });
     }
   });
  
}

function printReceipt(transactionId) {
  //alert('printing Receipt');
  var title = 'printing Receipt';
  var msg = 'printing Receipt';
  var buttons = [<v:itl key="Ok" encode="JS"/>];
  showMobileQueryDialog2(title, msg, buttons, function(index) {
    if (index == 0) {
     // var sequence = $(this).attr('data-printedTicket');
      //var totalTicketsToPrint = $(this).attr('data-totalTicketToPrint');
      //var transactionId = $(this).attr('data-transactionId');
      //var saleId = $(this).attr('data-saleId');
      //alert(parseInt(sequence)+1);
     // printEachTicket(parseInt(i)+1,totalTicketsToPrint,transactionId,saleId);
      //$(this).attr('data-printedTicket',parseInt(sequence)+1);
      return true;
  } 
    return true;
  });
  var reqDO = {
        Command: 'GetParsedTransactionReceipt',
        GetParsedTransactionReceipt: {
            TransactionId: transactionId,
            DocTemplateId: null
          }
      };

//  alert(JSON.stringify(reqDO));
  vgsService('Transaction', reqDO, true,function(ansDO) {
    if (ansDO.Answer != null) {
 	    NativeBridge.call("Print", [ ansDO.Answer.GetParsedTransactionReceipt.Template.DriverList, ansDO.Answer.GetParsedTransactionReceipt.Template.DocData], function(succesfull, errorMsg){
 	    	if (!succesfull)
 	    		alert(errorMsg);
 	    });
    }
  });
}

</script>





