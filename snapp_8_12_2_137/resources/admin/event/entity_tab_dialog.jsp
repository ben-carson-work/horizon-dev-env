<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="java.util.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
JvDataSet ds = pageBase.getBL(BLBO_EntityTab.class).getEntityTabDS(pageBase.getId());
%>

<div class="v-hidden">
  <select id="lang-combo-template" class="form-control">
    <option value="">(All)</option>
    <% for (String langISO : SnappUtils.getLangISOs()) { %>
    <%   String icon = SnappUtils.getFlagName(langISO); %>
    <%   Locale locale = new Locale(langISO); %>
    <%   String langName = JvString.getPascalCase(locale.getDisplayLanguage(pageBase.getLocale())); %>
    <%   if (icon != null) { %>
           <option value="<%=langISO%>"><%=JvString.escapeHtml(langName)%></option>
    <%   } %>
    <% } %>
  </select>
</div>

<v:dialog id="entity-tab-dialog" width="800" height="400" title="@Common.EntityTab">
  <v:grid id="entity-tab-grid">
    <thead>
      <tr>
        <td><v:grid-checkbox header="true"/></td>
        <td width="20%"><v:itl key="@Common.Language"/></td>
        <td width="25%"><v:itl key="@Common.Name"/></td>
        <td width="55%"><v:itl key="@Common.Type"/></td>
        <td></td>
      </tr>
    </thead>
    <tbody id="entity-tab-body">
    </tbody>
    <tbody>
      <tr>
        <td colspan="100%">
          <v:button caption="@Common.Add" fa="plus" href="javascript:addEntity()"/>
          <v:button caption="@Common.Remove" fa="minus" href="javascript:removeEntityTabs()"/>
        </td>
      </tr>
    </tbody>
  </v:grid>

<div id="entity-tab-type" class="v-hidden"><v:lk-combobox field="EntityTabType" lookup="<%=LkSN.EntityTabType%>" allowNull="false"/><div class="ext-url"><input type="text"/></div></div>

<script>

$("table#entity-tab-grid tbody").sortable({
  handle: "a#btn-move",
  helper: fixHelper
});  

$("a#btn-move").click(function(e) {
  e.stopPropagation();
});


<v:ds-loop dataset="<%=ds%>">
addEntity(
    <%=JvString.jsString(ds.getField("EntityTabId").getString())%>,
    <%=JvString.jsString(ds.getField("LangISO").getString())%>,
    <%=JvString.jsString(ds.getField("EntityTabName").getString())%>,
    <%=ds.getField("EntityTabType").getInt()%>,
    <%=JvString.jsString(ds.getField("ExternalURL").getString())%>,
    <%=ds.getField("PriorityOrder").getInt()%>
);
</v:ds-loop>

var dlg = $("#entity-tab-dialog");
dlg.on("snapp-dialog", function(event, params) {
  params.buttons = {
    <v:itl key="@Common.Save" encode="JS"/>: doSaveEntityTabs,
    <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
  };
});

function refreshExtURL(tdExtUrl, hidden) {
  tdExtUrl.setClass("v-hidden", hidden);
}

function addEntity(id, langISO, name, type, extURL, priority) {
  if (type)
    entityType = type;
  else
    entityType = 1;
  
  if (id)
    entityTabId = id;
  else
    entityTabId = "";

  var tr = $("<tr class='grid-row' data-EntityTabId='" + entityTabId + "'/>").appendTo("#entity-tab-body");
  var tdCB = $("<td valign='top'/>").appendTo(tr);  
  var tdCombo = $("<td valign='top'/>").appendTo(tr);
  var combo = $("#lang-combo-template").clone().appendTo(tdCombo);
  var tdName = $("<td valign='top'/>").appendTo(tr);
  var tdType = $("<td valign='top'/>").appendTo(tr); 
  var tdMove = $("<td align='right'><span class='row-hover-visible'><a id='btn-move' style='cursor:move' title='<v:itl key="@Common.Move"/>' href='#'><img src='<v:image-link name="move_item.png" size="16"/>'</a></span></td>").appendTo(tr);
  
  tdCB.append("<input value='" + entityTabId + "' type='checkbox' class='form-control cblist'>");  
  
  tdCombo.find("select").val(langISO);
  
  tdName.append("<input type='text' class='form-control' name='entity-name'>"); 
  tdName.find("input").attr("placeholder", "<v:itl key="@Common.Name" encode="utf-8"/>");
  tdName.find("input").val(name);
  
  tdType.html($("#entity-tab-type").html());
  tdType.find("select").val(entityType);
  tdType.find("select").change(function() {
    refreshExtURL(tr.find(".ext-url"), tdType.find("select").val()!=<%=LkSNEntityTabType.ExtURL.getCode()%>);
  });

  tr.find(".ext-url").find("input").val(extURL);  
  tr.find(".ext-url").find("input").attr("placeholder", <v:itl key="@Common.TypeURL" encode="JS"/>);
  tr.find(".ext-url").find("input").setClass("form-control", true);
  refreshExtURL(tr.find(".ext-url"), entityType!=<%=LkSNEntityTabType.ExtURL.getCode()%>);
}

function doSaveEntityTabs() {
  var reqDO = {
    Command: "SaveEntityTabs",
    SaveEntityTabs: {
      EntityTab: {
        EntityId: <%="'" + pageBase.getId() + "'"%>,
        EntityType: <%=pageBase.getNullParameter("EntityType")%>,
        EntityTabList: getEntityTabList()
      }
    }
  };
  
  vgsService("EntityTab", reqDO, false, function(ansDO) {
    showMessage(<v:itl key="@Common.SaveSuccessMsg" encode="JS"/>, function() {
      $("#entity-tab-dialog").dialog("close");
    });

  });
}

function getEntityTabList() {
  var list = [];
  var trs = $("#entity-tab-body tr");
  for (var i=0; i<trs.length; i++) {
    var tr = $(trs[i]);
    
    if (tr.find("[name='entity-name']").val() != "") {
      list.push({
        LangISO: tr.find("#lang-combo-template").val(),
        EntityTabId: tr.find("input").val(),
        EntityTabName: tr.find("[name='entity-name']").val(),
        EntityTabType: tr.find("[name='EntityTabType']").val(),
        ExternalURL: tr.find(".ext-url").find("input").val(),
        PriorityOrder: i + 1
      });
    }
  }
  return list;
}

function removeEntityTabs() {
  $("#entity-tab-dialog .cblist:checked").not(".header").closest("tr").remove();
}
</script>  

</v:dialog>