<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageAccount" scope="request"/>
<jsp:useBean id="account" scope="request" class="com.vgs.snapp.dataobject.DOAccount"/>

<div class="tab-toolbar">
  <v:button caption="@Common.Add" fa="plus" href="javascript:showAddSerialDialog()"/>
  <v:button caption="@Common.Remove" fa="minus" href="javascript:removeSerials()"/>
  <v:pagebox gridId="resserial-grid"/>
</div>

<div class="tab-content">
  <v:last-error/>

  <% String params = "EntityId=" + pageBase.getId(); %>
  <v:async-grid id="resserial-grid" jsp="resource/resourceserial_grid.jsp" params="<%=params%>"/>
</div>

<script>

function showAddSerialDialog() {
  asyncDialogEasy("resource/resourceserial_dialog", "id=new&EntityId=<%=account.AccountId.getHtmlString()%>&EntityType=<%=account.EntityType.getInt()%>&ResourceTypeId=<%=account.ResourceTypeId.getHtmlString()%>");
}

function removeSerials() {
  confirmDialog(null, function() {
    var reqDO = {
      Command: "RemoveSerial",
      RemoveSerial: {
        ResourceSerialIDs: $("[name='ResourceSerialId']").getCheckedValues()
      }
    };
    
    vgsService("Resource", reqDO, false, function(ansDO) {
      triggerEntityChange(<%=LkSNEntityType.ResourceSerial.getCode()%>);
    });
  });
}

function doAddSerial() {
  var reqDO = {
    Command: "AddSerial",
    AddSerial: {
      EntityId: "<%=account.AccountId.getHtmlString()%>",
      EntityType: <%=account.EntityType.getInt()%>,
      SerialCodes: $("#txt-new-serial").val()
    }
  };
  
  vgsService("Resource", reqDO, false, function(ansDO) {
    triggerEntityChange(<%=LkSNEntityType.ResourceSerial.getCode()%>);
    $("#resserial-dialog").dialog("close");
  });
}

</script>