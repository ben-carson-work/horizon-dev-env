<%@page import="com.vgs.web.library.BLBO_Siae"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageSiaeTaxList" scope="request"/>
<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>
<%
BLBO_Siae bl = pageBase.getBLDef();
%>

<div class="mainlist-container">
  <jsp:include page="/resources/admin/siae/siae_alert.jsp" />
  <div class="form-toolbar">
    <% String hrefSIAE = "javascript:asyncDialogEasy('siae/siae_tax_dialog')"; %>
    <v:button caption="@Common.New" fa="plus" enabled="<%=bl.isSiaeEnabled() %>" href="<%=hrefSIAE%>"/>
    <v:button id="del-btn" caption="@Common.Delete" fa="trash" enabled="<%=bl.isSiaeEnabled() %>" href="javascript:doDelete()"/>
    <v:pagebox gridId="tax-grid"/>
  </div>
  
  <div>
    <v:last-error/>
    <v:async-grid id="tax-grid" jsp="siae/siae_tax_grid.jsp" />
  </div>
</div>
<script>
function doDelete() {
  var ids = $("[name='SiaeTaxId']").getCheckedValues();
  if (ids == "")
    showMessage("<v:itl key="@Common.NoElementWasSelected" encode="UTF-8"/>");
  else {
    confirmDialog(null, function() {
      var reqDO = {
        Command: "DeleteTaxes",
        DeleteTaxes: {
          Ids: ids
        }
      };
      
      vgsService("Siae", reqDO, false, function(ansDO) {
        triggerEntityChange(<%=LkSNEntityType.SiaeTax.getCode()%>);
      });
    });
  }
}
</script>
<jsp:include page="/resources/common/footer.jsp"/>