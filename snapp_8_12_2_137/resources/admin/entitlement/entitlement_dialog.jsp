<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<%
boolean readOnly = pageBase.isParameter("ReadOnly", "true");
String entityId = pageBase.getParameter("EntityId");
LkSNEntitlementStatus.EntitlementStatusItem entitlementStatus = (LkSNEntitlementStatus.EntitlementStatusItem)LkSN.EntitlementStatus.getItemByCode(pageBase.getParameter("EntitlementStatus"));

pageBase.setRightCRUD(LkSNEntityType.ProductType, entityId);
request.setAttribute("entitlement", pageBase.getBL(BLBO_Entitlement.class).getEntitlement(entityId, entitlementStatus));
request.setAttribute("entitlement-readonly", readOnly);
request.setAttribute("entitlement-status", entitlementStatus);
%>

<v:dialog id="entitlement_dialog" title="<%=entitlementStatus.getButtonCaption()%>" width="900" height="800" autofocus="false">
  <v:alert-box type="info">
    <div><v:itl key="<%=entitlementStatus.getFunctionHint()%>"/></div>
    <% if (entitlementStatus.getFunctionExample() != null) { %>
      <v:itl key="@Common.Example"/> <v:hint-handle hint="<%=entitlementStatus.getFunctionExample()%>"/>
    <% } %>
  </v:alert-box>

  <div id="entitlement-container"><jsp:include page="entitlement_widget.jsp"/></div>


  <script>
  
  $(document).ready(function() {
    var $dlg = $("#entitlement_dialog");
    var readOnly = <%=readOnly%>;
    
    $dlg.on("snapp-dialog", function(event, params) {
      params.buttons = [dialogButton("@Common.Close", doCloseDialog)];
      if (!readOnly)
        params.buttons.unshift(dialogButton("@Common.Save", doSave));
    });
    
    function doSave() {
      var productId = <%=JvString.jsString(entityId)%>;
      
      snpAPI.cmd("Product", "SaveProduct", {
        "Product": {
          "ProductId": productId,
          <%=JvString.jsString(entitlementStatus.getProductField())%>: $dlg.find(".entitlement-widget").data("entitlement")
        }
      }).then(ansDO => {
        $dlg.dialog("close");
        entitySaveNotification(<%=LkSNEntityType.ProductType.getCode()%>, productId, "tab=entitlement&ent=specific");
      });
    }
  });  
  
  </script>

</v:dialog>
