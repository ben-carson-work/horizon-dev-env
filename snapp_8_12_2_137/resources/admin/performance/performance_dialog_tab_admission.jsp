<%@page import="com.vgs.snapp.library.FtCRUD"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="perf" class="com.vgs.snapp.dataobject.DOPerformance" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<%
boolean canEdit = pageBase.getBL(BLBO_Performance.class).checkRightsNoExceptions(perf.EventId.getString(), perf.PerformanceId.getString());
boolean autoCreated = perf.AutoCreated.getBoolean();

request.setAttribute("dsLocationAll", pageBase.getBL(BLBO_Account.class).getLocationDS());
request.setAttribute("dsAcAreaAll", pageBase.getBL(BLBO_Account.class).getAccessAreaDS(perf.LocationId.getString()));
%>

<div class="tab-content">
  <v:widget caption="@Performance.Admission">
    <v:widget-block>
      <v:form-field caption="@Account.Location">
        <v:combobox field="perf.LocationId" lookupDataSetName="dsLocationAll" idFieldName="AccountId" captionFieldName="DisplayName" enabled="<%=canEdit && !autoCreated%>"/>
      </v:form-field>
      <v:form-field caption="@Account.AccessArea">
        <v:combobox field="perf.AccessAreaId" lookupDataSetName="dsAcAreaAll" idFieldName="AccountId" captionFieldName="DisplayName" enabled="<%=canEdit && !autoCreated%>"/>
        <span id="SelectLocationHint" class="description v-hidden"><v:itl key="@Performance.SelectLocationHint"/></span>
        <div id="LocationLoadingSpinner" class="v-hidden"><img src="<v:config key="site_url" />/resources/admin/images/spinner.gif"/></div>
      </v:form-field>
    </v:widget-block>
    <v:widget-block>
      <v:form-field caption="@Event.AdmissionOpenMins" hint="@Event.AdmissionOpenMinsHint">
        <% String placeHolder = perf.Default_AdmissionOpenMins.isNull("@Event.AdmissionOpenMinsPlaceholder"); %>
        <v:input-text field="perf.AdmissionOpenMins" placeholder="<%=placeHolder%>" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@Event.AdmissionCloseMins" hint="@Event.AdmissionCloseMinsHint">
        <% String placeHolder = perf.Default_AdmissionCloseMins.isNull("@Event.AdmissionCloseMinsPlaceholder"); %>
        <v:input-text field="perf.AdmissionCloseMins" placeholder="<%=placeHolder%>" enabled="<%=canEdit%>"/>
      </v:form-field>
    </v:widget-block>
    <v:widget-block>
      <div><v:db-checkbox field="perf.InheritFulfilmentArea" value="true" caption="@Performance.InheritFulfilmentAreaFromAccessArea" enabled="<%=canEdit%>"/></div>
    </v:widget-block>
    <v:widget-block id="fulfilmentarea-block">
      <v:form-field caption="@Common.FulfilmentArea" hint="@Common.FulfilmentAreaHint">
        <snp:dyncombo field="perf.FulfilmentAreaTagId" id="FulfilmentAreaTagId" entityType="<%=LkSNEntityType.FulfilmentArea%>" enabled="<%=canEdit%>"/>
      </v:form-field>
    </v:widget-block>
    
  </v:widget>
</div>


<style>

select.time {
  width: 50px;
}

</style>


<script>
var loadingAA = false;
function refreshAccessArea() {
  var setted = ($("#perf\\.LocationId").val() != "");
  setVisible("#perf\\.AccessAreaId", setted && !loadingAA);
  setVisible("#SelectLocationHint", !setted && !loadingAA);
  setVisible("#LocationLoadingSpinner", loadingAA);
}
refreshAccessArea();

$("#perf\\.LocationId").change(function() {
  if ($("#perf\\.LocationId").val() == "") {
    $("#perf\\.AccessAreaId").val("");
    refreshAccessArea();
  }
  else {
    loadingAA = true;
    refreshAccessArea();
    $.ajax({
      url: "<v:config key="site_url"/>/admin?page=account_tab_acarea&action=get_accessarea_options&LocationId=" + $("#perf\\.LocationId").val(),
      dataType:'html',
      cache: false
    }).done(function(html) {
      $("#perf\\.AccessAreaId").html(html);
      loadingAA = false;
      refreshAccessArea();
    }).fail(function() {
      loadingAA = false;
      refreshAccessArea();
      alert(<v:itl key="@Common.GenericError" encode="JS"/>);
    });
  }
});

function inheritFulfilmentAreaChanged() {
	  var checked = $("#perf\\.InheritFulfilmentArea").isChecked();
	  $("#fulfilmentarea-block").setClass("hidden", checked);  
	}

$("#perf\\.InheritFulfilmentArea").change(inheritFulfilmentAreaChanged);
inheritFulfilmentAreaChanged();



</script>



