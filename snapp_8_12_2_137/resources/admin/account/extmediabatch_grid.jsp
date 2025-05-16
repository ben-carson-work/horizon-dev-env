<%@page import="com.vgs.web.library.PageBase"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_ExtMediaBatch.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_ExtMediaBatch.class);
// Select
qdef.addSelect(Sel.CommonStatus);
qdef.addSelect(Sel.ExtMediaBatchId);
qdef.addSelect(Sel.ExtMediaBatchCode);
qdef.addSelect(Sel.ExtMediaBatchStatus);
qdef.addSelect(Sel.ExtMediaBatchId);
qdef.addSelect(Sel.ExtMediaBatchStatus);
qdef.addSelect(Sel.ImportFileName);
qdef.addSelect(Sel.ExtMediaBatchAnomaly);
qdef.addSelect(Sel.ExtMediaBatchCodeExt1);
qdef.addSelect(Sel.ExtMediaBatchCodeExt2);
qdef.addSelect(Sel.EarlyValidDateTo);
qdef.addSelect(Sel.Quantity);
qdef.addSelect(Sel.MediaCodesAssigned);
qdef.addSelect(Sel.MediaCodesAvailable);
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Where
if (pageBase.getNullParameter("ExtMediaBatchId") != null)
  qdef.addFilter(Fil.ExtMediaBatchId, pageBase.getNullParameter("ExtMediaBatchId"));

if (pageBase.getNullParameter("AccountId") != null)
  qdef.addFilter(Fil.AccountId, pageBase.getNullParameter("AccountId"));

if (pageBase.getNullParameter("BatchStatus") != null) 
  qdef.addFilter(Fil.ExtMediaBatchStatus, JvArray.stringToArray(pageBase.getNullParameter("BatchStatus"), ","));
  
if (pageBase.getNullParameter("FromDate") != null)
  qdef.addFilter(Fil.ExpirationDateFrom, pageBase.getNullParameter("FromDate"));

if (pageBase.getNullParameter("ToDate") != null)
  qdef.addFilter(Fil.ExpirationDateTo, pageBase.getNullParameter("ToDate"));

if (pageBase.getNullParameter("FullText") != null)
  qdef.addFilter(Fil.FullText, pageBase.getParameter("FullText"));

// Sort
qdef.addSort(Sel.ExtMediaBatchId, false);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>

<v:grid id="extmediabatch-grid" dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.ExtMediaBatch%>">
  <thead>
    <tr>
      <td><v:grid-checkbox header="true"/></td>
      <td width="20%">
        <v:itl key="@Common.Code"/><br/>
        <v:itl key="@Common.Status"/>
      </td>
      <td width="20%">
        <v:itl key="@Common.FileName"/><br/>
        <v:itl key="@ExtMediaBatch.ExtMediaBatchWarnType"/>
      </td>
      <td width="20%">
        <v:itl key="@ExtMediaBatch.ExtMediaBatchCodeExt1"/><br/>
        <v:itl key="@ExtMediaBatch.ExtMediaBatchCodeExt2"/>
      </td>
      <td width="20%">
        <v:itl key="@ExtMediaBatch.ExpirationDate"/>
      </td>
      <td width="20%" align="right" valign="top">
        <v:itl key="@Common.Total"/><br/>
        <v:itl key="@Common.Assigned"/>&ndash;<v:itl key="@Common.Balance"/>
      </td>
    </tr>
  </thead>
  
  <tbody>
    <v:grid-row dataset="ds">
       <td style="<v:common-status-style status="<%=ds.getField(QryBO_ExtMediaBatch.Sel.CommonStatus)%>"/>"><v:grid-checkbox name="ExtMediaBatchId" dataset="ds" fieldname="ExtMediaBatchId"/></td>
      </td>
      <td>
        <snp:entity-link entityId="<%=ds.getField(Sel.ExtMediaBatchId).getString()%>" entityType="<%=LkSNEntityType.ExtMediaBatch%>" clazz="list-title">
          <%=ds.getField(Sel.ExtMediaBatchCode).getHtmlString()%>
        </snp:entity-link><br/>
         <span class="list-subtitle"><%=LkSN.ExtMediaBatchStatus.findItemDescription(ds.getField(Sel.ExtMediaBatchStatus).getInt()) %></span>
      </td>
      <td>
        <span class="list-title"><%=ds.getField(Sel.ImportFileName).getHtmlString()%></span><br/>
        <%if (ds.getField(Sel.ExtMediaBatchAnomaly).isNull()) {%>
          &ndash;
        <%}else{ %>
          <span class="list-subtitle"><%=LkSN.ExtMediaBatchAnomaly.findItemDescription(ds.getField(Sel.ExtMediaBatchAnomaly).getInt())%></span>
        <%} %>
      </td>
      <td>
        <span class="list-title"><%=ds.getField(Sel.ExtMediaBatchCodeExt1).getHtmlString()%></span><br/>
        <span class="list-subtitle">
        <% if (ds.getField(Sel.ExtMediaBatchCodeExt2).isNull()) { %>
          &ndash;
        <%} else { %>
          <%=ds.getField(Sel.ExtMediaBatchCodeExt2).getHtmlString()%>
        <%} %>
        </span>
      </td>
      <td>
        <snp:datetime format="shortdate" timestamp="<%=ds.getField(Sel.EarlyValidDateTo)%>" timezone="local"/>
      </td>
      <td align="right">
        <span class="list-title"><%=ds.getField(Sel.Quantity).getHtmlString()%></span><br/>
        <span class="list-subtitle"><%=ds.getField(Sel.MediaCodesAssigned).getHtmlString()%>&ndash;<%=ds.getField(Sel.MediaCodesAvailable).getHtmlString()%></span>
      </td>
    </v:grid-row>
  </tbody>
</v:grid>

