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
%>

<v:widget caption="Info">
  <v:widget-block>
    <p>
    	The purpose of this task is to daily export a Journal File to the Clients Financial System.<br/>
    	On top of a general file format that gets information based on Ledger movements this file will also grab information from different MetaFields that need to be attached to the ledger.<br/>
    	These Meta fields must be defined and are listed in the configuration. This file can either be run based on Execution Date, current Fiscal Date, or Previous Fiscal Date. <br/>
    	<b>Note:</b> Fiscal date is relative to the licensee time zone settings (server time-zone is not considered)<br/>
        <b>Note:</b> If the file is already exiting on the FTP destination, it will be replaced. <br/>
        <b>Note:</b> If the Entity field isn't properly linked we will have a default of RWSPL used for the File Headers and the name of the file, but it won't show up throughout the entire file. <br/>
    </p>
    <p>
      Each file contains a section for the <b>File Header</b>, the <b>File Line</b>, and the <b>File Footer</b>.<br/>
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
		<v:form-field caption="ENTITY" mandatory="true">
	      <v:input-text field="cfg.ENTITY" placeholder="RWSPL" clazz="rws-field"/>
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
	    <v:form-field caption="BUSINESS_UNIT" hint="Workstation Meta Field mapped to BUSINESS_UNIT column" mandatory="true">
      		<snp:dyncombo field="cfg.MetaFieldId_BUSINESS_UNIT" entityType="<%=LkSNEntityType.MetaField%>" clazz="rws-field"/>
    	</v:form-field> 
	    <v:form-field caption="JOURNAL_CATEGORY" hint="Chart of Accounts' Meta Field mapped to JOURNAL_CATEGORY column" mandatory="true">
	      <snp:dyncombo field="cfg.MetaFieldId_JOURNAL_CATEGORY" clazz="rws-field" entityType="<%=LkSNEntityType.MetaField%>"/>
	    </v:form-field> 
	</v:widget-block>
</v:widget>


<v:widget caption="FTP Settings">
  <v:widget-block>
    <jsp:include page="/resources/admin/common/ftp_config_widget.jsp"></jsp:include>
  </v:widget-block>
</v:widget>	
  
<script>

function saveTaskConfig(reqDO) {
  var config = {
    ftpConfig: getFtpConfig(),
    ENTITY: $("#cfg\\.ENTITY").val(),
  	MetaFieldId_ICCODE: $("#cfg\\.MetaFieldId_ICCODE").val(),
  	MetaFieldId_COSTCEN_CODE: $("#cfg\\.MetaFieldId_COSTCEN_CODE").val(),
  	MetaFieldId_OPERATING_UNIT: $("#cfg\\.MetaFieldId_OPERATING_UNIT").val(),
  	MetaFieldId_SAP_CODE: $("#cfg\\.MetaFieldId_SAP_CODE").val(),
  	MetaFieldId_BUSINESS_UNIT: $("#cfg\\.MetaFieldId_BUSINESS_UNIT").val(),
  	FixedFiscalDate: $("#cfg\\.FixedFiscalDate-picker").getXMLDate(),
    FiscalDate: $("#cfg\\.FiscalDate").val(),
    MetaFieldId_JOURNAL_CATEGORY: $("#cfg\\.MetaFieldId_JOURNAL_CATEGORY").val()
  }
  
  
  reqDO.TaskConfig = JSON.stringify(config); 
}


</script>

