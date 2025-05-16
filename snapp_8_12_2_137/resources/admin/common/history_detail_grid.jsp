<%@page import="java.io.Console"%>
<%@page import="com.vgs.web.tag.ConfigTag"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.search.dataobject.*"%>
<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.dataobject.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
DOHistoryLogSearchRequest reqDO = new DOHistoryLogSearchRequest();
reqDO.SearchRecapRequest.PagePos.setInt(pageBase.getQP());
reqDO.SearchRecapRequest.RecordPerPage.setInt(5);

String entityId = pageBase.getParameter("EntityId");
reqDO.SmartEntityId.setString(entityId);

if (pageBase.getNullParameter("LogDateTime") != null)
  reqDO.LogDateTime.setDateTime((pageBase.getNullParameter("LogDateTime") == null) ? null :  JvDateTime.createByXML(pageBase.getNullParameter("LogDateTime"))); 

DOHistoryLogSearchAnswer ansDO = pageBase.getBL(BLBO_HistoryLog.class).searchHistoryLog(reqDO);
%>

<%!
private String decodeValue(String value, DOWsLang.DOLangItem lang, LookupItem historyField, LookupItem historySubFieldType) {
  if (JvString.getNull(value) == null)
    return printEmptyValue(lang);
    
  if (historyField.isLookup(LkSNHistoryField.Common_Description))
    return value;
  	
  if ((value != null) && value.startsWith("@")) 
    value = JvMultiLang.translate(lang, value);

  return JvString.escapeHtml(value);
}

private String printEmptyValue(DOWsLang.DOLangItem lang) {
  return "<span class='list-subtitle'><i>" + lang.Common.Empty.getText().toLowerCase() + "<i></span>";
}
%>

<style>
#history-grid-table .list-icon {
  width: 20px;
  height: 20px;
}
#history-grid-table .grid-row {
  cursor: default;
}
#history-grid-table .label-old-value {
  color: var(--base-red-color);
}
#history-grid-table .label-new-value {
  color: var(--base-green-color);
}
#history-grid-table a.label-old-value,
#history-grid-table a.label-new-value {
  text-decoration: underline;
}
</style>

<script>
function openEntitlementsComparisonWindow(historyLogDetailId) {
  window.open("admin?page=history_detail_entitlement_comparison&historylog_detail_id=" + historyLogDetailId);  
}

</script>

<v:grid id="history-grid-table" search="<%=ansDO%>">
  <thead>
    <tr>
      <td>&nbsp;</td>
      <td width="20%"><v:itl key="@Common.Field"/></td>
      <td width="40%"><v:itl key="@Common.OriginalValue"/></td>
      <td width="40%"><v:itl key="@Common.NewValue"/></td>
    </tr>
  </thead>
  <tbody>
    <% String lastEntityId = null; %>
    <% for (DOHistoryLogRef historyDO : ansDO.HistoryLogRefList) { %>
      <% if (!historyDO.EntityId.isSameString(lastEntityId) && !historyDO.EntityId.isSameString(entityId)) { %>
        </tbody></table>
          <table class="listcontainer">
          <thead>
            <tr>
              <td colspan="100%" class="widget-title"><span class="widget-title-caption"><snp:entity-link entityId="<%=historyDO.EntityId%>" entityType="<%=historyDO.EntityType%>"><%=historyDO.EntityDesc.getHtmlString()%></snp:entity-link></span></td>
            </tr>
          </thead>
        <tbody>
        <% lastEntityId = historyDO.EntityId.getString(); %>
      <% } %>
      <tr class="group">
        <td><v:grid-icon name="account_prs.png" repositoryId="<%=historyDO.UserAccountProfilePictureId.getString()%>"/></td>
        <td colspan="3" width="100%">
          <% if (!historyDO.TransactionId.isNull()) {%>
            <span style="float:right">
              <snp:entity-link entityId="<%=historyDO.TransactionId%>" entityType="<%=LkSNEntityType.Transaction%>"><%=historyDO.TransactionCode.getHtmlString()%></snp:entity-link>
            </span>
          <% } %>
          <% if (!historyDO.JobId.isNull()) {%>
            <span style="float:right">
              <snp:entity-link entityId="<%=historyDO.JobId%>" entityType="<%=LkSNEntityType.Job%>"><%=historyDO.TaskName.getHtmlString()%></snp:entity-link>
            </span>
          <% } %>

          <snp:entity-link entityId="<%=historyDO.UserAccountId.getString()%>" entityType="<%=LkSNEntityType.Person%>">
            <%=historyDO.UserAccountName.getHtmlString()%>
          </snp:entity-link>
          
          <%=pageBase.getLang().Common.On.getText()%>

          <snp:entity-link entityId="<%=historyDO.LocationId%>" entityType="<%=LkSNEntityType.Location%>">
            <%=historyDO.LocationName.getHtmlString()%>
          </snp:entity-link>
          &raquo;
          <snp:entity-link entityId="<%=historyDO.OpAreaId%>" entityType="<%=LkSNEntityType.OperatingArea%>">
            <%=historyDO.OpAreaName.getHtmlString()%>
          </snp:entity-link>
          &raquo;
          <snp:entity-link entityId="<%=historyDO.WorkstationId%>" entityType="<%=LkSNEntityType.Workstation%>">
            <%=historyDO.WorkstationName.getHtmlString()%>
          </snp:entity-link>
          
          <br/>
          <%-- String caption = dsDet.isEmpty() ? "@Common.HistorySaveOnly" : "@Common.MadeChanges"; --%>
          <% String caption = historyDO.HistoryLogType.getHtmlLookupDesc(pageBase.getLang()); %>
          <snp:datetime timestamp="<%=historyDO.LogDateTime%>" format="shortdatetime" timezone="local"/> &mdash; <v:itl key="<%=caption%>" transform="lowercase"/>
		    </td>          
      </tr>
      
      <% for (DOHistoryDetailRef detailDO : historyDO.HistoryDetailList) { %>
        <tr class="grid-row">
          <td>&nbsp;</td>
          <td style="font-weight:bold">
            <%=JvString.replace(detailDO.HistoryFieldDesc.getHtmlString(), "\t", "<br>")%>    
          </td>
          <td>
          <% if ((detailDO.HistorySubFieldType.isLookup(LkSNHistorySubFieldType.Entitlement, LkSNHistorySubFieldType.AttributeItem_Entitlement)) && (JvString.getNull(detailDO.OldValue.getString()) != null)) { %>
              <%=printEmptyValue(pageBase.getLang())%>
          <% } else { %>
            <% if (detailDO.OldEntityId.isNull() || (EntityLinkManager.instance().findLink(false, detailDO.OldEntityType.getLkValue()) == null)) { %>
              <span class="label-old-value"><%=decodeValue(detailDO.OldValue.getString(), pageBase.getLang(), detailDO.HistoryField.getLkValue(), detailDO.HistorySubFieldType.getLkValue())%></span>
            <% } else { %>
              <snp:entity-link clazz="label-old-value" entityId="<%=detailDO.OldEntityId%>" entityType="<%=detailDO.OldEntityType%>"><%= decodeValue(detailDO.OldValue.getString(), pageBase.getLang(), detailDO.HistoryField.getLkValue(), detailDO.HistorySubFieldType.getLkValue())%></snp:entity-link>
            <% } %>
          <% } %>
          </td>  
          <td>
          <% if ((detailDO.HistorySubFieldType.isLookup(LkSNHistorySubFieldType.Entitlement, LkSNHistorySubFieldType.AttributeItem_Entitlement)) && (JvString.getNull(detailDO.NewValue.getString()) != null)) { %>
            <% String href = "openEntitlementsComparisonWindow('" + detailDO.HistoryDetailId.getString() + "')"; %>         
            <v:button fa="external-link" caption="@Entitlement.EntitlementsComparison" onclick="<%=href%>"/>
          <% } else { %>
            <% if (detailDO.NewEntityId.isNull() || (EntityLinkManager.instance().findLink(false, detailDO.NewEntityType.getLkValue()) == null)) { %>
              <span class="label-new-value"><%=decodeValue(detailDO.NewValue.getString(), pageBase.getLang(), detailDO.HistoryField.getLkValue(), detailDO.HistorySubFieldType.getLkValue())%></span>
            <% } else { %>
              <snp:entity-link clazz="label-new-value" entityId="<%=detailDO.NewEntityId%>" entityType="<%=detailDO.NewEntityType%>"><%= decodeValue(detailDO.NewValue.getString(), pageBase.getLang(), detailDO.HistoryField.getLkValue(),  detailDO.HistorySubFieldType.getLkValue())%></snp:entity-link>
            <% } %>
          <% } %>  
          </td>  
        </tr>
      <% } %>
      
    <% } %>
  </tbody>
</v:grid>   