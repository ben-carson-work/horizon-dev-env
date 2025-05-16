<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageCategoryTreeWidget" scope="request"/>

<div id="category-tree"></div>

<script>

$(document).ready(function() {
  $("#category-tree").tree({
    data: <%=pageBase.getBLDef().getCategoryTree(LkSN.EntityType.getItemByCode(pageBase.getParameter("EntityType"))).getJSONString()%>,
    nodeSelected: function(node) {
      var id = node.attr("data-Id");
      $("input[type='hidden']#CategoryId").val(id);
      if (functionExists("categorySelected")) 
        categorySelected(id);
    }
  });
});

</script>

