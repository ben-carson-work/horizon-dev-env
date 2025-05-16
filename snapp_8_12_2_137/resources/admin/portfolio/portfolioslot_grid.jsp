<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_PortfolioSlot.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_PortfolioSlot.class);
// Select
qdef.addSelect(QryBO_PortfolioSlot.Sel.IconName);
qdef.addSelect(QryBO_PortfolioSlot.Sel.SlotBalance);
qdef.addSelect(QryBO_PortfolioSlot.Sel.PortfolioId);
qdef.addSelect(QryBO_PortfolioSlot.Sel.MainPortfolioId);
qdef.addSelect(QryBO_PortfolioSlot.Sel.MembershipPointId);
qdef.addSelect(QryBO_PortfolioSlot.Sel.MembershipPointName);
qdef.addSelect(QryBO_PortfolioSlot.Sel.MembershipPointCode);
// Where
if (pageBase.hasParameter("PortfolioId"))
  qdef.addFilter(QryBO_PortfolioSlot.Fil.PortfolioId, pageBase.getNullParameter("PortfolioId"));
if (pageBase.hasParameter("ExcludePorfolioWalletSlot"))
  qdef.addFilter(QryBO_PortfolioSlot.Fil.ExcludePorfolioWalletSlot, pageBase.getNullParameter("ExcludePorfolioWalletSlot"));
//Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Sort
qdef.addSort(QryBO_PortfolioSlotLog.Sel.MembershipPointName);
// Exec
JvDataSet dsLog = pageBase.execQuery(qdef);
request.setAttribute("dsLog", dsLog);
%>

<v:grid id="portfolioslot-grid" dataset="<%=dsLog%>" qdef="<%=qdef%>">
  <thead>
    <tr>
	    <td>&nbsp;</td>
      <td width="50%">
        <v:itl key="@Common.Name"/><br/>
        <v:itl key="@Common.Code"/>
      </td>
      <td width="50%" align="right">
        <v:itl key="@Common.Balance"/>
      </td>
    </tr>
  </thead>
  <tbody>
    <v:grid-row dataset="dsLog">
	    <td><v:grid-icon name="<%=dsLog.getField(Sel.IconName).getString()%>"/></td>
       <td>
  	      <snp:entity-link entityId="<%=dsLog.getField(QryBO_PortfolioSlot.Sel.MembershipPointId).getString()%>" entityType="<%=LkSNEntityType.RewardPoint%>" >  
         		 <%=dsLog.getField(QryBO_PortfolioSlot.Sel.MembershipPointName).getHtmlString()%>
        	</snp:entity-link>  
	        <br/> 
        <span class="list-subtitle"><%=dsLog.getField(QryBO_PortfolioSlot.Sel.MembershipPointCode).getHtmlString()%></span>&nbsp;
  		</td>
      <td align="right">
        <span class="list-title">
        
        <% String params = "&MembershipPointId=" + dsLog.getField(QryBO_PortfolioSlot.Sel.MembershipPointId).getHtmlString();
           if (dsLog.getField(QryBO_PortfolioSlot.Sel.MainPortfolioId).getString() != null)
             params = "id=" + dsLog.getField(QryBO_PortfolioSlot.Sel.MainPortfolioId).getHtmlString() + params;
           else
             params = "id=" + dsLog.getField(QryBO_PortfolioSlot.Sel.PortfolioId).getHtmlString() + params;
        String hrefNew = "javascript:asyncDialogEasy('portfolio/portfolio_ledger_dialog', '" + params + "')"; 
        %>	 		
 	        <a href="<%=hrefNew%>">
 	        
          <% JvFieldNode balance = dsLog.getField(QryBO_PortfolioSlot.Sel.SlotBalance); %>
          <% if (dsLog.getField(QryBO_PortfolioSlot.Sel.MembershipPointId).isSameString(BLBO_DBInfo.getSystemPointId_Wallet())) { %>
            <%=pageBase.formatCurrHtml(balance)%>
          <% } else { %>
            <%=balance.getInt()%>
          <% } %>
          </a></span>
      </td>
    </v:grid-row>
  </tbody>
</v:grid>
    