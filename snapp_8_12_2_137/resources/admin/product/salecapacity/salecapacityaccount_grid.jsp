<%@page import="com.vgs.snapp.dataobject.salecapacity.*"%>
<%@page import="com.vgs.snapp.api.salecapacityaccount.*"%>
<%@page import="com.vgs.snapp.web.search.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.search.dataobject.*"%>
<%@page import="com.vgs.web.library.PageBase"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>


<%
APIDef_SaleCapacityAccount_Search.DORequest reqDO = new APIDef_SaleCapacityAccount_Search.DORequest();

/*
reqDO.SaleId.setString(pageBase.getNullParameter("SaleId"));
reqDO.TransactionId.setString(pageBase.getNullParameter("TransactionId"));
*/

reqDO.SearchRecap.PagePos.setInt(pageBase.getQP());
reqDO.SearchRecap.RecordPerPage.setInt(QueryDef.recordPerPageDefault);

APIDef_SaleCapacityAccount_Search.DOResponse ansDO = pageBase.getBL(API_SaleCapacityAccount_Search.class).search(reqDO);
%>


<v:grid id="salecapacityaccount-grid-inner" search="<%=ansDO%>" entityType="<%=LkSNEntityType.SaleCapacityAccount%>">
  <tr class="header">
    <td><v:grid-checkbox header="true"/></td>
    <td>&nbsp;</td>
    <td width="30%">
      <div><v:itl key="@SaleCapacity.TimeSlotType"/></div>
      <div><v:itl key="@Common.DateRange"/></div>
    </td>
    <td width="70%">
      <div><v:itl key="@SaleCapacity.AccountTags"/></div>
    </td>
  </tr>
  <tbody>
    <v:grid-row search="<%=ansDO%>">
      <% DOSaleCapacityAccountRef scaDO = ansDO.getRecord(); %>
      
      <td style="<v:common-status-style status="<%=scaDO.CommonStatus%>"/>">
        <v:grid-checkbox name="SaleCapacityAccountId" fieldname="SaleCapacityAccountId" value="<%=scaDO.SaleCapacityAccountId.getString()%>"/>
      </td>
      <td><v:grid-icon name="<%=scaDO.IconName.getString()%>"/></td>
      <td>
        <snp:entity-link entityId="<%=scaDO.SaleCapacityAccountId%>" entityType="<%=LkSNEntityType.SaleCapacityAccount%>" clazz="list-title" entityTooltip="false">
          <%=scaDO.TimeSlotType.getHtmlLookupDesc(pageBase.getLang())%>
        </snp:entity-link>
        <div class="list-subtitle">
          <%=scaDO.ValidDateFrom.isNull() ? pageBase.getLang().Common.Always.getHtmlText() : scaDO.ValidDateFrom.formatHtml(pageBase.getShortDateFormat())%>
          &mdash;
          <%=scaDO.ValidDateTo.isNull() ? pageBase.getLang().Common.Always.getHtmlText() : scaDO.ValidDateTo.formatHtml(pageBase.getShortDateFormat())%>
        </div>
      </td>
      <td>
        <div class="list-subtitle"><%=scaDO.AccountTagNames.getHtmlString()%></div>
      </td>
    </v:grid-row>
  </tbody>
</v:grid>
