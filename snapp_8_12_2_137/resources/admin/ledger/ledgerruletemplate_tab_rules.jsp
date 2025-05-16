<%@page import="com.vgs.cl.JvDateTime"%>
<%@page import="com.vgs.cl.JvString"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="java.util.List"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageLedgerRuleTemplate" scope="request"/>
<jsp:useBean id="ledgerRuleTemplate" class="com.vgs.snapp.dataobject.DOLedgerRuleTemplate" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
boolean canEdit = rights.SettingsLedgerAccounts.canUpdate();

DOLedgerRuleTemplateDate firstDate = ledgerRuleTemplate.LedgerRuleTemplateDateList.findFirst(); 
if (firstDate != null) {
  request.setAttribute("EntityType", LkSNEntityType.LedgerRuleTemplateDate.getCode());
  request.setAttribute("EntityId", firstDate.LedgerRuleTemplateDateId.getString());
  request.setAttribute("ReadOnly", !canEdit);
}
%>

<v:tab-content>
  <v:tab-group name="tab_date">
    <%for (DOLedgerRuleTemplateDate templateDate : ledgerRuleTemplate.LedgerRuleTemplateDateList) {%>
      <% 
        String templateId = templateDate.LedgerRuleTemplateId.getString(); 
        String templateDateId = templateDate.LedgerRuleTemplateDateId.getString(); 
        String tabCaption = pageBase.getBL(BLBO_LedgerRule.class).calcTemplateDateRangeCaption(templateDate.ValidDateFrom.getDateTime(), templateDate.ValidDateTo.getDateTime());
      %>

      <v:tab-item 
          icon="calendar.png" 
          tab="<%=templateDateId%>" 
          caption="<%=tabCaption%>" 
          jsp="ledgerrule_tab_widget.jsp"/>
    <%}%>
  </v:tab-group>
</v:tab-content>
