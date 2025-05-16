<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Opentab.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_Opentab.class);

qdef.addSelect(
    Sel.IconName,
    Sel.CommonStatus,
    Sel.OpentabId,
    Sel.OpentabCode,
    Sel.OpentabDateTime,
    Sel.OpentabPrefix,
    Sel.OpentabSerial,
    Sel.CreateLocationId,
    Sel.CreateLocationName,
    Sel.OpAreaAccountId,
    Sel.OpAreaAccountName,
    Sel.CreateWorkstationId,
    Sel.CreateWorkstationName,
    Sel.CreateWorkstationCode,
    Sel.CreateUserAccountId,
    Sel.CreateUserAccountName,
    Sel.CreateUserAccountEntityType,
    Sel.OpentabSerial,
    Sel.Owner,
    Sel.PartyNumber,
    Sel.WaiterId,
    Sel.TableName,
    Sel.TableStatus,
    Sel.TotalAmount,
    Sel.TotalTax,
    Sel.WaiterName,
    Sel.WaiterEntityType,
    Sel.OpentabDesc//note
    );
if (pageBase.getNullParameter("FromDateTime") != null)
 	qdef.addFilter(Fil.FromSaleTabDateTime, pageBase.getNullParameter("FromDateTime"));

if (pageBase.getNullParameter("ToDateTime") != null)
 	qdef.addFilter(Fil.ToSaleTabDateTime, pageBase.getNullParameter("ToDateTime"));

if (pageBase.getNullParameter("OpAreaAccountId") != null)
 	qdef.addFilter(Fil.OpAreaAccountId, pageBase.getNullParameter("OpAreaAccountId"));

if (pageBase.getNullParameter("SaleTabStatus") != null)
 	qdef.addFilter(Fil.OpentabStatus, pageBase.getNullParameter("SaleTabStatus"));

if (pageBase.getNullParameter("TableStatus") != null)
 	qdef.addFilter(Fil.TableStatus, pageBase.getNullParameter("TableStatus"));

if (pageBase.getNullParameter("LocationId") != null)
 	qdef.addFilter(Fil.CreateLocationId, pageBase.getNullParameter("LocationId"));

if (pageBase.getNullParameter("WorkstationId") != null)
 	qdef.addFilter(Fil.CreateWorkstationId, pageBase.getNullParameter("WorkstationId"));

if (pageBase.getNullParameter("WaiterId") != null)
   qdef.addFilter(Fil.WaiterId, pageBase.getNullParameter("WaiterId")); 
  
//Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
//Sort
qdef.addSort(Sel.OpentabFiscalDate, false);
qdef.addSort(Sel.OpentabDateTime, false);
qdef.addSort(Sel.OpentabId, false);
//Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>
<v:grid dataset="<%=ds%>" qdef="<%=qdef%>">
<tr class="header">
    <td><v:grid-checkbox header="true"/></td>
    <td>&nbsp;</td>
    <td width="180px" nowrap>
      <v:itl key="@Common.Code"/><br/>
      <v:itl key="@Common.CreationDate"/>
    </td>
    <td width="40%">
      <v:itl key="@Account.Location"/> &raquo; <v:itl key="@Account.OpArea"/> &raquo; <v:itl key="@Common.Workstation"/><br/>
      <v:itl key="@Common.User"/>
    </td>
    <td width="15%" valign="top">
      <v:itl key="@OpenTab.Waiter"/>
    </td>
    <td width="15%">
    	<v:itl key="@OpenTab.Table"/><br/>
    	<v:itl key="@OpenTab.TableStatus"/>
    </td>
    <td width="15%">
      <v:itl key="@OpenTab.PartySeats"/><br/>
      <v:itl key="@OpenTab.Owner"/>
    </td>
    <td width="15%" align="right">
      <v:itl key="@Reservation.TotalAmount"/><br/>
      <v:itl key="@Reservation.PaidAmount"/>
    </td>
  </tr>
  <v:grid-row dataset="ds" dateGroupFieldName="<%=Sel.OpentabFiscalDate.name()%>">
    <td style="<v:common-status-style status="<%=ds.getField(Sel.CommonStatus)%>"/>">
      <v:grid-checkbox name="OpenTabId" dataset="ds" fieldname="OpenTabId"/>
    </td>
    <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>"/></td>
    <td>
       <snp:entity-link entityId="<%=ds.getField(Sel.OpentabId).getString()%>" entityType="<%=LkSNEntityType.Opentab%>" clazz="list-title">
        <span class="list-title"><%= ds.getField(Sel.OpentabCode).getHtmlString() %></span>
      </snp:entity-link>
      <br/>
      <snp:datetime timestamp="<%=ds.getField(Sel.OpentabDateTime)%>" format="shortdatetime" timezone="local" clazz="list-subtitle" showMillisHint="true"/>
    </td>
    <td>
      <snp:entity-link entityId="<%=ds.getField(Sel.CreateLocationId).getString()%>" entityType="<%=LkSNEntityType.Location%>"><%=ds.getField(Sel.CreateLocationName).getHtmlString()%></snp:entity-link> &raquo;
      <snp:entity-link entityId="<%=ds.getField(Sel.OpAreaAccountId).getString()%>" entityType="<%=LkSNEntityType.OperatingArea%>"><%=ds.getField(Sel.OpAreaAccountName).getHtmlString()%></snp:entity-link> &raquo;
      <snp:entity-link entityId="<%=ds.getField(Sel.CreateWorkstationId).getString()%>" entityType="<%=LkSNEntityType.Workstation%>"><%=ds.getField(Sel.CreateWorkstationName).getHtmlString()%></snp:entity-link>
      <br/>
      <% if (ds.getField(Sel.CreateUserAccountId).isNull()) { %>
        &nbsp;
      <% } else { %>
        <% LookupItem userAccountEntityType = LkSN.EntityType.getItemByCode(ds.getField(Sel.CreateUserAccountEntityType)); %>
        <snp:entity-link entityId="<%=ds.getField(Sel.CreateUserAccountId).getString()%>" entityType="<%=userAccountEntityType%>"><%=ds.getField(Sel.CreateUserAccountName).getHtmlString()%></snp:entity-link>
      <% }%>      
    </td>
    <td valign="top">
    	<% if (ds.getField(Sel.WaiterId).isNull()) { %>
        &mdash;
      <% } else { %>
        <% LookupItem waiterAccountEntityType = LkSN.EntityType.getItemByCode(ds.getField(Sel.WaiterEntityType)); %>
        <snp:entity-link entityId="<%=ds.getField(Sel.WaiterId).getString()%>" entityType="<%=waiterAccountEntityType%>"><%=ds.getField(Sel.WaiterName).getHtmlString()%></snp:entity-link>
      <% }%>
		</td>
		<td>
      <%if (ds.getField(Sel.TableName).isNull()) {%>
				&mdash;<br/>&mdash;
      <%} else { %>
      	<%= ds.getField(Sel.TableName).getHtmlString() %><br/>
      	<span class="list-subtitle"><%=LkSN.TableStatus.findItemDescription(ds.getField(Sel.TableStatus).getInt()) %></span>
      <%} %>
		</td>
    <td>
      	<%=ds.getField(Sel.PartyNumber).getHtmlString()%>
      	<br/>
      	<span class="list-subtitle">
      	<%if (ds.getField(Sel.Owner).isNull()) {%>
      		&mdash;
      	<%} else { %>
      		<%=ds.getField(Sel.Owner).getHtmlString()%>
      	<%} %>
      	</span>
    </td>
    <td align="right">
      	<%=pageBase.formatCurrHtml(ds.getField(Sel.TotalAmount))%><br/>
      	<%=pageBase.formatCurrHtml(ds.getField(Sel.TotalTax))%>
    </td>
    </v:grid-row>
</v:grid>
