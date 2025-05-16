<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:dialog id="create_confirmation_email_dialog" title="@Sale.CreateOrderConfirmation" width="600" height="400">
  <v:widget caption="@Common.General">
    <v:widget-block>
      <v:form-field caption="@Common.Template" mandatory="true">
        <% JvDataSet dsOrderConfirmationDocTemplates = pageBase.getBL(BLBO_DocTemplate.class).getDocTemplateDS(LkSNDocTemplateType.OrderConfirmation); %>
	      <v:combobox field="DocTemplateId" idFieldName="DocTemplateId" captionFieldName="DocTemplateName" lookupDataSet="<%=dsOrderConfirmationDocTemplates%>"/>
      </v:form-field>
  	  <v:form-field caption="@Action.SendEmail" hint="@Sale.SendConfirmationEmail" checkBoxField="SendConfirmationEmail">
        <v:input-text field="ConfirmationEmailAddress"/>
  	  </v:form-field>
    </v:widget-block>
  </v:widget>
  
<script>
$(document).ready(function() {
  var $dlg = $("#create_confirmation_email_dialog");
  $dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      {
        text: itl("@Common.Create"),
        click: doCreate
      }, 
      {
        text: itl("@Common.Cancel"),
        click: doCloseDialog
      }
    ];
  }); 
  
  function doCreate() {
    var docTemplateId = $("#DocTemplateId").val();
    if (docTemplateId == "")
      showMessage(itl("@Common.CheckRequiredFields") + ":\nTemplate");
    else {
      var reqDO = {
        Command: "SendOrderConfirmation",
        SendOrderConfirmation: {
          SaleId: <%=JvString.jsString(pageBase.getNullParameter("SaleId"))%>,
          FilterTransactionId: <%=JvString.jsString(pageBase.getNullParameter("FilterTransactionId"))%>,
          DocTemplateId: docTemplateId,
          EmailAddress: $("#ConfirmationEmailAddress").val(),
          SendImmediately: $("input[name='SendConfirmationEmail']").isChecked()
        }
      };
      
      showWaitGlass();
      vgsService("Sale", reqDO, false, function(ansDO) {
        hideWaitGlass();
        $dlg.dialog("close");
        window.location = <%=JvString.jsString(pageBase.getContextURL())%> + "?page=action&id=" + ansDO.Answer.SendOrderConfirmation.ActionId;
      });
    }  
  }
});

</script>
</v:dialog>