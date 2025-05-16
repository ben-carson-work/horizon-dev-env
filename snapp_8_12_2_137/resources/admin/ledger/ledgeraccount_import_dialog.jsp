<%@page import="com.vgs.snapp.library.AsyncProcessUtils"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:dialog id="ledgeraccount-import-dialog" title="@Common.Import" width="800" height="600" autofocus="false">
  <div id="step-input">
    <v:widget caption="@Common.Parameters">
      <v:widget-block>
        <jsp:include page="../repository/file_upload_widget.jsp"/>
      </v:widget-block>
    </v:widget>
    <v:alert-box type="info" title="@Common.Info">
      <v:itl key="@Ledger.ImportWizard_Line1"/><br/>
      <v:itl key="@Ledger.ImportWizard_Line2"/>
      <ul>
        <li><strong>LedgerAccountCode</strong>: <v:itl key="@Ledger.ImportWizard_LedgerAccountCode"/></li>
        <li><strong>LedgerAccountName</strong>: <v:itl key="@Ledger.ImportWizard_LedgerAccountName"/></li>
        <li><strong>LedgerAccountType</strong>: <v:itl key="@Ledger.ImportWizard_LedgerAccountType"/></li>
        <li><strong>LedgerAccountLevel</strong>: <v:itl key="@Ledger.ImportWizard_LedgerAccountLevel"/></li>
        <li><strong>Meta Field code</strong>: <v:itl key="@Ledger.ImportWizard_LedgerAccountMetaFieldCode"/></li>
        <li><strong>Meta Field Type</strong>: <v:itl key="@Ledger.ImportWizard_LedgerAccountMetaFieldNumber"/></li>                   
      </ul>
    </v:alert-box>
  </div>

  <div id="step-preview" class="step-item v-hidden">
    <jsp:include page="../csv_import_widget.jsp">
      <jsp:param name="AsyncProcessClassAlias" value="<%=AsyncProcessUtils.CLASS_ALIAS_IMPORT_LEDGER_ACCOUNT%>"/>
    </jsp:include>
  </div>

<script>

<%--
function getImportParams() {
  return {
    Account: {
      EntityType: <%=entityType.getCode()%>,
      DefaultCategoryId: $("#account-import-dialog [name='CategoryId']").val()
    }
  }
}
--%>

function doUploadFinish(obj) {
  $("#step-input").addClass("v-hidden");
  $("#step-preview").removeClass("v-hidden");
  doCsvImport(obj.RepositoryId);
}

function csvImportCallback(proc) {
  triggerEntityChange(<%=LkSNEntityType.LedgerAccount.getCode()%>);
}

</script>

</v:dialog>
