<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<div class="tab-toolbar">
  <% String hrefNew = "javascript:asyncDialogEasy('dynprice/commissionrule_dialog', 'id=new')";%>
  <v:button caption="@Common.New" fa="plus" href="<%=hrefNew%>"/>
  <v:button caption="@Common.Delete" fa="trash" href="javascript:deleteCommissions()"/>
  <v:pagebox gridId="commissionrule-grid"/>
</div>

<div class="tab-content">
  <v:last-error/>
  <v:async-grid id="commissionrule-grid" jsp="dynprice/commissionrule_grid.jsp" />
</div>
 
<script>
 
function deleteCommissions() {
  var ids = $("[name='cbCommissionId']").getCheckedValues();
  if (ids == "")
    showMessage(<v:itl key="@Common.NoElementWasSelected" encode="JS"/>);
  else {
    confirmDialog(null, function() {
      var reqDO = {
        Command: "DeleteCommissionRule",
        DeleteCommissionRule: {
          CommissionIDs: ids
        }
      };
      
      showWaitGlass();
      vgsService("Product", reqDO, false, function(ansDO) {
        hideWaitGlass();
        changeGridPage("#commissionrule-grid", 1);
      });
    });
  }
}
 
 </script>
