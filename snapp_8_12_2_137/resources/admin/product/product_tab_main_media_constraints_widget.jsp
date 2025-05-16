<%@page import="com.vgs.web.library.product.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="org.apache.poi.util.*"%>
<%@page import="com.vgs.snapp.dataobject.DOProduct.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageProduct" scope="request"/>
<jsp:useBean id="product" class="com.vgs.snapp.dataobject.DOProduct" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<jsp:useBean id="rightCRUD" class="com.vgs.snapp.library.FtCRUD" scope="request"/>

<% 
boolean canEdit = rightCRUD.canUpdate(); 
%>

<v:widget-block include="<%=!product.ProductType.isLookup(LkSNProductType.StaffCard)%>">
  <v:form-field caption="@Product.MediaConstraints" hint="@Product.MediaConstraintsHint" checkBoxField="cbMediaConstraints">
    <v:grid>
      <thead>
        <tr>
          <td><v:grid-checkbox header="true"/></td>
          <td width="50%"><v:itl key="@DocTemplate.DocTemplate"/></td>
          <td width="25%"><v:itl key="@Common.Min"/></td>
          <td width="25%"><v:itl key="@Common.Max"/></td>
        </tr>
      </thead>
      <tbody id="tbody-media-constraints">
        <tr class="grid-row media-constraint-template hidden">
          <td><v:grid-checkbox/></td>
          <td><snp:dyncombo field="DocTemplateId" clazz="media-constraint-field" entityType="<%=LkSNEntityType.DocTemplate%>" filtersJSON="{\"DocTemplate\":{\"DocTemplateType\":1}}" enabled="<%=canEdit%>"/></td>
          <td><v:input-text field="QuantityMin" clazz="media-constraint-field" type="number" enabled="<%=canEdit%>"/></td>
          <td><v:input-text field="QuantityMax" clazz="media-constraint-field" type="number" placeholder="@Common.Unlimited" enabled="<%=canEdit%>"/></td>
        </tr>
      </tbody>
      <tbody>
        <tr>
          <td colspan="100%">
            <v:button id="btn-media-constraints-add" caption="@Common.Add" fa="plus" enabled="<%=canEdit%>"/>
            <v:button id="btn-media-constraints-del" caption="@Common.Remove" fa="minus" enabled="<%=canEdit%>"/>
          </td>
        </tr>
      </tbody>
    </v:grid>
  </v:form-field>
</v:widget-block>      

<script>
$(document).ready(function() {
  var $tbody = $("#tbody-media-constraints");
  var $template = $tbody.find(".media-constraint-template").removeClass("hidden").remove();
  var $cbConstraints = $("[name='cbMediaConstraints']"); 
  $cbConstraints.setChecked(<%=!product.MediaConstraintList.isEmpty()%>); 
  $("#btn-media-constraints-add").click(() => $template.clone().appendTo($tbody));
  $("#btn-media-constraints-del").click(() => $tbody.removeCheckedRows());
  
  $tbody.docToGrid({
    "doc": <%=product.MediaConstraintList.getJSONString()%>,
    "template": $template,
    "fieldSelector": ".media-constraint-field"
  });
  
  $(document).von($tbody, "product-save", function(event, params) {
    params.Product.MediaConstraintList = !$cbConstraints.isChecked() ? [] : $tbody.find("tr").gridToDoc({
      "fieldSelector": ".media-constraint-field"
    });
  });
});
</script>
