<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_AccountRelation.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
String accountId = pageBase.getEmptyParameter("AccountId");
boolean canEdit = !pageBase.isParameter("readonly", "true");

QueryDef qdef = new QueryDef(QryBO_AccountRelation.class);
// Select
qdef.addSelect(Sel.ChildAccountId);
qdef.addSelect(Sel.ChildAccountName);
qdef.addSelect(Sel.ChildIconName);
qdef.addSelect(Sel.ChildProfilePictureId);
qdef.addSelect(Sel.RelationName);
// Filter
qdef.addFilter(Fil.AccountId, accountId);
// Sort
qdef.addSort(Sel.ChildAccountName);
// Exec
JvDataSet ds = pageBase.execQuery(qdef);
request.setAttribute("ds", ds);
%>

<style>

.accrel-block {
  padding: 5px !important;
  font-size: 0.85em;
  line-height: 1.5;
}

.accrel-block img.list-icon {
  position: relative;
  float: left;
  width: 32px;
  height: 32px;
}

.accrel-block a {
  font-weight: bold;
}

.accrel-text-block {
  margin-left: 38px;
}

.accrel-block:hover .accrel-remove {
  visibility: visible;
}

.accrel-block .accrel-remove {
  float: right;
  visibility: hidden;
}

.accrel-add-block {
  padding: 0 !important;
}

.accrel-add-block a {
  display: block;
  padding: 5px;
  text-align: center;
  font-weight: bold;
  font-size: 0.85em;
}

.accrel-add-block a:hover {
  background: #efefef;
}

</style>

<div>
<v:ds-loop dataset="<%=ds%>">
  <v:widget-block clazz="accrel-block">
    <v:grid-icon name="<%=ds.getField(Sel.ChildIconName).getString()%>" repositoryId="<%=ds.getField(Sel.ChildProfilePictureId).getString()%>"/>
    <div class="accrel-text-block">
      <snp:entity-link entityId="<%=ds.getField(Sel.ChildAccountId)%>" entityType="<%=ds.getField(Sel.ChildEntityType)%>"><%=ds.getField(Sel.ChildAccountName).getHtmlString()%></snp:entity-link>
      <%-- 
      <a class="entity-tooltip" data-EntityType="<%=ds.getField(Sel.ChildEntityType).getInt()%>" data-EntityId="<%=ds.getField(Sel.ChildAccountId).getHtmlString()%>" href="<v:config key="site_url"/>/admin?page=account&id=<%=ds.getField(Sel.ChildAccountId).getHtmlString()%>"><%=ds.getField(Sel.ChildAccountName).getHtmlString()%></a>
      --%>
      <br/>
      <span style="color:#808080"><%=ds.getField(Sel.RelationName).getHtmlString()%></span>
      <% if (canEdit) { %>
        <a class="accrel-remove" href="javascript:removeAccountRelation('<%=ds.getField(Sel.ChildAccountId).getHtmlString()%>')"><v:itl key="@Common.Remove"/></a>
      <% } %>
    </div>
  </v:widget-block>
</v:ds-loop>

<% if (canEdit) { %>
	<v:widget-block clazz="accrel-add-block">
	  <a href="javascript:asyncDialogEasy('account/account_relation_dialog', 'AccountId=<%=accountId%>')"><v:itl key="@Common.Add"/></a>
	</v:widget-block>
<% } %>
</div>

<script>

function removeAccountRelation(childAccountId) {
  confirmDialog(null, function() {
    reqDO = {
      Command: "RemoveAccountRelation",
      RemoveAccountRelation: {
        AccountId: "<%=accountId%>",
        ChildAccountId: childAccountId
      }
    };
    
    vgsService("Account", reqDO, false, function(ansDO) {
      triggerEntityChange(<%=LkSNEntityType.AccountRelation.getCode()%>, null);
    });
  });
}

</script>
