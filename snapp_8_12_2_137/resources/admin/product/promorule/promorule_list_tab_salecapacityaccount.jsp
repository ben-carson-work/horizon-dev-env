<%@page import="com.vgs.web.library.product.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase");
FtCRUD rightCRUD = pageBase.getBL(BLBO_SaleCapacityAccount.class).getSaleCapacityAccountRightController().getOverallCRUD();
%>

<script>
$(document).ready(function() {
  $("#btn-sca-del").click(function() {
    confirmDialog(null, function() {
      snpAPI.cmd("SaleCapacity", "DeleteSaleCapacityAccount", {SaleCapacityAccountIDs: $("[name='SaleCapacityAccountId']").getCheckedValues()})
          .then(ansDO => triggerEntityChange(<%=LkSNEntityType.SaleCapacityAccount.getCode()%>));
    });
  });
});
</script>


<v:tab-toolbar>
  <v:button-group>
    <v:button id="btn-sca-new" caption="@Common.New" fa="plus" bindGrid="sca-grid" bindGridEmpty="true" enabled="<%=rightCRUD.canCreate()%>" onclick="asyncDialogEasy('product/salecapacity/salecapacityaccount_dialog')"/>
    <v:button id="btn-sca-del" caption="@Common.Delete" fa="trash" bindGrid="sca-grid" enabled="<%=rightCRUD.canDelete()%>"/>
  </v:button-group>

  <v:pagebox gridId="sca-grid"/>
</v:tab-toolbar>

<v:tab-content>
  <v:async-grid id="sca-grid" jsp="product/salecapacity/salecapacityaccount_grid.jsp"/>
</v:tab-content>


<jsp:include page="/resources/common/footer.jsp"/>
