<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.service.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
    
<%
String categoryId = pageBase.getRights().AccountPRS_DefaultCategoryId.getString();
if (categoryId == null)
  categoryId = pageBase.getBL(BLBO_Category.class).getRootCategoryId(LkSNEntityType.Person);
%>

<script>
//# sourceURL=shipaccount_dialog_js.jsp
$(document).ready(function() {
	var container = $("#shipaccount_itemaccount_list .widget-block");
	container.empty();
	
  var hasOrderGuestOnly = false;
	var hasItemAccount = false;
	var isItemAccount = false;
	
	if (shopCart.Items) {
		for (var i=0; i<shopCart.Items.length; i++) {
			var item = shopCart.Items[i];
			
			if (hasOrderGuestOnly !== true) {
	      var productFlags = getIntArray(item.ProductFlags);
	      hasOrderGuestOnly = (productFlags.indexOf(<%=LkSNProductFlag.OrderGuestOnly.getCode()%>) >= 0);
			}
			
			if (item.ItemDetailList) {
	      for (var k=0; k<item.ItemDetailList.length; k++) {
	        var detail = item.ItemDetailList[k];
	        if ((detail.AccountId != null) && ((detail.AccountContexts || []).indexOf(<%=LkSNAccountContext.OrderGuest.getCode()%>) >= 0)) {
	          var div = $("<div><label class='checkbox-label'><input type='radio' name='radio-ItemAccount'/> <span></span></label></div>").appendTo(container);
	          div.find("span").text(detail.AccountName);
	          div.find("input").val(detail.AccountId);
	          div.find("input").attr("data-AccountCode", detail.AccountCode);
	          div.find("input").attr("data-AccountName", detail.AccountName);
	          div.find("input").attr("data-AccountEmail", detail.AccountEmail);
	          
	          hasItemAccount = true;
	          if (detail.AccountId == shopCart.ShipAccountId) {
	            isItemAccount = true;
	            div.find("input").prop("checked", true);
	          }
	        } 
	      }
			}
		}
	}
	
  var radios = $("#shipaccount_dialog [name='radio-AccountOption']");   
  radios.filter("[value='anonymous']").setEnabled(hasOrderGuestOnly !== true);
  
	if (isItemAccount) 
		setRadioChecked(radios, "itemaccount");
  else if ((shopCart.ShipAccountId != null) || (hasOrderGuestOnly === true)) 
    setRadioChecked(radios, "newaccount");
	else {
		var first = $(container).find("input");
		if (first.length > 0)
	    $(first[0]).prop("checked", true);
	}
	
	$("#option-itemaccount").setClass("v-hidden", !hasItemAccount);
  onAccountOptionClick();
});

function getShipAccountOption() {
	return $("#shipaccount_dialog [name='radio-AccountOption']:checked").val();;
}

function onAccountOptionClick() {
	var shipAccountOption = getShipAccountOption();
	
	$("#shipaccount_itemaccount_list").setClass("v-hidden", shipAccountOption != "itemaccount");
	
	var newAccountContainer = $("#shipaccount-newaccount-container");
	newAccountContainer.setClass("v-hidden", shipAccountOption != "newaccount");
	
	if ((shipAccountOption == "newaccount") && !newAccountContainer.hasClass("initialized")) {
		newAccountContainer.addClass("initialized");
		
		var shipAccountId = shopCart.ShipAccountId;
		if (shipAccountId != null) {
		  if ($("#shipaccount_itemaccount_list input[name='radio-ItemAccount'][value='" + shipAccountId + "']").length > 0)
			  shipAccountId = null;
		}
		newAccountContainer.attr("data-AccountId", shipAccountId);
		
		var urlo = "<%=pageBase.getContextURL()%>?page=maskedit_widget&LoadData=true&EntityType=<%=LkSNEntityType.Person.getCode()%>";
		if (shipAccountId == null) 
      urlo += "&CategoryId=<%=categoryId%>";
    else
			urlo += "&id=" + shipAccountId;
		
		asyncLoad(newAccountContainer, urlo);
	}
}

$("#shipaccount_dialog [name='radio-AccountOption']").click(onAccountOptionClick);

function doCloseShipAccountDialog(stepDir) {
  $("#shipaccount_dialog").dialog("close");
  stepCallBack(Step_ShipAccount, stepDir);
}

$("#btn-shipaccount-back").click(function() {
	doCloseShipAccountDialog(StepDir_Back);
});

$("#btn-shipaccount-next").click(function() {
  var shipAccountOption = getShipAccountOption();
  
  if (shipAccountOption == "anonymous") {
    shopCart.ShipAccountId = null;
	  shopCart.ShipAccountCode = null;
    shopCart.ShipAccountName = null;
	  shopCart.ShipAccountEmail = null;
	  doCloseShipAccountDialog(StepDir_Next);
  }
  else if (shipAccountOption == "itemaccount") {
    doSetShipAccount($("#shipaccount_itemaccount_list input:checked").val(), function() {
      doCloseShipAccountDialog(StepDir_Next);
    });
  }
  else if (shipAccountOption == "newaccount") {
	  var list = prepareMetaDataArray("#shipaccount-newaccount-container");

	  if (!(list)) 
	    showMessage("<v:itl key="@Common.CheckRequiredFields" encode="UTF-8"/>");
	  else {
	    showWaitGlass();
	    var reqDO = {
	      Command: "SaveAccount",
	      SaveAccount: {
	        AccountId: $("#shipaccount-newaccount-container").attr("data-AccountId"),
	        EntityType: <%=LkSNEntityType.Person.getCode()%>,
	        CategoryId: <%=JvString.jsString(categoryId)%>,
	        MetaDataList: list
	      }
	    };
	    
	    vgsService("Account", reqDO, false, function(ansDO) {
	      doSetShipAccount(ansDO.Answer.SaveAccount.AccountId, function() {
	        hideWaitGlass();
	        doCloseShipAccountDialog(StepDir_Next);
	      });
	    });
	  }
  }
});

</script>