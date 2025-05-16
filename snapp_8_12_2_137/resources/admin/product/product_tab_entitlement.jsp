<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageProduct" scope="request"/>
<jsp:useBean id="product" class="com.vgs.snapp.dataobject.DOProduct" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% 
boolean canEdit = pageBase.getRightCRUD().canUpdate();

request.setAttribute("entitlement", product.Entitlement);
request.setAttribute("entitlement-readonly", "true"); 
%>

<v:tab-toolbar>
  <v:button-group>
    <% LkSNEntitlementStatus.EntitlementStatusItem[] entitlementButtons = {LkSNEntitlementStatus.Static, LkSNEntitlementStatus.DynamicEntity, LkSNEntitlementStatus.Dynamic}; %>
    <% for (LkSNEntitlementStatus.EntitlementStatusItem item : entitlementButtons) { %>
      <% 
      DOEntitlement ent = (DOEntitlement)product.getChildNode(item.getProductField());
      String id = "btn-ent-" + item.getCode(); 
      String iconColor = ent.isEmpty() ? null : item.getButtonIconColor();
      boolean buttonEnabled = !item.isLookup(LkSNEntitlementStatus.Dynamic) || !ent.isEmpty();
      %>
      <v:button id="<%=id%>" clazz="btn-ent" caption="<%=item.getButtonCaption() %>" title="<%=item.getButtonTitle()%>" fa="<%=item.getButtonIconAlias()%>" faColor="<%=iconColor%>" enabled="<%=buttonEnabled%>"/>
    <% } %>
  </v:button-group>
  
	<v:button id="btn-versioning" caption="@Entitlement.Versioning" fa="hashtag" enabled="<%=canEdit && rights.BulkEntitlementReplace.getBoolean()%>"/> 
</v:tab-toolbar>

<v:tab-content>
  <v:alert-box type="warning" include="<%=product.PreventAdmission.getBoolean()%>">
    <p><b><%=pageBase.getLang().Common.Warning.getHtmlText()%></b></p>
    <p><%=pageBase.getLang().Product.PreventAdmissionEntitlementWarning.getHtmlText()%></p>
  </v:alert-box>
    
  <div id="entitlement-container"><jsp:include page="../entitlement/entitlement_widget.jsp"/></div>
</v:tab-content>


<script>

$(document).ready(function() {
  var productId = <%=JvString.jsString(pageBase.getId())%>;
  var canEdit = <%=canEdit%>;
  
  $("#btn-versioning").click(() => asyncDialogEasy("product/entitlement_version_list_dialog", "id=" + productId));
  $(".btn-ent").click(doEditEntitlements);

  function doEditEntitlements() {
    var code = $(this).attr("id").substr("btn-ent-".length);
    var readOnly = !canEdit || (code == <%=LkSNEntitlementStatus.Dynamic.getCode()%>)
    asyncDialogEasy("entitlement/entitlement_dialog", "EntityId=" + productId + "&EntitlementStatus=" + code + "&ReadOnly=" + readOnly);
  }

  <%--
  $("#btn-ent-static").click(() => doEditEntitlements(<%=LkSNEntitlementStatus.Static.getCode()%>, false));
  $("#btn-ent-dynamicentity").click(() => doEditEntitlements(<%=LkSNEntitlementStatus.DynamicEntity.getCode()%>, false));
  $("#btn-ent-dynamic").click(() => doEditEntitlements(<%=LkSNEntitlementStatus.Dynamic.getCode()%>, true));
  
  function doEditEntitlements(entitlementStatus, readOnly) {
    asyncDialogEasy("entitlement/entitlement_dialog", "EntityId=" + productId + "&EntitlementStatus=" + entitlementStatus + "&ReadOnly=" + (readOnly || !canEdit));
  }
  --%>
});

</script>
