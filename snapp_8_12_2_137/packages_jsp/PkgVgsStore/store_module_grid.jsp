<%@page import="com.vgs.snapp.web.gencache.*"%>
<%@page import="com.vgs.cl.json.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<% PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); %>

<%
BLBO_Plugin blPlugin = pageBase.getBL(BLBO_Plugin.class);
DOExtensionPackage pkg = blPlugin.loadExtensionPackage(blPlugin.getExtensionPackageIdByCode("pkg-vgs-store"));

String dataSourceId = null;
if (!pkg.ConfigDoc.isNull()) {
  JSONObject cfg = new JSONObject(pkg.ConfigDoc.getString());
  dataSourceId = cfg.getString("DataSourceId");
}

JvDBSessionConnector storeConnector = new JvDBSessionConnector(SrvBO_Cache_DataSource.instance().getDBPool(dataSourceId), pageBase.getSession());
try {
  QueryDef qdef = new QueryDef("QryST_Module");
  // Select
  qdef.addSelect("IconPath", "ModuleId", "ModuleCode", "ModuleName", "ModuleType");
  // Paging
  qdef.pagePos = pageBase.getQP();
  qdef.recordPerPage = QueryDef.recordPerPageDefault;
  // Filter
  if (pageBase.getNullParameter("FullText") != null) 
    qdef.addFilter("FullText", pageBase.getNullParameter("FullText"));
  if (pageBase.getNullParameter("ModuleType") != null) 
    qdef.addFilter("ModuleType", pageBase.getNullParameter("ModuleType"));
  // Sort
  qdef.addSort("ModuleCode");
  // Exec
  JvDataSet ds = storeConnector.getDB().executeQuery(qdef, storeConnector);
%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>">
  <thead>
    <tr>
      <td><v:grid-checkbox header="true"/></td>
      <td>&nbsp;</td>
      <td width="100%">
        <v:itl key="@Common.Code"/><br/>
        <v:itl key="@Common.Name"/>
      </td>
    </tr>
  </thead>
  <tbody>
    <v:grid-row dataset="<%=ds%>">
      <td><v:grid-checkbox name="PackageId" dataset="<%=ds%>" fieldname="PackageId"/></td>
      <td><v:grid-icon name="<%=ds.getField(\"IconPath\").getString()%>"/></td>
      <td>
        <a class="list-title" href="javascript:asyncDialogEasy('../../plugins/pkg-vgs-store/store_module_dialog', 'id=<%=ds.getField("ModuleId").getHtmlString()%>')"><%=ds.getField("ModuleCode").getHtmlString()%></a><br/>
        <span class="list-subtitle"><%=ds.getField("ModuleName").getHtmlString()%></span>
      </td>
    </v:grid-row>
  </tbody>
</v:grid>
    
<%
} 
finally {
  storeConnector.dispose();  
}
%>
