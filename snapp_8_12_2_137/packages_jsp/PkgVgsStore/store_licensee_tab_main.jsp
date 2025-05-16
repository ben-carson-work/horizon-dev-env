<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>
<% PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); %>

<div id="init-spinner" class="tab-content"><i class="fa fa-3x fa-circle-notch fa-spin"></i></div>

<div id="tab-body" class="hidden">
  <div class="tab-toolbar">
    <v:button id="btn-save" caption="@Common.Save" fa="save"/>
    
    <% String hrefDownload = "admin?page=store_licensee&action=download&LicenseId=" + pageBase.getEmptyParameter("LicenseId"); %>
    <v:button caption="@Common.Download" clazz="no-ajax" fa="download" href="<%=hrefDownload%>"/>
  </div>
  
  <div class="tab-content">
    <v:widget caption="Info">
      <v:widget-block>
        <v:form-field caption="License ID" mandatory="true"><v:input-text field="txtLicenseId"/></v:form-field>
        <v:form-field caption="System URL"><v:input-text field="txtSystemUrl"/></v:form-field>
        <v:form-field caption="Description"><v:input-text field="txtLicenseName"/></v:form-field>
      </v:widget-block>
      <v:widget-block>
        <v:form-field caption="Custom builds" hint="Comma separated list of client's specific builds (ie: '8.11.2.57.X, 8.11.2.81.X')"><v:input-text field="txtCustomBuilds"/></v:form-field>
      </v:widget-block>
    </v:widget>
  
    <v:widget caption="Modules">
      <v:widget-block>
      <% for (SnpLicense.ModuleBean mb : SnpLicense.Modules) { %>
        <div>
          <label class="checkbox-label">
            <input type="checkbox" name="cbModules" value="<%=mb.code%>">
            <b><%=mb.code%></b> <i><%=JvString.escapeHtml(mb.name)%></i>
          </label>
        </div>
      <% } %>
      </v:widget-block>
    </v:widget>
  
    <v:widget caption="Limitations">
      <v:widget-block>
        <v:form-field caption="Max locations"><v:input-text field="txtMaxLocations" placeholder="unlimited"/></v:form-field>
        <v:form-field caption="Max products"><v:input-text field="txtMaxProducts" placeholder="unlimited"/></v:form-field>
        <v:form-field caption="Max users"><v:input-text field="txtMaxUsers" placeholder="unlimited"/></v:form-field>
        <v:form-field caption="Max BKO users"><v:input-text field="txtMaxConcUsers_BKO" placeholder="unlimited"/></v:form-field>
        <v:form-field caption="Max B2B users"><v:input-text field="txtMaxConcUsers_B2B" placeholder="unlimited"/></v:form-field>
      </v:widget-block>
    </v:widget>
  </div>
</div>


<script>
$(document).ready(function() {

  var lic = {};
  $("#btn-save").click(doSave);
  <% if (!pageBase.isParameter("LicenseId", "new")) { %>
    initData();
  <% } else { %>
    $("#init-spinner").addClass("hidden");
    $("#tab-body").removeClass("hidden");
  <% } %>
  
  
  function initData() {
    var reqDO = {
      Command: "LoadLicensee",
      LoadLicensee: {
        LicenseId: <%=JvString.jsString(pageBase.getNullParameter("LicenseId"))%>
      }
    };
    
    vgsService("PkgStoreAdmin", reqDO, false, function(ans) {
      lic = ans.Answer.LoadLicensee.LicenseDef;
      $("#init-spinner").addClass("hidden");
      $("#tab-body").removeClass("hidden");
      
      $("#txtLicenseId").val(lic.LicenseId);
      $("#txtLicenseName").val(lic.LicenseName);
      $("#txtSystemUrl").val(lic.SystemUrl);
      $("#txtCustomBuilds").val(lic.CustomBuilds);

      $("#txtMaxLocations").val(lic.MaxLocations);
      $("#txtMaxProducts").val(lic.MaxProducts);
      $("#txtMaxUsers").val(lic.MaxUsers);
      $("#txtMaxConcUsers_BKO").val(lic.MaxConcUsers_BKO);
      $("#txtMaxConcUsers_B2B").val(lic.MaxConcUsers_B2B);
      
      var modules = [];
      if (lic.Modules)
        modules = lic.Modules.split(",");
      
      $("[name='cbModules']").setChecked(false);
      for (var i=0; i<modules.length; i++)
        $("[name='cbModules'][value='" + modules[i] + "']").setChecked(true);
    });
  }
  
  function doSave() {
    var reqDO = {
      Command: "SaveLicensee",
      SaveLicensee: {
        LicenseDef: {
          LicenseId: $("#txtLicenseId").val(),
          LicenseName: $("#txtLicenseName").val(),
          SystemUrl: $("#txtSystemUrl").val(),
          CustomBuilds: $("#txtCustomBuilds").val(),
          Modules: $("[name='cbModules']").getCheckedValues(),
          MaxLocations: $("#txtMaxLocations").val(),
          MaxProducts: $("#txtMaxProducts").val(),
          MaxUsers: $("#txtMaxUsers").val(),
          MaxConcUsers_BKO: $("#txtMaxConcUsers_BKO").val(),
          MaxConcUsers_B2B: $("#txtMaxConcUsers_B2B").val()
        }
      }
    };
    
    showWaitGlass();
    vgsService("PkgStoreAdmin", reqDO, false, function(ans) {
      hideWaitGlass();
      var licenseId = $("#txtLicenseId").val();
      var urlo = <%=JvString.jsString(pageBase.getContextURL())%> + "/admin?page=store_licensee&LicenseId=" + licenseId;
      entitySaveNotification(<%=LkSNEntityType.ProductType.getCode()%>, licenseId, null, urlo);

    });
  }
  
});
</script>