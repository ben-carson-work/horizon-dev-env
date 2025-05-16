<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% boolean canEdit = !pageBase.getParameter("ReadOnly").equals("true");%>

<div class="tab-content">
  <v:widget caption="@Common.General">
    <v:widget-block id="details-Main">
      <v:form-field caption="@Product.StartDelta" hint="@Product.StartDeltaHint">
        <v:input-text field="product.RenewalWindowStartDays" placeholder="@Common.Always" enabled="<%=canEdit%>" />
      </v:form-field>
      <v:form-field caption="@Product.EndDelta" hint="@Product.EndDeltaHint">
        <v:input-text field="product.RenewalWindowEndDays" placeholder="@Common.Always" enabled="<%=canEdit%>" />
      </v:form-field>
    </v:widget-block>
    <v:widget-block>
      <div><v:db-checkbox field="product.RenewableFromAny" value="true" caption="@Product.RenewableFromAny" hint="@Product.RenewableFromAnyHint"/></div>
      <div><v:db-checkbox field="product.RenewableToAny" value="true" caption="@Product.RenewableToAny" hint="@Product.RenewableToAnyHint"/></div>
    </v:widget-block>
  </v:widget>
</div>

<script>

$(document).ready(function() {
  var $dlg = $("#productrenewal_dialog");
  var $cbRenewableFromAny = $dlg.find("#product\\.RenewableFromAny");
  
  $cbRenewableFromAny.change(_refreshDetailsAndTabs);
  _refreshDetailsAndTabs(); 

  function _refreshDetailsAndTabs() {
    $("[data-tabcode='tabs-quickrenew']").closest("li").setClass("v-hidden", $cbRenewableFromAny.isChecked());
  }
});

</script>