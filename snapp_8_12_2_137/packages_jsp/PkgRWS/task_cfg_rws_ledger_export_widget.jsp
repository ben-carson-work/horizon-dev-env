<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="java.text.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTask" scope="request"/>
<jsp:useBean id="task" class="com.vgs.snapp.dataobject.DOTask" scope="request"/>

<%
JvDocument cfg = (JvDocument)request.getAttribute("cfg");
request.setAttribute("cfgftp", cfg.getChildNode("FtpConfig"));
String currentPtsValue = cfg.getChildNode("ptsTypeFilter").toString();
%>

<v:widget caption="Info">
  <v:widget-block>
    <p>
    	The purpose of this task is to export General Ledger movements that correspond to either a specific <b>Ledger Type</b> or <b>PTS Type</b>.<br/>
    	On top of a general file format that gets information based on those movements this file will also grab information from different MetaFields that correspond to ledger Movement that need to be attached to the ledger.<br/>
    	These Meta fields must be defined and are listed in the configuration. This file can either be run based on Execution Date, current Fiscal Date, or Previous Fiscal Date. <br/>
    	<b>Note:</b>Fiscal date is relative to the licensee time zone settings (server time-zone is not considered)<br/>
    </p>
   	<p>
    	The files are named with the naming convention <b>PTS_Entity_Type_Date_SequenceID</b> 
    	where <b>Entity</b> is based on the corresponding Entity MetaField on the Ledger. <b>Type</b> is the type of file and <b>YYYYMMDD</b> is the date the file is being run on (Not it's Fiscal Date).
    	<b>Note:</b> for the name of the file (and specific headers in the file) if it's one of the 6 types listed below it will have a specific naming convention, for anything different/ added the Type will be <b>CUSTOM</b>.<br/>
      <ol>
        <li>PTS-Type = ATTRACTIONS</li>
        <li>PTS-Type = RTL</li>
        <li>PTS-Type = FNB</li>
        <li>Ledger Type = Amortization</li>
        <li>Ledger Type = Expiration and/or Clearing</li>
        <li>Ledger Type = Manual Ledger</li>
      </ol>
       <b>Note:</b> If the file is already exiting on the FTP destination, it will be replaced. <br/>
       <b>Note:</b> If the Entity field isn't properly linked we will have a default of RWSPL used for the File Headers and the name of the file, but it won't show up throughout the entire file. <br/>
    </p>
    <p>
      Each file contains a section for the <b>File Header</b>, the <b>Journal Header</b>, the <b>Journal Line</b> and the <b>File Footer</b>.<br/>
      Lines are separated with <i>line-feed</i> (ASCII code 10)<br/>
      Files are encoded in UTF-8.<br/>
    </p>
  </v:widget-block>
  
</v:widget> 
<v:widget caption="@Common.Configuration">
  <v:widget-block>
    <v:form-field caption="Fiscal date" hint="When set, it's the fiscal date the report will be ran on. When not set, \"Fiscal date rule\" will be used. Field will be automatically emptied at each task execution." mandatory="false">
      <v:input-text field="cfg.FixedFiscalDate" type="datepicker" placeholder="Default" clazz="rws-field"/>
    </v:form-field>
    <v:form-field caption="Fiscal date rule" hint="The Fiscal Date that this report will be run on" mandatory="false">
      <v:lk-combobox field="cfg.FiscalDate" lookup="<%=LkSN.LedgerRegDateTimeRule%>" clazz="rws-field" allowNull="false"/>
    </v:form-field>
  </v:widget-block>
	<v:widget-block>
		<v:form-field caption="ENTITY">
	      <v:input-text field="cfg.ENTITY" placeholder="RWSPL" clazz="rws-field"/>
	    </v:form-field>
    	<v:form-field caption="PTS_TYPE" hint="Workstation Meta Field mapped to PTS_TYPE column" mandatory="true">
	      	<snp:dyncombo field="cfg.MetaFieldId_PTS_TYPE" clazz="rws-field" entityType="<%=LkSNEntityType.MetaField%>"/>
	    </v:form-field>  
	    <v:form-field caption="ICCODE" hint="Chart of Accounts' Meta Field mapped to ICCODE column" mandatory="true">
	      	<snp:dyncombo field="cfg.MetaFieldId_ICCODE" clazz="rws-field" entityType="<%=LkSNEntityType.MetaField%>"/>
	    </v:form-field>
	    <v:form-field caption="COSTCEN-CODE" hint="Chart of Accounts' Meta Field mapped to COSTCEN-CODE column" mandatory="true">
	      	<snp:dyncombo field="cfg.MetaFieldId_COSTCEN_CODE" clazz="rws-field" entityType="<%=LkSNEntityType.MetaField%>"/>
	    </v:form-field>
	    <v:form-field caption="OPERATING_UNIT" hint="Chart of Accounts' Meta Field mapped to OPERATING_UNIT column" mandatory="true">
	      	<snp:dyncombo field="cfg.MetaFieldId_OPERATING_UNIT" clazz="rws-field" entityType="<%=LkSNEntityType.MetaField%>"/>
	    </v:form-field>
	    <v:form-field caption="SAP-CODE" hint="Chart of Accounts' Meta Field mapped to SAP-CODE column" mandatory="true">
	      	<snp:dyncombo field="cfg.MetaFieldId_SAP_CODE" clazz="rws-field" entityType="<%=LkSNEntityType.MetaField%>"/>
	    </v:form-field>
	    <v:form-field caption="BUSINESS_UNIT" hint="Chart of Accounts' Meta Field mapped to BUSINESS_UNIT column" mandatory="true">
      		<snp:dyncombo field="cfg.MetaFieldId_BUSINESS_UNIT" entityType="<%=LkSNEntityType.MetaField%>" clazz="rws-field"/>
    	</v:form-field>
		<v:form-field caption="LedgerType Filter" hint="The Ledger Type to filter on. Either this or PTS_TYPE Filter needs a value or the task will fail." mandatory="false">
	      	<v:lk-multibox field="cfg.ledgerTypeFilter" clazz="rws-field" lookup="<%=LkSN.LedgerType%>" limitItems="<%=LookupManager.getArray(LkSNLedgerType.SalePay, LkSNLedgerType.Manual, LkSNLedgerType.Clearing, LkSNLedgerType.Amortization, LkSNLedgerType.Expiration)%>"/>
	    </v:form-field>
	    <v:form-field caption="PTS_TYPE Filter" hint="The PTS_TYPE to filter on. Either this or PTS_TYPE Filter needs a value or the task will fail.">
	      <select id="cfg.ptsTypeFilter" class="form-field"></select>
	    </v:form-field>
	</v:widget-block>
</v:widget>

<v:widget caption="FTP Settings">
  <v:widget-block>
    <jsp:include page="/resources/admin/common/ftp_config_widget.jsp"></jsp:include>
  </v:widget-block>
</v:widget>	
  
<script>
  $(document).ready(function () {
    $("#cfg\\.MetaFieldId_PTS_TYPE").change(_refreshPtsType);
    _refreshPtsType();
    
    function _refreshPtsType() {
      var metaFieldId = $("#cfg\\.MetaFieldId_PTS_TYPE").val();
      snpAPI.cmd("METADATA", "LoadMetaField", {
    	  MetaField: {"MetaFieldId":metaFieldId}
      }).then(ansDO => {
   		var list = ansDO.MetaField.MetaFieldItemList || [];
    	var $field = $("#cfg\\.ptsTypeFilter");
    	$field.empty();
    	_parsePtsTypes(list);
      }
      );
    }
    
    var _parsePtsTypes = function(ptsTypes) {
  	  var $option = $("<option></option>").appendTo("#cfg\\.ptsTypeFilter");
	  $option.val("");
	  $option.html("No Pts Filter");

	  if (ptsTypes) {
		  ptsTypes = ptsTypes.forEach(function(obj) {
    	  var option = $("<option></option>");
    	  $(option).val(obj.MetaFieldItemCode);
    	  $(option).html(obj.MetaFieldItemName);
    	  $("#cfg\\.ptsTypeFilter").append(option);
	      });

	      $("#cfg\\.ptsTypeFilter").val('<%=currentPtsValue%>');
	    }
	  };
  });

function saveTaskConfig(reqDO) {
  var config = {
  	MetaFieldId_PTS_TYPE: $("#cfg\\.MetaFieldId_PTS_TYPE").val(),
  	ENTITY: $("#cfg\\.ENTITY").val(),
  	MetaFieldId_ICCODE: $("#cfg\\.MetaFieldId_ICCODE").val(),
  	MetaFieldId_COSTCEN_CODE: $("#cfg\\.MetaFieldId_COSTCEN_CODE").val(),
  	MetaFieldId_OPERATING_UNIT: $("#cfg\\.MetaFieldId_OPERATING_UNIT").val(),
  	MetaFieldId_SAP_CODE: $("#cfg\\.MetaFieldId_SAP_CODE").val(),
  	MetaFieldId_BUSINESS_UNIT: $("#cfg\\.MetaFieldId_BUSINESS_UNIT").val(),
    ftpConfig: getFtpConfig(),
    FixedFiscalDate: $("#cfg\\.FixedFiscalDate-picker").getXMLDate(),
    FiscalDate: $("#cfg\\.FiscalDate").val(),
    ptsTypeFilter: getNull($("#cfg\\.ptsTypeFilter").val()),
    ledgerTypeFilter: $("#cfg\\.ledgerTypeFilter").val()
  }
  reqDO.TaskConfig = JSON.stringify(config); 
}


</script>

