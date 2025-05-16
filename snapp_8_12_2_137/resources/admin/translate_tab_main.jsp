<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTranslate" scope="request"/>
<% String langISO = (String)request.getAttribute("langISO"); %>
<% ArrayList<JvNode> langList = pageBase.getLangList(pageBase.getLang()); %>
<% HashMap<String, String> langMap = pageBase.getMap(langISO); %>

<style>

#translate-grid .group {
  background-color: #F2F2F2;
  font-weight: bold;
}

#translate-grid .item {
  font-weight: bold;
}

#translate-grid .fixed {
  background-color: #F7F7F7;
}

#translate-grid .edit {
  background-color: white;
}

input.translate-edit {
  width: 98%;
  border: none;
  margin: 0px;
  padding: 0px;
}

input.translate-edit:focus {
  border: none;
  outline-width: 0px;
}

</style>

<v:page-form>
<input type="hidden" name="langISO" value="<%=pageBase.getEmptyParameter("langISO")%>"/>

<div class="tab-toolbar">
  <v:button caption="@Common.Save" fa="save" href="postaction:translate.save"/>
  <span class="divider"></span>
  <v:button caption="@Common.Import" fa="sign-in" href="javascript:showImportDialog()"/>
  <% String hrefExport = ConfigTag.getValue("site_url") + "/admin?page=translate&langiso=" + pageBase.getEmptyParameter("langISO") + "&action=export"; %>
  <v:button caption="@Common.Export" fa="sign-out" clazz="no-ajax" href="<%=hrefExport%>"/>
</div>  

<div class="tab-content">
  <v:last-error/>

  <v:grid id="translate-grid">
    <thead>
      <tr>
        <td>Label</td>
        <td>Default</td>
        <td>Translation</td>
      </tr>
    </thead>
    <tbody>
    <% for (JvNode node : langList) { %>
      <tr>
        <% String title = pageBase.getIndentation(node) + JvString.escapeHtml(node.getNodeName()); %>
        <% if (node instanceof JvDocument) { %>
          <td class="group" colspan="100%"><%=title%></td>
        <% } else { %>
          <% FtITL itl = (FtITL)node; %>
          <td class="item fixed" width="20%"><%=title%></td>
          <td class="fixed" width="20%"><%=JvString.escapeHtml(itl.getDefaultText())%></td>
          <td class="edit" width="60%">
            <% String key = pageBase.getKeyCode(node); %>
            <% String value = JvString.getEmpty(langMap.get(key)); %>
            <input type="text" class="translate-edit" name="<%=key%>" value="<%=value.replace("\"", "&quot;")%>"/>
          </td>
        <% } %>
      </tr>
    <% } %>
    </tbody>
  </v:grid>

</div>  

<script>

$("input.translate-edit").keydown(function(e) {
  var delta = 0;
  if ((e.keyCode == KEY_DOWN) || (e.keyCode == KEY_ENTER)) 
    delta = 1;
  else if (e.keyCode == KEY_UP) 
    delta = -1;
  if (delta != 0) {
    var fields  = $("input.translate-edit");
    var newIdx = fields.index(this) + delta;
    if ((newIdx >= 0) && (newIdx < fields.length))
      fields.eq(newIdx).focus();
  }
});

function showImportDialog() {
  var dlg = $("#import-dialog");
  dlg.dialog({
      modal: true,
      height: 150,
      width: 400,
      resizable: false,
      buttons: {
        "<v:itl key="@Common.Ok"/>": function() {
          //$(this).dialog("close");
          $("#import-form").submit();
        },
        "<v:itl key="@Common.Cancel"/>": function() {
          $(this).dialog("close");
        }
      }
  });
}

</script>

</v:page-form>


<div id="import-dialog" class="v-hidden" title="<v:itl key="@Common.Import"/>">
  <form id="import-form" method="post" enctype="multipart/form-data" action="<v:config key="site_url"/>/admin?page=translate&action=import&langiso=<%=pageBase.getEmptyParameter("langISO")%>">
    <input type="file" name="InputFile"/>
  </form>
</div>
