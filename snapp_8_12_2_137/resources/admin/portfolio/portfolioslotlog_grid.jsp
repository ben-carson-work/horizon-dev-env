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
JvDataSet ds;
boolean includeSubEntity = pageBase.hasParameter("IncludeSubEntity"); 
if (pageBase.hasParameter("RewardPointsOnly")) 
  ds = pageBase.getBL(BLBO_PortfolioSlot.class).getRewardPointsPortfolioSlotLogDS(pageBase.getNullParameter("EntityId"), includeSubEntity);
else
  ds = pageBase.getBL(BLBO_PortfolioSlot.class).getWalletPortfolioSlotLogDS(pageBase.getNullParameter("EntityId"), includeSubEntity);
request.setAttribute("ds", ds);
%>

<v:grid id="activity-grid" dataset="<%=ds%>">
  <thead>
    <tr>
	  <td>&nbsp;</td>
      <td width=5%>
        <v:itl key="@Common.Type"/>
      </td>
      <td width=40%>
        <v:itl key="@Account.Account"/><br/>
        <v:itl key="@Common.Target"/>
      </td>
      <td width=35%>
        <v:itl key="@Common.Reference"/>
      </td>
      <td width=5% align="right">
        <v:itl key="@Common.Serial"/>
      </td>
      <td width=15% align="right">
        <v:itl key="@Common.Amount"/><br/>
      </td>
    </tr>
  </thead>
  <tbody>
    <v:grid-row dataset="ds">
      <% boolean isWallet = JvString.isSameString(ds.getString(QryBO_PortfolioSlotLog.Sel.MembershipPointId), BLBO_DBInfo.getSystemPointId_Wallet()); %>
		  <td>
 		    <% String iconName = isWallet ? "wallet.png" : "membership.png"; %> 
		    <v:grid-icon name="<%=iconName%>"/>
		  </td>
	    <td>
	      <% LookupItem slotLogType = LkSN.PortfolioSlotLogType.getItemByCode(ds.getInt(QryBO_PortfolioSlotLog.Sel.PortfolioSlotLogType)); %>
	      <span class="list-subtitle"><%=slotLogType.getDescription(pageBase.getLang())%></span>
	    </td>
	    <td>
	      <% if (ds.getField(QryBO_PortfolioSlotLog.Sel.AccountId).isNull()) { %>
	      <span class="list-subtitle"><v:itl key="@Account.AnonymousAccount"/></span>
	      <% } else { %>
	      <snp:entity-link entityId="<%=ds.getField(QryBO_PortfolioSlotLog.Sel.AccountId)%>" entityType="<%=ds.getField(QryBO_PortfolioSlotLog.Sel.AccountEntityType)%>"><%=ds.getString(QryBO_PortfolioSlotLog.Sel.AccountName)%></snp:entity-link>
	      <% } %>
	      <br/>
	      <span class="list-subtitle">
	      <% if (!ds.getField(QryBO_PortfolioSlotLog.Sel.TicketId).isNull()) { %>
	        <snp:entity-link entityId="<%=ds.getString(QryBO_PortfolioSlotLog.Sel.TicketId)%>" entityType="<%=LkSNEntityType.Ticket%>" clazz="list-title"><%=ds.getString(QryBO_PortfolioSlotLog.Sel.TicketCode)%></snp:entity-link>
	      <% } else if (ds.getField(QryBO_PortfolioSlotLog.Sel.MediaIDs).isNull()) { %>
	        <%=JvString.MDASH%>
	      <% } else { 
	        	String[] mediaIDs = JvArray.stringToArray(ds.getField(QryBO_PortfolioSlotLog.Sel.MediaIDs).getString(), ",");
	        	String moreMedias = "";
	        	if (mediaIDs.length > 1)
	        	  moreMedias = " (+" + (mediaIDs.length-1) + ")";
	        	if (mediaIDs.length > 0) {%>
	            <snp:entity-link entityId="<%=mediaIDs[0]%>" entityType="<%=LkSNEntityType.Media%>" clazz="list-title"><v:itl key="@Common.PortfolioExt" param1="<%=pageBase.getBL(BLBO_Media.class).getTDSSNFromMediaId(mediaIDs[0]) + moreMedias %>"/></snp:entity-link>
	           <% } %>
	      <% } %>
	      </span>
	    </td>
	    <td>
	      <% LookupItem subEntityType = LkSN.EntityType.findItemByCode(ds.getField(QryBO_PortfolioSlotLog.Sel.SubEntityType)); 
	      String subEntityId = ds.getField(QryBO_PortfolioSlotLog.Sel.SubEntityId).getString(); 
	      %>
	      <% if ((subEntityType != null) && (subEntityId != null)) { %>
	      <%   BLBO_PagePath.EntityRecap subEntityRecap = BLBO_PagePath.findEntityRecap(pageBase.getConnector(), subEntityType, subEntityId); %>
	      <%   if (subEntityRecap != null) { %>
	             <snp:entity-link entityId="<%=ds.getField(QryBO_PortfolioSlotLog.Sel.SubEntityId)%>" entityType="<%=subEntityType%>"><%=JvString.escapeHtml(subEntityRecap.name)%></snp:entity-link><br/>
	             <span class="list-subtitle"><%=subEntityType.getHtmlDescription(pageBase.getLang())%></span>
	   	    <% } %>
	      <% } %>
	    </td>
	    <td align="right">
	      <%=ds.getInt(QryBO_PortfolioSlotLog.Sel.PortfolioSlotBalanceSerial)%>
	    </td>
	    <% String color = (ds.getField(QryBO_PortfolioSlotLog.Sel.Amount).getMoney() >= 0) ? "#000000" : "#9c0006"; %>
	    <td align="right" style="font-weight:bold;color:<%=color%>" nowrap="nowrap">
	      <% if (isWallet) { %>
	        <%=pageBase.formatCurrHtml(ds.getMoney(QryBO_PortfolioSlotLog.Sel.Amount))%>
	      <% } else { %>
          <v:itl key="@Common.PointsFormatted" param1="<%=(ds.getString(QryBO_PortfolioSlotLog.Sel.FormattedAmount))%>"/>
          &nbsp;
          <%=pageBase.formatCurrHtml(ds.getMoney(QryBO_PortfolioSlotLog.Sel.MainCurrencyAmount))%>
        <% } %>
        <br/>
	      <snp:entity-link entityId="<%=ds.getField(QryBO_PortfolioSlotLog.Sel.MembershipPointId)%>" entityType="<%=LkSNEntityType.RewardPoint%>"><%=ds.getField(QryBO_PortfolioSlotLog.Sel.MembershipPointName).getHtmlString()%></snp:entity-link>
	    </td>
    </v:grid-row>
  </tbody>
</v:grid>
    