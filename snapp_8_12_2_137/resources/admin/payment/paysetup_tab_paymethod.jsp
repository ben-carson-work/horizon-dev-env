<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PagePaymentSetup" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<v:tab-toolbar>
  <v:button caption="@Common.Search" fa="search" onclick="search()"/>
  
  <v:button-group>
    <v:button caption="@Common.New" fa="plus" href="javascript:showDriverPickup()"/>
    <v:button caption="@Common.Delete" fa="trash" href="javascript:deletePaymentMethods()"/>
  </v:button-group>
  
  <v:button-group>
    <v:button caption="@Common.Import" fa="sign-in" onclick="showImportDialog()"/>
    <v:button caption="@Common.Export" fa="sign-out" clazz="no-ajax" bindGrid="paymethod-grid"  onclick="exportPaymentMethod()"/>
  </v:button-group>
  
  <% String hRef="javascript:showHistoryLog(" + LkSNEntityType.PaymentMethod.getCode() + ")";%>
  <v:button caption="@Common.History" fa="history" href="<%=hRef%>" enabled="<%=rights.History.getBoolean()%>"/>
  <v:pagebox gridId="paymethod-grid"/>
</v:tab-toolbar>
    
<v:tab-content>
  <v:profile-recap>
    <v:widget caption="@Common.Search">
      <v:widget-block>
        <input type="text" id="full-text-search" class="form-control default-focus" placeholder="<v:itl key="@Common.FullSearch"/>" value="<%=pageBase.getEmptyParameter("FullText")%>"/>
      </v:widget-block>
     </v:widget>
    
     <v:widget caption="@Common.Status">
       <v:widget-block>
         <v:db-checkbox field="PaymentStatus" caption="@Common.Enabled" value="true" /><br/>
         <v:db-checkbox field="PaymentStatus" caption="@Common.Disabled" value="false" /><br/>          
       </v:widget-block>
     </v:widget>
    
     <v:widget caption="@Common.Type">
       <v:widget-block>
         <% int[] paymentCodes = LkSNDriverType.getGroup(LkSNDriverType.GROUP_Payment);%>         
         <% for (LookupItem type : LkSN.DriverType.getItemsByCodes(paymentCodes)) { %>
           <v:db-checkbox field="PaymentType" caption="<%=type.getDescription(pageBase.getLang())%>" value="<%=String.valueOf(type.getCode())%>"/><br/>
         <% } %>
       </v:widget-block>
     </v:widget>
  </v:profile-recap>
  
  <v:profile-main>
    <v:async-grid id="paymethod-grid" jsp="payment/paymethod_grid.jsp" />
  </v:profile-main>
</v:tab-content>

<script>
  $(document).ready(function() {
    $("#full-text-search").keypress(function(e) {
      if (e.keyCode == KEY_ENTER) {
        search();
        return false;
      }
    });
  });
	  
  function search() {
    setGridUrlParam("#paymethod-grid", "PaymentType", $("[name='PaymentType']").getCheckedValues());	
    setGridUrlParam("#paymethod-grid", "PaymentStatus", $("[name='PaymentStatus']").getCheckedValues());
    setGridUrlParam("#paymethod-grid", "FullText", $("#full-text-search").val(), true);
  }
  
  function showDriverPickup() {
    asyncDialogEasy("plugin/driver_pickup_dialog", "DriverGroup=<%=LkSNDriverType.GROUP_Payment%>");
  }
  
  function driverPickupCallback(driverId) {
    var reqDO = {
      Command: "CreatePaymentMethod",
      CreatePaymentMethod: {
        DriverId: driverId
      }
    };
    
    vgsService("PayMethod", reqDO, false, function(ansDO) {
      window.location = "<%=pageBase.getContextURL()%>?page=paymethod&id=" + ansDO.Answer.CreatePaymentMethod.PluginId      
    });
  }
  
  function deletePaymentMethods() {
    confirmDialog(null, function() {
      var reqDO = {
        Command: "DeletePaymentMethod",
        DeletePaymentMethod: {
          PaymentMethodIDs: $("[name='PluginId']").getCheckedValues()
        }
      };
      
      vgsService("PayMethod", reqDO, false, function(ansDO) {
        triggerEntityChange(<%=LkSNEntityType.PaymentMethod.getCode()%>);      
      });
    });
  }
  
  function showImportDialog() {
    asyncDialogEasy("payment/paymentmethod_snapp_import_dialog", "");
  }
        
  function exportPaymentMethod() {
    var bean = getGridSelectionBean("#paymentmethod-grid-table", "[name='PluginId']");
    if (bean) 
      window.location = BASE_URL + "/admin?page=export&EntityIDs=" + bean.ids + "&EntityType=<%=LkSNEntityType.PaymentMethod.getCode()%> + &QueryBase64=" + bean.queryBase64;
  }
</script>
