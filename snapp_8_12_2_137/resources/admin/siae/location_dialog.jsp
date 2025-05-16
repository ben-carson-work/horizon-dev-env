<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
BLBO_Siae bl = pageBase.getBL(BLBO_Siae.class);
BLBO_Account accountBl = pageBase.getBL(BLBO_Account.class);
DOSiaeLocation location = bl.isNewLocation(pageBase.getId()) ? bl.prepareNewLocation() : bl.loadLocation(pageBase.getId());
DOAccount account = accountBl.loadAccount(pageBase.getId());
request.setAttribute("location", location);
request.setAttribute("account", account);
boolean isEnabled = bl.isSiaeEnabled();
boolean isUsed = bl.isLocationUsed(pageBase.getId());
%>

<v:dialog id="location_dialog" icon="siae.png" title="Locale SIAE" width="800" height="600" autofocus="false">
<jsp:include page="/resources/admin/siae/siae_alert.jsp" />
<% if (isEnabled && isUsed) { %><div id="main-system-error" class="successbox">La modifica è limitata perché il locale è coinvolto in attività di vendita.</div><% } %>
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
      <snp:entity-link entityId="<%=account.AccountId.getString()%>" entityType="<%=LkSNEntityType.Location%>">
        <%=account.DisplayName%>
      </snp:entity-link>
    </v:form-field>
    <v:form-field caption="Codice locale SIAE" mandatory="true">
      <v:input-text enabled="<%=isEnabled && (!isUsed || rights.VGSSupport.getBoolean())%>" field="location.CodiceLocale" clazz="default-focus" required="" type="text" pattern="^\d+$" />
    </v:form-field>
    <v:form-field caption="Denominazione" mandatory="true">
      <v:input-text enabled="<%=isEnabled && !isUsed%>" field="location.Denominazione" required="" />
    </v:form-field>
    <v:form-field caption="Indirizzo">
      <v:input-text enabled="<%=isEnabled && !isUsed%>" field="location.Indirizzo"/>
    </v:form-field>
    <v:form-field caption="Citta">
      <v:input-text enabled="<%=isEnabled && !isUsed%>" field="location.Citta"/>
    </v:form-field>
    <v:form-field caption="Provincia">
      <v:input-text enabled="<%=isEnabled && !isUsed%>" field="location.Provincia"/>
    </v:form-field>
    <v:form-field caption="Capienza">
      <v:input-text enabled="<%=isEnabled%>" type="number" field="location.Capienza" placeholder="0" defaultValue="0" required="" min="0" max="2147483647" />
    </v:form-field>
  </v:widget-block>
</v:widget>
</div>

<script src="<v:config key="resources_url"/>/admin/script/siae.js"></script>
<script>

$(document).ready(function() {
  var formElements = $('#location_dialog').find(':input');
  monitorFormChange(formElements);
  
  var dlg = $("#location_dialog");
  dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      {
        text: <v:itl key="@Common.Save" encode="JS"/>,
        click: doSave,
        disabled: <%=!isEnabled%>
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

function doSave() {
  var formElements = $('#location_dialog').find(':input');
  var isDirty = formIsDirty(formElements);
  if (isDirty) {
    if (!formValidate(formElements)) {
      return;
    }
    var reqDO = {
        Command: "SaveLocation",
        SaveLocation: {
          Location: {
            LocationId: <%=JvString.jsString(pageBase.getId())%>,
            CodiceLocale: $('#location\\.CodiceLocale').val(),
            Denominazione: $('#location\\.Denominazione').val(),
            Indirizzo: $('#location\\.Indirizzo').val(),
            Citta: $('#location\\.Citta').val(),
            Provincia: $('#location\\.Provincia').val(),
            Capienza: $('#location\\.Capienza').val(),
          }
        }
      };
    vgsService("siae", reqDO, false, function(ansDO) {
      triggerEntityChange(<%=LkSNEntityType.SiaeLocation.getCode()%>);
      $("#location_dialog").dialog("close");
    });
  } else {
    $("#location_dialog").dialog("close");
  }
};
</script>

</v:dialog>