<%@page import="com.vgs.snapp.web.gencache.*"%>
<%@page import="com.vgs.cl.database.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pkg" class="com.vgs.snapp.dataobject.DOExtensionPackage" scope="request"/>
<% PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); %>

<div id="accesso-settings">

  <v:widget caption="@Common.Settings">
    <v:widget-block>
      <v:form-field caption="@PluginSettings.Accesso.GEP_TenantId">
        <v:input-text field="TenantId" clazz="accesso-field"/>
      </v:form-field>
      <%-- 
      <v:form-field caption="Display class field" hint="Product type's metafield representing GEP 'displayClassId'">
        <snp:dyncombo field="DisplayClassMetaFieldId" clazz="accesso-field" entityType="<%=LkSNEntityType.MetaField%>"/>
      </v:form-field>
      <v:form-field caption="Description field" hint="Product type's metafield representing GEP 'description'">
        <snp:dyncombo field="DescriptionMetaFieldId" clazz="accesso-field" entityType="<%=LkSNEntityType.MetaField%>"/>
      </v:form-field>
      --%>
    </v:widget-block>
  </v:widget>

  <v:grid>
    <thead>
      <v:grid-title caption="@PluginSettings.Accesso.GEP_CustomDataMapping" hint="@PluginSettings.Accesso.GEP_CustomDataMappingHint"/>
      <tr>
        <td><v:grid-checkbox header="true"/></td>
        <td width="50%"><v:itl key="@PluginSettings.Accesso.GEP_CustomDataField"/></td>
        <td width="50%"><v:itl key="@Common.FormField"/></td>
      </tr>
    </thead>
    <tbody id="tbody-gep-mapping-data">
    </tbody>
    <tbody id="tbody-gep-mapping-toolbar">
      <tr>
        <td colspan="100%">
          <v:button id="btn-gep-mapping-add" caption="@Common.Add" fa="plus"/>
          <v:button id="btn-gep-mapping-del" caption="@Common.Remove" fa="minus"/>
        </td>
      </tr>
    </tbody>
  </v:grid>
  
  <template id="template-gep-mapping-row">
    <tr class="grid-row">
      <td><v:grid-checkbox/></td>
      <td><v:input-text clazz="gep-mapping-fieldname"/></td>
      <td><snp:dyncombo clazz="gep-mapping-metafield" entityType="<%=LkSNEntityType.MetaField%>"/></td>
    </tr>
  </template>
  
</div>

<script>
$(document).ready(function() {
  var doc = <%=pkg.ConfigDoc.getString()%> || {};
  var $cfg = $("#accesso-settings");
  var $tbodyMappingData = $cfg.find("#tbody-gep-mapping-data");
  
  $cfg.find("#btn-gep-mapping-add").click(_addMapping);
  $cfg.find("#btn-gep-mapping-del").click(_delMapping);

  for (const key of Object.keys(doc)) 
    $cfg.find("#" + key).val(doc[key]);
  
  for (const item of (doc.CustomFieldList || []))
    _addMapping(item);
  
  function _addMapping(item) {
    var template = $cfg.find("#template-gep-mapping-row")[0].content.firstElementChild;
    var $tr = $(template).clone().appendTo($tbodyMappingData);

    if (item) {
      $tr.find(".gep-mapping-fieldname").val(item.FieldName);
      $tr.find(".gep-mapping-metafield").val(item.MetaFieldId);
    }
  }
  
  function _delMapping() {
    $tbodyMappingData.find(".cblist:checked").closest("tr").remove();
  }
});

function getExtensionPackageConfigDoc() {
  var doc = {
    "CustomFieldList": []
  };
  
  $("#accesso-settings .accesso-field").each(function() {
    var $field = $(this);
    doc[$field.attr("id")] = $field.val();
  });
  
  var requiredFields = ["displayClassId", "description"]; 
  
  $("#tbody-gep-mapping-data tr").each(function() {
    var $tr = $(this);
    var fieldName = $tr.find(".gep-mapping-fieldname").val();
    
    var index = requiredFields.indexOf(fieldName); 
    if (index >= 0)
      requiredFields.splice(index, 1);
    
    doc.CustomFieldList.push({
      "FieldName": fieldName,
      "MetaFieldId": $tr.find(".gep-mapping-metafield").val(),
    });
  });
  
  if (requiredFields.length > 0)
    showIconMessage("warning", itl("@PluginSettings.Accesso.GEP_MissingMappingFields", requiredFields.join(", ")));

  return doc;
}

</script>