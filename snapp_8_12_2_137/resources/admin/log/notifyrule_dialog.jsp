<%@page import="com.sun.mail.imap.Rights.Right"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.servlet.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
  BLBO_Notify bl = pageBase.getBL(BLBO_Notify.class);
  DONotifyRule notifyRule = pageBase.isNewItem() ? bl.prepareNewNotifyRule(LkSN.NotifyRuleType.getItemByCode(request.getParameter("notifyRuleType"))) : bl.loadNotifyRule(pageBase.getId());
  DONotifyRule.DONotifyRuleSale notifySale = notifyRule.NotifyRuleSale;
  DONotifyRule.DONotifyRuleEntityChange notifyEntityChange = notifyRule.NotifyRuleEntityChange;
  DONotifyRule.DONotifyRuleRedemption notifyRedemption = notifyRule.NotifyRuleRedemption;
  DONotifyRule.DONotifyRuleSale.DONotifyRuleConfig_CashInput configCashInput= notifySale.Config_CashInput;
  request.setAttribute("notifyRule", notifyRule);
  request.setAttribute("notifySale", notifySale);
  request.setAttribute("notifyRedemption", notifyRedemption);
  request.setAttribute("configCashInput", configCashInput);
  JvDataSet dsUser = pageBase.getBL(BLBO_Account.class).getUserDS();
  
  request.setAttribute("EntityRight_CanEdit", true);
  request.setAttribute("EntityRight_RightList", notifyRule.RightList);
  request.setAttribute("EntityRight_EntityTypes", new LookupItem[] {LkSNEntityType.Workstation, LkSNEntityType.Person});
  request.setAttribute("EntityRight_ShowRightLevelAutofill", false);
  request.setAttribute("EntityRight_ShowRightLevelEdit", false);
  request.setAttribute("EntityRight_ShowRightLevelDelete", false);
%>

<%!
  public static String getArrayString(String[] items) {
      String result = "[";
      for(int i = 0; i < items.length; i++) {
          result += "\"" + items[i] + "\"";
          if(i < items.length - 1) {
              result += ", ";
          }
      }
      result += "]";

      return result;
  }
  %>

<v:dialog id="notify_rule_dialog" tabsView="true" title="@Notify.NotifyRule" width="1024" height="768">

<script>
//# sourceURL=notifyrule_dialog.jsp

var notifyRuleType_EntityChange = <%=LkSNNotifyRuleType.EntityChange.getCode()%>;
var notifyRuleType_Redemption = <%=LkSNNotifyRuleType.Redemption.getCode()%>;
var notifyRuleType_Sales = <%=LkSNNotifyRuleType.Sales.getCode()%>;
var notifyRuleType_Performance = <%=LkSNNotifyRuleType.Performance.getCode()%>;
var notifyRuleType_Order = <%=LkSNNotifyRuleType.Order.getCode()%>;

var notifySaleType_Lookup = <%=LkSNNotifySaleType.MediaLookup.getCode()%>;
var notifySaleType_CashInput = <%=LkSNNotifySaleType.CashInput.getCode()%>;

$(document).ready(function() {
  mySelectize = $('#TagIDs').selectize({
    plugins: ['remove_button']
  });
  
  <%if(notifyEntityChange != null){%>
    $("#notifyEntityChange\\.NotifyEntityType").val(<%=notifyEntityChange.NotifyEntityType.getString()%>);
    $("#notifyEntityChange\\.NotifyEntityType").change(loadTags);
    loadTags(null, <%=getArrayString(notifyEntityChange.TagIDs.getArray())%>)
  <%}%>

  $("#notifyRule\\.NotifyRuleType").attr("disabled","disabled");
  $("#notifysale-widget").setClass("v-hidden", $("#notifyRule\\.NotifyRuleType").val() != notifyRuleType_Sales);
  $("#notifyredemption-widget").setClass("v-hidden", $("#notifyRule\\.NotifyRuleType").val() != notifyRuleType_Redemption);
  $("#notifyentitychange-widget").setClass("v-hidden", $("#notifyRule\\.NotifyRuleType").val() != notifyRuleType_EntityChange);

  $("#notifySale\\.NotifySaleType").change(refreshVisibility);
  $("#notifyRule\\.NotifyRuleEmail").click(refreshVisibility);
  $("#notifyRule\\.NotifyRuleSMS").click(refreshVisibility);
  refreshVisibility();
  
  $("#notifyRule\\.NotifyRuleSMS").click(function(){refreshNotificationFlag(this)});
  $("#notifyRule\\.NotifyRuleEmail").click(function(){refreshNotificationFlag(this)});

  
  var dlg = $("#notify_rule_dialog");

  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      {
        text: itl("@Common.Duplicate"),
        click: doDuplicate
      },
      {
        text: itl("@Common.Save"),
        click: doSave
      },
      {
        text: itl("@Common.Cancel"),
        click: doCloseDialog
      }
    ];
  });
  
  dlg.keypress(function() {
    if (event.keyCode == KEY_ENTER)
      doSave(false, null);
  });

  function refreshVisibility(){
    $('#notifyentity-recipients').setClass("v-hidden", ($("#notifyRule\\.NotifyRuleType").val() == notifyRuleType_Order) || !($("#notifyRule\\.NotifyRuleEmail").isChecked() || $("#notifyRule\\.NotifyRuleSMS").isChecked()));

    $(".notify-cashInput-block").each(function() {
      $(this).setClass("v-hidden", $(this).attr("data-NotifyCashType") != $('#notifySale\\.NotifySaleType').val());
    });
  }

  function loadTags(event, items) {
    var reqDO = {
      Command: "GetList",
      GetList: {
        EntityType: $("#notifyEntityChange\\.NotifyEntityType").val()
      }
    };

    vgsService("Tag", reqDO, false, function(ansDO) {
      if (mySelectize[0]) {
	      mySelectize[0].selectize.clearOptions();
	      if(ansDO.Answer != undefined && ansDO.Answer.GetList != undefined && ansDO.Answer.GetList.TagList != undefined){
	        var tags=[];
	        for(var i=0; i<ansDO.Answer.GetList.TagList.length; i++){
	          var obj = {};
	          obj.value = ansDO.Answer.GetList.TagList[i].TagId;
	          obj.text = ansDO.Answer.GetList.TagList[i].TagName;
	          tags.push(obj);
	        }
	        mySelectize[0].selectize.addOption(tags);
	        
	        if (items) {
	          mySelectize[0].selectize.addItems(items);
	          mySelectize[0].selectize.refreshItems();
	        }
	      }
      }
    });
  }
  
  function refreshNotificationFlag(clicked) {
    if($("#notifyRule\\.NotifyRuleType").val() == notifyRuleType_EntityChange){
      if($("[class=notify-checkbox]").is(':checked') == false)
        $(clicked).click();
    }
  }
  
  function doSave(duplicate, name) {
    duplicate = (duplicate === true);
    checkRequired("#notify_rule_dialog #tabs-main", function() {
      var notifyRuleId = <%=notifyRule.NotifyRuleId.isNull() ? null : "\"" +  notifyRule.NotifyRuleId.getHtmlString() + "\"" %>
      var notifyRuleName = $('#notifyRule\\.NotifyRuleName').val();
      if (duplicate) {
        notifyRuleId = null;
        notifyRuleName = name;
      }
      
      var notifyRuleType = parseInt($('#notifyRule\\.NotifyRuleType').val());
      
      var reqDO = {
        Command: "SaveNotifyRule",
        SaveNotifyRule: {
          NotifyRule: {
            NotifyRuleId: notifyRuleId,
            NotifyRuleType: notifyRuleType,
            NotifyRuleName: notifyRuleName,
            Active: $('#notifyRule\\.NotifyRuleActive').isChecked(),
            SendEmail: $('#notifyRule\\.NotifyRuleEmail').isChecked(),
            SendSMS: $('#notifyRule\\.NotifyRuleSMS').isChecked(),
            RoleIDs: $("#notifyRule\\.RoleIDs").val(),
            UserIDs: $("#notifyRule\\.UserIDs").val(),
            RightList: []
          }
        }
      };
      
      if (notifyRuleType == notifyRuleType_EntityChange) 
          reqDO.SaveNotifyRule.NotifyRule.NotifyRuleEntityChange = getNotifyRuleEntityChange_Config();
      if (notifyRuleType == notifyRuleType_Sales) 
    	  reqDO.SaveNotifyRule.NotifyRule.NotifyRuleSale = getNotifyRuleSale_Config();
      if (notifyRuleType == notifyRuleType_Redemption) 
          reqDO.SaveNotifyRule.NotifyRule.NotifyRuleRedemption = getNotifyRulRedemption_Config();
    	else if (notifyRuleType == notifyRuleType_Performance)
        reqDO.SaveNotifyRule.NotifyRule.NotifyRulePerformance = getNotifyRulePerformance_Config();
    	else if (notifyRuleType == notifyRuleType_Order)
        reqDO.SaveNotifyRule.NotifyRule.NotifyRuleOrder = getNotifyRuleOrder_Config();
      
      var rows = $("#entityright-grid tbody tr").not(".group");
      for (var i=0; i<rows.length;  i++) {
        reqDO.SaveNotifyRule.NotifyRule.RightList.push({
          UsrEntityType: $(rows[i]).attr("data-EntityType"),  
          UsrEntityId: $(rows[i]).attr("data-EntityId"),
          RightLevel: <%=LkSNRightLevel.Read.getCode()%>
        });
      }
      
      if ((!($("#notifyRule\\.NotifyRuleEmail").isChecked() || $("#notifyRule\\.NotifyRuleSMS").isChecked())) && ($("#notifyRule\\.NotifyRuleType").val() == notifyRuleType_EntityChange))
        showMessage(itl("@Notify.SendMailOrSMSRequired"));
      else {
        if (checkValue(reqDO.SaveNotifyRule.NotifyRule)) {
          showWaitGlass();
          vgsService("Notify", reqDO, false, function(ansDO) {
            hideWaitGlass();
            changeGridPage("#notifyrule-grid", 1);
            dlg.dialog("close");
            if (duplicate) {
              asyncDialogEasy('log/notifyrule_dialog', 'id=' + ansDO.Answer.SaveNotifyRule.NotifyRuleId);
            }
          });
        } 
      }
    });
  }
  
  //DUPLICATE
  
  function doDuplicate() {
    confirmDialog(null, function() {
      doSave(true, "duplicated");
    });
  }
  
  function checkValue(data) {
    if (data.NotifyRuleType == notifyRuleType_Sales) {
      if(data.NotifyRuleSale.Config_CashInput != undefined && data.NotifyRuleSale.Config_CashInput.CashAmount != null){
        data.NotifyRuleSale.Config_CashInput.CashAmount = data.NotifyRuleSale.Config_CashInput.CashAmount.replace(",", ".");
        var cashAmount = checkInteger(data.NotifyRuleSale.Config_CashInput.CashAmount);
        if (!cashAmount){
          showMessage(itl("@Notify.CashAmountValueNotValid"));
          return false;
        } 
      } 
    } else if (data.NotifyRuleType == notifyRuleType_Order) {
      if (!data.NotifyRuleOrder.NotifyOrder_OrderNotificationRecipientType) {
    	  if (!data.NotifyRuleOrder.NotifyOrder_AltEmailAddress || (data.NotifyRuleOrder.NotifyOrder_AltEmailAddress.trim().length == 0)) {
    		  showMessage(itl("@Notify.InvalidRecipient"));
          return false;
    	  }
      }
      if ((data.NotifyRuleOrder.NotifyOrder_Trg_TriggerType == <%=LkSNNotifyRuleOrderTriggerType.OrderStatusChange.getCode()%>) && (data.NotifyRuleOrder.NotifyOrder_Trg_Flags.length == 0)) {
    	  showMessage(itl("@Notify.OrderStatusChangeError"));
        return false;
      }
    	  
      
    }
    
    return true;
  }

  function checkInteger(value) {
    return $.isNumeric(value); 
  }
});
</script>

  <v:tab-group name="tab" main="true">
    <!-- PROFILE -->
    <v:tab-item-embedded tab="tabs-main" caption="@Common.Profile" default="true">
      <div class="tab-content">
        <v:widget caption="@Common.General">
          <v:widget-block>
             <v:form-field caption="@Common.Type" mandatory="true">
              <v:lk-combobox field="notifyRule.NotifyRuleType" lookup="<%=LkSN.NotifyRuleType%>" alphaSort="true" allowNull="false"/>
            </v:form-field>
            <v:form-field caption="@Common.Name" mandatory="true">
              <v:input-text field="notifyRule.NotifyRuleName"/>
            </v:form-field>
            <% if (!notifyRule.NotifyRuleType.isLookup(LkSNNotifyRuleType.Order)) { %>
	            <v:form-field caption="@Notify.Notification" mandatory="true">
	              <v:db-checkbox clazz="notify-checkbox" field="notifyRule.NotifyRuleEmail" checked="<%=notifyRule.SendEmail.getBoolean()%>" value="" caption="@Common.Email"/>
	              &nbsp;&nbsp;&nbsp;
	              <v:db-checkbox clazz="notify-checkbox" field="notifyRule.NotifyRuleSMS" checked="<%=notifyRule.SendSMS.getBoolean()%>" value="" caption="@Common.SMS"/>
	            </v:form-field>
            <% } %>
          </v:widget-block>
          <v:widget-block>
            <v:db-checkbox field="notifyRule.NotifyRuleActive" checked="<%=notifyRule.Active.getBoolean()%>" value="" caption="@Common.Active"/>
          </v:widget-block>
        </v:widget>
        
        <v:widget caption="@Notify.Recipients" id="notifyentity-recipients">
          <v:widget-block>
            <v:form-field caption="@Common.SecurityRoles">
              <v:multibox field="notifyRule.RoleIDs" name="notifyRule.RoleIDs" linkEntityType="<%=LkSNEntityType.Role%>" filtersJSON="{\"Role\":{\"RoleType\":0,\"ActiveOnly\":true}}"/>
            </v:form-field>
            <v:form-field caption="@Account.Users">
              <v:multibox field="notifyRule.UserIDs" name="notifyRule.UserIDs" lookupDataSet="<%=dsUser%>" idFieldName="AccountId" captionFieldName="DisplayName"/>
            </v:form-field>
          </v:widget-block>
        </v:widget>
        
        <% if (notifyRule.NotifyRuleType.isLookup(LkSNNotifyRuleType.Sales)) { %>
          <jsp:include page="notifyrule_sale_widget.jsp"></jsp:include>
        <% } else if (notifyRule.NotifyRuleType.isLookup(LkSNNotifyRuleType.EntityChange)) { %>
          <jsp:include page="notifyrule_entitychange_widget.jsp"></jsp:include>
        <% } else if (notifyRule.NotifyRuleType.isLookup(LkSNNotifyRuleType.Redemption)) { %>
          <jsp:include page="notifyrule_redemption_widget.jsp"></jsp:include>
        <% } else if (notifyRule.NotifyRuleType.isLookup(LkSNNotifyRuleType.Performance)) { %>
          <jsp:include page="notifyrule_performance_widget.jsp"></jsp:include>
        <% } else if (notifyRule.NotifyRuleType.isLookup(LkSNNotifyRuleType.Order)) { %>
          <jsp:include page="notifyrule_order_widget.jsp"></jsp:include>
        <% } %>
      </div>
    </v:tab-item-embedded>
  

    <!-- RIGHTS -->
    <v:tab-item-embedded tab="tabs-right" caption="@Common.Rights">
      <jsp:include page="../common/page_tab_rights.jsp"/>
    </v:tab-item-embedded>
    
    <!-- ACTION -->
    <% if ((notifyRule.ActionCount.getInt() > 0) || pageBase.isTab("tab", "tabs-action")) { %>
    <v:tab-item-embedded tab="tabs-action" caption="@Common.Email">
      <jsp:include page="../common/page_tab_actions.jsp"/>
    </v:tab-item-embedded>
    <% } %>

    <!-- HISTORY -->
    <% if (!pageBase.isNewItem() && rights.History.getBoolean()) { %>
      <v:tab-item-embedded tab="tabs-history" caption="@Common.History">
        <jsp:include page="../common/page_tab_historydetail.jsp"/>
      </v:tab-item-embedded>
    <% } %>
  </v:tab-group>

</v:dialog>