<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.vgs.cl.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.snapp.query.*"%>

<% 
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); 
QueryDef qdef = new QueryDef(QryBO_TimedTicketRule.class)
    .addSort(QryBO_TimedTicketRule.Sel.RuleName)
    .addSelect(
        QryBO_TimedTicketRule.Sel.TimedTicketRuleId,
        QryBO_TimedTicketRule.Sel.RuleName);

JvDataSet dsTTRules = pageBase.execQuery(qdef);
pageBase.getReq().setAttribute("ds-tt-rules", dsTTRules);
%>

<div id="ent-ttrule-dialog" class="ent-dialog" title="<v:itl key="@Product.TimedTicketRule"/>">
  <table class="form-table">
    <tr>
      <th width="30%"><label for="rule-id-combo"><v:itl key="@Product.TimedTicketRule"/></label></th>
      <td width="70%"><v:combobox field="rule-id-combo" lookupDataSetName="ds-tt-rules" idFieldName="TimedTicketRuleId" captionFieldName="RuleName" /></td>
    </tr>
  </table>
</div>
