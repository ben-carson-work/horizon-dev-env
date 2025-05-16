<%@page import="com.vgs.web.library.BLBO_Tag"%>
<%@page import="com.vgs.web.library.BLBO_Resource"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.json.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Account.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>


<%
int[] entityTypes = JvArray.stringToIntArray(pageBase.getGridParam("EntityType"), ",");

QueryDef qdef = new QueryDef(QryBO_Account.class);
//Select
qdef.addSelect(
    Sel.IconName,
    Sel.CommonStatus,
    Sel.AccountId,
    Sel.AccountCode,
    Sel.AccountCode,
    Sel.DisplayName,
    Sel.AllowSeatAllocation,
    Sel.FulfilmentAreaId);
//Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
//Sort
qdef.addSort(Sel.DisplayName);
//Filter
qdef.addFilter(QryBO_Account.Fil.EntityType, LkSNEntityType.AccessArea.getCode());
qdef.addFilter(QryBO_Account.Fil.ParentAccountId, pageBase.getNullParameter("LocationId"));
//Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.Account_All%>">
  <thead>
    <tr>
      <td><v:grid-checkbox header="true"/></td>
      <td>&nbsp;</td>
      <td width="20%">
        <v:itl key="@Common.Name"/><br/>
        <v:itl key="@Common.Code"/>
      </td>
      <td width="40%">
        <v:itl key="@Seat.LimitedCapacity"/>
      </td>
      <td width="40%">
        <v:itl key="@Common.FulfilmentArea"/>
      </td>
    </tr>
  </thead>
   
  <tbody>
    <v:grid-row dataset="ds">
      <td><v:grid-checkbox dataset="ds" name="cbAccountId" value="<%=ds.getField(QryBO_Account.Sel.AccountId).getString()%>"/></td>
      <td><v:grid-icon name="<%=ds.getField(QryBO_Account.Sel.IconName).getString()%>"/></td>
      <td>
        <snp:entity-link entityId="<%=ds.getField(QryBO_Account.Sel.AccountId)%>" entityType="<%=LkSNEntityType.AccessArea%>" clazz="list-title"><%=ds.getField(QryBO_Account.Sel.DisplayName).getHtmlString()%></snp:entity-link>
        <br/>
        <span class="list-subtitle"><%=ds.getField(QryBO_Account.Sel.AccountCode).getHtmlString()%></span>&nbsp;
      </td>
      <td>
      <% if (ds.getField(QryBO_Account.Sel.AllowSeatAllocation).getBoolean()) { %>
        <span class="list-subtitle"><v:itl key="@Seat.LimitedCapacity"/></span>
      <% } %>
      </td>
      <td>
       <% if (!ds.getField(QryBO_Account.Sel.FulfilmentAreaId).isNull()) { %>
         <span class="list-subtitle"><%=pageBase.getBL(BLBO_Tag.class).findTagName(ds.getField(QryBO_Account.Sel.FulfilmentAreaId).getString())%></span>
       <% } %>
      </td>
      
    </v:grid-row>
  </tbody>
</v:grid>
