<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% 
String eventId = pageBase.getNullParameter("EventId");
String defaultLocationId = pageBase.getDB().getString("select LocationAccountId from tbEvent where EventId=" + JvString.sqlStr(eventId));
String defaultAcAreaId = pageBase.getDB().getString("select AccessAreaAccountId from tbEvent where EventId=" + JvString.sqlStr(eventId));
%>

<v:wizard-step id="performance-create-wizard-step-admission" title="@Performance.Admission">
  <v:widget>
    <v:widget-block>
      <v:form-field caption="@Account.Location">
        <v:combobox field="LocationId" lookupDataSet="<%=pageBase.getBL(BLBO_Account.class).getLocationDS()%>" idFieldName="AccountId" captionFieldName="DisplayName"/>
      </v:form-field>
      <v:form-field caption="@Account.AccessArea">
        <select id="AccessAreaId" name="AccessAreaId" class="form-control v-hidden"></select>
        <span id="SelectLocationHint" class="description v-hidden"><v:itl key="@Performance.SelectLocationHint"/></span>
        <div id="LocationLoadingSpinner" class="v-hidden"><img src="<v:config key="site_url" />/resources/admin/images/spinner.gif"/></div>
      </v:form-field>
    </v:widget-block>
    <v:widget-block>
       <v:form-field caption="@Event.AdmissionOpenMins" hint="@Event.AdmissionOpenMinsHint">
         <v:input-text field="perf.AdmissionOpenMins" placeholder="@Event.AdmissionOpenMinsPlaceholder"/>
       </v:form-field>
       <v:form-field caption="@Event.AdmissionCloseMins" hint="@Event.AdmissionCloseMinsHint">
         <v:input-text field="perf.AdmissionCloseMins" placeholder="@Event.AdmissionCloseMinsPlaceholder"/>
       </v:form-field>
    </v:widget-block>
  <v:widget-block>
    <div><v:db-checkbox field="perf.InheritFulfilmentArea" value="true" caption="@Performance.InheritFulfilmentAreaFromAccessArea" checked="True" /></div>
  </v:widget-block>
  <v:widget-block id="fulfilmentarea-block">
    <v:form-field caption="@Common.FulfilmentArea" hint="@Common.FulfilmentAreaHint" >
      <snp:dyncombo field="perf.FulfilmentAreaTagId" id="FulfilmentAreaTagId" entityType="<%=LkSNEntityType.FulfilmentArea%>"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>

$(document).ready(function() {
  const $step = $("#performance-create-wizard-step-admission");
  const $wizard = $step.closest(".wizard");

  $step.vWizard("step-validate", _stepValidate);
  $step.vWizard("step-filldata", _stepFillData);
  
  var loadingAA = false;
  function _refreshAccessArea() {
    var setted = ($step.find("#LocationId").val() != "");
    setVisible($step.find("#AccessAreaId"), setted && !loadingAA);
    setVisible($step.find("#SelectLocationHint"), !setted && !loadingAA);
    setVisible($step.find("#LocationLoadingSpinner"), loadingAA);
  }
  
  function _reloadAccessArea() {
    if ($step.find("#LocationId").val() == "") {
      $step.find("#AccessAreaId").val("");
      _refreshAccessArea();
    }
    else {
      loadingAA = true;
      _refreshAccessArea();
      $.ajax({
        url: BASE_URL + "/admin?page=account_tab_acarea&action=get_accessarea_options&LocationId=" + $step.find("#LocationId").val(),
        dataType:'html',
        cache: false
      }).done(function(html) {
        $step.find("#AccessAreaId").html(html);
        loadingAA = false;
        <% if (defaultAcAreaId != null) { %>
          $step.find("#AccessAreaId").val("<%=defaultAcAreaId%>");
        <% } %>
        _refreshAccessArea();
      }).fail(function() {
        loadingAA = false;
        _refreshAccessArea();
        showMessage(itl("@Common.GenericError"));
      });
    }
  }
  
  $step.find("#LocationId").val("<%=defaultLocationId%>");
  <% if (defaultAcAreaId != null) { %>
    _reloadAccessArea(); 
  <% } %>
  _refreshAccessArea();
  
  $step.find("#LocationId").change(function() {
    $step.find("#AccessAreaId").empty();
    _reloadAccessArea();
  });
  
  function _inheritFulfilmentAreaChanged() {
    var checked = $step.find("#perf\\.InheritFulfilmentArea").isChecked();
    $step.find("#fulfilmentarea-block").setClass("hidden", checked);  
  }

  $step.find("#perf\\.InheritFulfilmentArea").change(_inheritFulfilmentAreaChanged);
  _inheritFulfilmentAreaChanged();

  function _stepValidate(callback) {
    if (getNull($step.find("#AccessAreaId").val()) != null)
      callback();
    else 
      confirmDialog(itl("@Performance.MissingAccessAreaWarning"), callback);
  }
  
  function _stepFillData(data) {
    data.LocationId            = $step.find("#LocationId").val();
    data.AccessAreaId          = $step.find("#AccessAreaId").val();
    data.AdmissionOpenMins     = $step.find("[name='perf.AdmissionOpenMins']").val();
    data.AdmissionCloseMins    = $step.find("[name='perf.AdmissionCloseMins']").val();
    data.InheritFulfilmentArea = $step.find("[name='perf.InheritFulfilmentArea']").isChecked();
    data.FulfilmentAreaTagId   = $step.find("[name='perf.FulfilmentAreaTagId']").val();
  }

});

</script>
    
</v:wizard-step>
