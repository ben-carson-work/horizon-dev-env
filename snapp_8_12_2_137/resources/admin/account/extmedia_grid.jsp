<%@page import="com.vgs.web.library.PageBase"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_ExtMediaCode.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_ExtMediaCode.class);
// Select
qdef.addSelect(
    Sel.IconName,
    Sel.CommonStatus,
    Sel.MediaCalcStatus,
    Sel.ExtMediaCode,
    Sel.ImportDateTime,
    Sel.ValidDateTo,
    Sel.MediaId,
    Sel.MediaCalcCode,
    Sel.PerformanceDate,
    Sel.ExtMediaGroupCode,
    Sel.ExtMediaGroupName,
    Sel.ExtMediaBatchId,
    Sel.ExtMediaBatchCode,
    Sel.HoldWorkstationId,
    Sel.HoldWorkstationName,
    Sel.HoldDateTime);

// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;

// Where
if (pageBase.getNullParameter("ExtMediaCode") != null)
  qdef.addFilter(Fil.ExtMediaCode, pageBase.getNullParameter("ExtMediaCode"));

if (pageBase.getNullParameter("AccountId") != null)
  qdef.addFilter(Fil.AccountId, pageBase.getNullParameter("AccountId"));

if (pageBase.getNullParameter("FromDate") != null)
  qdef.addFilter(Fil.ImportDateFrom, pageBase.getNullParameter("FromDate"));

if (pageBase.getNullParameter("ToDate") != null)
  qdef.addFilter(Fil.ImportDateTo, pageBase.getNullParameter("ToDate"));

if (pageBase.getNullParameter("ExtMediaBatchId") != null)
  qdef.addFilter(Fil.ExtMediaBatchId, pageBase.getNullParameter("ExtMediaBatchId"));

// Sort
qdef.addSort(Sel.ImportDateTime, false);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);

%>

<v:grid id="extmedia-grid" dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.ExtMediaCode%>">
  <thead>
    <tr>
      <td><v:grid-checkbox header="true"/></td>
      <td>&nbsp;</td>
      <td width="20%">
        <v:itl key="@Common.Code"/><br/>
        <v:itl key="@Common.Status"/>
      </td>
      <td width="20%">
        <v:itl key="@Common.Import"/><br/>
        <v:itl key="@Common.ValidTo"/>
      </td>
      <td width="20%">
        <v:itl key="@Product.ExtMediaGroup"/><br/>
        <v:itl key="@Performance.Performance"/>
      </td>
      <td width="20%">
        <v:itl key="@Common.HoldWorkstation"/><br/>
        <v:itl key="@Common.HoldDateTime"/>
      </td>
      </td>
      <td width="20%" align="right">
        <v:itl key="@Common.Media"/><br/>
        <v:itl key="@Common.BatchCode"/>
      </td>
    </tr>
  </thead>
  
  <tbody>
    <v:grid-row dataset="ds">
      <td style="<v:common-status-style status="<%=ds.getField(Sel.CommonStatus)%>"/>"><v:grid-checkbox name="ExtMediaCode" dataset="ds" fieldname="ExtMediaCode"/></td>
      <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>"/></td>
      <td>
        <span class="list-title"><%=ds.getField(Sel.ExtMediaCode).getHtmlString()%></span><br/>
        <span class="list-subtitle"><%=LkSN.ExtMediaCodeStatus.findItemDescriptionHtml(ds.getField(Sel.MediaCalcStatus).getInt())%></span>
      </td>
      <td>
        <span class="list-title"><snp:datetime format="shortdatetime" timestamp="<%=ds.getField(Sel.ImportDateTime)%>" timezone="local"/></span><br/>
        <span class="list-subtitle"><snp:datetime format="shortdate" timestamp="<%=ds.getField(Sel.ValidDateTo)%>" timezone="local"/></span>
      </td>
      <td>
        <span class="list-title"><%=ds.getField(Sel.ExtMediaGroupName).getHtmlString()%></span><br/>
        <span class="list-subtitle">
          <% if (ds.getField(Sel.PerformanceDate).isNull()) { %>
          -
          <% } else { %>
            <%=pageBase.format(ds.getField(Sel.PerformanceDate), pageBase.getShortDateFormat())%>
          <% } %>
        </span>
      </td>
      <td>
        <% if (!ds.getField(Sel.HoldWorkstationId).isNull()) { %>
          <snp:entity-link entityId="<%=ds.getField(Sel.HoldWorkstationId)%>" entityType="<%=LkSNEntityType.Workstation%>"><%=ds.getField(Sel.HoldWorkstationName).getHtmlString()%></snp:entity-link>
        <% } %>
        <br/>
        <% if (ds.getField(Sel.HoldDateTime).isNull()){%>
          &nbsp; 
        <% }else{ %>
          <snp:datetime timestamp="<%=ds.getField(Sel.HoldDateTime)%>" format="shortdatetime" timezone="local" clazz="list-subtitle"/>
        <%} %>
      </td>
      <td  align="right">
        <% if (!ds.getField(Sel.MediaId).isNull()) { %>
          <snp:entity-link entityId="<%=ds.getField(Sel.MediaId)%>" entityType="<%=LkSNEntityType.Media%>"><%=ds.getField(Sel.MediaCalcCode).getHtmlString()%></snp:entity-link>
        <% } %>
        <br/>
        <% if (ds.getField(Sel.ExtMediaBatchId).isNull()){%>
          &nbsp; 
        <%}else if (pageBase.getNullParameter("ExtMediaBatchId") == null) { %>
          <snp:entity-link entityId="<%=ds.getField(Sel.ExtMediaBatchId)%>" entityType="<%=LkSNEntityType.ExtMediaBatch%>"><%=ds.getField(Sel.ExtMediaBatchCode).getHtmlString()%></snp:entity-link>
        <% }else{ %>
          <span class="list-subtitle"><%=ds.getField(Sel.ExtMediaBatchCode).getHtmlString()%></span>  
        <%} %>
      </td>
    </v:grid-row>
  </tbody>
</v:grid>

