<%@page import="com.vgs.cl.json.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.web.gencache.*"%>
<%@page import="com.vgs.cl.database.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>
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
  QueryDef qdef = new QueryDef("QryST_Database");
  // Select
  qdef.addSelect("IconPath", "DatabaseId", "DatabaseName", "SystemUrl");
  // Paging
  qdef.pagePos = pageBase.getQP();
  qdef.recordPerPage = QueryDef.recordPerPageDefault;
  // Filter
  if (pageBase.getNullParameter("FullText") != null) 
    qdef.addFilter("FullText", pageBase.getNullParameter("FullText"));
  // Sort
  qdef.addSort("DatabaseId");
  // Exec
  JvDataSet ds = storeConnector.getDB().executeQuery(qdef, storeConnector);
%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>">
  <thead>
    <tr>
      <td><v:grid-checkbox header="true"/></td>
      <td>&nbsp;</td>
      <td width="100%">
        <v:itl key="License"/><br/>
        <v:itl key="URL"/>
      </td>
    </tr>
  </thead>
  <tbody>
    <v:grid-row dataset="<%=ds%>">
      <td><v:grid-checkbox name="DatabaseId" dataset="<%=ds%>" fieldname="DatabaseId"/></td>
      <td><v:grid-icon name="<%=ds.getField(\"IconPath\").getString()%>"/></td>
      <td>
        <a class="list-title" href="<%=pageBase.getContextURL()%>?page=store_licensee&LicenseId=<%=ds.getField("DatabaseId").getHtmlString()%>">[<%=ds.getField("DatabaseId").getHtmlString()%>] <%=ds.getField("DatabaseName").getHtmlString()%></a><br/>
        <span class="list-subtitle"><%=ds.getField("SystemUrl").getHtmlString()%></span>
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

    