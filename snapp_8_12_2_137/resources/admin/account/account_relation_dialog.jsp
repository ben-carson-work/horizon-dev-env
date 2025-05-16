<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
QueryDef qdef = new QueryDef(QryBO_Relation.class);
// Select
qdef.addSelect(QryBO_Relation.Sel.RelationId);
qdef.addSelect(QryBO_Relation.Sel.AssignRelationName);
// Sort
qdef.addSort(QryBO_Relation.Sel.AssignRelationName);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
%>

<v:dialog id="account_relation_dialog" title="<%=pageBase.getBL(BLBO_Account.class).getAccountName(pageBase.getNullParameter(\"AccountId\"))%>" icon="chain.png" width="500" height="250" autofocus="false">

<v:form-field caption="@Account.Person">
  <snp:dyncombo field="ChildAccountId" entityType="<%=LkSNEntityType.Person%>"/>
</v:form-field>
<v:form-field caption="@Account.Relation">
  <v:combobox field="RelationId" lookupDataSet="<%=ds%>" captionFieldName="AssignRelationName" idFieldName="RelationId" allowNull="false"/>
</v:form-field>

<script>

var dlg = $("#account_relation_dialog");

dlg.on("snapp-dialog", function(event, params) {
  params.buttons = {
    <v:itl key="@Common.Save" encode="JS"/>: doSaveRelation,
    <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
  };
});

dlg.keypress(function() {
  if (event.keyCode == KEY_ENTER)
    doSaveRelation();
});

function doSaveRelation() {
  var reqDO = {
    Command: "AddAccountRelation",
    AddAccountRelation: {
      AccountId: "<%=JvString.escapeHtml(pageBase.getEmptyParameter("AccountId"))%>",
      ChildAccountId: $("#ChildAccountId").val(),
      RelationId: $("#RelationId").val()
    }
  };
  
  vgsService("Account", reqDO, false, function(ansDO) {
    dlg.dialog("close");
    triggerEntityChange(<%=LkSNEntityType.AccountRelation.getCode()%>, null);
  });
}

</script>

</v:dialog>


