<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageResourceType" scope="request"/>
<jsp:useBean id="restype" class="com.vgs.snapp.dataobject.DOResourceType" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<%
  boolean canEdit = rights.ResourceManagement.canUpdate();
  String[] maskIDs = rights.MasksResourceType.getArray();
  String maskEditURL = pageBase.getContextURL() + "?page=maskedit_widget&id=" + pageBase.getId()  + "&EntityType=" + LkSNEntityType.ResourceType.getCode() + "&MaskIDs=" + JvArray.arrayToString(maskIDs, ",") + "&LoadData=true&readonly=" + !canEdit;
%>


<v:page-form id="resourcetype-form" trackChanges="true">

<script>
  var metaFields = <%=pageBase.getBL(BLBO_MetaData.class).encodeItems(restype.MetaDataList)%>;
</script>


<div class="tab-toolbar">
  <v:button fa="save" caption="@Common.Save" href="javascript:doSaveResourceType()" enabled="<%=canEdit%>"/>
  <snp:notes-btn entityId="<%=pageBase.getId()%>" entityType="<%=LkSNEntityType.Catalog%>"/>
</div>

<div class="tab-content">
  <v:widget caption="@Common.Profile">
    <v:widget-block>
      <v:form-field caption="@Common.Code">
        <v:input-text field="restype.ResourceTypeCode"/>
      </v:form-field>
      <v:form-field caption="@Common.Name">
        <v:input-text field="restype.ResourceTypeName"/>
      </v:form-field>
      <v:form-field caption="@Common.PriorityOrder">
        <v:input-text field="restype.PriorityOrder"/>
      </v:form-field>
      <v:form-field caption="@Resource.SerialTrack">
        <v:lk-combobox field="restype.SerialTrack" lookup="<%=LkSN.ResourceSerialTrack%>" allowNull="false"/>
      </v:form-field>
      <v:form-field caption="@Resource.AdvancedSaleQuantity">
        <v:input-text field="restype.AdvancedSaleQuantity" placeholder="@Common.Unlimited"/>
      </v:form-field>
      <v:form-field caption="@Plugin.Plugin">
        <% JvDataSet dsAvailabilityPlugin = pageBase.getBL(BLBO_Plugin.class).getPluginDS(null, LkSNDriverType.ResourceManager); %>
        <v:combobox field="restype.AvailabilityPluginId" captionFieldName="PluginName" idFieldName="PluginId" lookupDataSet="<%=dsAvailabilityPlugin%>"/>
      </v:form-field>
    </v:widget-block>
    <v:widget-block>
      <v:db-checkbox field="restype.VisibleInRecap" caption="@Resource.VisibleInRecap" value="true"/><br/>
      <v:db-checkbox field="restype.PersonOnly" caption="@Resource.PersonOnly" value="true"/>
    </v:widget-block>
    <v:widget-block>
      <td><v:db-checkbox field="restype.Enabled" caption="@Common.Enabled" value="true"/></td>
    </v:widget-block>
  </v:widget>

  <v:grid id="resource-skill-grid">
    <thead>
      <v:grid-title caption="@Resource.Skills"/>
      <tr>
        <td><v:grid-checkbox header="true"/>
        <td width="100%"><v:itl key="@Common.Name"/></td>
        <td></td>
      </tr>
    </thead>
    <tbody id="resource-skill-tbody">
    <% int i = 0; %>
    <% for (DOResourceType.DOResourceSkill skill : restype.ResourceSkillList.getItems()) { %>
      <tr data-ResourceSkillId="<%=skill.ResourceSkillId.getHtmlString()%>" data-ResourceSkillName="<%=skill.ResourceSkillName.getHtmlString()%>">
        <td><v:grid-checkbox name="ResourceSkillId" value="<%=skill.ResourceSkillId.getHtmlString()%>"/></td>
        <td><a href="javascript:editSkill(<%=i%>)"><%=skill.ResourceSkillName.getHtmlString()%></a></td>
        <td><img src="<v:image-link name="move_item.png" size="16"/>" class="sorthandle row-hover-visible" /></td>
      </tr>
      <% i++; %>
    <% } %>
    </tbody>
    <tbody>
      <tr>
        <td colspan="100%">
          <v:button caption="@Common.New" fa="plus" href="javascript:newResourceSkill()"/>
          <v:button caption="@Common.Delete" fa="trash" href="javascript:removeSkills()"/>
        </td>
      </tr>
    </tbody>
  </v:grid>
  <div id="maskedit-container"></div>
</div>

<div id="resource-skill-dialog" class="v-hidden" title="<v:itl key="@Resource.Skill"/>">
  <input type="hidden" name="ResourceSkillId"/>
  <input type="hidden" name="trIndex"/>
  <v:widget icon="profile.png" caption="@Common.Profile">
    <v:widget-block>
      <table class="form-table">
        <tr>
          <th><v:itl key="@Common.Name"/></th>
          <td><input type="text" name="ResourceSkillName" class="form-control"/></td>
        </tr>
      </table>
    </v:widget-block>
  </v:widget>
</div>

<style>
.sorthandle {
  cursor: move;
}
</style>

<script>

$(document).ready(function() {
	  asyncLoad("#maskedit-container", <%=JvString.jsString(maskEditURL)%>);
});

$("#resource-skill-dialog").keypress(function() {
  if (event.keyCode == KEY_ENTER)
    doResourceSkillDialogOK();
});

$("#resource-skill-tbody").sortable({
  handle: ".sorthandle"
});

function updateResourceSkill(trIndex, id, name) {
	var tr = (trIndex == "") ? $("<tr class='grid-row'/>").appendTo("#resource-skill-tbody") : $($("#resource-skill-tbody tr")[trIndex]);
  tr.empty();
  tr.attr("data-ResourceSkillId", id);
  tr.attr("data-ResourceSkillName", name);

  var tdCheckbox = $("<td/>").appendTo(tr);
  var tdName = $("<td class='ResourceSkillName'/>").appendTo(tr);
  var tdMove = $("<td/>").appendTo(tr);
  tdCheckbox.html("<input type='checkbox' name='ResourceSkillId' class='cblist'/>");
  tdName.html("<a href='javascript:editSkill(" + tr.index() + ")'></a>");
  tdName.find("a").text(name);
  tdMove.html("<img src='<v:image-link name="move_item.png" size="16"/>' class='sorthandle row-hover-visible' />");
}

function doResourceSkillDialogOK() {
  var dlg = $("#resource-skill-dialog");
  updateResourceSkill(dlg.find("[name='trIndex']").val(), dlg.find("[name='ResourceSkillId']").val(), dlg.find("[name='ResourceSkillName']").val());
  dlg.dialog("close");    
}

function showSkillDialog(trIndex, id, name) {
  var dlg = $("#resource-skill-dialog");
  dlg.find("[name='trIndex']").val(trIndex);
  dlg.find("[name='ResourceSkillId']").val(id);
  dlg.find("[name='ResourceSkillName']").val(name);

  dlg.dialog({
    modal: true,
    width: 400,
    height: 250,
    buttons: [
      {
        text: itl("@Common.Ok"),
        click: doResourceSkillDialogOK
      },
      {
        text: itl("@Common.Cancel"),
        click: doCloseDialog
      }
    ] 
  });
}

function newResourceSkill() {
  showSkillDialog("", "", "");  
}

function editSkill(trIndex) {
  var tr = $($("#resource-skill-tbody tr")[trIndex]);
  showSkillDialog(trIndex, tr.attr("data-ResourceSkillId"), tr.attr("data-ResourceSkillName"));  
}

function removeSkills() {
  var cbs = $("input[type='checkbox'][name='ResourceSkillId']:checked");
  for (var i=0; i<cbs.length; i++)
    $(cbs[i]).closest("tr").remove();
}

function doSaveResourceType() {
    var metaDataList = prepareMetaDataArray("#resourcetype-form");
    if (!(metaDataList)) 
      showIconMessage("warning", itl("@Common.CheckRequiredFields"));
    else {
      reqDO = {
        Command: "SaveResourceType",
        SaveResourceType: {
          ResourceType: {
            ResourceTypeId: "<%=restype.ResourceTypeId.getHtmlString()%>",
            ResourceTypeCode: $("#restype\\.ResourceTypeCode").val(),
            ResourceTypeName: $("#restype\\.ResourceTypeName").val(),
            PriorityOrder: $("#restype\\.PriorityOrder").val(),
            SerialTrack: $("#restype\\.SerialTrack").val(),
            AdvancedSaleQuantity: strToIntDef($("#restype\\.AdvancedSaleQuantity").val(), null),
            AvailabilityPluginId: $("#restype\\.AvailabilityPluginId").val(),
            Enabled: $("#restype\\.Enabled").isChecked(),
            VisibleInRecap: $("#restype\\.VisibleInRecap").isChecked(),
            PersonOnly: $("#restype\\.PersonOnly").isChecked(),
            ResourceSkillList: [],
            MetaDataList: metaDataList
          }
        }
      };
      
      var trs = $("#resource-skill-tbody tr");
      for (var i=0; i<trs.length; i++) {
        reqDO.SaveResourceType.ResourceType.ResourceSkillList.push({
          ResourceSkillId: $(trs[i]).attr("data-ResourceSkillId"),
          ResourceSkillName: $(trs[i]).attr("data-ResourceSkillName")
        });
      }
    		  
 		  showWaitGlass();
      vgsService("Resource", reqDO, false, function(ansDO) {
 		      hideWaitGlass();
 		      entitySaveNotification(<%=LkSNEntityType.ResourceType.getCode()%>, ansDO.Answer.SaveResourceType.ResourceTypeId);
 		  });
    }
}

</script>
</v:page-form>