<%@page import="com.vgs.web.library.BLBO_Seat"%>
<%@page import="com.vgs.snapp.web.search.BLBO_QueryRef_SeatEnvelope"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="java.util.Map.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v"%>
<%@ taglib uri="snp-tags" prefix="snp"%>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<% JvDocument settings = (JvDocument) request.getAttribute("settings"); %>

<v:widget caption="Settings">
  <v:widget-block>
    <v:form-field caption="Doc.Number field" hint="Field containing the document number (inserted by user)" mandatory="true">
      <snp:dyncombo id="DocNum_MetaFieldId" entityType="<%=LkSNEntityType.MetaField%>"/>
    </v:form-field>
    <v:form-field caption="Doc.Type field" hint="Field containing the document type (auto calculated)" mandatory="true">
      <snp:dyncombo id="DocType_MetaFieldId" entityType="<%=LkSNEntityType.MetaField%>"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<v:grid>
  <thead>
    <v:grid-title caption="Mapping"/>
    <tr>
      <td><v:grid-checkbox header="true"/></td>
      <td width="50%">Doc.Type</td>
      <td width="50%">Length</td>
    </tr>
  </thead>
  <tbody id="mdv-doctype-mapping-tbody"></tbody>
  <tbody>
    <tr>
      <td colspan="100%">
        <v:button id="btn-mdv-doctype-mapping-add" caption="@Common.Add" fa="plus"/>
        <v:button id="btn-mdv-doctype-mapping-del" caption="@Common.Remove" fa="minus"/>
      </td>
    </tr>
  </tbody>
</v:grid>

<div id="mdv-doctype-templates" class="hidden">
  <v:grid>
    <tr class="mdv-doctype-mapping-row-template">
      <td><v:grid-checkbox header="false"/></td>
      <td><v:input-text clazz="txt-mdv-doctype-mapping-value"/></td>      
      <td><v:input-text type="number" clazz="txt-mdv-doctype-mapping-length"/></td>      
    </tr>
  </v:grid>
</div>

<script>
function getPluginSettings() {
  var settings = {
    DocNum_MetaFieldId: $("#DocNum_MetaFieldId").val(),
    DocType_MetaFieldId: $("#DocType_MetaFieldId").val(),
    MappingList: []
  };
  
  $("#mdv-doctype-mapping-tbody .mdv-doctype-mapping-row-template").each(function(index, item) {
    var $item = $(item);
    settings.MappingList.push({
      Value: $item.find(".txt-mdv-doctype-mapping-value").val(),
      Length: $item.find(".txt-mdv-doctype-mapping-length").val()
    });
  });
  
  return settings;
}

$(document).ready(function() {
  var settings = <%=settings.getJSONString()%>; 
  $("#btn-mdv-doctype-mapping-add").click(_addMapping);
  $("#btn-mdv-doctype-mapping-del").click(_delMapping);
  
  $("#DocNum_MetaFieldId").val(settings.DocNum_MetaFieldId);
  $("#DocType_MetaFieldId").val(settings.DocType_MetaFieldId);
  settings.MappingList = settings.MappingList || [];
  for (var i=0; i<settings.MappingList.length; i++) {
    var item = settings.MappingList[i];
    _doAddMapping(item.Value, item.Length);
  }
  
  function _addMapping() {
    _doAddMapping();
  }
  
  function _delMapping() {
    $("#mdv-doctype-mapping-tbody .cblist:checked").closest(".mdv-doctype-mapping-row-template").remove();
  }
  
  function _doAddMapping(value, length) {
    $item = $("#mdv-doctype-templates .mdv-doctype-mapping-row-template").clone().appendTo("#mdv-doctype-mapping-tbody");
    $item.find(".txt-mdv-doctype-mapping-value").val(value);
    $item.find(".txt-mdv-doctype-mapping-length").val(length);
  }
});
</script>