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

<v:dialog id="actkey_create_dialog" tabsView="true" title="Create activation keys" width="800" height="600">

  <v:tab-group name="tab" main="true">
    <v:tab-item-embedded tab="tabs-main" caption="@Common.Profile" default="true">
      <div class="tab-content">
        <v:widget caption="General">
          <v:widget-block>
            <v:form-field caption="Number of licenses" mandatory="true">
              <input type="text" id="txtLicenseCount" class="form-control">
            </v:form-field>
            <v:form-field caption="Workstation type">
              <% for (LookupItem wt : LookupManager.getArray(LkSNWorkstationType.POS, LkSNWorkstationType.VPS, LkSNWorkstationType.MOB, LkSNWorkstationType.WEB, LkSNWorkstationType.B2C, LkSNWorkstationType.WPG, LkSNWorkstationType.XPI, LkSNWorkstationType.CHM, LkSNWorkstationType.ACC, LkSNWorkstationType.KSK)) { %>
                <label class="checkbox-label"><input type="radio" name="rdWorkstationType" value="<%=wt.getCode()%>"/> <%=wt.getHtmlDescription(pageBase.getLang())%></label>
                &nbsp;&nbsp;&nbsp;
              <% } %>
            </v:form-field>
          </v:widget-block>
          <v:widget-block clazz="app-block app-block-pos">
            <% for (String app : SnpLicense.PosApps) { %>
              <label class="checkbox-label"><input type="checkbox" name="cbAPPS" value="<%=app%>"/> <%=app%></label><br/>
            <% } %>
          </v:widget-block>
          <v:widget-block clazz="app-block app-block-mob">
            <% for (String app : SnpLicense.getMobApps()) { %>
              <label class="checkbox-label"><input type="checkbox" name="cbAPPS" value="<%=app%>"/> <%=app%></label><br/>
            <% } %>
          </v:widget-block>
        </v:widget>
      </div>
    </v:tab-item-embedded>
  </v:tab-group>


<style>
.app-block {
  display: none;
}
[data-wd='<%=LkSNWorkstationType.POS.getCode()%>'] .app-block-pos {
  display: block;
}
[data-wd='<%=LkSNWorkstationType.MOB.getCode()%>'] .app-block-mob {
  display: block;
}
</style>


<script>

$(document).ready(function() {
  var $dlg = $("#actkey_create_dialog");
  $dlg.bind("snapp-dialog", function(event, params) {
    params.buttons = [
      {
        "text": itl("@Common.Create"),
        "click": doCreateActivationKey
      },
      {
        "text": itl("@Common.Cancel"),
        "click": doCloseDialog
      }
    ];
  });

  $dlg.find("[name='rdWorkstationType']").change(doRefreshOptions).filter("[value='<%=LkSNWorkstationType.POS.getCode()%>']").setChecked(true);
  
  function doRefreshOptions() {
    $dlg.find("[name='cbAPPS']").setChecked(false);
    $dlg.find(".tab-content").attr("data-wd", $("[name='rdWorkstationType']").getCheckedValues());
  }
  doRefreshOptions();

  function doCreateActivationKey() {
    var reqDO = {
      Command: "CreateActivationKey",
      CreateActivationKey: {
        LicenseId: <%=JvString.jsString(pageBase.getNullParameter("LicenseId"))%>,
        LicenseCount: $dlg.find("#txtLicenseCount").val(),
        WorkstationType: $dlg.find("[name='rdWorkstationType']").getCheckedValues(),
        Apps: $dlg.find("[name='cbAPPS']").getCheckedValues()
      }
    };
    
    vgsService("PkgStoreAdmin", reqDO, false, function(ansDO) {
      changeGridPage("#actkey-grid");
      $dlg.dialog("close");
    });
  }
});

</script>

</v:dialog>
