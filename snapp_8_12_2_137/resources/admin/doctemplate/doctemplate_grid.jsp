<%@page import="com.vgs.web.library.PageBase"%>
<%@page import="com.vgs.web.tag.ConfigTag"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_DocTemplate.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageGridWidget" scope="request"/>

<%

QueryDef qdef = new QueryDef(QryBO_DocTemplate.class);
// Select
qdef.addSelect(Sel.IconName);
qdef.addSelect(Sel.CommonStatus);
qdef.addSelect(Sel.DocTemplateId);
qdef.addSelect(Sel.DocTemplateCode);
qdef.addSelect(Sel.DocTemplateNameITL);
qdef.addSelect(Sel.DocTemplateType);
qdef.addSelect(Sel.DocEditorType);
qdef.addSelect(Sel.DocEnabled);
qdef.addSelect(Sel.SystemCode);
qdef.addSelect(Sel.ExtensionPackageId);
qdef.addSelect(Sel.ExtensionPackageCode);
qdef.addSelect(Sel.ExtensionPackageName);
qdef.addSelect(Sel.ExtensionPackageVersion);
// Where

if (pageBase.getNullParameter("FullText") != null)
  qdef.addFilter(Fil.FullText, pageBase.getNullParameter("FullText"));

if (pageBase.getNullParameter("DocTemplateType") != null)
  qdef.addFilter(Fil.DocTemplateType, JvArray.stringToIntArray(pageBase.getParameter("DocTemplateType"), ","));

if (pageBase.getNullParameter("DocEditorType") != null)
  qdef.addFilter(Fil.DocEditorType, JvArray.stringToIntArray(pageBase.getParameter("DocEditorType"), ","));

if (!pageBase.getRights().SuperUser.getBoolean()) {
  qdef.addFilter(Fil.ForUserAccountId, pageBase.getSession().getUserAccountId());
  qdef.addFilter(Fil.ForWorkstationId, pageBase.getSession().getWorkstationId());
}

if ((pageBase.getNullParameter("CategoryId") != null) && !pageBase.isParameter("CategoryId", "all"))
  qdef.addFilter(Fil.CategoryId, pageBase.getNullParameter("CategoryId"));

// Sort
qdef.addSort(Sel.DocTemplateNameITL);
// Paging
qdef.pagePos = pageBase.getQP();
qdef.recordPerPage = QueryDef.recordPerPageDefault;
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);

%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>" entityType="<%=LkSNEntityType.DocTemplate%>">
  <thead>
    <tr>
      <td><v:grid-checkbox header="true"/></td>
      <td>&nbsp;</td>
      <td width="20%">
        <v:itl key="@Common.Name"/><br/>
        <v:itl key="@Common.Type"/>
      </td>
      <td width="60%">
        <v:itl key="@DocTemplate.Editor"/><br/>
        <v:itl key="@Common.Code"/>
      </td>
      <td width="20%">
        <v:itl key="@Plugin.ExtensionPackage"/>
      </td>
    </tr>
  </thead>
  <tbody>
  <v:grid-row dataset="ds">
    <td style="<v:common-status-style status="<%=ds.getField(Sel.CommonStatus)%>"/>"><v:grid-checkbox name="DocTemplateId" dataset="ds" fieldname="DocTemplateId"/></td>
    <td><v:grid-icon name="<%=ds.getField(Sel.IconName).getString()%>"/></td>
    <td>
      <% 
      String id = ds.getField(Sel.DocTemplateId).getHtmlString();
      String href = ConfigTag.getValue("site_url") + "/admin?page=doctemplate&id=" + id; 
      if (pageBase.isParameter("reportexec", "true"))
        href = "javascript:asyncDialogEasy('doctemplate/reportexec_dialog', 'id=" + id + "')";
      %>
      <a href="<%=href%>" class="list-title"><%=ds.getField(Sel.DocTemplateNameITL).getHtmlString()%></a><br/>
      <span class="list-subtitle"><%= LkSN.DocTemplateType.getItemByCode(ds.getField(Sel.DocTemplateType).getInt()).getDescription(pageBase.getLang()) %></span>
    </td>
    <td>
      <%= LkSN.DocEditorType.getItemByCode(ds.getField(Sel.DocEditorType).getInt()).getDescription(pageBase.getLang()) %><br/>
      
      <span class="list-subtitle">
      <% if (ds.getField(Sel.SystemCode).isNull()) { %>
        -
      <% } else { %>
        <%=ds.getField(Sel.SystemCode).getHtmlString()%>
      <% } %>
      </span>
    </td>
    <td>
      <%  if (ds.getField(Sel.ExtensionPackageId).isNull()) { %>
      <span class="list-subtitle">
        <%="" + JvString.MDASH %>
      </span>
      <% } else { %>
        <%=ds.getField(Sel.ExtensionPackageCode).getHtmlString() + " " + ds.getField(Sel.ExtensionPackageVersion).getHtmlString() %>
        <span class="list-subtitle">
          <%=ds.getField(Sel.ExtensionPackageName).getHtmlString()%><br/>
        </span>
      <% } %>
    </td>  
  </v:grid-row>
  </tbody>
</v:grid>
