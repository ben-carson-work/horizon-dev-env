<%@page import="com.vgs.cl.lookup.LookupItem"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<% 
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); 
String params = "LicenseId=" + pageBase.getEmptyParameter("LicenseId");
%>

<v:tab-toolbar>
  <v:button id="btn-search" caption="@Common.Search" fa="search"/>
  <v:button-group>
    <v:button id="btn-create" caption="@Common.Create" fa="plus" bindGrid="actkey-grid" bindGridEmpty="true"/>
    <v:button id="btn-remove" caption="@Common.Remove" fa="trash" bindGrid="actkey-grid"/>
  </v:button-group> 
  
  <v:pagebox gridId="actkey-grid"/>
</v:tab-toolbar>

<v:tab-content>
  <v:profile-recap>
    <v:widget caption="@Common.Search">
      <v:widget-block>
        <v:lk-checkbox field="WorkstationType" lookup="<%=LkSN.WorkstationType%>"/>
      </v:widget-block>
      <v:widget-block clazz="apps-widget apps-pos hidden">
        <% for (String app : SnpLicense.PosApps) { %>
          <div><v:db-checkbox field="Apps" value="<%=app%>" caption="<%=app%>"/></div>
        <% } %>
      </v:widget-block>
      <v:widget-block clazz="apps-widget apps-mob hidden">
        <% for (String app : SnpLicense.getMobApps()) { %>
          <div><v:db-checkbox field="Apps" value="<%=app%>" caption="<%=app%>"/></div>
        <% } %>
      </v:widget-block>
    </v:widget>
  </v:profile-recap>
  
  <v:profile-main>
    <v:async-grid id="actkey-grid" jsp="../../plugins/pkg-vgs-store/store_actkey_grid.jsp" params="<%=params%>"/>
  </v:profile-main>
</v:tab-content>

<script>
$(document).ready(function() {
  $("#btn-search").click(_search);
  $("#btn-create").click(_onCreateClick);
  $("#btn-remove").click(_onRemoveClick);
  $("[name='WorkstationType']").click(_refreshApps);
  
  function _onCreateClick() {
    asyncDialogEasy("../../plugins/pkg-vgs-store/store_actkey_create_dialog", <%=JvString.jsString(params)%>);
  }
  
  function _onRemoveClick() {
    confirmDialog(null, function() {
      snpAPI.cmd("PkgStoreAdmin", "DeleteActivationKey", {
        ActivationKeys: $("[name='ActivationKey']").getCheckedValues()
      })
      .then(ansDO => _search());
    });
  }
  
  function _search() {
    setGridUrlParam("#actkey-grid", "WorkstationType", $("[name='WorkstationType']").getCheckedValues());
    setGridUrlParam("#actkey-grid", "Apps", $(".apps-widget:not(.hidden) [name='Apps']").getCheckedValues());
    changeGridPage("#actkey-grid", 1);
  }
  
  function _isTypeChecked(workstationType) {
    return $("[name='WorkstationType']").getCheckedValues().indexOf(workstationType) >= 0;
  }
  
  function _refreshApps() {
    $(".apps-pos").setClass("hidden", !_isTypeChecked(<%=LkSNWorkstationType.POS.getCode()%>));
    $(".apps-mob").setClass("hidden", !_isTypeChecked(<%=LkSNWorkstationType.MOB.getCode()%>));
  }
})
</script>