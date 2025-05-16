<%@page import="javax.annotation.Resources"%>
<%@page import="com.vgs.snapp.dataobject.DOResourceSerial"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_ResourceSerial.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<% 
  BLBO_Resource bl = pageBase.getBL(BLBO_Resource.class);
  DOResourceSerial resourceSerial; 
  if (pageBase.isNewItem()) {
    LookupItem entityType = LkSN.EntityType.getItemByCode(pageBase.getParameter("EntityType"));
    resourceSerial = bl.prepareNewSerial(pageBase.getParameter("EntityId"), entityType, pageBase.getParameter("ResourceTypeId"));
  }
  else
    resourceSerial = bl.loadSerial(pageBase.getId());
%>

<v:dialog id="resourceserial_dialog" icon="<%=resourceSerial.IconName.getString()%>" title="@Resource.Serial" width="500">

  <v:form-field caption="@Common.Code">
    <input type="text" maxlength="50" id="txtResourceSerialCode" class="form-control" value="<%=resourceSerial.ResourceSerialCode.getHtmlString()%>"/>
  </v:form-field>


<script>

var dlg = $("#resourceserial_dialog");

dlg.on("snapp-dialog", function(event, params) {
  params.buttons = {
    <v:itl key="@Common.Save" encode="JS"/>: doSaveResourceSerial,
    <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
  };
});

dlg.keypress(function(e) {
  if (e.keyCode == KEY_ENTER)
    doSaveResourceSerial();
});

function doSaveResourceSerial() {
  var reqDO = {
    Command: "SaveSerial",
    SaveSerial: {
      ResourceSerial: {
        ResourceSerialId: <%=resourceSerial.ResourceSerialId.isNull() ? null : "\"" + resourceSerial.ResourceSerialId.getHtmlString() + "\""%>,
        ResourceSerialCode: $("#txtResourceSerialCode").val(),
        EntityId: "<%=resourceSerial.EntityId.getHtmlString()%>",
        EntityType: <%=resourceSerial.EntityType.getHtmlString()%>,
        ResourceTypeId: "<%=resourceSerial.ResourceTypeId.getHtmlString()%>",
        Enabled: true
      }
    }
  };
  
  vgsService("Resource", reqDO, false, function(ansDO) {
    $("#resourceserial_dialog").dialog("close");
    triggerEntityChange(<%=LkSNEntityType.ResourceSerial.getCode()%>);
  });
}

</script>


</v:dialog>
