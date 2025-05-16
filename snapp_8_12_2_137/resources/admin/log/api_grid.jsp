<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="java.util.*"%>
<%@page import="java.lang.String"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_ApiLog.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>
<%
String colorRed= "red";
String colorGreen= "green";

QueryDef qdef = new QueryDef(QryBO_ApiLog.class)
    .addSort(Sel.EndDateTime, false)
    .addSelect(
        Sel.ApiLogId,
        Sel.StartDateTime,
        Sel.EndDateTime,
        Sel.RequestCode,
        Sel.RequestCommand,
        Sel.WorkstationId,
        Sel.WorkstationName,
        Sel.OpAreaId,
        Sel.OpAreaName,
        Sel.LocationId,
        Sel.LocationName,
        Sel.UserAccountId,
        Sel.UserAccountName,
        Sel.RequestHttpMethod,
        Sel.RequestURL,
        Sel.RequestBody,
        Sel.RequestHeader,
        Sel.AnswerBody,
        Sel.AnswerHeader,
        Sel.AnswerCommonStatus,
        Sel.AnswerHttpStatus,
        Sel.AnswerStatusCode,
        Sel.ServerId,
        Sel.ServerName,
        Sel.ClientIPAddress,
        Sel.MsgRequestSize,
        Sel.MsgAnswerSize,
        Sel.Duration);

if (pageBase.getNullParameter("StartDateTime") != null)
  qdef.addFilter(Fil.StartDateTime, pageBase.convertFromBrowserToServerTimeZone(pageBase.getParameter("StartDateTime")));

if (pageBase.getNullParameter("EndDateTime") != null)
  qdef.addFilter(Fil.EndDateTime, pageBase.convertFromBrowserToServerTimeZone(pageBase.getParameter("EndDateTime")));

String[] locationIDs = pageBase.getBL(BLBO_EntitySearch.class).getAuditLocationFilter(pageBase.getNullParameter("LocationId"));
if (locationIDs != null) 
  qdef.addFilter(Fil.LocationId, locationIDs);

if (pageBase.getNullParameter("OpAreaId") != null)
  qdef.addFilter(Fil.OpAreaId, pageBase.getNullParameter("OpAreaId"));

if (pageBase.getNullParameter("WorkstationId") != null)
  qdef.addFilter(Fil.WorkstationId, pageBase.getNullParameter("WorkstationId"));

if (pageBase.getNullParameter("RequestCode") != null)
  qdef.addFilter(Fil.RequestCode, pageBase.getNullParameter("RequestCode"));

if (pageBase.getNullParameter("RequestCommand") != null)
  qdef.addFilter(Fil.RequestCommand, pageBase.getNullParameter("RequestCommand"));

if (pageBase.getNullParameter("AnswerCommonStatus") != null)
  qdef.addFilter(Fil.AnswerCommonStatus, JvArray.stringToIntArray(pageBase.getNullParameter("AnswerCommonStatus"), ","));

if (pageBase.getNullParameter("AnswerHttpStatus") != null)
  qdef.addFilter(Fil.AnswerHttpStatus, pageBase.getNullParameter("AnswerHttpStatus"));

// Paging
if (!pageBase.isParameter("paging", "false")) {
  qdef.pagePos = pageBase.getQP();
  qdef.recordPerPage = QueryDef.recordPerPageDefault;
}

// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);

%>

<style>

.api-grid-table {table-layout:fixed; width:100%;}
.api-grid-table td {word-wrap:break-word;}

</style>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" clazz="api-grid-table">
  <tr class="header">
    <td width="140px" nowrap>
      <v:itl key="@Common.DateTime" /><br />
      Http/Snp status
    </td>

    <td width="15%">
      <v:itl key="API"/><br />
      <v:itl key="Command"/>
    </td>
    <td width="60%">
      <v:itl key="@Common.Workstation"/> &mdash; <v:itl key="@Common.User"/>&nbsp;&nbsp;&nbsp;(IP address)<br />
      <v:itl key="URL" />
    </td>
    <td align="right" width="25%">
      Server &mdash; Duration<br/>
      Request Size &mdash; Response Size
    </td>
  </tr>
  
 <v:grid-row dataset="ds" dateGroupFieldName="<%=Sel.EndDateTime.name()%>">
	<td style="<v:common-status-style status="<%=ds.getField(Sel.AnswerCommonStatus)%>"/>" nowrap>
	 <span class="list-title" title="<snp:datetime timestamp="<%=ds.getField(Sel.EndDateTime)%>" format="shortdatetime" timezone="local" clazz="list-title" textOnly="true"/>:<%=JvString.leadZero(ds.getField(Sel.EndDateTime).getDateTime().getSec(), 2)%> .<%=JvString.leadZero(ds.getField(Sel.EndDateTime).getDateTime().getMSec(), 3)%>">
	   <snp:entity-link clazz="list-title" entityId="<%=ds.getField(Sel.ApiLogId).getEmptyString()%>" entityType="<%=LkSNEntityType.ApiLog%>">
	     <snp:datetime timestamp="<%=ds.getField(Sel.EndDateTime)%>" format="shortdatetime" timezone="local" clazz="list-title"/>
	   </snp:entity-link>
	 </span>
	 <br/>
	 <span class="list-subtitle">
     <%=ds.getField(Sel.AnswerHttpStatus).getHtmlString()%>
     /
     <%=ds.getField(Sel.AnswerStatusCode).getHtmlString()%>
	 </span>
	</td>
  	<td>
	   <%=ds.getField(Sel.RequestCode).getHtmlString()%>
       <br/>
       <span class="list-subtitle">
	   <% if(ds.getField(Sel.RequestCommand).getHtmlString().equals("")){ %>
        &mdash;
	   <% } else { %>
         <%=ds.getField(Sel.RequestCommand).getHtmlString()%>
       <% } %>
      </span>
    </td>
    <td>
      <% if (ds.getField(Sel.WorkstationId).isNull()) { %>
        &mdash;
      <% } else { %>
        <snp:entity-link entityId="<%=ds.getField(Sel.LocationId).getHtmlString()%>" entityType="<%=LkSNEntityType.Location%>"><%=ds.getField(Sel.LocationName).getHtmlString()%></snp:entity-link>
        &raquo;
        <snp:entity-link entityId="<%=ds.getField(Sel.OpAreaId).getHtmlString()%>" entityType="<%=LkSNEntityType.OperatingArea%>"><%=ds.getField(Sel.OpAreaName).getHtmlString()%></snp:entity-link>
        &raquo;
        <snp:entity-link entityId="<%=ds.getField(Sel.WorkstationId).getHtmlString()%>" entityType="<%=LkSNEntityType.Workstation%>"><%=ds.getField(Sel.WorkstationName).getHtmlString()%></snp:entity-link>
      <% } %>
      <% if (!ds.getField(Sel.UserAccountId).isNull()) { %>
        &mdash; 
        <snp:entity-link entityId="<%=ds.getField(Sel.UserAccountId).getHtmlString()%>" entityType="<%=LkSNEntityType.Person%>"><%=ds.getField(Sel.UserAccountName).getHtmlString()%></snp:entity-link>
      <% } %>
      <% if (!ds.getField(Sel.ClientIPAddress).isNull()) { %>
        &nbsp;&nbsp;&nbsp;(<%=ds.getField(Sel.ClientIPAddress).getHtmlString()%>)
      <% } %>
      <br/>
      <span class="list-subtitle">
       <%=ds.getField(Sel.RequestURL).getHtmlString()%>
      </span>
    </td>
    <td align="right">
	 <% if (!ds.getField(Sel.ServerId).isNull()) { %>
	   <snp:entity-link entityId="<%=ds.getField(Sel.ServerId)%>" entityType="<%=LkSNEntityType.Server%>">
	     <%=ds.getField(Sel.ServerName).getHtmlString()%>
	   </snp:entity-link>
        &mdash; 
       <%=JvDateUtils.getSmoothTime(ds.getField(Sel.Duration).getInt())%>
      <% } %>
	 <br/>
	 <span class="list-subtitle">
	   <%=JvString.getSmoothSize(ds.getField(Sel.MsgRequestSize).getLong())%> &mdash; <%=JvString.getSmoothSize(ds.getField(Sel.MsgAnswerSize).getLong())%>
	 </span>
    </td>
  </v:grid-row> 
</v:grid>