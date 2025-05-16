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

<v:dialog id="mediacode-import-dialog" title="@Common.Import" width="800" height="600" autofocus="false">
  <div id="step-input">
    <v:widget caption="@Common.Parameters">
      <v:widget-block>
        <jsp:include page="../repository/file_upload_widget.jsp"/>
      </v:widget-block>
    </v:widget>
    <v:alert-box type="info" title="@Common.Info">
      This wizard will add new media codes to existing medias from a CSV file.<br/>
      The first line of the input file will be used to identify the field matching as follows:
      <ul>
        <li><b>MediaTDSSN</b> <i>(mandatory)</i>: used for to get the existing media</li>
        <li><b>MediaCode</b> <i>(mandatory)</i>: used for to get the existing media</li>
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
      <jsp:param name="AsyncProcessClassAlias" value="<%=AsyncProcessUtils.CLASS_ALIAS_IMPORT_MEDIA_CODE%>"/>
    </jsp:include>
  </div>

<script>

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
