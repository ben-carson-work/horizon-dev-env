<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.snapp.lookup.LkSNEntityType"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<% JvDocument settings = (JvDocument)request.getAttribute("settings"); %>

<div id="motf-restful-reader-settings">
  <jsp:include page="doc-openapi.jspf"></jsp:include>

  <v:grid>
    <thead>
      <v:grid-title caption="Media template mapping"/>
      <tr>
        <td><v:grid-checkbox header="true"/></td>
        <td width="50%">Type</td>
        <td width="50%">Template</td>
      </tr>
    </thead>
    <tbody id="tbody-mapping">
      <tr class="grid-row template-mapping-row hidden">
        <td><v:grid-checkbox/></td>
        <td><v:input-text field="Type" clazz="media-type-field"/></td>
        <td><snp:dyncombo field="DocTemplateId" clazz="media-type-field" entityType="<%=LkSNEntityType.DocTemplate%>" filtersJSON="{\"DocTemplate\":{\"DocTemplateType\":1}}"/></td>
      </tr>
    </tbody>
    <tbody>
      <tr>
        <td colspan="100%">
          <v:button id="btn-mapping-add" caption="@Common.Add" fa="plus"/>
          <v:button id="btn-mapping-del" caption="@Common.Remove" fa="minus"/>
        </td>
      </tr>
    </tbody>
  </v:grid>

</div>


<script>
$(document).ready(function() {
  var $cfg = $("#motf-restful-reader-settings");
  var $tbody = $cfg.find("#tbody-mapping");
  var $template = $tbody.find(".template-mapping-row").removeClass("hidden").remove();

  $cfg.find("#btn-mapping-add").click(() => $template.clone().appendTo($tbody));
  $cfg.find("#btn-mapping-del").click(() => $tbody.removeCheckedRows());

  $(document).von($cfg, "driver-settings-load", function(event, params) {
    $tbody.docToGrid({
      "doc": (params.settings || {}).MediaTypes,
      "template": $template
    });
  });
  
  $(document).von($cfg, "driver-settings-save", function(event, params) {
    params.settings = {
      "MediaTypes": $tbody.find("tr").gridToDoc({"fieldSelector":".media-type-field"})
    };
  });
});
</script>