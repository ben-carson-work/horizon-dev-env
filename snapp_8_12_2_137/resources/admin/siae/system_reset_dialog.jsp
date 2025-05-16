<%@page import="com.vgs.snapp.lookup.LkSNEntityType"%>
<%@page import="com.vgs.web.library.BLBO_Siae"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
boolean canReset = pageBase.getBL(BLBO_Siae.class).canReset();

%>
<v:dialog id="system-reset-dialog" tabsView="true" width="800" title="SIAE - reset del sistema">

    <div class="tab-content">
      <v:widget>
        <v:widget-block>
          <v:alert-box type="warning" title="@Common.Warning">
            Questa procedura <b>cancellerà alcune tabelle SIAE</b> ed è resa disponibile solo per sistemi di test.<br/>
            <ul>
							<li>tbSiaeLogAbbonamento: codici abbonamento (<%=pageBase.getBL(BLBO_Siae.class).siaeLogAbbQty() %>)</li>
							<li>tbSiaeLog: sigilli (<%=pageBase.getBL(BLBO_Siae.class).siaeLogQty() %>)</li>
							<li>tbSiaeCard: smart card (<%=pageBase.getBL(BLBO_Siae.class).siaeCardQty() %>)</li>          
							<li>tbSiaeBox: verrà aggiornato il campo SiaeBoxUrl</li>         
							<li>tbSiaeSystem: dati di inizializzazione</li>
							<li>tbSiaeReport: riepiloghi (<%=pageBase.getBL(BLBO_Siae.class).siaeReportQty() %>)</li>       
            </ul>
            Verranno inoltre <b>disabilitati i task</b> lettura/invio email e generazione dei riepiloghi.<br/>
            La configurazione smtp/imap verrà aggiornata con parametri di test.<br/>
            Prima di procedere: <br/>
            <ul>
              <li>Effettuare una copia del DB</li>
              <li>Assicurarsi che questo <b>non sia un sito di produzione</b></li>
            </ul>
          </v:alert-box>
        </v:widget-block>
        <v:widget-block>
          <v:form-field caption="Siaebox test URL" mandatory="true">
            <v:input-text field="siae-box-url"/>
          </v:form-field>
       </v:widget-block>
      </v:widget>
    </div>

<script>
//# sourceURL=system_reset_dialog.jsp
$(document).ready(function() { 
  var dlg = $("#system-reset-dialog");
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = {
      <% if (canReset) { %>    
        <v:itl key="@Common.Reset" encode="JS"/>: doReset,
      <% } %>
      <v:itl key="@Common.Cancel" encode="JS"/>: doCloseDialog
    };
  });
  
  function doReset() {
	    confirmDialog(null, function() {
	      var reqDO = {
	        Command: "Reset",
	        Reset:{
	        	SiaeBoxUrl:$('#siae-box-url').val()
	        }
	      };

	      vgsService("Siae", reqDO, false, function(ansDO) {
	        showAsyncProcessDialog(ansDO.Answer.Reset.AsyncProcessId, function() {
	        	dlg.dialog("close");
	        	window.location.reload();
	        });
	      });
	    });  
	}
});
 </script>  

</v:dialog>