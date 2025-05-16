<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.snapp.lookup.LkSNDriverType"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>

<%
JvDocument settings = (JvDocument)request.getAttribute("settings"); 
%>

<v:widget caption="@Common.Settings">
  <v:widget-block>
    <v:form-field caption="Client ID" mandatory="true">
      <v:input-text field="settings.clientId"/>
    </v:form-field>
    <v:form-field caption="Login Base Url" mandatory="true">
      <v:input-text field="settings.loginBaseUrl"/>
    </v:form-field>
    <v:form-field caption="Certificate issuer" mandatory="true">
      <v:input-text field="settings.certificateIssuer"/>
    </v:form-field>
    <v:form-field caption="Certificate Url" mandatory="true">
      <v:input-text field="settings.certificateUrl"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<v:widget caption="Health Check">
  <v:widget-block>
    <v:form-field caption="Url" mandatory="true">
      <v:input-text field="settings.healthCheckUrl"/>
    </v:form-field>
  </v:widget-block>
  <v:widget-block id="criteria-list-block" style="background:white">
    <v:grid id="criteria-list" style="margin-bottom:10px">
      <thead>
         <tr>
          <td><v:grid-checkbox header="true"/></td>
          <td width="40%">Group</td>
          <td width="40%">Component</td>
          <td width="20%">Status Threshold</td>
        </tr>
      </thead>
      <tbody id="criteria-list-tbody">
      </tbody>
      <tbody id="criteria-tool-tbody">
      <tr>
        <td colspan="100%">
          <div class="btn-group">
            <v:button caption="@Common.Add" fa="plus" dropdown="false" onclick="addCriteria()"/>
          </div>
          <v:button caption="@Common.Remove" fa="minus" onclick="removeCriterias()"/>
        </td>
      </tr>
      </tbody>
    </v:grid>    
  </v:widget-block>
</v:widget>

<div id="templates" class="hidden">
  <table>
    <tr class="grid-row criteria-list-row-template">
      <td>
        <v:grid-checkbox name="criteria-checkbox"/>
      </td>

      <td>
        <input type="text" name="Group" title="Group" class="criteria-grid-input form-control"/>
      </td>
      <td>
        <input type="text" name="Component" title="Component" class="criteria-grid-input form-control"/>
      </td>
      <td>
        <input type="text" name="StatusThreshold" title="Status Threshold" class="criteria-grid-input form-control"/>
      </td>
    </tr> 
  </table>
</div>

<script>
function getPluginSettings() {
  return {
    clientId: $("#settings\\.clientId").val(),
    loginBaseUrl: $("#settings\\.loginBaseUrl").val(),
    healthCheckUrl: $("#settings\\.healthCheckUrl").val(),
    healthCheckGroup: $("#settings\\.healthCheckGroup").val(),
    healthCheckComponent: $("#settings\\.healthCheckComponent").val(),
    healthCheckStatusThreshold: $("#settings\\.healthCheckStatusThreshold").val(),
    healthCheckCriteriaList: getCriteriaList(),
    certificateIssuer: $("#settings\\.certificateIssuer").val(),
    certificateUrl: $("#settings\\.certificateUrl").val()
  };
}

function getCriteriaList() { 
  var list = [];
  var trs = $("#criteria-list-tbody tr");
  for (var i=0; i<trs.length; i++) {
    var tr = $(trs[i]);
    list.push({
      Group: tr.find("input[name='Group']").val(),
      Component: tr.find("input[name='Component']").val(),
      StatusThreshold: tr.find("input[name='StatusThreshold']").val()
    });
  }
  return list;
}

function addCriteria(criteria) {
  criteria = (criteria) ? criteria : {
    Group: "",
    Component: "",
    StatusThreshold: ""
  };
  
  var trCriteria = $("#templates .criteria-list-row-template").clone().appendTo("#criteria-list-tbody");
  trCriteria.find("input[name=Group]").attr("value", criteria.Group);
  trCriteria.find("input[name=Component]").attr("value", criteria.Component);
  trCriteria.find("input[name=StatusThreshold]").attr("value", criteria.StatusThreshold);
}

function removeCriterias() {
  var cbs = $("#criteria-list [name='criteria-checkbox']:checked");
  for (var i=0; i<cbs.length; i++) {
    $(cbs[i]).closest("tr").remove();
  }
}

var settings;

$(document).ready(function() {
  settings = <%=settings.getJSONString()%>;
  if ((settings) && (settings.healthCheckCriteriaList)) {
    for (var i=0; i<settings.healthCheckCriteriaList.length; i++) 
      addCriteria(settings.healthCheckCriteriaList[i]);    
  }   
});
</script>

