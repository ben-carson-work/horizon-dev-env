<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.snapp.dataobject.ticket.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<% 
@SuppressWarnings("unchecked")
List<DOTimedTicketStatementRef> list = (List<DOTimedTicketStatementRef>)request.getAttribute("listTimedTicketStatement");
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase");
%>

<v:grid entityType="<%=LkSNEntityType.TimedTicketStatement%>" include="<%=(list != null) && !list.isEmpty()%>">
  <thead>
    <v:grid-title caption="@Product.TimedTicketStatement"/>
  </thead>
  <tbody>
     <tr class="header">
       <td width="35px">&nbsp;</td>
       <td>
         <v:itl key="@Common.Name"/><br/>
         <v:itl key="@Common.Status"/>
       </td>
       <td>
         <v:itl key="@Ticket.Entry"/>
       </td>
       <td>
         <v:itl key="@Ticket.Exit"/>
       </td>
       <td>
         <v:itl key="@Product.Settlement"/>
       </td>
       <td>
         <v:itl key="@Common.Amount"/>
       </td>
     </tr>
     <% for (DOTimedTicketStatementRef item : list) { %>
     <tr class="grid-row">
       <td><v:grid-icon name="<%=item.IconName.getString()%>"/></td>
       <td>
         <a href="javascript:asyncDialogEasy('product/timedticket/timedticketrule_dialog', 'id=<%=item.TimedTicketRuleId.getEmptyString()%>')" class="list-title">
         <%=item.RuleName.getHtmlString()%></a><br/>
         <span class="list-subtitle"><v:itl key="<%=item.StatementStatus.getLkValue().getRawDescription()%>"/></span>
       </td>
       <td>
         <div><snp:entity-link entityType="<%=LkSNEntityType.AccessPoint%>" entityId="<%=item.EntryAccessPointId%>"><%=item.EntryAccessPointName.getHtmlString()%></snp:entity-link></div>
         <div><snp:datetime timestamp="<%=item.EntryDateTime%>" format="shortdatetime" timezone="location" location="<%=item.EntryLocationId.getEmptyString()%>" clazz="list-subtitle"/></div>
       </td> 
       <td>
         <div><snp:entity-link entityType="<%=LkSNEntityType.AccessPoint%>" entityId="<%=item.ExitAccessPointId%>"><%=item.ExitAccessPointName.getHtmlString()%></snp:entity-link></div>
         <div><snp:datetime timestamp="<%=item.ExitDateTime%>" format="shortdatetime" timezone="location" location="<%=item.ExitLocationId.getEmptyString()%>" clazz="list-subtitle"/></div>
       </td> 
       <td>
         <div><snp:entity-link entityType="<%=LkSNEntityType.Transaction%>" entityId="<%=item.SettleTransactionId%>"><%=item.SettleTransactionCode.getHtmlString()%></snp:entity-link></div>
         <div><snp:datetime timestamp="<%=item.SettleTransactionDateTime%>" format="shortdatetime" timezone="location" location="<%=item.SettleLocationId.getEmptyString()%>" clazz="list-subttitle"/></div>
       </td> 
       <td>
       <% if (!item.SettleAmount.isNull()) { %>
         <%=pageBase.formatCurrHtml(item.SettleAmount)%>
       <% } %>
       </td> 
     </tr>
     <% } %>
  </tbody>
</v:grid>
