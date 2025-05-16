<%@page import="com.vgs.snapp.library.AsyncProcessUtils"%>
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

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<v:dialog id="metafielditem_import_dialog" title="@Common.Import" width="800" height="600" autofocus="false">
  <div id="step-input" class="step-item">
    <v:widget caption="Upload">
      <v:widget-block>
        <jsp:include page="../repository/file_upload_widget.jsp"/>
      </v:widget-block>
    </v:widget>

    <v:alert-box type="info" title="@Common.Info">
      This wizard will import product types from a CSV file into the system.<br/>
      The first line of the input file will be used to identify the field matching as follows:
      <ul>
        <li><b>Code</b> <i>(optional)</i>: unique code</li>
        <li><b>Name</b> <i>(mandatory)</i>: item name</li>
        <li>
          <b>Name_ITL_##</b> <i>(optional)</i>: item name translation<br/>
          "##" to be replaced with proper <a href="https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes" target="_new">language 2 chars ISO code</a>
          </li>
      </ul>
    </v:alert-box>
  </div>
  
  <div id="step-preview" class="step-item v-hidden">
    <jsp:include page="../csv_import_widget.jsp">
      <jsp:param name="AsyncProcessClassAlias" value="<%=AsyncProcessUtils.CLASS_ALIAS_IMPORT_META_FIELD_ITEM%>"/>
    </jsp:include>
  </div>

<script>

function getImportParams() {
  return {
    MetaFieldItem: {
      MetaFieldId: <%=JvString.jsString(pageBase.getId())%>  
    }
  }
}

function doUploadFinish(obj) {
  $("#step-input").addClass("v-hidden");
  $("#step-preview").removeClass("v-hidden");
  doCsvImport(obj.RepositoryId);
}

</script>

</v:dialog>

