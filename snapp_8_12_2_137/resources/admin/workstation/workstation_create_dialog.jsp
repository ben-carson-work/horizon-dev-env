<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>
<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request" />
<jsp:useBean id="license" class="com.vgs.snapp.dataobject.DOLicenseDef" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
LkSNWorkstationType.WorkstationTypeItem workstationType = (LkSNWorkstationType.WorkstationTypeItem)LkSN.WorkstationType.getItemByCode(pageBase.getParameter("WorkstationType"));
String categoryId = pageBase.getNullParameter("CategoryId");
String locationId = pageBase.getNullParameter("LocationId");
String opAreaId = pageBase.getNullParameter("OpAreaId");

boolean canCreate = rights.SystemSetupWorkstations.getOverallCRUD().canCreate();  
boolean canEditActivationKey = canCreate && rights.SystemSetupWorkstationActivationKey.getBoolean();
boolean canEditDemographic = canCreate && rights.SystemSetupWorkstationDemographic.getBoolean();
boolean canEditDevices = canCreate && rights.SystemSetupWorkstationDevices.getBoolean();
String disableActivationKey = canEditActivationKey ? "" : " disabled='disabled'";                        
String disableDemographic = canEditDemographic ? "" : " disabled='disabled'";                        
%>

<v:dialog id="workstation-create-dialog" title="@Common.Workstations" width="800" height="600">

<v:widget caption="@Common.Options">
  <v:widget-block>
    <v:form-field caption="@Account.Location" mandatory="true">
      <snp:dyncombo id="LocationId" entityType="<%=LkSNEntityType.Location%>" entityId="<%=locationId%>" enabled="<%=canEditDemographic%>"/>
    </v:form-field>
    <v:form-field caption="@Account.OpArea" mandatory="true">
      <snp:dyncombo id="OpAreaId" entityType="<%=LkSNEntityType.OperatingArea%>" entityId="<%=opAreaId%>" parentComboId="LocationId" enabled="<%=canEditDemographic%>"/>
    </v:form-field>
    <v:form-field caption="@Category.Category">
      <v:combobox field="wks.CategoryId" 
        lookupDataSet="<%=pageBase.getBL(BLBO_Category.class).getCategoryAshedTreeDS(LkSNEntityType.Workstation)%>" 
        idFieldName="CategoryId" 
        captionFieldName="AshedCategoryName" 
        value="<%=categoryId%>"  
        enabled="<%=canEditDemographic%>"/>
    </v:form-field>
  </v:widget-block>
  <v:widget-block>
    <v:form-field caption="@Workstation.PatternName">
      <input type="text" id="NamePattern" class="form-control" value="Workstation #" <%=disableDemographic%>/>
    </v:form-field>
    <v:form-field caption="@Workstation.PatternCode">
      <input type="text" id="CodePattern" class="form-control" value="WKS-#" <%=disableDemographic%>/>
    </v:form-field>
    <v:form-field caption="@Workstation.PatternStart">
      <input type="text" id="PatternStart" class="form-control" value="1" <%=disableDemographic%>/>
    </v:form-field>
  </v:widget-block>
  <v:widget-block>
    <% if (workstationType.acceptDevices) { %>
      <v:form-field caption="@Plugin.Devices">
        <v:multibox field="DriverIDs" lookupDataSet="<%=pageBase.getBL(BLBO_Driver.class).getDriverDS(LkSNDriverType.GROUP_Device)%>" idFieldName="DriverId" captionFieldName="DriverName"  enabled="<%=canEditDevices%>"/>
      </v:form-field>
    <% } %>
    <v:form-field caption="@Common.ActivationKeys" mandatory="true"> 
      <select <%=disableActivationKey%> id="ActivationKeys" multiple>
        <option/>
        <% String[] keys = pageBase.getBL(BLBO_License.class).getAvailActivationKeys(workstationType); %>
        <% for (DOLicense lic : license.LicenseList.getItems()) { %>
          <% if (JvArray.contains(lic.ActivationKey.getString(), keys)) { %>
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
            
            <option value="<%=lic.ActivationKey.getHtmlString()%>"><%=desc%></option>
          <% } %>
        <% } %>
      </select>
    </v:form-field>
  </v:widget-block>
</v:widget>


<script>

$(document).ready(function() {
  var dlg = $("#workstation-create-dialog").focus();

  dlg.bind("snapp-dialog", function(event, params) {
    params.buttons = [
      {
        "text": <v:itl key="@Common.Create" encode="JS"/>,
        "click": doCreate
      },
      {
        "text": <v:itl key="@Common.Close" encode="JS"/>,
        "click": doCloseDialog
      }
    ];
  });

  dlg.find("#ActivationKeys").selectize({
    dropdownParent: "body",
    plugins: ['remove_button','drag_drop']
  });
  
  
  function doCreate() {
  	checkRequired("#workstation-create-dialog", function() {
      var reqDO = {
        Command: "CreateWorkstation",
        CreateWorkstation: {
          WorkstationType: <%=workstationType.getCode()%>,
          LocationId: dlg.find("#LocationId").val(),
          OperatingAreaId: dlg.find("#OpAreaId").val(),
          CategoryId: dlg.find("#wks\\.CategoryId").val(),
          ActivationKeys: dlg.find("#ActivationKeys").val(),
          DriverIDs: dlg.find("#DriverIDs").val(),
          NamePattern: dlg.find("#NamePattern").val(),
          CodePattern: dlg.find("#CodePattern").val(),
          PatternStart: strToIntDef(dlg.find("#PatternStart").val(), 1)
        }
      };
      
      showWaitGlass();
      vgsService("Workstation", reqDO, false, function() {
        hideWaitGlass();
        dlg.dialog("close");
        triggerEntityChange(<%=LkSNEntityType.Workstation.getCode()%>);
      });
  	});
  }
});
</script>

</v:dialog>