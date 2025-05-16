<%@page import="com.vgs.web.library.BLBO_Survey"%>
<%@page import="com.vgs.snapp.query.QryBO_Mask"%>
<%@page import="com.vgs.web.library.BLBO_MetaData"%>
<%@page import="com.vgs.snapp.query.QryBO_Category"%>
<%@page import="com.vgs.snapp.query.QryBO_DocTemplate"%>
<%@page import="com.vgs.cl.JvDataSet"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.QueryDef"%>
<%@page import="com.vgs.snapp.query.QryBO_Survey"%>
<%@page import="com.vgs.service.dataobject.DOCmd_Siae"%>
<%@page import="com.vgs.web.library.BLBO_Siae"%>
<%@page import="com.vgs.web.library.BLBO_DocTemplate"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageSiaeConfig" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
BLBO_Siae bl = pageBase.getBLDef();

QueryDef qdef = new QueryDef(QryBO_Survey.class);
qdef.addSelect(QryBO_Survey.Sel.SurveyId);
qdef.addSelect(QryBO_Survey.Sel.SurveyName);
qdef.addSort(QryBO_Survey.Sel.SurveyName);
JvDataSet ds = pageBase.execQuery(qdef);

QueryDef qdefAR = new QueryDef(QryBO_Mask.class);
qdefAR.addSelect(QryBO_Mask.Sel.MaskId);
qdefAR.addSelect(QryBO_Mask.Sel.MaskName);
int[] entityCodes = new int[] {LkSNEntityType.Licensee.getCode(), LkSNEntityType.Location.getCode(), LkSNEntityType.Organization.getCode(), LkSNEntityType.Person.getCode(), LkSNEntityType.Association.getCode()};
qdefAR.addFilter(QryBO_Mask.Fil.EntityType, LkSNEntityType.Person.getCode());
qdefAR.addSort(QryBO_Mask.Sel.MaskName);
JvDataSet dsAR = pageBase.execQuery(qdefAR);

JvDataSet dsTR = pageBase.getBL(BLBO_Survey.class).getMaskDSBySurveyType(LkSNSurveyType.Transaction);

QueryDef qdefTRSurvey = new QueryDef(QryBO_Survey.class);
qdefTRSurvey.addSelect(QryBO_Survey.Sel.SurveyId);
qdefTRSurvey.addSelect(QryBO_Survey.Sel.SurveyName);
qdefTRSurvey.addFilter(QryBO_Survey.Fil.SurveyType, LkSNSurveyType.Transaction.getCode());
qdefTRSurvey.addSort(QryBO_Survey.Sel.SurveyName);
JvDataSet dsTRSurvey = pageBase.execQuery(qdefTRSurvey);


BLBO_DocTemplate blDocTemplate = pageBase.getBL(BLBO_DocTemplate.class);
boolean canEdit = bl.isSiaeEnabled();
boolean canEditVgs = rights.VGSSupport.getBoolean();
%>

<div class="tab-toolbar">
  <v:button id="save-btn" caption="@Common.Save" fa="save" enabled="<%=canEdit%>" />
</div>

<div class="tab-content">

  <v:widget caption="Email account">
    <v:widget-block> 
      <v:form-field caption="@Common.User"><v:input-text field="mail-auth-username" enabled="<%=canEdit%>"/></v:form-field>
      <v:form-field caption="@Common.Password"><v:input-text type='password' field="mail-auth-password" enabled="<%=canEdit%>"/></v:form-field>
    </v:widget-block>  
  </v:widget>

  <v:widget caption="@SmtpSettings.SmtpSettings">
    <v:widget-block> 
      <v:form-field caption="@SmtpSettings.SmtpHost"><v:input-text field="mail-smtp-host"  enabled="<%=canEdit%>"/></v:form-field>
      <v:form-field caption="@SmtpSettings.SmtpPort"><v:input-text field="mail-smtp-port" enabled="<%=canEdit%>"/></v:form-field>
      <v:form-field caption="CC recipient"><v:input-text field="mail-debug-to" enabled="<%=canEdit%>"/></v:form-field>
      <v:form-field>
        <v:db-checkbox field="mail-smtp-auth" caption="@SmtpSettings.SmtpAuth" value="true"  enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field>
        <v:db-checkbox field="mail-smtp-starttls-enable" caption="@SmtpSettings.SmtpStartTLS" value="true"  enabled="<%=canEdit%>"/>
      </v:form-field>
    </v:widget-block>  
  </v:widget>
  
  <v:widget caption="@ImapSettings.ImapSettings">
    <v:widget-block> 
      <v:form-field caption="@ImapSettings.ImapHost"><v:input-text field="mail-imap-host"  enabled="<%=canEdit%>"/></v:form-field>
      <v:form-field caption="@ImapSettings.ImapPort"><v:input-text field="mail-imap-port" enabled="<%=canEdit%>"/></v:form-field>
      <v:form-field>
        <v:db-checkbox field="mail-imap-SSL" caption="@ImapSettings.ImapSSL" value="true" enabled="<%=canEdit%>"/>
      </v:form-field>
	    <v:form-field>
	      <v:db-checkbox hint="Attiva l'autorizzazione OAuth2.0 tramite token per accedere all'imap di office365" field="mail-imap-o365" caption="Office365 OAuth2.0" value="true" enabled="<%=canEdit%>"/>
		    <v:widget-block visibilityController="#mail-imap-o365" id="office365-oauth-params">
		      <v:form-field hint="Identificativo univoco associato all' organizzazione" caption="Tenant Id"><v:input-text field="mail-imap-o365-tenant-id" enabled="<%=canEdit%>"/></v:form-field>
		      <v:form-field hint="Identificativo univoco associato all' applicazione autorizzata (Application Id)"  caption="Client Id"><v:input-text field="mail-imap-o365-client-id" enabled="<%=canEdit%>"/></v:form-field>
		      <v:form-field hint="Codice univoco associato all' applicazione autorizzata" caption="Client secret"><v:input-text field="mail-imap-o365-client-secret" type='password' enabled="<%=canEdit%>"/></v:form-field>
		    </v:widget-block>
	    </v:form-field>
	    <v:form-field>
	      <v:db-checkbox hint="Traccia sia le connessioni che i risultati delle autorizzazioni" field="mail-imap-debug" caption="Debug mode" value="true" enabled="<%=canEdit%>"/>
	    </v:form-field>
   </v:widget-block>
     
  </v:widget>

  <v:widget caption="@Common.CDBurner">
    <v:widget-block> 
      <v:form-field caption="@Common.BurnReportAfterHours"><v:input-text field="burn-report-after-hours" enabled="<%=canEdit%>"/></v:form-field>
   </v:widget-block>  
  </v:widget>
  
  <v:widget caption="Void mask">
    <v:widget-block>
      <div class="form-field">
        <div class="form-field-caption">Void mask: </div>
        <div class="form-field-value">
          <v:combobox field="survey-id" idFieldName="SurveyId" captionFieldName="SurveyName" lookupDataSet="<%=ds %>" allowNull="false" enabled="<%=canEditVgs%>" />
        </div>
      </div>
      <div class="form-field">
        <div class="form-field-caption">Void mask field:</div>
        <div class="form-field-value">
          <select id="survey-field-id" class="form-control" <%if (!canEditVgs) { %> disabled<% } %>>
          </select>
        </div>
      </div>
    </v:widget-block>
  </v:widget>
  
  <v:widget caption="Riepiloghi">
    <v:widget-block>
      <div class="form-field">
        <div class="form-field-caption">C1 giornaliero: </div>
        <div class="form-field-value">
          <v:combobox field="c1-day-id" idFieldName="DocTemplateId" captionFieldName="DocTemplateName" lookupDataSet="<%=blDocTemplate.getAllDocTemplatesDS()%>" allowNull="false" enabled="<%=canEditVgs%>" />
        </div>
      </div>
      <div class="form-field">
        <div class="form-field-caption">C1 mensile: </div>
        <div class="form-field-value">
          <v:combobox field="c1-month-id" idFieldName="DocTemplateId" captionFieldName="DocTemplateName" lookupDataSet="<%=blDocTemplate.getAllDocTemplatesDS()%>" allowNull="false" enabled="<%=canEditVgs%>" />
        </div>
      </div>
      <div class="form-field">
        <div class="form-field-caption">C2 giornaliero: </div>
        <div class="form-field-value">
          <v:combobox field="c2-day-id" idFieldName="DocTemplateId" captionFieldName="DocTemplateName" lookupDataSet="<%=blDocTemplate.getAllDocTemplatesDS()%>" allowNull="false" enabled="<%=canEditVgs%>" />
        </div>
      </div>
      <div class="form-field">
        <div class="form-field-caption">C2 mensile: </div>
        <div class="form-field-value">
          <v:combobox field="c2-month-id" idFieldName="DocTemplateId" captionFieldName="DocTemplateName" lookupDataSet="<%=blDocTemplate.getAllDocTemplatesDS()%>" allowNull="false" enabled="<%=canEditVgs%>" />
        </div>
      </div>
    </v:widget-block>
  </v:widget>
  
  <v:widget caption="Registrazione acquirente">
    <v:widget-block>
      <v:form-field caption="Soglia capienza"><v:input-text field="registrazione-soglia-capienza" enabled="<%=false%>"/></v:form-field>
      <v:form-field caption="Tipi evento"><v:input-text field="registrazione-tipi-evento" enabled="<%=false%>"/></v:form-field>
      <v:form-field caption="Max biglietti"><v:input-text field="registrazione-max-biglietti" enabled="<%=false%>"/></v:form-field>
      <v:form-field caption="Maschera anagrafica">
        <v:combobox field="ar-registration-form-id" idFieldName="MaskId" captionFieldName="MaskName" lookupDataSet="<%=dsAR %>" allowNull="false" enabled="<%=canEditVgs%>" />
      </v:form-field>
   
      <% JvDataSet dsARIPReg = pageBase.getBL(BLBO_MetaData.class).getMetaFieldDS(); %>
      <v:form-field caption="Indirizzo IP registrazione">
        <v:combobox field="ar-registration-ip-id" lookupDataSet="<%=dsARIPReg%>" idFieldName="MetaFieldId" captionFieldName="MetaFieldName" linkEntityType="<%=LkSNEntityType.MetaField%>" enabled="<%=canEditVgs%>"/>
      </v:form-field>
   
      <% JvDataSet dsARDateTimeReg = pageBase.getBL(BLBO_MetaData.class).getMetaFieldDS(); %>
      <v:form-field caption="Data/ora registrazione">
        <v:combobox field="ar-registration-datetime-id" lookupDataSet="<%=dsARDateTimeReg%>" idFieldName="MetaFieldId" captionFieldName="MetaFieldName" linkEntityType="<%=LkSNEntityType.MetaField%>" enabled="<%=canEditVgs%>"/>
      </v:form-field>
      
      <% JvDataSet dsARAUTReg = pageBase.getBL(BLBO_MetaData.class).getMetaFieldDS(); %>
      <v:form-field caption="Tipo autenticazione">
        <v:combobox field="ar-registration-auth-id" lookupDataSet="<%=dsARAUTReg%>" idFieldName="MetaFieldId" captionFieldName="MetaFieldName" linkEntityType="<%=LkSNEntityType.MetaField%>" enabled="<%=canEditVgs%>"/>
      </v:form-field>
      
   
    </v:widget-block>
  </v:widget>
  
  <v:widget caption="Transazione acquirente">
    <v:widget-block>
      <v:form-field caption="Survey">
        <v:combobox field="tr-transaction-survey-id" idFieldName="SurveyId" captionFieldName="SurveyName" lookupDataSet="<%=dsTRSurvey %>" allowNull="false" enabled="<%=canEditVgs%>" />
      </v:form-field>
    
      <v:form-field caption="Maschera anagrafica">
        <v:combobox field="tr-registration-form-id" idFieldName="MaskId" captionFieldName="MaskName" lookupDataSet="<%=dsTR %>" allowNull="false" enabled="<%=canEditVgs%>" />
      </v:form-field>
     
      <% JvDataSet dsATIPReg = pageBase.getBL(BLBO_MetaData.class).getMetaFieldDS(); %>
      <v:form-field caption="Idirizzo IP transazione">
        <v:combobox field="at-transaction-ip-id" lookupDataSet="<%=dsATIPReg%>" idFieldName="MetaFieldId" captionFieldName="MetaFieldName" linkEntityType="<%=LkSNEntityType.MetaField%>" enabled="<%=canEditVgs%>"/>
      </v:form-field>
      
      <% JvDataSet dsATCellNum = pageBase.getBL(BLBO_MetaData.class).getMetaFieldDS(); %>
      <v:form-field caption="Cellulare acquirente">
        <v:combobox field="at-transaction-cellnumber-id" lookupDataSet="<%=dsATCellNum%>" idFieldName="MetaFieldId" captionFieldName="MetaFieldName" linkEntityType="<%=LkSNEntityType.MetaField%>" enabled="<%=canEditVgs%>"/>
      </v:form-field>
      
      <% JvDataSet dsATEmail = pageBase.getBL(BLBO_MetaData.class).getMetaFieldDS(); %>
      <v:form-field caption="EMail acquirente">
        <v:combobox field="at-transaction-email-id" lookupDataSet="<%=dsATEmail%>" idFieldName="MetaFieldId" captionFieldName="MetaFieldName" linkEntityType="<%=LkSNEntityType.MetaField%>" enabled="<%=canEditVgs%>"/>
      </v:form-field>
      
      <% JvDataSet dsATDateTimeStartCO = pageBase.getBL(BLBO_MetaData.class).getMetaFieldDS(); %>
      <v:form-field caption="Data/ora inizio checkout">
        <v:combobox field="at-transaction-datetimestartcheckout-id" lookupDataSet="<%=dsATDateTimeStartCO%>" idFieldName="MetaFieldId" captionFieldName="MetaFieldName" linkEntityType="<%=LkSNEntityType.MetaField%>" enabled="<%=canEditVgs%>"/>
      </v:form-field>

      <% JvDataSet dsATDateTimePayment = pageBase.getBL(BLBO_MetaData.class).getMetaFieldDS(); %>
      <v:form-field caption="Data/ora esecuzione pagamento">
        <v:combobox field="at-transaction-datetimepayment-id" lookupDataSet="<%=dsATDateTimePayment%>" idFieldName="MetaFieldId" captionFieldName="MetaFieldName" linkEntityType="<%=LkSNEntityType.MetaField%>" enabled="<%=canEditVgs%>"/>
      </v:form-field>
      
      <% JvDataSet dsATCRO = pageBase.getBL(BLBO_MetaData.class).getMetaFieldDS(); %>
      <v:form-field caption="CRO">
        <v:combobox field="at-transaction-cro-id" lookupDataSet="<%=dsATCRO%>" idFieldName="MetaFieldId" captionFieldName="MetaFieldName" linkEntityType="<%=LkSNEntityType.MetaField%>" enabled="<%=canEditVgs%>"/>
      </v:form-field>
      
      <% JvDataSet dsATShipmentType = pageBase.getBL(BLBO_MetaData.class).getMetaFieldDS(); %>
      <v:form-field caption="Metodo spedizione titolo">
        <v:combobox field="at-transaction-shipmenttype-id" lookupDataSet="<%=dsATShipmentType%>" idFieldName="MetaFieldId" captionFieldName="MetaFieldName" linkEntityType="<%=LkSNEntityType.MetaField%>" enabled="<%=canEditVgs%>"/>
      </v:form-field>
      
      <% JvDataSet dsDateTimeReg = pageBase.getBL(BLBO_MetaData.class).getMetaFieldDS(); %>
      <v:form-field caption="Indirizzo spedizione titolo">
        <v:combobox field="at-transaction-shipmentaddress-id" lookupDataSet="<%=dsDateTimeReg%>" idFieldName="MetaFieldId" captionFieldName="MetaFieldName" linkEntityType="<%=LkSNEntityType.MetaField%>" enabled="<%=canEditVgs%>"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>
  
    <v:widget caption="Biglietto nominativo">
    <v:widget-block>
      <v:form-field caption="Soglia capienza"><v:input-text field="nominativo-soglia-capienza" enabled="<%=false%>"/></v:form-field>
      <v:form-field caption="Tipi evento"><v:input-text field="nominativo-tipi-evento" enabled="<%=false%>"/></v:form-field>
    </v:widget-block>
  </v:widget>
  
  <v:widget caption="Prodotti">
    <v:widget-block>
      <v:form-field caption="Soglia prezzo irrisorio"><v:input-text field="soglia-prezzo-irrisorio" enabled="<%=canEditVgs%>"/></v:form-field>
    </v:widget-block>
  </v:widget>
  
</div>

<script>



(function() {
  var isEnabled = <%=canEdit%>;
  var params = {};
  var param = {};
  
  if (isEnabled) {
    $('#survey-id').change(doGetSurveyFields);
    $('#save-btn').click(doSave);
  }

<% for (DOCmd_Siae.DOSiaeParam param: pageBase.getBL(BLBO_Siae.class).getParams()) { %>
     param = <%=param.getJSONString()%>; 
     params[param.Key] = param.Value;
<% } %>

    $('#mail-auth-username').val(params['mail.auth.username']);
    $('#mail-auth-password').val(params['mail.auth.password']);
    $('#mail-debug-to').val(params['mail.debug.to']);    

    $('#mail-smtp-host').val(params['mail.smtp.host']);
    $('#mail-smtp-port').val(params['mail.smtp.port']);
    $('#mail-smtp-auth').prop('checked', (params['mail.smtp.auth'] == 'True' || params['mail.smtp.auth'] == 'true' || params['mail.smtp.auth'] == '1'));
    $('#mail-smtp-starttls-enable').prop('checked', (params['mail.smtp.starttls.enable'] == 'True' || params['mail.smtp.starttls.enable'] == 'true' || params['mail.smtp.starttls.enable'] == 1));

    $('#mail-imap-host').val(params['mail.imap.host']);
    $('#mail-imap-port').val(params['mail.imap.port']);
    $('#mail-imap-SSL').prop('checked', (params['mail.imap.SSL'] == 'True' || params['mail.imap.SSL'] == 'true' || params['mail.imap.SSL'] == 1));
    
    $('#mail-imap-o365').prop('checked', (params['mail.imap.o365'] == 'True' || params['mail.imap.o365'] == 'true' || params['mail.imap.o365'] == 1));
    $('#mail-imap-o365-tenant-id').val(params['mail.imap.o365.tenant.id']);
    $('#mail-imap-o365-client-id').val(params['mail.imap.o365.client.id']);
    $('#mail-imap-o365-client-secret').val(params['mail.imap.o365.client.secret']);
    
    $('#mail-imap-debug').prop('checked', (params['mail.imap.debug'] == 'True' || params['mail.imap.debug'] == 'true' || params['mail.imap.debug'] == 1));
    
    $('#burn-report-after-hours').val(params['BURN_REPORTS_AFTER_HOURS']);
    
    $('#registrazione-soglia-capienza').val('1000');
    $('#registrazione-tipi-evento').val('01,04,05,06,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,30,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,64,65,67,68,74,75,76,77,78,91');    
    $('#registrazione-max-biglietti').val('10');
    
    $('#ar_autentication_type').val("OTP");
    
    if (params['ar-registration-form-id']) 
        $('#ar-registration-form-id option[value="{0}"]'.format(params['ar-registration-form-id'])).prop('selected', true);
    
    if (params['ar-registration-ip-id'])
    	$('#ar-registration-ip-id option[value="{0}"]'.format(params['ar-registration-ip-id'])).prop('selected', true);
      
    if (params['ar-registration-datetime-id'])
    	$('#ar-registration-datetime-id option[value="{0}"]'.format(params['ar-registration-datetime-id'])).prop('selected', true);
    
    if (params['ar-registration-auth-id'])
      $('#ar-registration-auth-id option[value="{0}"]'.format(params['ar-registration-auth-id'])).prop('selected', true);
    
    if (params['tr-transaction-survey-id']) 
      $('#tr-transaction-survey-id option[value="{0}"]'.format(params['tr-transaction-survey-id'])).prop('selected', true);
    
    if (params['tr-registration-form-id']) 
      $('#tr-registration-form-id option[value="{0}"]'.format(params['tr-registration-form-id'])).prop('selected', true);
    
    if (params['at-transaction-ip-id']) 
    	$('#at-transaction-ip-id option[value="{0}"]'.format(params['at-transaction-ip-id'])).prop('selected', true);
    
    if (params['at-transaction-cellnumber-id']) 
    	$('#at-transaction-cellnumber-id option[value="{0}"]'.format(params['at-transaction-cellnumber-id'])).prop('selected', true);
    
    if (params['at-transaction-email-id']) 
    	$('#at-transaction-email-id option[value="{0}"]'.format(params['at-transaction-email-id'])).prop('selected', true);
    
    if (params['at-transaction-datetimestartcheckout-id']) 
    	$('#at-transaction-datetimestartcheckout-id option[value="{0}"]'.format(params['at-transaction-datetimestartcheckout-id'])).prop('selected', true);
    
    if (params['at-transaction-datetimepayment-id']) 
    	$('#at-transaction-datetimepayment-id option[value="{0}"]'.format(params['at-transaction-datetimepayment-id'])).prop('selected', true);
    
    if (params['at-transaction-cro-id']) 
    	$('#at-transaction-cro-id option[value="{0}"]'.format(params['at-transaction-cro-id'])).prop('selected', true);
    
    if (params['at-transaction-shipmenttype-id']) 
    	$('#at-transaction-shipmenttype-id option[value="{0}"]'.format(params['at-transaction-shipmenttype-id'])).prop('selected', true);
    
    if (params['at-transaction-shipmentaddress-id']) 
    	$('#at-transaction-shipmentaddress-id option[value="{0}"]'.format(params['at-transaction-shipmentaddress-id'])).prop('selected', true);
    
    $('#nominativo-soglia-capienza').val('5000');   
    $('#nominativo-tipi-evento').val('01,04,53,54,56,57,60,61,64,65');      
        
    $('#soglia-prezzo-irrisorio').val(params['soglia-prezzo-irrisorio']);
    
    if (params['SURVEY_ID']) {
      $('#survey-id option[value="{0}"]'.format(params['SURVEY_ID'])).prop('selected', true);
    }
    
    doGetSurveyFields();
    if (params['C1_DAY_ID']) {
      $('#c1-day-id option[value="{0}"]'.format(params['C1_DAY_ID'])).prop('selected', true);
    }
    if (params['C1_MONTH_ID']) {
      $('#c1-month-id option[value="{0}"]'.format(params['C1_MONTH_ID'])).prop('selected', true);
    }
    if (params['C2_DAY_ID']) {
      $('#c2-day-id option[value="{0}"]'.format(params['C2_DAY_ID'])).prop('selected', true);
    }
    if (params['C2_MONTH_ID']) {
      $('#c2-month-id option[value="{0}"]'.format(params['C2_MONTH_ID'])).prop('selected', true);
    }
    
  function doSave() {
    params['mail.auth.username']            = $('#mail-auth-username').val();
    params['mail.auth.password']            = $('#mail-auth-password').val();
    params['mail.smtp.host']                = $('#mail-smtp-host').val();
    params['mail.smtp.port']                = $('#mail-smtp-port').val();
    params['mail.smtp.auth']                = $('#mail-smtp-auth').isChecked();
    params['mail.smtp.starttls.enable']     = $('#mail-smtp-starttls-enable').isChecked();
    params['mail.debug.to']                 = $('#mail-debug-to').val();
    params['mail.imap.host']                = $('#mail-imap-host').val();
    params['mail.imap.port']                = $('#mail-imap-port').val();
    params['mail.imap.SSL']                 = $('#mail-imap-SSL').isChecked();
    params['mail.imap.o365']                = $('#mail-imap-o365').isChecked();
    params['mail.imap.o365.tenant.id']      = $('#mail-imap-o365-tenant-id').val();
    params['mail.imap.o365.client.id']      = $('#mail-imap-o365-client-id').val();
    params['mail.imap.o365.client.secret']  = $('#mail-imap-o365-client-secret').val(); 
    params['mail.imap.debug']               = $('#mail-imap-debug').isChecked();
    
    params['BURN_REPORTS_AFTER_HOURS']      = $('#burn-report-after-hours').val();
    params['soglia-prezzo-irrisorio']       = $('#soglia-prezzo-irrisorio').val();
    
    if ($('#survey-id').val()) {
      params['SURVEY_ID'] = $('#survey-id').val();
    }
    if ($('#survey-field-id').val()) {
      params['SURVEY_FIELD_ID'] = $('#survey-field-id').val();
    }
    
    params['C1_DAY_ID'] = $('#c1-day-id').val();
    params['C1_MONTH_ID'] = $('#c1-month-id').val();
    params['C2_DAY_ID'] = $('#c2-day-id').val();
    params['C2_MONTH_ID'] = $('#c2-month-id').val();
    
    if ($('#ar-registration-form-id').val()) 
      params['ar-registration-form-id'] = $('#ar-registration-form-id').val();
    
    if ($('#ar-registration-ip-id').val())
      params['ar-registration-ip-id'] = $('#ar-registration-ip-id').val();
    
    if ($('#ar-registration-datetime-id').val())
      params['ar-registration-datetime-id'] = $('#ar-registration-datetime-id').val();
    
    if ($('#ar-registration-auth-id').val())
      params['ar-registration-auth-id'] = $('#ar-registration-auth-id').val();
    
    if ($('#tr-transaction-survey-id').val()) 
      params['tr-transaction-survey-id'] = $('#tr-transaction-survey-id').val();
    
    if ($('#tr-registration-form-id').val()) 
      params['tr-registration-form-id'] = $('#tr-registration-form-id').val();
    
    if ($('#at-transaction-ip-id').val())
      params['at-transaction-ip-id'] = $('#at-transaction-ip-id').val();
    
    if ($('#at-transaction-cellnumber-id').val())
      params['at-transaction-cellnumber-id'] = $('#at-transaction-cellnumber-id').val();
    
    if ($('#at-transaction-email-id').val())
      params['at-transaction-email-id'] = $('#at-transaction-email-id').val();
    
    if ($('#at-transaction-datetimestartcheckout-id').val())
      params['at-transaction-datetimestartcheckout-id'] = $('#at-transaction-datetimestartcheckout-id').val();
    
    if ($('#at-transaction-datetimepayment-id').val())
      params['at-transaction-datetimepayment-id'] = $('#at-transaction-datetimepayment-id').val();
    
    if ($('#at-transaction-cro-id').val())
      params['at-transaction-cro-id'] = $('#at-transaction-cro-id').val();
    
    if ($('#at-transaction-shipmenttype-id').val())
      params['at-transaction-shipmenttype-id'] = $('#at-transaction-shipmenttype-id').val();
    
    if ($('#at-transaction-shipmentaddress-id').val())
      params['at-transaction-shipmentaddress-id'] = $('#at-transaction-shipmentaddress-id').val();      
    
    var array = $.map(params, function(value, key) {
      return [{Key: key, Value: value}]
    });

    var reqDO = {
        Command: "SaveConfig",
        SaveConfig: {
          Params: array
        }
      };
      
      vgsService("Siae", reqDO, false, function(ansDO) {
        showMessage("<v:itl key="@Common.SaveSuccessMsg"/>", function() {
            window.location.reload();
        });
      });
  };
  
  function doGetSurveyFields() {
    $('#survey-field-id').children().remove();
    
    var reqDO = {
      Command: "GetSurveyFields",
      GetSurveyFields: {
        SurveyId: $('#survey-id').val()
      }
    };

    vgsService("Siae", reqDO, false, function(ansDO) {
      for (var i = 0; i < ansDO.Answer.GetSurveyFields.Fields.length; ++i) {
        var field = ansDO.Answer.GetSurveyFields.Fields[i];
        var option = $('<option>').val(field.MetaFieldId).text(field.MetaFieldName).appendTo('#survey-field-id');
        if (params['SURVEY_FIELD_ID'] === field.MetaFieldId) {
          option.prop('selected', true);
        }
      }
    });
  };
  
})();

</script>