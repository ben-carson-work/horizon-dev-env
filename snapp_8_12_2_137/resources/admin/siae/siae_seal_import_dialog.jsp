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
<%@page import="com.vgs.web.library.BLBO_Siae.SiaeLookup"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
JvDataSet dsVoidReasons = pageBase.getBL(BLBO_Siae.class).getSiaeLookupItemsDS(SiaeLookup.VOID_REASON); 
%>

<v:dialog id="siae_seal_import_dialog" title="@Common.Import" width="800" height="600" autofocus="false">
  <div id="step-input" class="step-item">
  	<v:widget caption="Annullo sigillo">
		  <v:widget-block>
		    <v:form-field caption="Causale annullamento">
		      <v:combobox field="voidreason-id" idFieldName="LookupItemCode" captionFieldName="LookupItemName" lookupDataSet="<%=dsVoidReasons%>" allowNull="false" enabled="true" />
		    </v:form-field>
		  </v:widget-block>
		</v:widget>
    <v:widget caption="Upload">
      <v:widget-block>
        <jsp:include page="../repository/file_upload_widget.jsp"/>
      </v:widget-block>
    </v:widget>
    <v:alert-box type="info" title="@Common.Info">
      Questa procedura carica sigilli da annullare da un file CSV <br/>
      La prima linea del file caricato definisce la tipologia di dato nel seguente modo:
      <ul>
        <li><b>Sigillo</b> <i>(obbligatorio)</i>: sigillo</li>
      </ul>
    </v:alert-box>
  </div>
  
  <div id="step-preview" class="step-item v-hidden">
    <jsp:include page="../csv_import_widget.jsp">
      <jsp:param name="AsyncProcessClassAlias" value="<%=AsyncProcessUtils.CLASS_ALIAS_IMPORT_SIAE_SEAL%>"/>
    </jsp:include>
  </div>

<script>

function getImportParams() {
  return {
	  Siae_Seal: {
    	VoidReason: $("#voidreason-id").val()
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

