<%@page import="com.vgs.snapp.lookup.LkSNEntityType"%>
<%@page import="com.vgs.snapp.query.QryBO_SiaeTax"%>
<%@page import="com.vgs.snapp.query.QryBO_SiaeSector"%>
<%@page import="com.vgs.snapp.query.QryBO_SiaeOrganizer"%>
<%@page import="com.vgs.snapp.query.QryBO_SiaeLookup.Fil"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
BLBO_Siae bl = pageBase.getBL(BLBO_Siae.class);
String codiceRichiedente = bl.findCodiceRichiedente(pageBase.getId()); 
%>

<v:dialog id="workstation_dialog" icon="siae.png" title="Configurazione SIAE" width="800" height="600" autofocus="false">
<jsp:include page="/resources/admin/siae/siae_alert.jsp" />

<v:widget caption="@Common.General" icon="profile.png">
  <v:widget-block>
    <v:form-field caption="Codice richiedente emissione sigillo" mandatory="true">
      <input class="form-control" id="codice-richiedente" type="text" readonly="readonly" value="<%= codiceRichiedente != null ? codiceRichiedente : ""%>" />
    </v:form-field>
  </v:widget-block>
</v:widget>

<script src="<v:config key="resources_url"/>/admin/script/siae.js"></script>
<script>
//# sourceURL=siae_workstation_dialog.jsp
$(document).ready(function() { 
  $(".default-focus").focus();
  var dlg = $("#workstation_dialog");
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      { 
    	  id:"btn-genera-codice-richiedente",
        text: <v:itl key="Genera codice richiedente" encode="JS"/>,
        click: doGenerateWorkstationCode,
        disabled: <%=JvString.getNull(codiceRichiedente) != null%>
      }, 
      {
        text: <v:itl key="@Common.Cancel" encode="JS"/>,
        click: doCloseDialog
      }
    ];
    
  });
  
  function doGenerateWorkstationCode() {
  	var reqDO = {
  	      Command: "GenerateWorkstationCode",
  	      GenerateWorkstationCode: {
  	        WorkstationId:  <%=JvString.jsString(pageBase.getId()) %>
  	    }
  	};
  	     
  	showWaitGlass();
  	vgsService("siae", reqDO, false, function(ansDO) {
  		 hideWaitGlass();
  	   showMessage("Codice richiedente: " + ansDO.Answer.GenerateWorkstationCode.CodiceRichiedente + " assegnato", function() {
  		   dlg.find("#codice-richiedente").val(ansDO.Answer.GenerateWorkstationCode.CodiceRichiedente);
  		   $("#btn-genera-codice-richiedente").attr("disabled", true);
  	     triggerEntityChange(<%=LkSNEntityType.SiaeWorkstation.getCode()%>);
  	     entitySaveNotification(<%=LkSNEntityType.Workstation.getCode()%>, <%=JvString.jsString(pageBase.getId())%>, "tab=main");
  	   });
  	});
  };
});
</script>
</v:dialog>