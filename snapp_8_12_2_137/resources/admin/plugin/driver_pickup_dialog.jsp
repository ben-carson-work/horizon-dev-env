<%@page import="java.util.Map.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% Map<LookupItem, List<DODriverRef>> map = pageBase.getBL(BLBO_Driver.class).getDriversGroupedByType(JvArray.stringToIntArray(pageBase.getParameter("DriverGroup"), ",")); %>

<v:dialog id="driver_pickup_dialog" title="@Common.Driver" width="800" height="600">

  <v:tab-group name="driver-pickup" clazz="absolute-all" sideNav="true" showSearch="true">
    <% boolean first = true; %>
    <% for (Entry<LookupItem, List<DODriverRef>> entry : map.entrySet()) { %>
      <% LookupItem driverType = entry.getKey(); %>
      <v:tab-item-embedded tab="<%=\"driver-type-\"+driverType.getCode()%>" caption="<%=driverType.getRawDescription()%>" icon="<%=driverType.getIconName()%>" default="<%=first%>">
        <% first = false; %>
        <v:tab-content>
          <v:grid>
            <% for (DODriverRef driver : entry.getValue()) { %>
              <tr class="grid-row" data-driverid="<%=driver.DriverId.getHtmlString()%>">
                <td><v:grid-icon name="<%=driver.IconName%>"/></td>
                <td width="100%">
                  <div class="list-title"><%=JvString.escapeHtml(JvMultiLang.translate(pageBase.getLang(), driver.DriverName.getString()))%></div>
                  <div class="list-subtitle"><%=driver.ExtensionPackageName.getHtmlString()%>&nbsp;</div>
                </td>
              </tr>
            <% } %>
          </v:grid>
        </v:tab-content>
      </v:tab-item-embedded>
    <% } %>
  </v:tab-group>

<script>
$(document).ready(function() {
  var $dlg = $("#driver_pickup_dialog");
  var $txtSearch = $dlg.find(".txt-search");
  
  $txtSearch.keyup(_search);
  
  $dlg.find("tr[data-driverid]").click(function() {
    if (functionExists("driverPickupCallback"))
      driverPickupCallback($(this).attr("data-driverid"));
    $(this).closest(".ui-dialog-content").dialog("close");
  });
  
  function _search() {
    $dlg.find(".search-hide").removeClass("search-hide");

    var keys = getSearchKeys($txtSearch.val());
    if (keys.length > 0) {
      $dlg.find(".v-tabs-item").addClass("search-hide").each(function(idx, item) {
        var $item = $(item);
        if (isTextFullSearch($item.find(".v-tabs-caption").text(), keys))
          $item.removeClass("search-hide");
        else {
          var $panel = $dlg.find($item.find(".v-tabs-anchor").attr("href")).addClass("search-hide");
          $panel.find("tr").addClass("search-hide").each(function(idx, tr) {
            var $tr = $(tr);
            if (isTextFullSearch($tr.text(), keys)) {
              $tr.removeClass("search-hide");
              $panel.removeClass("search-hide");
              $item.removeClass("search-hide");
            }
          });
        }
      });
    }
  }
});
</script>

</v:dialog>