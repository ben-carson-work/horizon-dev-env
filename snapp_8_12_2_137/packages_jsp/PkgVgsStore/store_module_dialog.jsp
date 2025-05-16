<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.web.gencache.*"%>
<%@page import="com.vgs.cl.json.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
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

class VersionBean {
  String moduleVersion;
  String fileName;
  String warMinVersion;
  String warMaxVersion;
  String posMinVersion;
  String posMaxVersion;
}
List<VersionBean> versions = new ArrayList<>();

JvDBSessionConnector storeConnector = new JvDBSessionConnector(SrvBO_Cache_DataSource.instance().getDBPool(dataSourceId), pageBase.getSession());
try {
  QueryDef qdef = new QueryDef("QryST_ModuleVersion");
  qdef.addSelect("ModuleVersion", "FileName", "SnappMinVersion", "SnappMaxVersion", "PosMinVersion", "PosMaxVersion");
  qdef.addFilter("ModuleId", pageBase.getId());
  JvDataSet ds = storeConnector.getDB().executeQuery(qdef, storeConnector);
  while (!ds.isEof()) {
    VersionBean v = new VersionBean();
    v.moduleVersion = ds.getField("ModuleVersion").getString();
    v.fileName = ds.getField("FileName").getString();
    v.warMinVersion = ds.getField("SnappMinVersion").getString();
    v.warMaxVersion = ds.getField("SnappMaxVersion").getString();
    v.posMinVersion = ds.getField("PosMinVersion").getString();
    v.posMaxVersion = ds.getField("PosMaxVersion").getString();
    versions.add(v);
    
    ds.next();
  }
  
  versions.sort(new Comparator<VersionBean>() {
    @Override
    public int compare(VersionBean o1, VersionBean o2) {
      return JvUtils.isSubsequentVersion(o1.moduleVersion, o2.moduleVersion) ? -1 : 1;
    }
  });
  
  JvDataSet dsLicense = storeConnector.getDB().executeQuery(
      "select" + JvString.CRLF +
      "  DatabaseId as LicenseId," + JvString.CRLF +
      "  '[' + Cast(DatabaseId as varchar(max)) + '] ' + DatabaseName as LicenseDesc" + JvString.CRLF +
      "from tbDatabase" + JvString.CRLF +
      "order by DatabaseId");
  
  boolean publicModule = false;
  LookupItem moduleType = null;
  try (JvDataSet dsModule = storeConnector.getDB().executeQuery("select ModuleType, PublicModule from tbModule where ModuleId=" + JvString.sqlStr(pageBase.getId()))) {
    if (!dsModule.isEmpty()) {
      publicModule = dsModule.getField("PublicModule").getBoolean(); 
      moduleType = LkSN.ModuleType.findItemByCode(dsModule.getField("ModuleType").getInt());
    }
  }
  int[] selLicenseIDs = storeConnector.getDB().getInts("select DatabaseId from tbModule2Database where ModuleId=" + JvString.sqlStr(pageBase.getId()));
  
  String dialogTitle = "Package";
  if ((moduleType != null) && moduleType.isLookup(LkSNModuleType.POS))
    dialogTitle = "Vgs Board";
%>

<v:dialog id="store_module_dialog" title="<%=dialogTitle%>" tabsView="true" width="800" height="600" autofocus="false">

  <v:tab-group name="tab" main="true">
    <v:tab-item-embedded tab="main" caption="@Common.Profile" default="true">
      <div class="tab-content">
        <% if ((moduleType != null) && moduleType.isLookup(LkSNModuleType.PKG)) { %>
          <v:widget caption="General">
            <v:widget-block>
              <v:db-checkbox field="PublicPackage" value="true" checked="<%=publicModule%>" caption="Public" hint="Package available to any licensee"/>
            </v:widget-block>
            <v:widget-block>
              <v:form-field caption="Licenses">
                <v:multibox field="LicenseIDs" lookupDataSet="<%=dsLicense%>" idFieldName="LicenseId" captionFieldName="LicenseDesc" value="<%=JvArray.arrayToString(selLicenseIDs, \",\")%>"/>
              </v:form-field>
            </v:widget-block>
          </v:widget>
        <% } %>
        
        <v:grid>
          <thead>
            <tr>
              <td></td>
              <td width="25%">Version</td>
              <td width="25%">FileName</td>
              <td width="25%">BKO version</td>
              <% if ((moduleType != null) && !moduleType.isLookup(LkSNModuleType.POS)) { %>
                <td width="25%">POS version</td>
              <% } %>
            </tr>
          </thead>
          <tbody>
          <% String oldMajorVersion = null; %>
          <% for (VersionBean v : versions) { %>
            <% String newMajorVersion = v.moduleVersion.substring(0, v.moduleVersion.lastIndexOf(".")) + ".X"; %>
            <% if ((oldMajorVersion == null) || !oldMajorVersion.equals(newMajorVersion)) { %>
              <tr class="group"><td colspan="100%"><%=JvString.escapeHtml(newMajorVersion)%></td></tr>
              <% oldMajorVersion = newMajorVersion; %>
            <% } %>
            <tr class="grid-row">
              <%
              String warMin = JvString.escapeHtml(v.warMinVersion);
              String warMax = JvString.escapeHtml(v.warMaxVersion);
              String posMin = JvString.escapeHtml(v.posMinVersion);
              String posMax = JvString.escapeHtml(v.posMaxVersion);
              warMin = (warMin.length() > 0) ? warMin : "<i>not-set</i>"; 
              warMax = (warMax.length() > 0) ? warMax : "<i>unlimited</i>"; 
              posMin = (posMin.length() > 0) ? posMin : "<i>not-set</i>"; 
              posMax = (posMax.length() > 0) ? posMax : "<i>unlimited</i>"; 
              %>
              <td nowrap>&bull;&nbsp;</td>
              <td><b><%=JvString.escapeHtml(v.moduleVersion)%></b></td>
              <td><%=JvString.escapeHtml(v.fileName)%></td>
              <td><%=warMin%> &rArr; <%=warMax%></td>
              <% if ((moduleType != null) && !moduleType.isLookup(LkSNModuleType.POS)) { %>
                <td><%=posMin%> &rArr; <%=posMax%></td>
              <%} %>
            </tr>
          <% } %>
          </tbody>
        </v:grid>
      </div>
    </v:tab-item-embedded>
  </v:tab-group>

<% if ((moduleType != null) && moduleType.isLookup(LkSNModuleType.PKG)) { %>
<script>

$(document).ready(function() {

  var $dlg = $("#store_module_dialog");
  $dlg.bind("snapp-dialog", function(event, params) {
    params.buttons = {
      <v:itl key="@Common.Save" encode="JS"/>: doSavePackage,
      <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
    };
  });

  function doSavePackage() {
    var reqDO = {
      Command: "SavePackageLicenses",
      SavePackageLicenses: {
        PackageId: <%=JvString.jsString(pageBase.getId())%>,
        PublicPackage: $dlg.find("#PublicPackage").isChecked(),
        LicenseIDs: $dlg.find("#LicenseIDs").val()
      }
    };
    
    vgsService("PkgStoreAdmin", reqDO, false, function(ansDO) {
      $dlg.dialog("close");
    });
  }

});

</script>
<% } %>
</v:dialog>
    
<%
} 
finally {
  storeConnector.dispose();  
}
%>
