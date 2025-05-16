<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Mask.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>


<%
QueryDef qdef = new QueryDef(QryBO_Mask.class);
// Select
qdef.addSelect(Sel.IconName);
qdef.addSelect(Sel.MaskId);
qdef.addSelect(Sel.MaskCode);
qdef.addSelect(Sel.MaskName);
qdef.addSelect(Sel.PriorityOrder);
qdef.addSelect(Sel.EntityType);
// Filter
if (pageBase.getNullParameter("FullText") != null)
qdef.addFilter(Fil.FullText, pageBase.getParameter("FullText"));

if (pageBase.getNullParameter("EntityType") != null)
  qdef.addFilter(Fil.EntityType, pageBase.getNullParameter("EntityType"));
// Sort
qdef.addSort(Sel.EntityType);
qdef.addSort(Sel.MaskName);
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);

%>

<v:grid id="mask-grid-table" dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.Mask%>">
  <thead>
    <tr>
      <td><v:grid-checkbox header="true"/></td>
      <td>&nbsp;</td>
      <td width="30%">
        <v:itl key="@Common.Name"/><br/>
        <v:itl key="@Common.Code"/>
      </td>
      <td width="70%">
        <v:itl key="@Common.PriorityOrder"/>
      </td>
    </tr>
  </thead>
  <tbody>
  <% int lastEntityCode = -1; %>
  <% LookupItem entityType = null; %>
  <v:ds-loop dataset="<%=ds%>">
    <%
      if (ds.getField(Sel.EntityType).getInt() != lastEntityCode) {
        lastEntityCode = ds.getField(Sel.EntityType).getInt();
        entityType = LkSN.EntityType.getItemByCode(lastEntityCode);
        String entity_desc = BLBO_Mask.getMaskEntityTypeDescription(entityType, pageBase.getLang());
        %><tr class="group"><td colspan="100%"><%=entity_desc%></td></tr><%
      } 
    %>
    <tr class="grid-row">
      <td><v:grid-checkbox name="cbMaskId" dataset="ds" fieldname="MaskId"/></td>
      <td><v:grid-icon name="<%=ds.getField(QryBO_Mask.Sel.IconName).getString()%>"/></td>
      <td>
        <div>
          <snp:entity-link entityId="<%=ds.getField(Sel.MaskId)%>" entityType="<%=LkSNEntityType.Mask%>"  clazz="list-title">
            <%=ds.getField(Sel.MaskName).getHtmlString()%>
          </snp:entity-link>
        </div>
        <div class="list-subtitle">
          <%=ds.getField(Sel.MaskCode).getHtmlString()%>
        </span>
      </td>
      <td>
        <%= ds.getField(Sel.PriorityOrder).isNull() ? JvString.MDASH : ds.getField(Sel.PriorityOrder).getHtmlString()%>
      </td>
    </tr>
  </v:ds-loop>
  </tbody>
</v:grid>
