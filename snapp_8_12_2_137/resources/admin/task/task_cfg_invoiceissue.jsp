<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="java.text.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTask" scope="request"/>
<jsp:useBean id="task" class="com.vgs.snapp.dataobject.DOTask" scope="request"/>

<v:widget caption="@Task.InvoiceIssue_OrderSelection">
  <v:widget-block>
    <v:form-field caption="@Task.InvoiceIssue_Period" hint="@Task.InvoiceIssue_PeriodHint" mandatory="true">
      <v:lk-combobox field="cfg.Period" lookup="<%=LkSN.TaskInvoicePeriod%>" allowNull="false"/>
    </v:form-field>
    <v:form-field caption="@Task.InvoiceIssue_OrganizationTags" hint="@Task.InvoiceIssue_OrganizationTagsHint">
      <v:multibox field="cfg.OrganizationTagIDs" linkEntityType="<%=LkSNEntityType.Tag_Organization%>"/>
    </v:form-field>
  </v:widget-block> 
</v:widget>
 
<v:widget caption="@Common.Options">
  <v:widget-block>
    <v:form-field caption="@Task.InvoiceIssue_Grouping" hint="@Task.InvoiceIssue_GroupingHint" mandatory="true">
      <v:lk-combobox field="cfg.Grouping" lookup="<%=LkSN.TaskInvoiceGrouping%>" allowNull="false"/>
    </v:form-field>
    <v:form-field caption="@Task.InvoiceIssue_Template" hint="@Task.InvoiceIssue_TemplateHint" mandatory="true">
      <snp:dyncombo field="cfg.DocTemplateId" entityType="<%=LkSNEntityType.DocTemplate%>" allowNull="false" filtersJSON="{\"DocTemplate\":{\"DocTemplateType\":\"Invoice\"}}"/>
    </v:form-field>
  </v:widget-block>
</v:widget> 
 
<v:widget caption="@Common.Email">
  <v:widget-block>
    <v:db-checkbox field="cfg.SendEmail" value="true" caption="@Task.InvoiceIssue_SendEmail" hint="@Task.InvoiceIssue_SendEmailHint"/>
  </v:widget-block>
  <v:widget-block visibilityController="#cfg\\.SendEmail">
    <v:form-field caption="@Task.InvoiceIssue_EmailTemplate">
      <snp:dyncombo field="cfg.EmailDocTemplateId" entityType="<%=LkSNEntityType.DocTemplate%>" filtersJSON="{\"DocTemplate\":{\"DocTemplateType\":\"InvoiceNotification\"}}"/>
    </v:form-field>
    <v:form-field caption="@Task.InvoiceIssue_EmailField">
      <snp:dyncombo field="cfg.EmailMetaFieldId" entityType="<%=LkSNEntityType.MetaField%>"/>
    </v:form-field>
    <v:form-field>
      <v:db-checkbox field="cfg.SendEmailNegative" value="true" caption="@Task.InvoiceIssue_SendEmailNegative" hint="@Task.InvoiceIssue_SendEmailNegativeHint"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>

function saveTaskConfig(reqDO) {
  var config = {
    Period: $("#cfg\\.Period").val(),
    OrganizationTagIDs: $("#cfg\\.OrganizationTagIDs").val(),
    Grouping: $("#cfg\\.Grouping").val(),
    DocTemplateId: $("#cfg\\.DocTemplateId").val(),
    SendEmail: $("[name='cfg\\.SendEmail']").isChecked(),
    SendEmailNegative: $("[name='cfg\\.SendEmailNegative']").isChecked(),
    EmailDocTemplateId: $("#cfg\\.EmailDocTemplateId").val(),
    EmailMetaFieldId: $("#cfg\\.EmailMetaFieldId").val()
	}
	reqDO.TaskConfig = JSON.stringify(config); 
}

</script>

