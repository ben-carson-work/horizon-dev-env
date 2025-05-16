<%@page import="java.net.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageWorkstation" scope="request"/>
<jsp:useBean id="wks" class="com.vgs.snapp.dataobject.DOWorkstation" scope="request"/>
<jsp:useBean id="license" class="com.vgs.snapp.dataobject.DOLicenseDef" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<%
boolean canEditCRUD = rights.SystemSetupWorkstations.getOverallCRUD().canUpdate();
boolean canEdit = canEditCRUD && rights.SystemSetupWorkstationDemographic.getBoolean(); 
boolean canEditLicense = canEditCRUD && rights.SystemSetupWorkstationActivationKey.getBoolean(); 
boolean mobTest = !pageBase.isNewItem() && rights.SuperUser.getBoolean() && wks.WorkstationType.isLookup(LkSNWorkstationType.MOB);
String installerDownloadURL = pageBase.getContextURL() + "?page=board-installer&id=" + wks.WorkstationId.getString() + "&_=" + System.currentTimeMillis(); 
%>

<v:page-form id="workstation-form">
<v:input-text type="hidden" field="wks.WorkstationId"/>
<v:input-text type="hidden" field="wks.LicenseId"/>
<v:input-text type="hidden" field="wks.WorkstationType"/>
<v:input-text type="hidden" field="wks.LocationAccountId"/>

<script>
  var metaFields = <%=pageBase.getBL(BLBO_MetaData.class).encodeItems(wks.MetaDataList)%>;
</script>

<v:tab-toolbar>
  <v:button id="btn-save" caption="@Common.Save" fa="save" enabled="<%=canEdit || canEditLicense%>"/>
  <snp:notes-btn entityId="<%=pageBase.getId()%>" entityType="<%=LkSNEntityType.Workstation%>"/>
  
  <v:button id="btn-apisecurity" caption="@Workstation.ApiSecurity" fa="shield-check" enabled="<%=rights.ResetWorkstationLicense.getBoolean()%>" include="<%=!pageBase.isNewItem()%>"/>
  
  <v:button id="btn-open-kiosk" caption="Open Kiosk" fa="browser" include="<%=!pageBase.isNewItem() && rights.SuperUser.getBoolean() && wks.WorkstationType.isLookup(LkSNWorkstationType.KSK)%>"/>
  
  <v:button-group include="<%=!pageBase.isNewItem() && wks.WorkstationType.isLookup(LkSNWorkstationType.POS, LkSNWorkstationType.VPS)%>">
    <v:button id="btn-install" caption="@System.InstallPOS" fa="cloud-download" clazz="disabled" dropdown="true"/>
    <v:popup-menu bootstrap="true">
      <v:popup-item id="menu-installer-download" fa="cloud-download" caption="@Common.Download"/>
      <v:popup-item id="menu-installer-email" fa="envelope" caption="@System.EmailPosInstall"/>
    </v:popup-menu>
  </v:button-group>
  
  <v:button-group include="<%=!pageBase.isNewItem() && wks.WorkstationType.isLookup(LkSNWorkstationType.MOB)%>">
    <v:button id="btn-mob-register" caption="@Common.Register" fa="check" clazz="disabled" dropdown="true"/>
    <v:popup-menu bootstrap="true">
      <% String hrefMobDownload = "admin?page=mob-download-qrcode&id=" + pageBase.getId(); %>
      <v:popup-item fa="cloud-download" caption="@Common.Download" href="<%=hrefMobDownload%>" target="_new"/>
      <% String hrefMobRegister = "admin?page=mob-register-qrcode&id=" + pageBase.getId(); %>
      <v:popup-item fa="check" caption="@Common.Register" href="<%=hrefMobRegister%>" target="_new"/>
    </v:popup-menu>
  </v:button-group>
  
  <v:button id="btn-mob-test" caption="Test APP" fa="mobile-screen-button" include="<%=mobTest%>"/>
</v:tab-toolbar>

<v:tab-content>
    
  <v:profile-recap>
    <snp:profile-pic entityId="<%=pageBase.getId()%>" entityType="<%=LkSNEntityType.Workstation%>" field="wks.ProfilePictureId" enabled="<%=canEdit%>"/>

	  <% if (!pageBase.isNewItem() && wks.WorkstationType.isLookup(LkSNWorkstationType.POS, LkSNWorkstationType.APT, LkSNWorkstationType.MOB)) { %>
	    <v:widget caption="@System.LastActivity">
	      <v:widget-block>
	        <v:itl key="@Common.User"/><span class="recap-value"><%=wks.LastUserAccountName.getHtmlString()%></span><br/>
	        <v:itl key="@Common.DateTime"/><span class="recap-value"><snp:datetime timestamp="<%=wks.LastClientActivity%>" format="ShortDateTime" timezone="local"/></span><br/>
	        <v:itl key="@System.ClientVersion"/><span class="recap-value"><%=wks.LastClientVersion.getHtmlString()%></span><br/>
	        <v:itl key="@Common.IPAddress"/><span class="recap-value"><%=wks.LastClientIPAddress.getHtmlString()%></span>
	      </v:widget-block>
        <% if (!wks.LoggedUserAccountId.isNull()) { %>
          <v:widget-block id="lock-section">
            <div><v:itl key="@Common.LoggedUser"/><span class="recap-value"><snp:entity-link entityId="<%=wks.LoggedUserAccountId%>" entityType="<%=LkSNEntityType.Person%>"><%=wks.LoggedUserAccountName.getHtmlString()%></snp:entity-link></span></div>
            <div>&nbsp;</div>
            <center><v:button id="btn-unlock" caption="Unlock" clazz="btn-warning" fa="unlock" enabled="<%=rights.ManualUnlock.getBoolean()%>"/></center>
          </v:widget-block>
        <% } %>
	    </v:widget>
	  <% } %>
  </v:profile-recap>
  
  <v:profile-main>
    <v:widget caption="@Common.General">
      <v:widget-block>
        <v:form-field caption="@Common.DistributionChannel">
          <input type="text" readonly="readonly" class="form-control" value="<%=wks.WorkstationType.getLkValue().getHtmlDescription(pageBase.getLang())%>"/>
        </v:form-field>
        <% if (!wks.WorkstationType.isLookup(LkSNWorkstationType.BKO, LkSNWorkstationType.B2B, LkSNWorkstationType.CLC)) { %>
          <v:form-field caption="@Common.ActivationKey">
            <v:input-group>
              <% String sDisabled = canEditLicense ? "" : "disabled=\"disabled\""; %>
              <select id="wks.ActivationKey" name="wks.ActivationKey" class="form-control" <%=sDisabled%>>
                <option/>
                <% String[] keys = pageBase.getBL(BLBO_License.class).getAvailActivationKeys(wks.WorkstationType.getLkValue()); %>
                <% for (DOLicense lic : license.LicenseList.getItems()) { %>
                  <% boolean selected = JvString.isSameText(lic.ActivationKey.getString(), wks.ActivationKey.getString()); %>
                  <% if (selected || JvArray.contains(lic.ActivationKey.getString(), keys)) { %>
                    <%
                    String[] apps = new String[0];
                    for (DOLicense.DOAppItem app : lic.AppList)
                      apps = JvArray.add(app.AppName.getString(), apps);
                    
                    String desc = lic.StationCode.getInt() + " &mdash; " + lic.ActivationKey.getHtmlString();
                    if (apps.length > 0)
                      desc += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(" + JvString.escapeHtml(JvArray.arrayToString(apps, ", ")) + ")";
                    if (!lic.Description.isNull())
                      desc += " &mdash; " + lic.Description.getHtmlString();
                    %>
                    
                    <option value="<%=lic.ActivationKey.getHtmlString()%>" <%=(selected)?"selected":""%>><%=desc%></option>
                  <% } %>
                <% } %>
              </select>
              <v:input-group-btn>
                <v:button id="btn-actkey-copy" fa="copy" title="Copy activation key to the clipboard"/>
              </v:input-group-btn>
            </v:input-group>
          </v:form-field>
        <% } %>
      </v:widget-block>
      <v:widget-block>
        <v:form-field caption="@Common.Code" mandatory="true">
          <v:input-text field="wks.WorkstationCode" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Common.Name" mandatory="true">
          <v:input-text field="wks.WorkstationName" enabled="<%=canEdit%>"/>
        </v:form-field>
        <% if (wks.WorkstationType.isLookup(LkSNWorkstationType.CLC, LkSNWorkstationType.B2B)) { %>
          <%
          String hint = null;
          if (wks.WorkstationType.isLookup(LkSNWorkstationType.CLC))
            hint = "@Common.WorkstationUriHint_CLC";
          else if (wks.WorkstationType.isLookup(LkSNWorkstationType.B2B))
            hint = "@Common.WorkstationUriHint_B2B";
          %>
          <v:form-field caption="@Common.WorkstationURI" hint="<%=hint%>" mandatory="true">
            <v:input-text field="wks.WorkstationURI" enabled="<%=canEdit%>"/>
            <br/>
            <strong><a id="workstation-uri-link" class="v-hidden" href="" target="_new"></a></strong>
          </v:form-field>
        <% } %>
        <% if (wks.WorkstationType.isLookup(LkSNWorkstationType.ACC)) { %>
          <v:form-field caption="@Common.URL">
            <% String accURL = pageBase.getContextURL() + "?page=account-temp&code=" + URLEncoder.encode(wks.WorkstationCode.getString(), "UTF-8"); %>
            <strong><a href="<%=accURL%>" target="_new"><%=accURL%></a></strong>
          </v:form-field>
        <% } %>
      </v:widget-block>
      <v:widget-block>
        <v:form-field caption="@Account.OpArea" mandatory="true">
          <v:combobox field="wks.OpAreaAccountId" lookupDataSetName="dsOpArea" idFieldName="AccountId" captionFieldName="Displayname" linkEntityType="<%=LkSNEntityType.OperatingArea%>" enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Category.Category">
          <v:combobox field="wks.CategoryId" lookupDataSetName="dsCategoryAll" idFieldName="CategoryId" captionFieldName="AshedCategoryName" linkEntityType="<%=LkSNEntityType.Category%>" enabled="<%=canEdit%>"/>
        </v:form-field>
      </v:widget-block>
      
      <v:widget-block>
        <v:form-field caption="@SaleChannel.SaleChannel">
          <v:combobox 
              field="wks.SaleChannelId" 
              lookupDataSet="<%=pageBase.getBL(BLBO_SaleChannel.class).getSaleChannelLookupDS(wks.WorkstationType.isLookup(LkSNWorkstationType.XPI) ? LkSNSaleChannelType.External: LkSNSaleChannelType.Internal)%>" 
              idFieldName="SaleChannelId" 
              captionFieldName="SaleChannelName" 
              linkEntityType="<%=LkSNEntityType.SaleChannel%>" 
              enabled="<%=canEdit%>"/>
        </v:form-field>
        <v:form-field caption="@Workstation.ChannelGroup">
          <snp:tag-combobtn field="wks.ChannelGroupTagId" entityType="<%=LkSNEntityType.ChannelGroup%>" enabled="<%=canEdit%>"/>
        </v:form-field>
      </v:widget-block>
      
      <v:widget-block>
      <% if (LkSNWorkstationType.is3Party(wks.WorkstationType.getLkValue())) { %>
        <v:form-field caption="@Workstation.ApiSecurityType">
          <v:lk-combobox field="wks.ApiSecurityType" lookup="<%=LkSN.ApiSecurityType%>" allowNull="true"/>
        </v:form-field>
      <% } %>
        <v:form-field>
          <v:db-checkbox field="wks.ApiDebugMode" value="true" caption="@Workstation.ApiDebugMode" hint="@Workstation.ApiDebugModeHint" enabled="<%=canEdit%>"/>
        </v:form-field>
      </v:widget-block>
    </v:widget>
    <div id="maskedit-container"></div>
  </v:profile-main>
</v:tab-content>

<% if (mobTest) { %>
<jsp:include page="workstation_tab_main_mobtest.jsp"></jsp:include>
<% } %>
  
<script>

// Data Masks

function reloadMaskEdit(categoryId) {
  asyncLoad("#maskedit-container", "admin?page=maskedit_widget&id=<%=pageBase.getId()%>&EntityType=<%=LkSNEntityType.Workstation.getCode()%>&CategoryId=" + categoryId + "&readonly=<%=!canEdit%>");
}
reloadMaskEdit(document.getElementById("wks.CategoryId").value);

$("#wks\\.CategoryId").change(function() {
  reloadMaskEdit(this.value);
});

// Workstation

$(document).ready(function() {
  $("#btn-save").click(doSave);  
  $("#btn-unlock").click(showReleaseConfirmDialog); 
  $("#btn-apisecurity").click(showApiSecurityDialog);  
  $("#btn-actkey-copy").click(copyActivationKey);  
  $("#menu-installer-download").click(doInstallerDownload);
  $("#menu-installer-email").click(doInstallerEmail);
  $("#btn-open-kiosk").click(openKioskPage);

  enableDisable();
  $("#wks\\.ActivationKey").change(enableDisable);

  recalcWorkstationURI();
  $("#wks\\.WorkstationURI").change(recalcWorkstationURI);

  function enableDisable() {
    var keyNotSet = $("#wks\\.ActivationKey").val() == "";
    var canInstallPOS = <%=rights.InstallPOS.getBoolean()%>
    $("#btn-install").setClass("disabled", keyNotSet || !canInstallPOS);
    $("#btn-mob-register").setClass("disabled", keyNotSet);
  }

  function recalcWorkstationURI() {
    var baseURL = "<v:config key="site_url"/>/<%=wks.WorkstationType.isLookup(LkSNWorkstationType.B2B) ? "b2b" : "cc"%>/";
    var wksURI = $("#wks\\.WorkstationURI").val();
    var lnk = $("#workstation-uri-link");
    lnk.setClass("v-hidden", wksURI == "");
    if (wksURI != "") {
      var wksURL = baseURL + wksURI;
      lnk.attr("href", wksURL);
      lnk.text(wksURL);
    }
  }

  function showReleaseConfirmDialog() {
    confirmDialog(null, function() {
      var reqDO = {
        Command: "Unlock",
        Unlock: {
          WorkstationId: "<%=wks.WorkstationId.getHtmlString()%>"
        }
      };

      showWaitGlass();
      vgsService("Workstation", reqDO, false, function() {
        hideWaitGlass();
        $("#lock-section").remove();
      });
    });
  }
  
  function showApiSecurityDialog() {
    asyncDialogEasy("workstation/workstation_apisecurity_dialog", "id=<%=pageBase.getId()%>");
  }

  function doSave() {
    var metaDataList = prepareMetaDataArray("#workstation-form");
    
    checkRequired("#workstation-form", function() {
      var reqDO = {
        Command: "SaveWorkstation",
          SaveWorkstation: {
            Workstation: {
            LocationAccountId  : <%=wks.LocationAccountId.getJsString()%>,
            WorkstationId      : <%=wks.WorkstationId.getJsString()%>,
            WorkstationType    : <%=wks.WorkstationType.getJsString()%>,
            ProfilePictureId   : $("#wks\\.ProfilePictureId").val(),
            WorkstationCode    : $("#wks\\.WorkstationCode").val(),
            WorkstationName    : $("#wks\\.WorkstationName").val(),
            WorkstationURI     : $("#wks\\.WorkstationURI").val(),
            OpAreaAccountId    : $("#wks\\.OpAreaAccountId").val(),
            CategoryId         : $("#wks\\.CategoryId").val(),
            SaleChannelId      : $("#wks\\.SaleChannelId").val(),
            ActivationKey      : $("#wks\\.ActivationKey").val(),
            ChannelGroupTagId  : $("[name='wks\\.ChannelGroupTagId']").val(),
            ApiSecurityType    : $("#wks\\.ApiSecurityType").val(),
            ApiDebugMode       : $("#wks\\.ApiDebugMode").isChecked(),
            MetaDataList       : metaDataList
            }
          }
      };
    
      showWaitGlass();
      vgsService("Workstation", reqDO, false, function(ansDO) {
        hideWaitGlass();
        entitySaveNotification(<%=LkSNEntityType.Workstation.getCode()%>, ansDO.Answer.SaveWorkstation.WorkstationId);
      });  
    });
  }
  
  function openKioskPage() {
  	window.open("<%=pageBase.getContextURL() + "?tab=main&page=kiosk&wks=" + wks.WorkstationCode.getString()%>")
	}
  
  function openMobTest() {
    var h = $("body").height() - 100;
    $("<div style='padding:0'><iframe style='overflow:hidden;height:100%;width:100%' height='100%' width='100%'></iframe></div>").dialog({
      modal: true,
      height: h,  
      width: h*0.4
    });
  }
  
  function checkActivationKeyChanged(callback) {
    if ($("#wks\\.ActivationKey").val() != <%=wks.ActivationKey.getJsString()%>)
      showIconMessage("warning", "Please, save first!"); // TODO: ITL
    else if (callback)
      callback();
  }
  
  function resetLicenseIfNeeded(callback) {
    if (<%=wks.LicenseRegistered.getBoolean()%>) { 
	    confirmDialog("Current license registration will be reset. Proceed?", function() { // TODO: ITL
	      var reqDO = {
	        Command: "ResetLicense",
	        ResetLicense: {
	          WorkstationId: <%=wks.WorkstationId.getJsString()%>
	        }
	      };  
	    
	      showWaitGlass();
	      vgsService("Workstation", reqDO, false, function() {
	        hideWaitGlass();
	        if (callback)
	          callback();
	      });
	    });
	  } 
    else if (callback)
	    callback();
  }
  
  function doInstallerDownload() {
    checkActivationKeyChanged(function() {
      resetLicenseIfNeeded(function() {
        window.location = <%=JvString.jsString(installerDownloadURL)%>;
      });  
    });
  }
  
  function doInstallerEmail() {
    checkActivationKeyChanged(function() {
      resetLicenseIfNeeded(function() {
        var $dlg = $("<div><input type='text' name='txt-address-to' class='form-control' placeholder='Email address'/></div>");
        $dlg.dialog({
          modal: true,
          title: itl("@System.InstallPOS"),
          width: 400,
          close: $dlg.remove(),
          buttons: [
            dialogButton("@Action.SendEmail", doSendEmail),
            dialogButton("@Common.Cancel", doCloseDialog)
          ] 
        });
        
        $dlg.keypress(function(event) {
          if (event.keyCode == KEY_ENTER)
            doSendEmail();
        });
                  
        function doSendEmail() {
          $dlg.dialog("close");

          var reqDO = {
            Command: "SendPosInstallerEmail",
            SendPosInstallerEmail: {
              WorkstationId: <%=wks.WorkstationId.getJsString()%>,
              AddressTo: $dlg.find("[name='txt-address-to']").val()
            }
          };
          
          showWaitGlass();
          vgsService("Workstation", reqDO, false, function() {
            hideWaitGlass();
          });
        }
      });  
    });
  }
  
  function copyActivationKey() {
    var ak = $("#wks\\.ActivationKey").val();
    navigator.clipboard.writeText(ak);
    showMessage("Activation Key copied to the clipboard!");
  }
});

</script>
  
</v:page-form>
