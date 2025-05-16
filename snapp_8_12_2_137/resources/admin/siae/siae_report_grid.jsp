<%@page import="com.vgs.web.library.BLBO_Siae"%>
<%@page import="com.vgs.web.library.BLBO_SiaeReport.ReportType"%>
<%@page import="com.vgs.vcl.NvSubIcon"%>
<%@page import="com.vgs.web.library.BLBO_SiaeReport.ReportStatus"%>
<%@page import="com.vgs.snapp.query.QryBO_SiaeReport.Sel"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>
<%
BLBO_Siae bl = pageBase.getBL(BLBO_Siae.class);
boolean allCardsAreExpired = bl.areCardsExpired();
boolean isEnabled = bl.isSiaeEnabled() && !allCardsAreExpired;

QueryDef qdef = new QueryDef(QryBO_SiaeReport.class);
// Select
qdef.addSelect(Sel.IconName);
qdef.addSelect(Sel.RiepilogoId);
qdef.addSelect(Sel.Nome);
qdef.addSelect(Sel.DataRiferimento);
qdef.addSelect(Sel.Tipo);
qdef.addSelect(Sel.Stato);
qdef.addSelect(Sel.DataGenerazione);
qdef.addSelect(Sel.DataSalvataggio);
qdef.addSelect(Sel.DataInvio);
qdef.addSelect(Sel.Progressivo);
qdef.addSelect(Sel.Sostituzione);
qdef.addSelect(Sel.Riepilogo);
//Sort
qdef.addSort(Sel.DataGenerazione, false);
qdef.addSort(Sel.Tipo);
qdef.addSort(Sel.Progressivo, false);
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.SiaeReport%>">
  <tr class="header">
    <td width="1%"><v:grid-checkbox header="true"/></td>
    <td width="1%">&nbsp;</td>
    <td>Nome</td>
    <td>Data Generazione<br />Data Riferimento</td>
    <td>Stato invio<br />Data invio</td>
    <td>Salvato CD<br />Data</td>
    <td>Progressivo</td>
    <td>Sostituzione</td>
    <td>Scarica</td>
    <td>Invia</td>
  </tr>
  <v:grid-row dataset="ds">
<%
  String icon = ds.getField(Sel.IconName).getString();
  ReportStatus status = ReportStatus.getEnum(ds.getString(Sel.Stato));
  boolean isBurned = !ds.getField(Sel.DataSalvataggio).isNull();
  String type = ds.getString(Sel.Tipo);
  if (status == ReportStatus.IN_ATTESA) {
    icon += "|" + NvSubIcon.Wait;
  } else if (status == ReportStatus.RISPOSTA_ERRATA) {
    icon += "|" + NvSubIcon.Cancel;
  } else if (status == ReportStatus.INVIATO ||
      ("LT".indexOf(type) != -1 && isBurned)) {
    icon += "|" + NvSubIcon.Ok;
  };
%>
    <td><v:grid-checkbox dataset="ds" name="ReportId" fieldname="RiepilogoId" /></td>
    <td><v:grid-icon name="<%=icon%>"/></td>
    <td>
      <%=ds.getField(Sel.Nome).getHtmlString() %>
    </td>
    <td>
      <%=pageBase.format(ds.getField(Sel.DataGenerazione), pageBase.getShortDateTimeFormat(), true)%><br />
      <span class="list-subtitle"><%=pageBase.format(ds.getField(Sel.DataRiferimento), pageBase.getShortDateTimeFormat(), true)%></span>
    </td>
    <td>
      <%=status %><br />
      <span class="list-subtitle"><%=pageBase.format(ds.getField(Sel.DataInvio), pageBase.getShortDateTimeFormat(), true)%></span>
    </td>
    <td>
      <% if (isBurned) { %> Si <% } else { %> No <% } %><br />
      <span class="list-subtitle"><%=pageBase.format(ds.getField(Sel.DataSalvataggio), pageBase.getShortDateTimeFormat(), true)%></span>
    </td>
    <td>
      <%=ds.getField(Sel.Progressivo).getHtmlString() %>
    </td>
    <td>
       <%=ds.getField(Sel.Sostituzione).getHtmlString() %>
    </td>
    <td>
      <a href="?page=siae_report_list&action=downloadUnsigned&reportId=<%=ds.getField(Sel.RiepilogoId).getHtmlString()%>" title="Scarica"><i class="fa fa-2x fa-download"></i></a>
    </td>
    <td>
      <% if (isEnabled && "GRM".indexOf(ds.getField(Sel.Tipo).getString()) != -1 && status == ReportStatus.SALVATO) { %>
        <a href="#" onclick="javascript:doSend('<%=ds.getField(Sel.RiepilogoId).getHtmlString()%>')"><v:grid-icon title="Invia" name="<%=LkSNEntityType.Email.getIconName()%>" /></a>
      <% } %>
    </td>
  </v:grid-row>
</v:grid>
<script type="text/javascript">
function doSend(reportId) {
  var reqDO = {
    Command: "SendReport",
    SendReport: {
      ReportId: reportId
    }
  };
  showWaitGlass();
  vgsService("Siae", reqDO, false, function(ansDO) {
    triggerEntityChange(<%=LkSNEntityType.SiaeReport.getCode()%>);
    hideWaitGlass();
  });
  return false;
};
</script>