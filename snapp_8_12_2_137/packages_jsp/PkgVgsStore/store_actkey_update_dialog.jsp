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
  QueryDef qdef = new QueryDef("QryST_License");
  // Select
  qdef.addSelect("ActivationKey", "StationCode", "WorkstationType", "Description", "Apps");
  // Filter
  qdef.addFilter("ActivationKey", pageBase.getNullParameter("ActivationKey"));
  // Exec
  JvDataSet dsKey = storeConnector.getDB().executeQuery(qdef, storeConnector);
  LookupItem workstationType = LkSN.WorkstationType.getItemByCode(dsKey.getField("WorkstationType"));
%>

<v:dialog id="actkey_update_dialog" tabsView="true" title="Activation Key" width="800" height="600">

  <v:tab-group name="tab" main="true">
    <v:tab-item-embedded tab="tabs-main" caption="@Common.Profile" default="true">
      <div class="tab-content">
        <v:widget caption="General">
          <v:widget-block>
            <v:form-field caption="Activation Key">
              <input type="text" id="txtActivationKey" class="form-control" readonly="readonly" value="<%=dsKey.getField("ActivationKey").getHtmlString()%>">
            </v:form-field>
            <v:form-field caption="Type">
              <input type="text" readonly="readonly" class="form-control" value="<%=workstationType.getHtmlDescription(pageBase.getLang())%>">
            </v:form-field>
            <v:form-field caption="Station Code">
              <input type="text" readonly="readonly" class="form-control" value="<%=dsKey.getField("StationCode").getHtmlString()%>">
            </v:form-field>
            <v:form-field caption="Description">
              <input type="text" id="txtDescription" class="form-control" value="<%=dsKey.getField("Description").getHtmlString()%>">
            </v:form-field>
          </v:widget-block>
          <v:widget-block>
            <% 
            String[] chk_apps = JvArray.stringToArray(dsKey.getField("Apps").getString(), ","); 
            String[] avl_apps = new String[0]; 
            if (workstationType.isLookup(LkSNWorkstationType.POS)) 
              avl_apps = SnpLicense.PosApps;
            else if (workstationType.isLookup(LkSNWorkstationType.MOB)) 
              avl_apps = SnpLicense.getMobApps();
            %>
            <% for (String app : avl_apps) { %>
              <label class="checkbox-label"><input type="checkbox" name="cbAPPS" value="<%=app%>" <%= JvArray.contains(app, chk_apps) ? "checked" : "" %>/> <%=app%></label><br/>
            <% } %>
          </v:widget-block>
        </v:widget>
      </div>
    </v:tab-item-embedded>
  </v:tab-group>


<script>

var $dlg = $("#actkey_update_dialog");
$dlg.bind("snapp-dialog", function(event, params) {
  params.buttons = {
    <v:itl key="@Common.Save" encode="JS"/>: doSaveActivationKey,
    <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
  };
});


function doSaveActivationKey() {
  var reqDO = {
    Command: "SaveActivationKey",
    SaveActivationKey: {
      ActivationKey: $dlg.find("#txtActivationKey").val(),
      Description: $dlg.find("#txtDescription").val(),
      Apps: $dlg.find("[name='cbAPPS']").getCheckedValues()
    }
  };
  
  vgsService("PkgStoreAdmin", reqDO, false, function(ansDO) {
    changeGridPage("#actkey-grid");
    $dlg.dialog("close");
  });
}
</script>

</v:dialog>
    
<%
} 
finally {
  storeConnector.dispose();  
}
%>
