<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<%
BLBO_Siae bl = pageBase.getBL(BLBO_Siae.class);
BLBO_Account accountBl = pageBase.getBL(BLBO_Account.class);
DOSiaeOrganizer organizer = bl.isNewOrganizer(pageBase.getId()) ? bl.prepareNewOrganizer() : bl.loadOrganizer(pageBase.getId());
DOAccount account = accountBl.loadAccount(pageBase.getId());
request.setAttribute("organizer", organizer);
request.setAttribute("account", account);
boolean isEnabled = bl.isSiaeEnabled();
boolean isUsed = bl.isOrganizerUsed(pageBase.getId());
%>

<v:dialog id="organizer_dialog" icon="siae.png" title="Organizzatore SIAE" width="800" height="600" autofocus="false">
<jsp:include page="/resources/admin/siae/siae_alert.jsp" />
<% if (isEnabled && isUsed) { %><div id="main-system-error" class="successbox">La modifica non è consentita, perché organizzatore gia ha emesso i biglietti.</div><% } %>
<div class="profile-pic-div">
  <snp:profile-pic entityId="<%=pageBase.getId()%>" entityType="<%=account.EntityType.getLkValue()%>" field="account.ProfilePictureId" enabled="false"/>
</div>
<div class="profile-cont-div">
<v:widget caption="@Common.General" icon="profile.png">
  <v:widget-block>
    <v:form-field caption="@Common.Code" mandatory="true">
      <v:input-text field="account.AccountCode" placeholder="<%=account.AccountCode.getHtmlString()%>" enabled="false" />
    </v:form-field>
    <v:form-field caption="@Common.Name" mandatory="true">
      <snp:entity-link entityId="<%=account.AccountId.getString()%>" entityType="<%=LkSNEntityType.Organization%>">
        <%=account.DisplayName%>
      </snp:entity-link>
    </v:form-field>
    <v:form-field caption="Denominazione" mandatory="true">
      <v:input-text enabled="<%=isEnabled && !isUsed %>" field="organizer.Denominazione" clazz="default-focus" required=""  />
    </v:form-field>
    <v:form-field caption="Codice fiscale / P. IVA">
      <v:input-text enabled="<%=isEnabled && !isUsed %>" field="organizer.CodiceFiscale" />
    </v:form-field>
  </v:widget-block>
</v:widget>
</div>

<script src="<v:config key="resources_url"/>/admin/script/siae.js"></script>
<script>
//# sourceURL=organizer_dialog.jsp
$(document).ready(function() {
  $(".default-focus").focus();
  var formElements = $('#organizer_dialog').find(':input');
  monitorFormChange(formElements);

  var dlg = $("#organizer_dialog");
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      {
        text: <v:itl key="@Common.Save" encode="JS"/>,
        click: doSave,
        disabled: <%=!isEnabled || isUsed %>
      }, 
      {
        text: <v:itl key="@Common.Cancel" encode="JS"/>,
        click: doCloseDialog
      }
    ];
    setTimeout(function() {
      $(".default-focus").focus();
    }, 1);
  });
});


function validate_regularCF(cf) {
	if (cf.length != 16) 
		return true;
	
  if( (/^[a-zA-Z]+$/.test(cf)) || (/^[0-9]+$/.test(cf)) )
    return true;
  
  var s = 0;
  var even_map = "BAFHJNPRTVCESULDGIMOQKWZYX";
  for(var i = 0; i < 15; i++){
    var c = cf[i];
    var n = 0;
    if( "0" <= c && c <= "9" )
      n = c.charCodeAt(0) - "0".charCodeAt(0);
    else
      n = c.charCodeAt(0) - "A".charCodeAt(0);
    if( (i & 1) === 0 )
      n = even_map.charCodeAt(n) - "A".charCodeAt(0);
    s += n;
  }
  if( s%26 + "A".charCodeAt(0) !== cf.charCodeAt(15) )
    return false;
  
  return true;
}

function save() {
	 var reqDO = {
    Command: "SaveOrganizer",
    SaveOrganizer: {
      Organizer: {
        OrganizerId: <%=JvString.jsString(pageBase.getId()) %>,
        Denominazione: $('#organizer\\.Denominazione').val(),
        CodiceFiscale: $('#organizer\\.CodiceFiscale').val(),
        TipoOrganizzatore: 'G'
      }
    }
  };
  vgsService("siae", reqDO, false, function(ansDO) {
    triggerEntityChange(<%=LkSNEntityType.SiaeOrganizer.getCode()%>);
    $("#organizer_dialog").dialog("close");
  });
}

function doSave() {
  var formElements = $('#organizer_dialog').find(':input');
  var isDirty = formIsDirty(formElements);
  if (isDirty) {
    if (!formValidate(formElements)) {
      return;
    }
    
    var strCF = $('#organizer\\.CodiceFiscale').val();
    var cfIsValid = validate_regularCF(strCF);
    if (!cfIsValid) {
    	confirmDialog('Codice fiscale non conforme, salvarlo ugualmente?', function() {
    	  save();	
    	});
    } else {    
      save(); 
    }
    
  } else {
    $("#organizer_dialog").dialog("close");
  }
};
</script>
</v:dialog>