<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageSessionPoolList" scope="request"/>

<jsp:include page="../common/header.jsp"/>

<v:page-title-box/>


<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-dashboard" caption="@Common.Search" default="true">
    <div class="tab-toolbar">
      <v:button caption="@Common.New" fa="plus" href="javascript:asyncDialogEasy('sessionpool_dialog', 'id=new')"/>
      <v:button caption="@Common.Delete" fa="trash" title="@Common.DeleteSelectedItems" href="javascript:doDeleteSessionPools()"/>
      <v:pagebox gridId="sessionpool-grid"/>
    </div>
    
    <div class="tab-content">
      <v:async-grid id="sessionpool-grid" jsp="sessionpool_grid.jsp" />
    </div>
  </v:tab-item-embedded>
</v:tab-group>


<script>
function doDeleteSessionPools() {
  confirmDialog(null, function() {
    var reqDO = {
      Command: "DeleteSessionPool",
      DeleteSessionPool: {
        SessionPoolIDs: $("[name='SessionPoolId']").getCheckedValues() 
      }
    };
    
    vgsService("Session", reqDO, false, function(ansDO) {
      triggerEntityChange(<%=LkSNEntityType.SessionPool.getCode()%>);
    });
  });
}
</script>
 
<jsp:include page="../common/footer.jsp"/>
