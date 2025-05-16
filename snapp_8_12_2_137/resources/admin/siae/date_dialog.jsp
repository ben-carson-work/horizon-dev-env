<%@page import="java.awt.CardLayout"%>
<%@page import="com.vgs.snapp.query.QryBO_SiaeCard.Sel"%>
<%@page import="com.vgs.snapp.query.QryBO_SiaeCard"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_SiaeCard.class);
qdef.addSelect(Sel.CodiceCarta);
qdef.addSort(Sel.CodiceCarta);
qdef.addFilter(Sel.CardStatus, new int[] {2, 3});
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);

String type = pageBase.getParameter("type");
%>
<v:dialog id="date_dialog" icon="smartcard.png" title="Selezione data" width="220" height="210">
  <v:widget-block>
  <form id="dateForm">
    <label>Scegli la data
      <v:input-text type="datepicker" field="ReportDate" />
    </label>
  </form>
  </v:widget-block>
<script>

var dlg = $("#date_dialog");

$(document).ready(function() {
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = {
      <v:itl key="@Common.Ok" encode="JS"/>: doGenerate,
      <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
    };
  });
  
  function doGenerate() {
    showWaitGlass();
    var reqDO = {
        Command: "GenerateReport",
        GenerateReport: {
          Date: dlg.find('#ReportDate').val(),
          Type: '<%=type%>'
        }
      };
      
    vgsService("Siae", reqDO, false, function(ansDO) {
      dlg.dialog("close");
      hideWaitGlass();
      triggerEntityChange(<%=LkSNEntityType.SiaeReport.getCode()%>);
    });
  }

  
  
  
});	  
	  
// dlg.on("snapp-dialog", function(event, params) {
//   params.buttons = [
//     {
//     	id: 'send-btn',
//       text: <v:itl key="@Common.Ok" encode="JS"/>,
//       click: doGenerate
//     },
//     {
//       id: 'close-btn',
//       text: <v:itl key="@Common.Cancel" encode="JS"/>,
//       click: doCloseDialog
//     }
//   ];
//   $(".default-focus").focus();
// });

</script>

</v:dialog>
