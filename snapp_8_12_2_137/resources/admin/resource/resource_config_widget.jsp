<%@page import="com.vgs.web.page.PageBO_Base"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<% PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); %>
<% LookupItem entityType = LkSN.EntityType.getItemByCode(request.getParameter("RC-EntityType")); %>
<% String entityId = request.getParameter("RC-EntityId"); %>

<%
JvDataSet ds = pageBase.getDB().executeQuery(
    "select" + JvString.CRLF +
    "  RC.ResourceTypeId," + JvString.CRLF +
    "  RT.ResourceTypeName," + JvString.CRLF +
    "  RC.Quantity," + JvString.CRLF +
    "  RC.Mandatory," + JvString.CRLF +
    "  RC.Main," + JvString.CRLF +
    "  RC.AutoSelect," + JvString.CRLF +
    "  RC.GroupByPerformance," + JvString.CRLF +
    "  SubString((" + JvString.CRLF +
    "    select (',' + Cast(RSL.ResourceSkillId as varchar(max)))" + JvString.CRLF +
    "    from" + JvString.CRLF +
    "      tbResourceSkill RS inner join" + JvString.CRLF +
    "      tbResourceSkillLink RSL on RSL.ResourceSkillId=RS.ResourceSkillId" + JvString.CRLF +
    "    where" + JvString.CRLF +
    "      RSL.EntityId=RC.EntityId and" + JvString.CRLF +
    "      RS.ResourceTypeId=RC.ResourceTypeId" + JvString.CRLF +
    "    for XML PATH('')), 2, 10000) as ResourceSkillIDs" + JvString.CRLF +
    "from" + JvString.CRLF +
    "  tbResourceConfig RC inner join" + JvString.CRLF +
    "  tbResourceType RT on RT.ResourceTypeId=RC.ResourceTypeId" + JvString.CRLF +
    "where RC.EntityId=" + JvString.sqlStr(pageBase.getId()) + JvString.CRLF +
    "order by" + JvString.CRLF +
    "  RT.PriorityOrder," + JvString.CRLF +
    "  RT.ResourceTypeName");
request.setAttribute("ds", ds);


QueryDef qdef = new QueryDef(QryBO_ResourceType.class);
// Select
qdef.addSelect(QryBO_ResourceType.Sel.ResourceTypeId);
qdef.addSelect(QryBO_ResourceType.Sel.ResourceTypeName);
// Sort
qdef.addSort(QryBO_ResourceType.Sel.PriorityOrder);
qdef.addSort(QryBO_ResourceType.Sel.ResourceTypeName);
// Exec
JvDataSet dsResourceType = pageBase.execQuery(qdef);

JvDataSet dsResourceSkill = pageBase.getDB().executeQuery("select * from tbResourceSkill order by PriorityOrder");
%>


<div class="tab-toolbar">
  <v:button caption="@Common.Add" fa="plus" href="javascript:addResourceType()"/>
  <v:button caption="@Common.Remove" fa="minus" href="javascript:removeResourceTypes()"/>
</div>

<div class="tab-content">

  <v:grid id="resource-type-grid">
    <thead>
      <tr>
        <td><v:grid-checkbox header="true"/></td>
        <td width="25%">
          <v:itl key="@Resource.ResourceType"/><br/>
          <v:itl key="@Common.Quantity"/>
        </td>
        <td width="25%">
          <v:itl key="@Common.Options"/>
        </td>
        <td width="50%">
          <v:itl key="@Resource.Skills"/>
        </td>
      </tr>
    </thead>
    <tbody>
    </tbody>
  </v:grid>

</div>


<div id="resource-type-dialog" class="v-hidden" title="<v:itl key="@Resource.ResourceType"/>">
  <v:widget caption="@Common.Settings">
    <v:widget-block>
      <v:form-field caption="@Resource.ResourceType">
        <v:combobox field="RC-ResourceTypeId" lookupDataSet="<%=dsResourceType%>" idFieldName="<%=QryBO_ResourceType.Sel.ResourceTypeId.name()%>" captionFieldName="<%=QryBO_ResourceType.Sel.ResourceTypeName.name()%>" />
      </v:form-field>
      <v:form-field caption="@Common.Quantity">
        <v:input-text field="RC-Quantity" />
      </v:form-field>
    </v:widget-block>
    <v:widget-block>
      <v:db-checkbox field="RC-Mandatory" caption="@Common.Mandatory" value="true" /><br/>
      <v:db-checkbox field="RC-Main" caption="@Common.Main" value="true" /><br/>
      <v:db-checkbox field="RC-AutoSelect" caption="@Resource.AutoSelect" value="true" />
      <v:db-checkbox field="RC-GroupByPerformance" caption="@Resource.GroupByPerformance" value="true" />
    </v:widget-block>
  </v:widget>
  <v:widget caption="@Resource.Skills">
    <v:widget-block>
      <v:input-text type="hidden" field="RC-ResourceSkillIDs"/>
      <div id="RC-skills"></div>
    </v:widget-block>
  </v:widget>
</div>


<script>

var dsSkill = <%=dsResourceSkill.getDocJSON()%>;
var dlgResourceType = $("#resource-type-dialog");

$(document).ready(function() {
  <% while (!ds.isEof()) { %>
    setResourceType($("<tr class='grid-row'/>").appendTo("#resource-type-grid tbody"), {
      ResourceTypeId: "<%=ds.getField("ResourceTypeId").getHtmlString()%>", 
      ResourceTypeName: "<%=ds.getField("ResourceTypeName").getHtmlString()%>", 
      Quantity: <%=ds.getField("Quantity").getInt()%>, 
      Mandatory: <%=ds.getField("Mandatory").getBoolean()%>, 
      Main: <%=ds.getField("Main").getBoolean()%>,
      AutoSelect: <%=ds.getField("AutoSelect").getBoolean()%>,
      GroupByPerformance: <%=ds.getField("GroupByPerformance").getBoolean()%>,
      ResourceSkillIDs: "<%=ds.getField("ResourceSkillIDs").getHtmlString()%>"
    });
    <% ds.next(); %>
  <% } %>
});

function addResourceType() {
  dlgResourceType.dialog({
    modal: true,
    width: 400,
    height: 500,
    buttons: {
      <v:itl key="@Common.Save" encode="JS"/>: doAdd,
      <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
    }
  });
}

function removeResourceTypes() {
  var reqDO = getUpdateReqDO();

  var tbd = [];
  var trs = $("#resource-type-grid tbody tr");
  for (var i=0; i<trs.length; i++) {
    if ($(trs[i]).find(".cblist").isChecked())
      tbd.push(trs[i]);
    else
      reqDO.UpdateResourceConfig.ResourceTypeList.push(getResourceType(trs[i]));
  }
  
  vgsService("Resource", reqDO, false, function() {
    for (var i=0; i<tbd.length; i++)
      $(tbd[i]).remove();
  });
}

function editResourceType(ref) {
  var tr = $(ref).closest("tr");
  var obj = getResourceType(tr);

  $("#RC-ResourceTypeId").val(obj.ResourceTypeId);
  $("#RC-Quantity").val(obj.Quantity);
  $("#RC-Mandatory").setChecked(obj.Mandatory);
  $("#RC-Main").setChecked(obj.Main);
  $("#RC-AutoSelect").setChecked(obj.AutoSelect);
  $("#RC-ResourceSkillIDs").val(obj.ResourceSkillIDs);
  refreshDialogSkills();

  dlgResourceType.dialog({
    modal: true,
    width: 400,
    height: 500,
    buttons: {
      <v:itl key="@Common.Save" encode="JS"/>: function() {
        doEdit(tr);
      },
      <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
    }
  });
}

function refreshDialogSkills() {
  $("#RC-skills").empty();
  for (var i=0; i<dsSkill.length; i++) {
    if (dsSkill[i].ResourceTypeId == $("#RC-ResourceTypeId").val()) {
      var div = $("<div/>").appendTo("#RC-skills");
      var checked = ($("#RC-ResourceSkillIDs").val().indexOf(dsSkill[i].ResourceSkillId) < 0) ? "" : "checked=checked";
      div.append("<label class='checkbox-label'><input type='checkbox' name='ResourceSkillId' " + checked + " value='" + dsSkill[i].ResourceSkillId + "'/> " + dsSkill[i].ResourceSkillName + "</label>");
    }
  }
}

$("#RC-ResourceTypeId").change(refreshDialogSkills);

function getUpdateReqDO() {
  return {
    Command: "UpdateResourceConfig",
    UpdateResourceConfig: {
      EntityId: "<%=entityId%>",
      EntityType: <%=entityType.getCode()%>,
      ResourceTypeList: []
    }
  };
}

function getDialogDO() {
  return {
    ResourceTypeId: $("#RC-ResourceTypeId").val(),
    ResourceTypeName: $("#RC-ResourceTypeId option:selected").html(),
    Quantity: parseInt($("#RC-Quantity").val()),
    Mandatory: $("#RC-Mandatory").isChecked(),
    Main: $("#RC-Main").isChecked(),
    AutoSelect: $("#RC-AutoSelect").isChecked(),
    GroupByPerformance: $("#RC-GroupByPerformance").isChecked(),
    ResourceSkillIDs: $("#RC-skills [name='ResourceSkillId']").getCheckedValues() 
  };
}

function getResourceType(trSelector) {
  return $(trSelector).data();
}

function setResourceType(trSelector, obj) {
  if (obj.Main) {
    $("#resource-type-grid tr").attr("data-Main", false);
    $("#resource-type-grid .td-main").html("<v:itl key="@Common.No"/>");
  }
  
  var tr = $(trSelector);
  tr.empty();
  tr.data(obj);
  
  var tdCheckbox = $("<td/>").appendTo(tr);
  var tdResourceType = $("<td/>").appendTo(tr);
  var tdMandatory = $("<td/>").appendTo(tr);
  var tdSkills = $("<td/>").appendTo(tr);
  
  var options = [];
  if (obj.Mandatory)
    options.push(itl("@Common.Mandatory"));
  if (obj.Main)
    options.push(itl("@Common.Main"));
  if (obj.AutoSelect)
    options.push(itl("@Resource.AutoSelect"));
  if (obj.GroupByPerformance)
    options.push(itl("@Resource.GroupByPerformance"));
  
  tdResourceType.html("<a href='#' class='list-title' onclick='editResourceType(this)'>" + obj.ResourceTypeName + "</a><br/>" + (isNaN(obj.Quantity) ? 1 : obj.Quantity));
  tdMandatory.html("<span class='list-subtitle'>" + options.join(", ") + "</span>");
  tdSkills.html("<span class='list-subtitle'>" + getResourceSkillNames(obj.ResourceSkillIDs) + "</span>");
  
  $("<input type='checkbox' class='cblist'/>").appendTo(tdCheckbox);
}

function getResourceSkillNames(resourceSkillIDs) {
  var result = [];
  for (var i=0; i<dsSkill.length; i++) {
    if (resourceSkillIDs.indexOf(dsSkill[i].ResourceSkillId) >= 0)
      result.push(dsSkill[i].ResourceSkillName);
  }
  return result.join(", ");
}

function doAdd() {
  var reqDO = getUpdateReqDO();
  var thisDO = getDialogDO();
  
  var trs = $("#resource-type-grid tbody tr");
  for (var i=0; i<trs.length; i++) {
    var itemDO = getResourceType(trs[i]);
    itemDO.Main = (thisDO.Main) ? false : itemDO.Main;
    reqDO.UpdateResourceConfig.ResourceTypeList.push(itemDO);
  }
  reqDO.UpdateResourceConfig.ResourceTypeList.push(thisDO);
  
  vgsService("Resource", reqDO, false, function(ansDO) {
    setResourceType($("<tr class='grid-row'/>").appendTo("#resource-type-grid tbody"), thisDO);
    dlgResourceType.dialog("close");
  });
}

function doEdit(tr) {
  var reqDO = getUpdateReqDO();
  var thisDO = getDialogDO();

  var trs = $("#resource-type-grid tbody tr");
  for (var i=0; i<trs.length; i++) {
    var itemDO; 
    if (trs[i] == tr[0]) 
      itemDO = thisDO;
    else {
      itemDO = getResourceType(trs[i]);
      itemDO.Main = (thisDO.Main) ? false : itemDO.Main;
    }

    reqDO.UpdateResourceConfig.ResourceTypeList.push(itemDO);
  } 
  
  vgsService("Resource", reqDO, false, function(ansDO) {
    setResourceType(tr, thisDO);
    dlgResourceType.dialog("close");
  });
}

</script>