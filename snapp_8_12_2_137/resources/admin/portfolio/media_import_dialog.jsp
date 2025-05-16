<%@page import="com.vgs.snapp.library.*"%>
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

<v:dialog id="media-import-dialog" title="@Common.Import" width="800" height="600" autofocus="false">
  <div id="step-input">
    <v:widget caption="@Common.Parameters">
      <v:widget-block>
        <jsp:include page="../repository/file_upload_widget.jsp"/>
      </v:widget-block>
    </v:widget>
    <v:alert-box type="info" title="@Common.Info">
      This wizard will import medias from a CSV file into the system.<br/>
      The first line of the input file will be used to identify the field matching as follows:
      <ul>
        <li><b>ProductCode</b> <i>(mandatory)</i>: used for matching the proper product type</li>
        <li><b>AccountCode</b> <i>(optional)</i>: used for matching an account to set the portfolio owner</li>
        <li><b>ValidDateFrom</b> <i>(optional)</i>: in the format YYYY-MM-DD; specify a fixed start validity date for the encoded product (date will be set as "manually changed")</li>
        <li><b>ExpirationDate</b> <i>(optional)</i>: in the format YYYY-MM-DD; specify a fixed expiration date for the encoded product (date will be set as "manually changed")</li>
         <%
          String href = pageBase.getContextURL() + "?page=doc_lookup_list&LookupTable=" + LkSN.ExtSystemType.getCode();
          String desc = "<a href='" + href + "' target='_new'>LkSNExtSystemType</a>";
        %>
        <li><b>ExtSystemType</b> <i>(optional)</i>: define type of external system that generate the media codes, only values defined into <%=desc%> are accepted</li>
        <li><b>MC_1</b> <i>(mandatory)</i>: media code</li>
        <li><b>MC_2</b> <i>(optional)</i>: media code</li>
        <li><b>MC_N</b> <i>(optional)</i>: media code</li>
        <li><b>MCT_1</b> <i>(optional)</i>: media code type for MC_1</li>
        <li><b>MCT_2</b> <i>(optional)</i>: media code type for MC_2</li>
        <li><b>MCT_N</b> <i>(optional)</i>: media code type for MC_N</li>
      </ul>
    </v:alert-box>
  </div>

  <div id="step-preview" class="step-item v-hidden">
    <jsp:include page="../csv_import_widget.jsp">
      <jsp:param name="AsyncProcessClassAlias" value="<%=AsyncProcessUtils.CLASS_ALIAS_IMPORT_MEDIA%>"/>
    </jsp:include>
  </div>

<script>

$(document).ready(function() {
  var id = $("#category-tree li.selected").attr("data-id");
  if (id != "all")
    $("#account-import-dialog [name='CategoryId']").val(id);
});

function getImportParams() {
  return {
    Media: {
    }
  }
}

function doUploadFinish(obj) {
  $("#step-input").addClass("v-hidden");
  $("#step-preview").removeClass("v-hidden");
  doCsvImport(obj.RepositoryId);
}

function csvImportCallback(proc) {
  triggerEntityChange(<%=LkSNEntityType.Media.getCode()%>);
}

</script>

</v:dialog>
