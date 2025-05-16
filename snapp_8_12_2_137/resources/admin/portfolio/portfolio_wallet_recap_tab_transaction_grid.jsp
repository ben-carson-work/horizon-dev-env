<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.search.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_PortfolioSlotLog.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<%
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase");

DOPortfolioSlotLogSearchRequest reqDO = new DOPortfolioSlotLogSearchRequest();  

//Paging
reqDO.SearchRecapRequest.PagePos.setInt(pageBase.getQP());
reqDO.SearchRecapRequest.RecordPerPage.setInt(QueryDef.recordPerPageDefault);

//Where
reqDO.PortfolioId.setString(pageBase.getNullParameter("PortfolioId"));

reqDO.MembershipPointId.setString(pageBase.getNullParameter("MembershipPointId"));

if (pageBase.getNullParameter("PortfolioSlotLogType") != null) {
  int[] portfolioSlotLogTypes = new int[] {JvString.strToIntDef(pageBase.getNullParameter("PortfolioSlotLogType"), 0)};
  reqDO.PortfolioSlotLogType.setArray(portfolioSlotLogTypes);
}

if (pageBase.getNullParameter("UnbindedSlotLogsOnly") != null)
  reqDO.UnbindedSlotLogsOnly.setBoolean(true);

if (pageBase.getNullParameter("BindedSlotLogsOnly") != null)
  reqDO.BindedSlotLogsOnly.setBoolean(true);

//Sort
reqDO.SearchRecapRequest.addSortField("LogDateTime", true);
reqDO.SearchRecapRequest.addSortField("LogSerial", true);

//Exec
DOPortfolioSlotLogSearchAnswer ansDO = new DOPortfolioSlotLogSearchAnswer();  
pageBase.getBL(BLBO_PortfolioSlot.class).searchPortfolioSlotLog(reqDO, ansDO);
%>

<v:grid search="<%=ansDO%>">
  <thead>
    <tr>
      <td>&nbsp;</td>
      <td>
        <v:itl key="@Common.Transaction"/><br/>
        <v:itl key="@Common.DateTime"/>
      </td>
      <td width="100%">
        <v:itl key="@Account.Location"/> &raquo; <v:itl key="@Common.Workstation"/><br/>
        <v:itl key="@Common.User"/>
      </td>
      <td align="right">
        <v:itl key="@Common.Amount"/><br/>
        <v:itl key="@Common.Type"/>
      </td>
    </tr>
  </thead>
  <tbody>
    <v:grid-row search="<%=ansDO%>">
      <% 
      DOPortfolioSlotLogRef pslDO = ansDO.getRecord();
      //LookupItem slotLogType = pslDO.PortfolioSlotLogType.getLkValue();
      //LookupItem entityType = pslDO.EntityType.getLkValue();
      %>
      <td><v:grid-icon name="<%=pslDO.IconName.getString()%>"/></td>
      <td nowrap="nowrap">
        <snp:entity-link entityId="<%=pslDO.LinkEntityId%>" entityType="<%=pslDO.LinkEntityType%>" clazz="list-title"><%=pslDO.LinkEntityCode.getHtmlString()%></snp:entity-link>
        <br/>
        <snp:datetime timestamp="<%=pslDO.LogDateTime%>" format="shortdatetime" timezone="local" clazz="list-subtitle"/>
      </td>
      <td>
        <snp:entity-link entityId="<%=pslDO.LocationId%>" entityType="<%=LkSNEntityType.Location%>"><%=pslDO.LocationName.getHtmlString()%></snp:entity-link>
        &raquo;
        <snp:entity-link entityId="<%=pslDO.WorkstationId%>" entityType="<%=LkSNEntityType.Workstation%>"><%=pslDO.WorkstationName.getHtmlString()%></snp:entity-link>
        <br/>
        <snp:entity-link entityId="<%=pslDO.UserAccountId%>" entityType="<%=LkSNEntityType.Person%>"><%=pslDO.UserAccountName.getHtmlString()%></snp:entity-link>
      </td>
      <% String color = (pslDO.Amount.getMoney() >= 0) ? "black" : "var(--base-red-color)"; %>
      <td align="right" style="font-weight:bold;color:<%=color%>" nowrap="nowrap">
        <%=pslDO.AmountFormatted.getString()%><br/>
        <span class="list-subtitle"><%=pslDO.PortfolioSlotLogType.getHtmlLookupDesc(pageBase.getLang())%></span>
      </td>
    </v:grid-row>
  </tbody>
</v:grid>