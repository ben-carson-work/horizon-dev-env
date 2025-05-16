<%@page import="com.vgs.cl.json.JSONObject"%>
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
  QueryDef qdef = new QueryDef("QryST_License")
      .addSelect("IconPath", "ActivationKey", "WorkstationType", "StationCode", "Apps", "Description")
      .addFilter("DatabaseId", pageBase.getNullParameter("LicenseId"))
      .addFilter("ClientId", "0")
      .addSort("StationCode")
      .setPaging(pageBase.getQP(), QueryDef.recordPerPageDefault);
  
  if (pageBase.getNullParameter("WorkstationType") != null)
    qdef.addFilter("WorkstationType", JvString.replace(pageBase.getParameter("WorkstationType"), ",", "\t"));
  
  if (pageBase.getNullParameter("Apps") != null)
    qdef.addFilter("Apps", JvString.replace(pageBase.getParameter("Apps"), ",", "\t"));

  JvDataSet ds = storeConnector.getDB().executeQuery(qdef, storeConnector, true);
%>

<v:grid dataset="<%=ds%>" qdef="<%=qdef%>">
  <thead>
    <tr>
      <td><v:grid-checkbox header="true"/></td>
      <td>&nbsp;</td>
      <td>
        <v:itl key="Activation key"/><br/>
        <v:itl key="Station code"/>
      </td>
      <td>
        <v:itl key="@Common.Type"/>
      </td>
      <td width="100%">
        <v:itl key="Apps"/><br/>
        <v:itl key="@Common.Description"/>
      </td>
    </tr>
  </thead>
  <tbody>
    <v:grid-row dataset="<%=ds%>">
      <td><v:grid-checkbox name="ActivationKey" dataset="<%=ds%>" fieldname="ActivationKey"/></td>
      <td><v:grid-icon name="<%=ds.getField(\"IconPath\").getString()%>"/></td>
      <td>
        <a href="javascript:asyncDialogEasy('../../plugins/pkg-vgs-store/store_actkey_update_dialog', 'ActivationKey=<%=ds.getField("ActivationKey").getHtmlString()%>')" class="list-title"><%=ds.getField("ActivationKey").getHtmlString()%></a><br/>
        <span class="list-subtitle"><%=ds.getField("StationCode").getHtmlString()%></span>
      </td>
      <td>
        <% LookupItem workstationType = LkSN.WorkstationType.getItemByCode(ds.getField("WorkstationType")); %>
        <%=workstationType.getDescription(pageBase.getLang())%>
      </td>
      <td>
        <%=ds.getField("Apps").getHtmlString()%><br/>
        <span class="list-subtitle"><%=ds.getField("Description").getHtmlString()%></span>
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

    