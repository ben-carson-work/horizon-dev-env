<%@page import="com.vgs.cl.JvString"%>
<%@page import="com.vgs.cl.JvArray"%>
<%@page import="com.vgs.vcl.fontawesome.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<%
String[] bannedNames = {
    JvFA.HAND_MIDDLE_FINGER,
    JvFA.POO,
    JvFA.POO_STORM,
    JvFA.POOP
};
%>

<v:dialog id="iconalias_dialog" title="@Common.Icon" width="1200" height="800">

<style>
.icon-item {
  display: inline-block;
  width: 130px;
  text-align: center;
  border-radius: 6px;
  overflow: hidden;
  cursor: pointer;
  margin: 5px;
}

.icon-item-icon {
  font-size: 48px;
  padding: 10px;
}

.icon-item-name {
  padding: 5px;
  font-size: 12px;
  color: rgba(0,0,0,0.5);
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.icon-item-label,
.icon-item-terms {
  display: none;
}

.icon-item.search-hide {
  display: none;
}

.icon-item:hover {
  box-shadow: 0 4px 0 rgba(0,0,0,0.05);
}

.icon-item:hover .icon-item-icon {
  background-color: var(--highlight-color);
  color: var(--content-bg-color);
}

.icon-item:hover .icon-item-name {
  background-color: var(--content-bg-color);
  color: black;
}

.icon-item.no-icon {
  color: rgba(0,0,0,0.1);
}
</style>

<v:input-text field="txt-search" placeholder="@Common.Search"/>
  <div class="icon-item noselect no-icon">
    <div class="icon-item-icon"><i class="fa fa-user-slash"></i></div>
    <div class="icon-item-name">empty</div>
  </div>

<% for (String jvname : JvFABase.getNames()) { %>
  <% if (!JvArray.contains(jvname, bannedNames)) { %>
    <% 
    JvFABase.FABean bean = JvFABase.findFABean(jvname);
    String faClass = "fa fa-" + JvString.escapeHtml(bean.name);
    if (bean.isBrands())
      faClass += " fab";
    %>
    <div class="icon-item noselect">
      <div class="icon-item-icon"><i class="<%=faClass%>"></i></div>
      <div class="icon-item-name"><%=JvString.escapeHtml(bean.name)%></div>
      <div class="icon-item-label"><%=JvString.escapeHtml(bean.label)%></div>
      <div class="icon-item-terms"><%=JvString.escapeHtml(JvArray.arrayToString(bean.searchTerms, " "))%></div>
    </div>
  <% } %>
<% } %>


<script>
$(document).ready(function() {
  var $dlg = $("#iconalias_dialog");
  $dlg.find("#txt-search").keyup(iconSearch);
  $dlg.find(".icon-item").click(doClick);
  
  function iconSearch() {
    var keys = $(this).val().toLowerCase().split(" ");
    var $items = $dlg.find(".icon-item");
    $items.removeClass("search-hide");
    
    var doSearch = false;
    if (keys) {
      for (var i=0; i<keys.length; i++) {
        var key = keys[i];
        if ((key) && (key.trim() != "")) {
          doSearch = true;
          break;
        }
      }
    }
    
    if (doSearch) {
      function _txtSearchMatch(text) {
        if (text) {
          for (var i=0; i<keys.length; i++) {
            var key = keys[i].trim();
            if ((key != "") && (text.toLowerCase().indexOf(key) < 0))
              return false;
          }
          return true;
        }
        return false;
      }
      
      $items.addClass("search-hide").each(function(idx, item) {
        var $item = $(item);
        var terms = $item.find(".icon-item-name").text() + " " + $item.find(".icon-item-label").text() + " " + $item.find(".icon-item-terms").text();
        if (_txtSearchMatch(terms))
          $item.removeClass("search-hide");
      });
    }
  }
  
  function doClick() {
    var $this = $(this);
    var handlerId = <%=JvString.jsString(pageBase.getParameter("HandlerId"))%>;
    
    var $icon = $(".v-icon-alias[data-handlerid='" + handlerId + "']");
    if ($icon.length == 0)
      console.err("Unable to find .v-icon-alias[data-handlerid='" + handlerId + "']");
    
    var remove = $this.hasClass("no-icon"); 
    var name = (remove) ? "" : $this.find(".icon-item-name").text();
    
    var clazz = "fa";
    if ($this.find(".fa").is(".fab"))
      clazz += " fab";
    clazz += " fa-" + ((name == "") ? "user-slash" : name);
    
    $icon.setClass("no-icon", remove).attr("data-alias", name).find(".fa").attr("class", clazz);
    $dlg.dialog("close");
  }
});

</script>

</v:dialog>