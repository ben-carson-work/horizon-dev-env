<%@page import="com.vgs.web.service.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
DOWorkstation wks = pageBase.getBL(BLBO_Workstation.class).loadWorkstation(pageBase.getId());
wks.WorkstationCode.setString(pageBase.getBLDef().generateDuplicateCode(LkSNEntityType.Workstation, "tbWorkstation", "WorkstationCode", wks.WorkstationCode));
wks.WorkstationName.setString(pageBase.getBLDef().generateDuplicateName(LkSNEntityType.Workstation, "tbWorkstation", "WorkstationName", wks.WorkstationName));
request.setAttribute("wks", wks);
%>

<v:dialog id="workstation_dup_dialog" title="@Common.Duplicate" width="600" autofocus="false">

  <v:form-field caption="@Common.NewCode">
    <v:input-text field="wks.WorkstationCode"/>
  </v:form-field>

  <v:form-field caption="@Common.NewName">
    <v:input-text field="wks.WorkstationName"/>
  </v:form-field>


<script>

$(document).ready(function() {
  var dlg = $("#workstation_dup_dialog");
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = {
      <v:itl key="@Common.Ok" encode="JS"/>: doDuplicate,
      <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
    };
  });

  function doDuplicate() {
    var reqDO = {
      Command: "DuplicateWorkstation",
      DuplicateWorkstation: {
        OriginalWorkstationId: <%=JvString.jsString(pageBase.getId())%>,
        NewWorkstationCode: dlg.find("#wks\\.WorkstationCode").val(),
        NewWorkstationName: dlg.find("#wks\\.WorkstationName").val()
      }
    };
    
    showWaitGlass();
    vgsService("Workstation", reqDO, false, function(ansDO) {
      hideWaitGlass();
      var workstationId = ansDO.Answer.DuplicateWorkstation.WorkstationId;
      openEntityLink(<%=LkSNEntityType.Workstation.getCode()%>, workstationId);
    });
  }
});

</script>

</v:dialog>