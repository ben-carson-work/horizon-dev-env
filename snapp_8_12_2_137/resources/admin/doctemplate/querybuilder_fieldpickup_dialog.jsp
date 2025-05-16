<%@page import="com.vgs.snapp.dataobject.DOQueryBuilderCollection"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" scope="request" class="com.vgs.snapp.web.common.page.PageCommonWidget"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<v:dialog id="querybuilder_fieldpickup_dialog" title="@DocTemplate.FieldPickup" width="800" height="600" autofocus="false">

<script>
  
function addCollection(coll) {
  var liColl = $("<li class='collection-node'/>").appendTo(".collection-list");
  $("<div class='item-caption'/>").appendTo(liColl).text(coll.CollectionName);
  $("<ul class='field-list'/>").appendTo(liColl);
  
  liColl.data("collection", coll);
  if (coll.FieldList) 
    for (var i=0; i<coll.FieldList.length; i++)
      addField(liColl, coll.FieldList[i]);
}

function addField(liColl, field) {
  var liField = $("<li class='field-node'/>").appendTo(liColl.find(".field-list"));
  var divName = $("<div class='item-caption'/>").appendTo(liField).text(field.FieldAlias);
  
  liField.data("field", field);
  divName.click(function() {
    var coll = $(this).closest(".collection-node").data("collection");
    var field = $(this).closest(".field-node").data("field");
    $(document).trigger("querybuilder-addfield", [coll, field]);
  });
}

$(document).ready(function() {
<% for (DOQueryBuilderCollection coll : BLBO_QueryBuilder.getCollections()) { %>
  addCollection(<%=coll.getJSONString()%>);
<% } %>
});
</script>

<ul class="collection-list"></ul>

</v:dialog>