<%@page import="com.vgs.snapp.library.AsyncProcessUtils"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:dialog id="account-extmedia-import-dialog" title="@Account.ImportExtMediaCodesHint" width="800" height="600" autofocus="false">
  <div id="step-input">
    <v:widget caption="@Common.Parameters">
      <v:widget-block>
      <v:form-field caption="@Product.ExtMediaGroup">
       <snp:dyncombo field="MediaGroupTagId" entityType="<%=LkSNEntityType.ExtMediaGroup%>"/>
      </v:form-field>
      <v:form-field caption="@Reservation.PerformanceDate">
        <v:input-text type="datepicker" field="PerfDate"/>
      </v:form-field>
      </v:widget-block>
      <v:widget-block>
        <jsp:include page="../repository/file_upload_widget.jsp"/>
      </v:widget-block>
    </v:widget>
 
    <v:alert-box type="info" title="@Common.Info">
      This wizard will import external media codes from a CSV file into the system.<br/>
      The first line of the input file will be used to identify the field matching as follows:
      <ul>
        <li><b>ExtMediaCode</b> <i>(mandatory)</i>: external media code</li>
        <li><b>ExtMediaGroupCode</b> <i>(optional)</i>: used for matching an external media group</li>
        <li><b>PerformanceDate</b> <i>(optional)</i>: in the format YYYY-MM-DD; performance date to be linked</li>
      </ul>
      External media group and performance date can be set using the parameters below.<br/>
      They will be applied when corresponding field is empty.
    </v:alert-box>
  </div>

  <div id="step-preview" class="step-item v-hidden">
    <jsp:include page="../csv_import_widget.jsp">
      <jsp:param name="AsyncProcessClassAlias" value="<%=AsyncProcessUtils.CLASS_ALIAS_IMPORT_EXT_MEDIA%>"/>
    </jsp:include>
  </div>
</v:dialog>

<script>

function getImportParams() {
  return {
    ExtMedia: {
      AccountId: '<%=pageBase.getId()%>',
      DefaultMediaGroupId: $("#MediaGroupTagId").val(),
      DefaultPerformanceDate: $("#PerfDate").val()
    }
  }
}

function doUploadFinish(obj) {
  $("#step-input").addClass("v-hidden");
  $("#step-preview").removeClass("v-hidden");
  doCsvImport(obj.RepositoryId);
}

function csvImportCallback(proc) {
  triggerEntityChange(<%=LkSNEntityType.ExtMediaCode.getCode()%>);
}


</script>