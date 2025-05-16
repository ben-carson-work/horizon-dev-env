<%@page import="com.vgs.cl.lookup.LookupItem"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_Account.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
LookupItem entityType = LkSN.EntityType.getItemByCode(pageBase.getParameter("EntityType"));
String handlerId = pageBase.getNullParameter("HandlerId");
String formTitle = pageBase.getNullParameter("FormTitle");
if (formTitle == null)
  formTitle = entityType.getDescription(pageBase.getLang());
%>


<v:dialog id="tag-pickup-dialog" width="360" height="450" title="<%=formTitle%>">

<div class="v-lkdialog-txt"><input type="text" placeholder="Full Search"></div>
<div class="v-lkdialog-itemlist">

<% JvDataSet ds = pageBase.getBL(BLBO_Tag.class).getTagDS(entityType); %>
<v:ds-loop dataset="<%=ds%>">
  <% String selected = ds.isBof() ? "selected" : ""; %>
  <div class="v-combo-item <%=selected%>" data-TagId="<%=ds.getField("TagId").getHtmlString()%>" onclick="pickupTagItem(this)">
    <% if (rights.GenericSetup.getBoolean()) { %>
      <div class="v-combo-item-btn" onclick=doEditTag(this)><i class="fa fa-pencil"></i></div>
    <% } %>
    <div class="v-combo-item-name"><%=ds.getField("TagName").getHtmlString()%></div>
    <div class="v-combo-item-code"><%=ds.getField("TagCode").getHtmlString()%></div>
    <div class="v-combo-item-icon foricon" style="background-image:url(<v:image-link name="printgroup.png" size="28"/>)"></div>
  </div>
</v:ds-loop>

</div>

<script>
var dlg = $("#tag-pickup-dialog");
dlg.on("snapp-dialog", function(event, params) {
  params.buttons = {
    <% if (rights.GenericSetup.getBoolean()) { %>
      <v:itl key="@Common.New" encode="JS"/>: doNewTag,
    <% } %>
    <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
  };
});

dlg.keydown(function() {
  if (event.keyCode == KEY_UP) {
    var sel = dlg.find(".v-combo-item.selected");
    var prev = sel.prev();
    while (prev.is(".v-hidden"))
      prev = prev.prev();
    if (prev.length > 0) {
      sel.removeClass("selected");
      prev.addClass("selected");
    }
    event.stopPropagation();
    event.preventDefault();
  }
  else if (event.keyCode == KEY_DOWN) {
    var sel = dlg.find(".v-combo-item.selected");
    var next = sel.next();
    while (next.is(".v-hidden"))
      next = next.next();
    if (next.length > 0) {
      sel.removeClass("selected");
      next.addClass("selected");
    }
    event.stopPropagation();
    event.preventDefault();
  }
  else if (event.keyCode == KEY_ENTER) {
    var sel = dlg.find(".v-combo-item.selected");
    if (sel.length > 0) {
      event.stopPropagation();
      event.preventDefault();
      pickupTagItem(sel);
    }
  }
});

dlg.find(".v-lkdialog-txt input").keyup(function() {
  var txt = $(this).val().trim().toLowerCase();
  var items = dlg.find(".v-combo-item");
  var selVisible = false;
  var firstVisible = null;
  for (var i=0; i<items.length; i++) {
    var item = $(items[i]);
    var name = item.find(".v-combo-item-name").text().toLowerCase();
    var code = item.find(".v-combo-item-code").text().toLowerCase();
    var visible = (txt == "") || (name.indexOf(txt) >= 0) || (code.indexOf(txt) >= 0);
    item.setClass("v-hidden", !visible);
    if (visible) {
      firstVisible = item;
      if (!selVisible && item.is(".selected"))
        selVisible = true;
    }
    else if (item.is(".selected"))
      item.removeClass("selected");
  }
  if ((firstVisible != null) && !selVisible) 
    firstVisible.addClass("selected");  
});

function pickupTagItem(item) {
  var tagId = $(item).attr("data-TagId");
  var tagCode = $(item).find(".v-combo-item-code").text();
  var tagName = $(item).find(".v-combo-item-name").text();
  
  comboBtnCallback(<%=JvString.jsString(handlerId)%>, tagId, tagCode, tagName);
  
  dlg.dialog("close");
}

function doEditTag(btn) {
  var item = $(btn).closest(".v-combo-item");
  var tagId = $(item).attr("data-TagId");
  
  asyncDialogEasy("common/tag_edit_dialog", "id=" + tagId + "&EntityType=<%=entityType.getCode()%>&HandlerId=<%=handlerId%>");
  
  dlg.dialog("close");
}

function doNewTag() {
  dlg.dialog("close");
  asyncDialogEasy("common/tag_edit_dialog", "EntityType=<%=entityType.getCode()%>&HandlerId=<%=handlerId%>");
}
</script>  

</v:dialog>