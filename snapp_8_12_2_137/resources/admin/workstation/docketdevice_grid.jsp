<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_DocketDevice.class);
// Select
qdef.addSelect(QryBO_DocketDevice.Sel.DocketDeviceName);
qdef.addSelect(QryBO_DocketDevice.Sel.DocketDeviceId);
qdef.addSelect(QryBO_DocketDevice.Sel.ProductTypeTagNames);
qdef.addSelect(QryBO_DocketDevice.Sel.OpAreaNames);
qdef.addSelect(QryBO_DocketDevice.Sel.WorkstationId);

// Where
if (pageBase.getNullParameter("FullText") != null)
  qdef.addFilter(QryBO_DocketDevice.Fil.FullText, pageBase.getParameter("FullText"));

qdef.addFilter(QryBO_DocketDevice.Fil.WorkstationId, pageBase.getParameter("WorkstationId"));
// Paging
  qdef.pagePos = pageBase.getQP();
  qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>

<v:grid id="docketdevice-grid" dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.DocketDevice%>">
  <tr class="header">
    <td>
      <v:grid-checkbox header="true"/>
    </td>
    <td width="20%">
      <v:itl key="@Common.Name"/>
    </td>
    <td width="40%" valign="top">
      <v:itl key="@Account.OpAreas"/>         
    </td>
    <td width="40%" valign="top">
      <v:itl key="@Common.Tags"/>         
    </td>
    <td>&nbsp;</td>
  </tr>
  <v:grid-row dataset="ds">
    <td><v:grid-checkbox dataset="ds" fieldname="DocketDeviceId" name="DocketDeviceId"/></td>
    <td>
      <snp:entity-link entityId="<%=ds.getField(QryBO_DocketDevice.Sel.DocketDeviceId)%>" entityType="<%=LkSNEntityType.DocketDevice%>" clazz="list-title">
        <%=ds.getField(QryBO_DocketDevice.Sel.DocketDeviceName).getHtmlString()%>
      </snp:entity-link>
    </td>
    <td>
      <span class="list-subtitle"><%=ds.getField(QryBO_DocketDevice.Sel.OpAreaNames).getHtmlString()%></span>
    </td>
    <td>
      <span class="list-subtitle"><%=ds.getField(QryBO_DocketDevice.Sel.ProductTypeTagNames).getDisplayText()%></span>
    </td>
    <td>
      <a href="<%=pageBase.getBackofficeURL()%>/admin?page=docket-display&id=<%=ds.getField(QryBO_DocketDevice.Sel.DocketDeviceId).getHtmlString()%>" class="no-ajax" target="_blank"><i class="fa fa-external-link"></i></a>
    </td>
  </v:grid-row>
</v:grid>
