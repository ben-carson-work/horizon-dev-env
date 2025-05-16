<%@page import="com.vgs.snapp.lookup.LkSNEntityType"%>
<%@page import="com.vgs.snapp.lookup.LkSNRightLevel"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageAccount" scope="request"/>
<jsp:useBean id="account" class="com.vgs.snapp.dataobject.DOAccount" scope="request"/>
<jsp:useBean id="license" class="com.vgs.snapp.dataobject.DOLicenseDef" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
  JvDateTime lastUpdate = pageBase.getBL(BLBO_License.class).getLicenseLastUpdate(account.LicenseId.getInt());
  boolean canImportLicense = rights.ImportLicense.getBoolean();
%>

<% if (rights.SuperUser.getBoolean() || canImportLicense) { %>
<div class="tab-toolbar">
  <div class="btn-group">
    <v:button caption="@Common.ImportLicense" fa="sign-in" dropdown="true"/>
    <v:popup-menu bootstrap="true">
      <v:popup-item id="menu-cloud-import" caption="Import from vgs-store online" fa="cloud-download"/>
      <v:popup-item id="menu-file-import" caption="Upload a file" fa="upload"/>
    </v:popup-menu>
  </div>
</div>
<% } %>

<script>
$(document).ready(function() {
  var accountId = <%=JvString.jsString(pageBase.getId())%>;
  
  $("#menu-cloud-import").click(function() {
    var dlg = $("<div/>");
    dlg.dialog({
      modal: true,
      buttons: {
        <v:itl key="@Common.Ok" encode="JS"/>: function() {
          dlg.remove();
          location.reload(true);
        }
      }
    });
    asyncLoad(dlg, "<v:config key="site_url"/>/admin?page=account&action=import-license&id=" + accountId);
  });

  $("#menu-file-import").click(function() {
    vgsImportDialog("admin?page=account&action=import-license-file&id=" + accountId);
  });

  $("a.reset-workstation").click(function(e) {
    e.preventDefault();
    e.stopPropagation();
    
    var workstationId = $(this).attr("data-workstationid");
    confirmDialog(null, function() {
      var reqDO = {
        Command: "ResetLicense",
        ResetLicense: {
          WorkstationId: workstationId
        }
      };
      
      showWaitGlass();
      vgsService("Workstation", reqDO, false, function() {
        hideWaitGlass();
        location.reload(true);
      });
    });
  });
});
</script>

<style>
  table.listcontainer tbody tr {
    cursor: inherit;
  }
</style>

<div class="tab-content">
  <v:widget caption="@Common.Licensee">
    <v:widget-block>
      <v:form-field caption="License ID"><v:input-text field="license.DatabaseId" enabled="false"/></v:form-field>
      <v:form-field caption="Licensee Name"><v:input-text field="license.DatabaseName" enabled="false"/></v:form-field>
      <v:form-field caption="System URL"><v:input-text field="license.SystemUrl" enabled="false"/></v:form-field>
    </v:widget-block>
    <v:widget-block>
      <v:form-field caption="Modules"><v:input-text field="license.Modules" enabled="false"/></v:form-field>
      <v:form-field caption="Max locations"><v:input-text field="license.MaxLocations" placeholder="@Common.Unlimited" enabled="false"/></v:form-field>
      <v:form-field caption="Max products"><v:input-text field="license.MaxProducts" placeholder="@Common.Unlimited" enabled="false"/></v:form-field>
      <v:form-field caption="Max users"><v:input-text field="license.MaxUsers" placeholder="@Common.Unlimited" enabled="false"/></v:form-field>
      <v:form-field caption="Max BKO users"><v:input-text field="license.MaxConcUsers_BKO" placeholder="@Common.Unlimited" enabled="false"/></v:form-field>
      <v:form-field caption="Max B2B users"><v:input-text field="license.MaxConcUsers_B2B" placeholder="@Common.Unlimited" enabled="false"/></v:form-field>
    </v:widget-block>
    <v:widget-block>
      <v:form-field caption="@Common.LastUpdate"><snp:datetime timestamp="<%=lastUpdate%>" format="shortdatetime" timezone="local"/></v:form-field>
    </v:widget-block>
  </v:widget>

  <v:grid>
    <thead>
      <tr>
        <td>&nbsp;</td>
        <td>
          <v:itl key="@Common.Code"/><br/>
          <v:itl key="@Common.Type"/>
        </td>
        <td width="20%">
          Activation Key<br/>
          Apps
        </td>
        <td width="20%"><v:itl key="@Common.Workstation"/></td>
        <td width="60%"><v:itl key="@Common.Registered"/></td>
      </tr>
    </thead>  
    <tbody>
    <% for (DOLicense lic : license.LicenseList.getItems()) { %>
      <%
      QueryDef qdefWks = new QueryDef(QryBO_Workstation.class);
      qdefWks.addSelect(
          QryBO_Workstation.Sel.IconName,
          QryBO_Workstation.Sel.WorkstationId,
          QryBO_Workstation.Sel.WorkstationCode,
          QryBO_Workstation.Sel.WorkstationName,
          QryBO_Workstation.Sel.ActivationKey,
          QryBO_Workstation.Sel.LicenseParams);
      qdefWks.addFilter(QryBO_Workstation.Fil.ActivationKey, lic.ActivationKey.getString());
      JvDataSet dsWks = pageBase.execQuery(qdefWks);
      %>
      <tr class="grid-row">
        <td><v:grid-icon name="<%=LkSNEntityType.Login.getIconName()%>"/></td>
        <td>
          <strong><%=lic.StationCode.getHtmlString()%></strong><br/>
          <span class="list-subtitle" style='white-space:nowrap'><%=lic.WorkstationType.getHtmlLookupDesc(pageBase.getLang())%></span> 
        </td>
        <td valign="top">
          <%=lic.ActivationKey.getHtmlString()%><br/>
          <%
            String[] apps = new String[0];
            for (DOLicense.DOAppItem app : lic.AppList.getItems())
              apps = JvArray.add(app.AppName.getHtmlString(), apps);
          %>
          <span class="list-subtitle"><%=JvArray.arrayToString(apps, ", ")%></span>
        </td>
        <td>
          <% if (!dsWks.isEmpty()) { %>
            <a href="<v:config key="site_url"/>/admin?page=workstation&id=<%=dsWks.getField(QryBO_Workstation.Sel.WorkstationId).getEmptyString()%>"><%=dsWks.getField(QryBO_Workstation.Sel.WorkstationName).getHtmlString()%></a><br/>
            <%=dsWks.getField(QryBO_Workstation.Sel.WorkstationCode).getHtmlString()%>
          <% } else { %>
            <span class="list-subtitle"><v:itl key="@Common.None"/></span>
          <% } %>
        </td>
        <td>
          <% if (!dsWks.isEmpty() && !dsWks.getField(QryBO_Workstation.Sel.LicenseParams).isNull()) { %>
            <v:itl key="@Common.Yes"/><br/>
            <a class="reset-workstation" href="#" data-workstationid="<%=dsWks.getField(QryBO_Workstation.Sel.WorkstationId).getEmptyString()%>"><v:itl key="@Common.Reset"/></a>
          <% } else { %>
            <span class="list-subtitle"><v:itl key="@Common.No"/></span>
          <% } %>
        </td>
      </tr>
    <% } %>
    </tbody>
  </v:grid>
</div>
