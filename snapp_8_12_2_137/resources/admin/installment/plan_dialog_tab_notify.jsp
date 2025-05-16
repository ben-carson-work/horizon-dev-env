<%@page import="com.vgs.snapp.web.bko.library.BLBO_Installment"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plan" class="com.vgs.snapp.dataobject.DOInstallmentPlan" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% boolean canEdit = rights.InstallmentPlans.canUpdate(); %>

<%!
private String findDocTemplateId(DOInstallmentPlan plan, LookupItem commType) {
  for (DOInstallmentPlan.DOInstallmentPlanComm comm : plan.CommunicationList.getItems())
    if (comm.CommunicationType.isLookup(commType))
      return comm.DocTemplateId.getString();
  return null;
} 
%>


<div class="tab-content">
  <% for (LookupItem commType : LkSN.InstallmentCommType.getItems()) { %>
    <v:form-field caption="<%=commType.getDescription(pageBase.getLang())%>">
      <% String id = "CommType_" + commType.getCode(); %>
      <v:combobox field="<%=id%>" clazz="CommDocTemplate" lookupDataSet="<%=pageBase.getBL(BLBO_DocTemplate.class).getDocTemplateDS(LkSNDocTemplateType.InstallmentNotification)%>" idFieldName="DocTemplateId" captionFieldName="DocTemplateName" value="<%=findDocTemplateId(plan, commType)%>" enabled="<%=canEdit%>"/>
    </v:form-field>
  <% } %>
</div>