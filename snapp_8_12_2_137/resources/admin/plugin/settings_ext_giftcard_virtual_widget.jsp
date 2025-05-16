<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="java.util.Map.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>
<jsp:useBean id="settings" class="com.vgs.entity.dataobject.DOPlgSettings_ExtGiftCardVirtual" scope="request"/>

<v:widget caption="Settings" icon="<%=JvImageCache.ICON_SETTINGS%>">
<div class="tab-content">
  <v:grid id="giftcard-grid" style="margin-bottom:10px">
    <thead>
      <tr>
        <td><v:grid-checkbox header="true"/></td>
        <td width="30%"><v:itl key="Code"/></td>
        <td width="14%"><v:itl key="Amount"/></td>
        <td width="7%"><v:itl key="Active"/></td>
        <td width="7%"><v:itl key="Reward card"/></td> 
        <td width="7%"><v:itl key="Deny activate"/></td>
        <td width="7%"><v:itl key="Deny reload"/></td>
        <td width="7%"><v:itl key="Deny cashout"/></td>
        <td width="7%"><v:itl key="Fail activate"/></td>
        <td width="7%"><v:itl key="Fail reload"/></td>
        <td width="7%"><v:itl key="Fail cashout"/></td>
        <td></td>              
      </tr>
    </thead>
    <tbody id="giftcard-body">
    </tbody>
    <tbody>
      <tr>
        <td colspan="100%">
          <v:button fa="plus" caption="@Common.Add" onclick="addGiftcard()"/>
          <v:button fa="minus" caption="@Common.Remove" onclick="removeCards()"/>
        </td>
      </tr>
    </tbody>
  </v:grid>
</div>

</v:widget>

<script>

$(document).ready(function() {
  var settings = <%=settings.getJSONString()%>;
  
  if (settings.GiftCardList != undefined) {
    for (var i=0; i<settings.GiftCardList.length; i++) {
      var giftCard = settings.GiftCardList[i];
      addGiftcard(giftCard.Number, giftCard.Amount, giftCard.Active, giftCard.Reward, giftCard.DenyActivate, giftCard.DenyReload, giftCard.DenyCashout, giftCard.FailActivate, giftCard.FailReload, giftCard.FailCashout);
    }
  }
});

function addGiftcard(number, amount, active, reward, denyActivate, denyReload, denyCashout, failActivate, failReload, failCashout) {
  var rowNumbers = $("#giftcard-grid-grid tbody#giftcard-body tr").length;
  var tr = $("<tr class='grid-row'/>").appendTo("#giftcard-body");

  var tdCB = $("<td/>").appendTo(tr);
  var tdNumber = $("<td/>").appendTo(tr);
  var tdAmount = $("<td/>").appendTo(tr);
  
  var tdActive = $("<td/>").appendTo(tr);
  var tdReward = $("<td/>").appendTo(tr);
  
  var tdDenyActivate = $("<td/>").appendTo(tr);
  var tdDenyReload = $("<td/>").appendTo(tr);
  var tdDenyCashout = $("<td/>").appendTo(tr);
  
  var tdFailActivate = $("<td/>").appendTo(tr);
  var tdFailReload = $("<td/>").appendTo(tr);
  var tdFailCashout = $("<td/>").appendTo(tr);

  tdCB.append("<input type='checkbox' class='cblist'>");
  tdNumber.append("<input type='text' name='number' class='form-control giftcard-number'>");
  tdAmount.append("<input type='text' name='amount' class='form-control giftcard-amount'>");
  
  tdActive.append("<input type='checkbox' name='active'  class='giftcard-active'>");
  tdReward.append("<input type='checkbox' name='reward' class='giftcard-reward'>");
  
  tdDenyActivate.append("<input type='checkbox' class='giftcard-deny-activate'>");
  tdDenyReload.append("<input type='checkbox' class='giftcard-deny-reload'>");
  tdDenyCashout.append("<input type='checkbox' class='giftcard-deny-cashout'>");
  
  tdFailActivate.append("<input type='checkbox' class='giftcard-fail-activate'>");
  tdFailReload.append("<input type='checkbox' class='giftcard-fail-reload'>");
  tdFailCashout.append("<input type='checkbox' class='giftcard-fail-cashout'>");
  
  if (number)
	  tdNumber.find("input.giftcard-number").val(number);
  
  if (amount)
	  tdAmount.find("input.giftcard-amount").val(amount);
  
  if (active) 
	  $(tdActive.find("input.giftcard-active")).attr("checked", "chekced");
  else
	  $(tdActive.find("input.giftcard-active")).removeAttr("checked");
  
  if (reward)
	  $(tdReward.find("input.giftcard-reward")).attr("checked", "chekced");
  else
    $(tdReward.find("input.giftcard-reward")).removeAttr("checked");
  
  if (denyActivate) 
    $(tdDenyActivate.find("input.giftcard-deny-activate")).attr("checked", "chekced");
  else
	  $(tdDenyActivate.find("input.giftcard-deny-activate")).removeAttr("checked");
  
  if (denyReload) 
    $(tdDenyReload.find("input.giftcard-deny-reload")).attr("checked", "chekced");
  else
    $(tdDenyReload.find("input.giftcard-deny-reload")).removeAttr("checked");
  
  if (denyCashout) 
    $(tdDenyCashout.find("input.giftcard-deny-cashout")).attr("checked", "chekced");
  else
    $(tdDenyCashout.find("input.giftcard-deny-cashout")).removeAttr("checked");
  
  if (failActivate) 
    $(tdFailActivate.find("input.giftcard-fail-activate")).attr("checked", "chekced");
  else
    $(tdFailActivate.find("input.giftcard-fail-activate")).removeAttr("checked");
  
  if (failReload) 
    $(tdFailReload.find("input.giftcard-fail-reload")).attr("checked", "chekced");
  else
    $(tdFailReload.find("input.giftcard-fail-reload")).removeAttr("checked");
  
  if (failCashout) 
    $(tdFailCashout.find("input.giftcard-fail-cashout")).attr("checked", "chekced");
  else
    $(tdFailCashout.find("input.giftcard-fail-cashout")).removeAttr("checked");
  
}
	
function removeCards() {
  if ($("#giftcard-grid tbody .cblist:checked").length == 0)
    showMessage(itl("@Common.NoElementWasSelected"));
  else
    $("#giftcard-grid tbody .cblist:checked").closest("tr").remove();
}	

function getGiftCardList() {
	var giftCardList = [];
	var cards = $("#giftcard-grid tbody#giftcard-body tr");
	for (var i=0; i<cards.length; i++) {
    var card = $(cards[i]);

    giftCardList.push({
      "Number": card.find("input.giftcard-number").val(),
      "Amount": card.find("input.giftcard-amount").val(),
      
      "Active": card.find("input.giftcard-active").isChecked(),
      "Reward": card.find("input.giftcard-reward").isChecked(),
      
      "DenyActivate": card.find("input.giftcard-deny-activate").isChecked(),
      "DenyReload": card.find("input.giftcard-deny-reload").isChecked(),
      "DenyCashout": card.find("input.giftcard-deny-cashout").isChecked(),
      
      "FailActivate": card.find("input.giftcard-fail-activate").isChecked(),
      "FailReload": card.find("input.giftcard-fail-reload").isChecked(),
      "FailCashout": card.find("input.giftcard-fail-cashout").isChecked()
    });
  }
	console.log(giftCardList);
  return giftCardList;
}

function getPluginSettings() {
  return {
    GiftCardList: getGiftCardList()
  };
}

</script>
