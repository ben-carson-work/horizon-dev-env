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

<v:dialog id="performance-import-dialog" title="@Common.Import" width="800" autofocus="false">
  <div id="step-input">
    <v:widget caption="@Common.Parameters">
      <v:widget-block>
        <v:form-field caption="@Common.Status" id="DefaultPerformanceStatus">
          <v:lk-combobox lookup="<%=LkSN.PerformanceStatus%>" allowNull="false" field="PerformanceStatus"/>
        </v:form-field>
      </v:widget-block>
      <v:widget-block>
        <jsp:include page="../repository/file_upload_widget.jsp"/>
      </v:widget-block>
    </v:widget>
    <v:alert-box type="info" title="@Common.Info">
      This wizard will import perfomances from a CSV file into the system.<br/>
      The first line of the input file will be used to identify the field matching as follows:
      <ul>
        <li><b>EventCode</b> <i>(mandatory)</i>: used for matching the proper event</li>
        <li><b>AccessAreaCode</b> <i>(optional)</i>: used for matching the proper access area when multiple access areas are linked to the same event</li>
        <li><b>PerformanceDateTimeFrom</b> <i>(mandatory)</i>: used for matching the proper performance (or create a new one). Format "YYYY-MM-DDThh:mm:ss"</li>
        <%
          String href = pageBase.getContextURL() + "?page=doc_lookup_list&LookupTable=" + LkSN.PerformanceStatus.getCode();
          String desc = "<a href='" + href + "' target='_new'>LkSNPerformanceStatus</a>";
        %>
        <li>
          <b>PerformanceStatus</b> <i>(optional)</i>: only the values defined into <%=desc%> are accepted<br/>
          If the column is compiled the parameter will be ignored.
        </li>
        <li><b>SeatCategoryCode_1</b> <i>(optional)</i>: used to add/update a record in the limited capacity sector</li>
        <li><b>SeatEnvelopeCode_1</b> <i>(optional)</i>: used to add/update a record in the limited capacity sector</li>
        <li><b>Quantity_1</b> <i>(optional)</i>: new quantity</li>
        <li><b>SeatCategoryCode_2</b> <i>(optional)</i>: used to add/update a record in the limited capacity sector</li>
        <li><b>SeatEnvelopeCode_2</b> <i>(optional)</i>: used to add/update a record in the limited capacity sector</li>
        <li><b>Quantity_2</b> <i>(optional)</i>: new quantity</li>
        <li><b>SeatCategoryCode_N</b> <i>(optional)</i>: used to add/update a record in the limited capacity sector</li>
        <li><b>SeatEnvelopeCode_N</b> <i>(optional)</i>: used to add/update a record in the limited capacity sector</li>
        <li><b>Quantity_N</b> <i>(optional)</i>: new quantity</li>
      </ul>
    </v:alert-box>
  </div>

  <div id="step-preview" class="step-item v-hidden">
    <jsp:include page="../csv_import_widget.jsp">
      <jsp:param name="AsyncProcessClassAlias" value="<%=AsyncProcessUtils.CLASS_ALIAS_IMPORT_PERFORMANCE%>"/>
    </jsp:include>
  </div>

<script>

$(document).ready(function() {
  var id = $("#category-tree li.selected").attr("data-id");
  if (id != "all")
    $("#performance-import-dialog [name='CategoryId']").val(id);
});

function getImportParams() {
  return {
    Performance: {
    	DefaultPerformanceStatus: $("#performance-import-dialog [name='PerformanceStatus']").val()
    }
  }
}

function doUploadFinish(obj) {
  $("#step-input").addClass("v-hidden");
  $("#step-preview").removeClass("v-hidden");
  doCsvImport(obj.RepositoryId);
}

function csvImportCallback(proc) {
  triggerEntityChange(<%=LkSNEntityType.Performance.getCode()%>);
}

</script>

</v:dialog>
