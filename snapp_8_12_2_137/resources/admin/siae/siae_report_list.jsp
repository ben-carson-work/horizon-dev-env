<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="org.apache.poi.ss.formula.ptg.TblPtg"%>
<%@page import="com.vgs.web.library.BLBO_SiaeReport.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageSiaeReportList" scope="request"/>
<jsp:include page="/resources/common/header.jsp"/>

<style>
  #report-status {
    width: 150px;
  }
</style>

<v:page-title-box/>
<%
BLBO_Siae bl = pageBase.getBL(BLBO_Siae.class);
boolean allCardsAreExpired = bl.areCardsExpired();
boolean isEnabled = bl.isSiaeEnabled() && !allCardsAreExpired; 
%>

<div class="mainlist-container">
  <jsp:include page="/resources/admin/siae/siae_alert.jsp" /> 
  <div class="form-toolbar">
    <v:button id="del-btn" caption="@Common.Delete" fa="trash" enabled="<%=isEnabled %>" href="javascript:doDelete()"/>
    <v:button id="rpg-btn" caption="RPG" fa="plus" enabled="<%=isEnabled %>" href="javascript:doGenerate('RPG')"/>
    <v:button id="rpm-btn" caption="RPM" fa="plus" enabled="<%=isEnabled %>" href="javascript:doGenerate('RPM')"/>
    <v:button id="rca-btn" caption="RCA" fa="plus" enabled="<%=isEnabled %>" href="javascript:doGenerate('RCA')"/>
    <v:button id="log-btn" caption="LOG" fa="plus" enabled="<%=isEnabled %>" href="javascript:doGenerate('LOG')"/>
    <v:button id="lta-btn" caption="LTA" fa="plus" enabled="<%=isEnabled %>" href="javascript:doGenerate('LTA')"/>
    <select id="report-status" class="form-control">
    <% for (ReportStatus status: ReportStatus.values()) { %>
      <option value="<%=status.code() %>"><%=status.name() %></option>
    <% } %>
    </select>
    <v:button id="status-btn" caption="Set status" fa="save" enabled="<%=isEnabled %>" href="javascript:doSetStatus()"/>
    <v:button id="c1-day-btn" caption="C1 Giorno" fa="download" enabled="<%=isEnabled %>" href="javascript:doGenerate('C1_DAY_ID')"/>
    <v:button id="c1-month-btn" caption="C1 Mese" fa="download" enabled="<%=isEnabled %>" href="javascript:doGenerate('C1_MONTH_ID')"/>
    <v:button id="c2-day-btn" caption="C2 Giorno" fa="download" enabled="<%=isEnabled %>" href="javascript:doGenerate('C2_DAY_ID')"/>
    <v:button id="c2-month-btn" caption="C2 Mese" fa="download" enabled="<%=isEnabled %>" href="javascript:doGenerate('C2_MONTH_ID')"/>
    <v:pagebox gridId="report-grid"/>
  </div>
  
  <div>
    <v:last-error/>
    <v:async-grid id="report-grid" jsp="siae/siae_report_grid.jsp" />
  </div>
</div>
<script>

function doDelete() {
  var ids = $("[name='ReportId']").getCheckedValues();
  if (ids == "")
    showMessage("<v:itl key="@Common.NoElementWasSelected" encode="UTF-8"/>");
  else {
    confirmDialog(null, function() {
      var reqDO = {
        Command: "DeleteReports",
        DeleteReports: {
          Ids: ids
        }
      };
      
      vgsService("Siae", reqDO, false, function(ansDO) {
        triggerEntityChange(<%=LkSNEntityType.SiaeReport.getCode()%>);
      });
    });
  }
};

function doSetStatus() {
  var ids = $("[name='ReportId']").getCheckedValues();
  if (ids == "")
    showMessage("<v:itl key="@Common.NoElementWasSelected" encode="UTF-8"/>");
  else {
    confirmDialog(null, function() {
      var reqDO = {
        Command: "SetReportsStatus",
        SetReportsStatus: {
          Ids: ids,
          Status: $('#report-status').val()
        }
      };
      
      vgsService("Siae", reqDO, false, function(ansDO) {
        triggerEntityChange(<%=LkSNEntityType.SiaeReport.getCode()%>);
      });
    });
  }
};

function doGenerate(type) {
  if (type.startsWith('C')) {
    var params = {};
    var param;
    <% for (DOCmd_Siae.DOSiaeParam param: pageBase.getBL(BLBO_Siae.class).getParams()) { %>
    param = <%=param.getJSONString()%>;
    params[param.Key] = param.Value;
    <% } %>
    if (params[type]) 
      asyncDialogEasy('doctemplate/reportexec_dialog', 'id=' + params[type])
    else 
      showMessage("E' necessario specificare la configurazione SIAE per questo riepilogo");
  } 
  else   
    asyncDialogEasy('siae/date_dialog', 'type={0}'.format(type));
};
</script>
<jsp:include page="/resources/common/footer.jsp"/>