<%@page import="com.vgs.snapp.query.QryBO_PaymentCredit"%>
<%@page import="com.vgs.web.library.BLBO_DocTemplate"%>
<%@page import="java.util.stream.Collectors"%>
<%@page import="com.vgs.web.library.BLBO_Invoice"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v"%>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<%
String accountId = pageBase.getNullParameter("AccountId");
String saleId = pageBase.getNullParameter("SaleId");
String[] paymentIDs = JvArray.stringToArray(pageBase.getNullParameter("PaymentIDs"), ",");
String queryBase64 = pageBase.getNullParameter("QueryBase64");
String docTemplateId = JvUtils.getCookieValue(request, "SNP-Invoice-DocTemplateId");


if (((paymentIDs == null) || (paymentIDs.length == 0)) && (queryBase64 != null)) {
  QueryDef qdef = (QueryDef)JvString.unserializeBase64(queryBase64);
  qdef.selectList.clear();
  qdef.addSelect(QryBO_PaymentCredit.Sel.PaymentId);
  qdef.pagePos = -1;
  qdef.recordPerPage = -1;
  
  try (JvDataSet ds = pageBase.execQuery(qdef)) {
    paymentIDs = ds.getStrings();
  }
}

DOInvoicePreview invoice;
if (saleId != null)
  invoice = pageBase.getBL(BLBO_Invoice.class).invoicePreviewBySaleId(accountId, saleId);
else
  invoice = pageBase.getBL(BLBO_Invoice.class).invoicePreviewByPayments(accountId, paymentIDs);
  
String[] saleIDs = new String[0];
for (DOInvoicePreview.DOInvoicedSale sale: invoice.InvoicedSaleList) {
  if (sale.Valid.getBoolean())
    saleIDs = JvArray.add(sale.SaleId.getString(), saleIDs);  
}

boolean issueDisabled = (saleId == null) && (saleIDs.length == 0);
boolean canCreateNoteType = LkSNHighlightedNoteRightLevel.Create.check(rights.HighlightedNote);
%>

<v:dialog id="invoice_issue_dialog" icon="invoice.png" title="@Invoice.InvoiceIssue" autofocus="false" width="600" >

  <div class="wizard">
    <div class="wizard-step wizard-step-template">
      <div class="wizard-step-title"><v:itl key="@Common.Template"/></div>
      <div class="wizard-step-content">
        <v:widget>
          <v:widget-block>
            <div class="recap-value-item">
              <v:itl key="@Common.Organization"/>
              <span class="recap-value"><%=invoice.AccountName.getString()%></span>
            </div>
            <div class="recap-value-item">
              <v:itl key="@Invoice.DueDate"/>
              <span class="recap-value"><%=pageBase.format(invoice.DueDate, pageBase.getShortDateFormat())%></span>
            </div>
          </v:widget-block>
          <v:widget-block>
            <div style="max-height: 200px; overflow: auto;">
            <% for (DOInvoicePreview.DOInvoicedSale sale: invoice.InvoicedSaleList) {%>  
              <div class="recap-value-item">
                <snp:entity-link entityId="<%=sale.SaleId.getString()%>" entityType="<%=LkSNEntityType.Sale%>">
                <%=sale.SaleCode.getHtmlString() %>
                </snp:entity-link>
                <%
                  String sAmount = sale.Valid.getBoolean() ? pageBase.formatCurrHtml(sale.TotalAmount) : pageBase.getLang().Invoice.NotSelectable.getHtmlText();
                  String sStyle = sale.Valid.getBoolean() ? "" : "style=\"color:var(--base-orange-color)\"";
                %>
                <span class="recap-value" <%=sStyle%>><%=sAmount%></span><br/>
              </div>
            <%} %>
            </div>
          </v:widget-block>
          <v:widget-block>
            <div class="recap-value-item">
              <v:itl key="@Invoice.TotalAmount"/>
              <span class="recap-value"><%=pageBase.formatCurrHtml(invoice.TotalAmount)%></span><br/>
            </div>
            <div class="recap-value-item">
              <v:itl key="@Invoice.TotalTax"/>
              <span class="recap-value"><%=pageBase.formatCurrHtml(invoice.TotalTax)%></span><br/>
            </div>
            <div class="recap-value-item">
              <v:itl key="@Invoice.UnsettledAmount"/>
              <span class="recap-value"><%=pageBase.formatCurrHtml(invoice.UnsettledAmount)%></span><br/>
            </div>
          </v:widget-block>
          <v:widget-block>
            <v:form-field caption="@Common.Template" mandatory="true">
              <v:combobox field="invoice.DocTemplateId" lookupDataSet="<%=pageBase.getBL(BLBO_DocTemplate.class).getDocTemplateDS(LkSNDocTemplateType.Invoice)%>" idFieldName="DocTemplateId" captionFieldName="DocTemplateName" allowNull="false"/>
            </v:form-field>
          </v:widget-block>
          
        </v:widget>      
      </div>
    </div>
      
    <div class="wizard-step">
      <div class="wizard-step-title"><v:itl key="@Common.Note"/></div>
      <div class="wizard-step-content">
        <v:input-txtarea field="Note" rows="16"/>
        <% if (canCreateNoteType) { %>
          <v:widget>
            <v:widget-block>
              <v:db-checkbox field="NoteHighlighted" value="true" caption="@Common.Highlighted"/>
            </v:widget-block>
          </v:widget>
        <% } %>
      </div>
    </div>
  </div>



<script>  
//# sourceURL=invoice_issue_dialog.jsp

$(document).ready(function() {
  var $dlg = $("#invoice_issue_dialog");
  var $wizard = $dlg.find(".wizard");
  var $stepTemplate = $wizard.find(".wizard-step-template");

  $dlg.on("snapp-dialog", function(event, params) {
    params.open = _enableDisable;
    params.buttons = [
      {
        id: "btn-back",
        text: itl("@Common.Back"),
        click: _previousStep
      },
      {
        id: "btn-continue",
        text: itl("@Common.Continue"),
        click: _nextStep
      },
      {
        id: "btn-issue",
        text: itl("@Common.Issue"),
        click: _issue
      }, 
      {
        text: itl("@Common.Cancel"),
        click: doCloseDialog
      }                     
    ];
  });
  
  <%if (docTemplateId != null) {%>
    $("#invoice\\.DocTemplateId").val("<%=docTemplateId%>");
  <%}%>
  
  $wizard.vWizard({
    onStepChanged: _enableDisable
  });
  
  function _enableDisable() {
    var confirm = ($wizard.vWizard("activeIndex") == $wizard.vWizard("length") -1);
    var lastStep = ($wizard.vWizard("activeIndex") == $wizard.vWizard("length"));
    var firstStep = ($wizard.vWizard("activeIndex") == 0);

    var $buttonPane = $dlg.siblings(".ui-dialog-buttonpane");
    $buttonPane.find("#btn-continue").setClass("hidden", confirm || lastStep);
    $buttonPane.find("#btn-back").setClass("hidden", firstStep || lastStep);
    $buttonPane.find("#btn-issue").setClass("hidden", !confirm || lastStep);
    $buttonPane.find("#btn-issue").prop( "disabled", <%=issueDisabled%>);
  }

  function _nextStep() {
    if ($stepTemplate.is(".active")) {
      setCookie("SNP-Invoice-DocTemplateId", $("#invoice\\.DocTemplateId").val(), 30);
    }
    
    $wizard.vWizard("next");
  }
  
  function _previousStep() {
    $wizard.vWizard("prior");
  }
 
  function _issue() {
    var noteType = $dlg.find("#NoteHighlighted").isChecked() ? <%=LkSNNoteType.Highlighted.getCode()%> : <%=LkSNNoteType.Standard.getCode()%>;
    var reqDO = {
      Command: "IssueInvoice",
      IssueInvoice: {
        AccountId: <%=JvString.jsString(accountId)%>,
        SaleIDs: "<%= JvArray.arrayToString(saleIDs, ",")%>",
        DocTemplateId: $("#invoice\\.DocTemplateId").val(),
        DueDate: <%=JvString.jsString(invoice.DueDate.getXMLValue())%>,
        Note: $dlg.find("#Note").val(),
        NoteType: noteType,
      }
    };
    
    showWaitGlass();
    
    vgsService("Invoice", reqDO, false, function(ansDO) {
      triggerEntityChange(<%=LkSNEntityType.Invoice.getCode()%>);
      hideWaitGlass();
      $dlg.dialog("close");
      window.location.reload();
      window.open(getPageURL(<%=LkSNEntityType.Invoice.getCode()%>, ansDO.Answer.IssueInvoice.InvoiceId, null), "_blank");
    });
  }
});

</script>

</v:dialog>