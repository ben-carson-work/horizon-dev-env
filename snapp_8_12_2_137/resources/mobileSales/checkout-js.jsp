<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageMobileSales" scope="request"/>

<script>
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

function doTransaction () {
	$('#floatingBarsGbg').show();
	
	if (localStorage.getItem('AccountId')) {
		var AccountId = localStorage.getItem('AccountId');
	} else {
		var AccountId = window.AccountId;
	}
	var AccountId = window.AccountId;
	var notes = window.OrderNote;

	reqDO = {
			MediaCount : 0
	      };   
	vgsService('generatemediacode',reqDO,false, function(ansDO) {
		//alert(JSON.stringify(ansDO.Answer));
		PNR = ansDO.Answer.PNR;
		TransactionSerial = ansDO.Answer.TransactionSerial;
		TransactionFiscalDate = ansDO.Answer.TransactionFiscalDate;
		now = new Date();
		
		var myDate_string = formatDate(new Date());
				
		transactionXML = { 
				
					Request: {
						SaleCodeExt : PNR,
						AccountId: AccountId,
						TransactionSerial: TransactionSerial,
						TransactionFiscalDate: TransactionFiscalDate,
						TransactionDateTime: myDate_string,
						
						TransactionType: 1,
            			WorkstationId: workstationId,
            			UserAccountId: userAccountId,
						HoldId: "",
						Approved:1,
						Encoded:1,
						Printed:1,
						Validated:1,
						Completed:1,
						PortfolioList: {
							
						},
						SaleItemList: {
						},
						SaleSurveyMetaDataList: {
						},
						PaymentList: {
						}
				    }
				};   
		
		transactionXML['Request']['SaleSurveyMetaDataList'] = new Array();
		
		SaleSurveyMetaData = {
        MetaFieldCode: 'TABLE',
				Value:OrderLocation,
			}

		transactionXML['Request']['SaleSurveyMetaDataList'].push(SaleSurveyMetaData);
		SaleSurveyMetaData = {
				MetaFieldCode: 'NOTES',
				Value:window.OrderNote,
			}

		transactionXML['Request']['SaleSurveyMetaDataList'].push(SaleSurveyMetaData);
		
		transactionXML['Request']['PaymentList'] = new Array();
		/*if (localStorage.getItem('AccountId')) {
			payment = {
					PaymentType:1,
					PaymentStatus:2,
					CurrencyAmount:totals,
					CurrencyISO:'',
					ExchangeRate:1,
					Change:1,
					PaymentAmount:totals,
				}
		} else {
			*/
			payment = {
				PaymentType:15,
				PaymentStatus:2,
				CurrencyAmount:totals,
				CurrencyISO:'',
				ExchangeRate:1,
				Change:1,
				PaymentAmount:totals,
				Wallet: {
					PortfolioId: window.PortfolioId,
					MediaCode:window.MediaCode
				}
			}
		//}
		
		transactionXML['Request']['PaymentList'].push(payment);
		transactionXML['Request']['PortfolioList'] = new Array();
		for (i = 1; i <= totalitems; i++) { 
		    portfolio = {
		    		
		    			PortfolioGroup:i,
		    			AccountId: AccountId,
		    			Medialist: {
		    				
		    					MediaStatus:0,
		    					MediaType:0,
		    					MediaCodeList: {
		    						MediaCode:window.barcode,
		    						MediaCodeType:1
		    					}
		    				
		    			}
		    		
		    };
		    transactionXML['Request']['PortfolioList'].push(portfolio);
		}
		
		
		transactionXML['Request']['SaleItemList'] = new Array();
		//alert(JSON.stringify(transactionXML));
		i=0;
		$('.cartRows .item').each(function(index, value) {
			i = i+1;
			qty = $(value).find('.quantity').html();
			unitprice = $(value).find('.cartItemUnitPrice').html();
			itemprice =  $(value).find('.cartItemPrice').html();
			productId = $(this).attr('data-id');
			
			saleitem = { 
					ProductId: productId,
					PerformanceTypeId:'',
					Performances:'',
					Quantity:qty,
					Options:'',
					UnitRawPrice: unitprice,
					TaxCalcType: 1,
					UnitAmount:unitprice,
					UnitTax:0,
					TotalAmount: itemprice,
					TotalTax:0,
					SaleItemDetail: {
						Position:1,
						PortfolioGroup:i,
						SeatHoldId:'',
						SeatIDs:''
					}
				
			};
			attr = $(this).attr('data-attr');
			if (attr) {
				saleitem['Options'] = attr;
			}
			transactionXML['Request']['SaleItemList'].push(saleitem);
			//transactionXML = transactionXML.replace("\\", "\\\\");
		
		});
		//alert(JSON.stringify(transactionXML));
		uploadId = getUniquid().toString();
		reqDO = {
				Command: 'Add',
				Add: {
					UploadId: uploadId,
					UploadType: 1,
					MsgRequest: JSON.stringify(transactionXML)
				}
		      };   
		//alert(JSON.stringify(reqDO));
		vgsService('Upload',reqDO,false, function(ansDO) {
			//alert(JSON.stringify(ansDO));
			reqDO = {
					Command: 'Status',
					Status: {
						UploadId: uploadId
					}
			      }; 
			//alert(JSON.stringify(reqDO));
			vgsService('Upload',reqDO,false, function(ansDO) {
				//alert(JSON.stringify(ansDO.Answer.Status.UploadStatus));
				UploadStatus = ansDO.Answer.Status.UploadStatus;
				if (UploadStatus<3){
					checkUploadStatus(uploadId);
				} else if (UploadStatus==3) {
					$('#floatingBarsGbg').hide();
					showTransactionResults(ansDO.Answer.Status.EntityId,"ok");
				} else if (UploadStatus>3) {
					$('#floatingBarsGbg').hide();
					showTransactionResults(ansDO.Answer.Status.EntityId,"error");
				}
				
			});
		});
		
	});
   
}
function showTransactionResults(TransactionId,type) {
	if (type=="ok") {
		//alert(TransactionId);
		reqDO = {
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
				
			
			reqDO = {
				Command : 'Lookup',
				Lookup: {
					MediaCode:window.barcode
				}
		     };
				
			$('#floatingBarsGbg').show();
				  
			vgsService('Portfolio',reqDO,false, function(ansDO) {
				$('#floatingBarsGbg').hide();
				portfolioList = ansDO.Answer.Lookup.PortfolioList;
				
				$('#transactionResultLookup').html("");
				$.each(portfolioList, function(index, value) {
					var lookupresults = $('<table class="transactionLookupResults" />').appendTo('#transactionResultLookup');
					if (value.AccountProfilePictureId!=null) {
						lookupresults.append('<tr><td class="label"></td><td class="value ftright"><img src="'+"<v:config key='site_url'/>/repository?id="
	                    + value.AccountProfilePictureId
	                    + '&type=small" /></td></tr>');
					}
					lookupresults.append('<tr><td class="label">Name</td><td class="value ftright">'+value.AccountName+'</td></tr>');
					lookupresults.append('<tr><td class="label">New Balance</td><td class="value ftright '+((parseFloat(value.WalletBalance)>0) ? '':'negative') +'">'+value.WalletBalance.formatMoney(currency.RoundDecimals, DecimalSeparator, ThousandSeparator)+' '+currency.Symbol+'</td></tr>');
				});
				
				
				
			});
			//} 
			totalitems = 0;
			totals = 0;
			updateTotals(totalitems,totals);
			$('.cartRows').html("");
			$('.productQtyCart').html("");
			OrderLocation = '';
			$('#location').val("");
			$('#note').val("");
				//alert(JSON.stringify(portfolioList));
				
		});
	} else {
		mainactivity(mainactivity_step.transactionResult);
		$("#transactionResultContent .thumb").css("background-image","url('<v:image-link name="[font-awesome]times|CircleRed" size="100"/>')");
		$("#transactionResultContent .text").html("Transaction Failed");
		$('#transactionResultContainer').removeClass('hidden');
	}
}

function checkUploadStatus (uploadId) {
	reqDO = {
			Command: 'Status',
			Status: {
				UploadId: uploadId
			}
	      }; 
	//alert(JSON.stringify(reqDO));
	vgsService('Upload',reqDO,false, function(ansDO) {
		//alert(JSON.stringify(ansDO));
		UploadStatus = ansDO.Answer.Status.UploadStatus;
		if (UploadStatus<3){
			checkUploadStatus(uploadId)
		} else if (UploadStatus==3) {
			$('#floatingBarsGbg').hide();
			showTransactionResults(ansDO.Answer.Status.EntityId,"ok");
		} else if (UploadStatus>3) {
			$('#floatingBarsGbg').hide();
			showTransactionResults(ansDO.Answer.Status.EntityId,"error");
		}
	});
}

function checkoutTapResults(portfolioList) {

	$('#checkoutContainer .tap').addClass("hidden");
	$('#checkoutContainer #tapResults').removeClass("hidden");
	//alert(JSON.stringify(ansDO.Answer.Lookup.PortfolioList));
	

	$.each(portfolioList, function(index, value) {
		//if (portfolio) {
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
			//alert(JSON.stringify(value));
			
			//value.WalletBalance="10000000000"; //uncomment for test mode
			//alert(value.WalletBalance);
			if (parseFloat(value.WalletBalance) >= totals) {
			//if (parseFloat(portfolio.WalletBalance) > totals) {
				$('#checkoutContainer .pay').removeClass('disabled');
			} else if(parseFloat(value.WalletBalance + value.WalletCreditLimit)>=totals) {
				$('#checkoutContainer .pay').removeClass('disabled');
			} else {
				$('#checkoutContainer .pay').addClass('disabled');
			}
		/*} else {
			$('#tapResults').html("No account");
		}*/
	});

//return portfolio;
}
function formatDate(date1) {
	  return date1.getFullYear() + '-' +
	    (date1.getMonth() < 9 ? '0' : '') + (date1.getMonth()+1) + '-' +
	    (date1.getDate() < 10 ? '0' : '') + date1.getDate()+"T"+
	    (date1.getHours() < 10 ? '0' : '') + date1.getHours()+":"+
	    (date1.getMinutes() < 10 ? '0' : '') + date1.getMinutes()+":"+
	  	(date1.getSeconds() < 10 ? '0' : '') + date1.getSeconds();
	}
</script>





