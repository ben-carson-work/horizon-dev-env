<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% 
LookupItem entityType = LkSN.EntityType.getItemByCode(pageBase.getParameter("EntityType")); 
String queryBase64 = pageBase.getNullParameter("QueryBase64");
String sEntityIDs = pageBase.getNullParameter("EntityIDs");
%>

<script>

$(document).ready(function() {
  var $dlg = $("#multiedit_dialog");
  $dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      dialogButton("@Common.Update", doSave),
      dialogButton("@Common.Cancel", doCloseDialog)
    ];
  });
  
  function prepareRequestData() {
    var result = {};
    
    $dlg.find(".v-cfgform-field.selected").each(function(index, elem) {
      var $field = $(elem);
      var fieldPath = ($field.attr("data-field") || "").split(".");
      var $control = $field.find(".value-control");
      
      var value = getNull($control.val());
      if ($control.is(".v-switch"))
        value = $control.is(".v-switch-on");
      
      if ($control.is(".v-date"))
	      value = $control.getXMLDate();
    
      var node = result;
      for (var i=0; i<fieldPath.length; i++) {
        var pathItem = fieldPath[i];
        if (i == fieldPath.length - 1)
          node[pathItem] = value;
        else {
          if (node[pathItem] === undefined) 
            node[pathItem] = {};
          node = node[pathItem];
        } 
      }
    });
    
    return result;
  }
  
  function prepareRequest_Account(queryBase64, accountIDs) {
    return reqDO = {
      Service: "Account",
      Command: "SaveMultiEditAccount",
      Request: {
        QueryBase64: queryBase64,
        AccountIDs: accountIDs,
        Account: prepareRequestData()        
      }
    };
  }
  
  function prepareRequest_RedemptionCommissionRule(queryBase64, redemptionCommissionRuleIDs) {
    return reqDO = {
      Service: "RedemptionCommissionRule",
      Command: "SaveMultiEditRedemptionCommissionRule",
      Request: {
        QueryBase64: queryBase64,
        RedemptionCommissionRuleIDs: redemptionCommissionRuleIDs,
        RedemptionCommissionRule: prepareRequestData()        
      }
    };
  }
  
  function prepareRequest() {
    var queryBase64 = <%=JvString.jsString(queryBase64)%>;
    var entityIDs = <%=JvString.jsString(sEntityIDs)%>;
    
    <% if (entityType.isLookup(LkSNEntityType.getAccountEntityTypes())) { %>
      return prepareRequest_Account(queryBase64, entityIDs)
    <% } else if (entityType.isLookup(LkSNEntityType.RedemptionCommissionRule)) { %>
      return prepareRequest_RedemptionCommissionRule(queryBase64, entityIDs)      
    <% } else { %>
      throw new RuntimeException("EntityType not handled: " + entityType);
    <% } %>
  }
  
  function getAsyncProcessId(ansDO) {
    <% if (entityType.isLookup(LkSNEntityType.getAccountEntityTypes())) { %>
      return ansDO.AsyncProcessId
    <%} else if(entityType.isLookup(LkSNEntityType.RedemptionCommissionRule)) { %>
      return ansDO.AsyncProcessId
    <% } else { %>
      throw new RuntimeException("EntityType not handled: " + entityType);
    <% } %>
  }
  
  function doSave() {
    var request = prepareRequest();
    console.log(request);
    
    snpAPI.cmd(request.Service, request.Command, request.Request).then(ansDO => {
      $dlg.dialog("close");
      
      showAsyncProcessDialog(getAsyncProcessId(ansDO), function() {
        triggerEntityChange(<%=entityType.getCode()%>);
      });
    });
  }
});

</script>
