<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Role.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_Role.class)
    .addSelect(
        Sel.IconName,
        Sel.CommonStatus,
        Sel.RoleId,
        Sel.RoleCode,
        Sel.RoleName,
        Sel.RoleType,
        Sel.NoteCount);

// Where
if (pageBase.getNullParameter("FullText") != null)
  qdef.addFilter(Fil.FullText, pageBase.getNullParameter("FullText"));
if ((pageBase.getNullParameter("RoleType") != null))
  qdef.addFilter(Fil.RoleType, JvArray.stringToArray(pageBase.getNullParameter("RoleType"), ","));

boolean includeActive = pageBase.isParameter("IncludeActive", "true");
boolean includeInactive = pageBase.isParameter("IncludeInactive", "true");
if (includeActive ^ includeInactive)
  qdef.addFilter(Fil.Active, String.valueOf(includeActive));

// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;

// Sort
qdef.addSort(Sel.RoleName);

// Exec
JvDataSet ds = pageBase.execQuery(qdef);
%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.Role%>">
  <tr class="header">
    <td><v:grid-checkbox header="true"/></td>
    <td>&nbsp;</td>
    <td width="85%">
      <v:itl key="@Common.Name"/><br/>
      <v:itl key="@Common.Code"/>
    </td>
    <td width="15%">
      <v:itl key="@Common.Type"/><br/>
    </td>
  </tr>
  <v:grid-row dataset="<%=ds%>">
    <% 
    LookupItem commonStatus = LkSN.CommonStatus.getItemByCode(ds.getField(Sel.CommonStatus)); 
    LookupItem roleType = LkSN.RoleType.getItemByCode(ds.getField(Sel.RoleType)); 
    %>
    <td style="<v:common-status-style status="<%=commonStatus%>"/>">
      <v:grid-checkbox name="RoleId" dataset="<%=ds%>" fieldname="RoleId"/>
      <snp:grid-note entityType="<%=LkSNEntityType.Role%>" entityId="<%=ds.getString(Sel.RoleId)%>" noteCountField="<%=ds.getField(Sel.NoteCount)%>"/>
    </td>
    <td><v:grid-icon name="<%=ds.getField(Sel.IconName)%>"/></td>
    <td>
      <snp:entity-link entityId="<%=ds.getField(Sel.RoleId).getString()%>" entityType="<%=LkSNEntityType.Role%>" clazz="list-title">
        <v:label field="<%=ds.getField(Sel.RoleName)%>"/>
      </snp:entity-link><br/>
      <span class="list-subtitle"><%=ds.getField(Sel.RoleCode).getHtmlString()%></span>
    </td>
    <td>
      <%=roleType.getHtmlDescription(pageBase.getLang())%>
    </td>
  </v:grid-row>
</v:grid>
