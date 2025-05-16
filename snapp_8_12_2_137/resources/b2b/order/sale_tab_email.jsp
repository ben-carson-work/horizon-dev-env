<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.b2b.page.PageB2B_Sale" scope="request"/>

<div class="tab-toolbar">
<%--   <v:button caption="@Common.Create" fa="plus" href="javascript:createOrdConf()"/> --%>
<%--   <v:button caption="@Common.Delete" fa="trash" href="javascript:doDelete()"/> --%>
  <v:pagebox gridId="action-grid"/>
</div>

<div class="tab-content">
  <% String params = "LinkEntityId=" + pageBase.getId() + "&LinkEntityType=" + LkSNEntityType.Sale.getCode(); %>
  <v:async-grid id="action-grid" jsp="action/action_grid.jsp" params="<%=params%>"/>
</div>


<script>

// function createOrdConf() {
<%--   asyncDialogEasy("order/orderconf_template_dialog", "SaleId=<%=pageBase.getId()%>&IncludeTickets=true");   --%>
// }

function doDelete() {
  var ids = $("[name='ActionId']").getCheckedValues();
  if (ids) {
    confirmDialog(null, function() {
      var reqDO = {
        Command: "Delete",
        Delete: {
          ActionIDs: ids
        }
      };
      
      vgsService("Action", reqDO, false, function(ansDO) {
        triggerEntityChange(<%=LkSNEntityType.Email.getCode()%>);
      });
    });
  }
}

</script>