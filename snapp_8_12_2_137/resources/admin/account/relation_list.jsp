<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageRelationList" scope="request"/>

<jsp:include page="/resources/common/header.jsp"/>
<v:page-title-box/>
<v:last-error/>

<script>
function doDeleteRelations() {
  confirmDialog(null, function() {
    var reqDO = {
      Command: "DeleteRelation",
      DeleteRelation: {
        RelationIDs: $("[name='RelationId']").getCheckedValues()
      }
    };
    
    vgsService("Account", reqDO, null, function() {
      triggerEntityChange(<%=LkSNEntityType.Relation.getCode()%>);
    });
  });
}
</script>

<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-dashboard" caption="@Common.Search" default="true">
    <div class="tab-toolbar">
      <v:button caption="@Common.New" fa="plus" href="javascript:asyncDialogEasy('account/relation_dialog', 'id=new')"/>
      <v:button caption="@Common.Delete" title="@Common.DeleteSelectedItems" fa="trash" href="javascript:doDeleteRelations()"/>
      <v:pagebox gridId="relation-grid"/>
    </div>
    
    <div class="tab-content">
      <v:async-grid id="relation-grid" jsp="account/relation_grid.jsp" />
    </div>
  </v:tab-item-embedded>
</v:tab-group>
 
<jsp:include page="/resources/common/footer.jsp"/>
