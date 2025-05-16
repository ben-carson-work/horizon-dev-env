<%@page import="com.vgs.dataobject.DOWebTreeNode"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageSystemTreeWidget" scope="request"/>


<% DOWebTreeNode<?> tree = (DOWebTreeNode<?>)request.getAttribute("tree"); %>

<div id="system-tree"></div>

<script>

$("#system-tree").tree({
  data: <%=tree.getJSONString()%>,
  nodeSelected: function(node) {
    var id = node.attr("data-Id");
    var entityType = <%=LkSNEntityType.Licensee.getCode()%>;
    if ($(node).hasClass("loc"))
      entityType = <%=LkSNEntityType.Location.getCode()%>;
    else if ($(node).hasClass("opa"))
      entityType = <%=LkSNEntityType.OperatingArea.getCode()%>;

    if (systemTreeSelected) 
      systemTreeSelected(entityType, id);
  }
});

</script>

