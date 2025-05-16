<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<script>

function displayLookupResults(portfolioList) {
	//alert(JSON.stringify(portfolioList));
	$('#lookupContainer .tap').addClass("hidden");
	$('#lookupContainer #lookupResults').removeClass("hidden");
		$.each(portfolioList, function(index, value) {
			//if (portfolio) {
				$('#lookupResultsContent').html("");
				
				var lookupresults = $('<table width="100%" class="lookupLookupResults" />').appendTo('#lookupResultsContent');
				if (value.AccountProfilePictureId!=null) {
				lookupresults.append('<tr><td class="label"></td><td class="value ftright"><img src="'+"<v:config key='site_url'/>/repository?id="
                    + value.AccountProfilePictureId
                    + '&type=small" /></td></tr>');
				}
				lookupresults.append('<tr><td class="label">Name</td><td class="value ftright">'+value.AccountName+'</td></tr>');
				lookupresults.append('<tr><td class="label">Balance</td><td class="value ftright '+((parseFloat(value.WalletBalance)>0) ? '':'negative') +'">'+value.WalletBalance.formatMoney(currency.RoundDecimals, DecimalSeparator, ThousandSeparator)+' '+currency.Symbol+'</td></tr>');
				if (value.WalletCreditLimit>0) {
					lookupresults.append('<tr><td class="label">Credit Limit</td><td class="value ftright">'+value.WalletCreditLimit.formatMoney(currency.RoundDecimals, DecimalSeparator, ThousandSeparator)+' '+currency.Symbol+'</td></tr>');
					if (parseFloat(value.WalletBalance + value.WalletCreditLimit)>0) {
						var availableBalance = parseFloat(value.WalletBalance + value.WalletCreditLimit).formatMoney(currency.RoundDecimals, DecimalSeparator, ThousandSeparator);
					} else {
						var availableBalance = 0;
					}
					lookupresults.append('<tr><td class="label">Available Balance</td><td class="value ftright">'+availableBalance.formatMoney(currency.RoundDecimals, DecimalSeparator, ThousandSeparator)+' '+currency.Symbol+'</td></tr>');
				}
				window.AccountId = value.AccountId;
				//WalletBalance="10000000000";
				//alert(totals);
				
			/*} else {
				$('#tapResults').html("No account");
			}*/
		});
}
</script>





