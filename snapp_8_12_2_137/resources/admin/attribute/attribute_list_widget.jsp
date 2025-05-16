<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageAttributeList" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
boolean canCreate = pageBase.getRightCRUD().canCreate();
boolean canDelete = pageBase.getRightCRUD().canDelete();
%>

<script>
function doNewAttribute() {
  asyncDialogEasy("attribute/attribute_dialog", "id=new&ParentEntityType=<%=pageBase.getEmptyParameter("ParentEntityType")%>&ParentEntityId=<%=pageBase.getEmptyParameter("ParentEntityId")%>");
}
function doDelAttributes() {
  confirmDialog(null, function() {
    var reqDO = {
      Command: "DeleteAttribute",
      DeleteAttribute: {
        AttributeIDs: $("[name='AttributeId']").getCheckedValues()
      }
    };
    
    vgsService("Product", reqDO, false, function(ansDO) {
      triggerEntityChange(<%=LkSNEntityType.Attribute.getCode()%>);
    });
  });
}
</script>

<v:page-form>
<div class="tab-toolbar">
  <v:button caption="@Common.New" title="@Product.NewAttribute" fa="plus" href="javascript:doNewAttribute()" enabled="<%=canCreate%>"/>
  <v:button caption="@Common.Delete" title="@Common.DeleteSelectedItems" fa="trash" href="javascript:doDelAttributes()" enabled="<%=canDelete%>"/>
  <v:pagebox gridId="attribute-grid"/>
</div>

<div class="tab-content">
  <% String params = "ParentEntityId=" + pageBase.getParameter("ParentEntityId"); %>
  <v:async-grid id="attribute-grid" jsp="attribute/attribute_grid.jsp" params="<%=params%>" />
</div>

</v:page-form>
