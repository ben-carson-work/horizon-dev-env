<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageDocTemplate" scope="request"/>
<jsp:useBean id="doc" class="com.vgs.web.dataobject.DOUI_DocTemplate" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="docRightCRUD" class="com.vgs.snapp.library.FtCRUD" scope="request"/>

<%
DODocTemplateWaiver docWaiver = JvNode.createByJSON(DODocTemplateWaiver.class, doc.DocData.getString());
request.setAttribute("docWaiver", docWaiver);
boolean enabled = docRightCRUD.canUpdate(); 
%>

<v:widget id="doctemplate-waiver-settings" caption="@Common.Settings" include="<%=doc.DocEditorType.isLookup(LkSNDocEditorType.Waiver)%>">

  <v:widget-block>
    <v:form-field caption="@DocTemplate.WaiverTemplate" hint="@DocTemplate.WaiverTemplateHint">
      <v:upload-tile field="docWaiver.DocEditorFile" clazz="waiver-field" limitExtension=".doc,.docx" enabled="<%=enabled%>"/>
    </v:form-field>
  </v:widget-block>

  <v:widget-block>
    <v:form-field caption="@DocTemplate.WaiverFileName" hint="@DocTemplate.WaiverFileNameHint">
      <v:input-text field="docWaiver.FileName" clazz="waiver-field" placeholder="waiver.pdf" enabled="<%=enabled%>"/>
    </v:form-field>
  </v:widget-block>
   
  <v:widget-block>
    <v:form-field caption="@DocTemplate.WaiverExpirationRule" clazz="waiver-field" checkBoxField="docWaiver.ExpirationRuleFlag" enabled="<%=enabled%>">
      <v:lk-radio field="docWaiver.ExpirationRule" lookup="<%=LkSN.WaiverExpirationRule%>" clazz="waiver-field" inline="true" allowNull="false" enabled="<%=enabled%>"/>
      <v:input-text field="docWaiver.ExpirationNumber" type="number" clazz="waiver-field" placeholder="@Common.Quantity" enabled="<%=enabled%>"/>
    </v:form-field>
  </v:widget-block>
  
</v:widget>


<script>
$(document).ready(function() {
  var $settings = $("#doctemplate-waiver-settings");
  var $radioExpRule = $settings.find("#docWaiver\\.ExpirationRule input[type='radio']"); 
  
  $radioExpRule.click(_refreshVisibility);
  $("#doctemplate-tab-main").on("doctemplate-save", _save);
  
  _refreshVisibility();

  
  function _refreshVisibility() {
    console.log("refre");
    var quantitySupportedItems = [<%=JvArray.arrayToString(LkSN.WaiverExpirationRule.getQuantitySupportedItems().stream().mapToInt(it -> it.getCode()).toArray(), ",")%>];
    var rule = parseInt($radioExpRule.filter(":checked").val());
    $settings.find("#docWaiver\\.ExpirationNumber").setClass("hidden", quantitySupportedItems.indexOf(rule) < 0);
  }
  
  function _save(event, reqDO) {
    var doc = $settings.find(".waiver-field").viewToDoc();
    reqDO.DocData = JSON.stringify(doc);
  }
});
</script>
