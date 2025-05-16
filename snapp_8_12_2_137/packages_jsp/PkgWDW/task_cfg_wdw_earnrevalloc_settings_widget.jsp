<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.document.*"%>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageTask" scope="request"/>

<style>

.double-col {
  width: 45%;
  display: inline-table;
}

</style>

<% 
JvDocument cfg = (JvDocument)request.getAttribute("cfg"); 

QueryDef qdef = new QueryDef(QryBO_LedgerAccount.class);
qdef.addSelect(
    QryBO_LedgerAccount.Sel.LedgerAccountId,
    QryBO_LedgerAccount.Sel.LedgerAccountCode,
    QryBO_LedgerAccount.Sel.LedgerAccountName);
qdef.addSort(QryBO_LedgerAccount.Sel.LedgerAccountCode);
qdef.addFilter(QryBO_LedgerAccount.Fil.LedgerAccountLevel, LkSNLedgerAccountLevel.SubAccount.getCode());

// String offsetHoursHint = 
//   "Number of hours in the past to consider<br/>" +
//   "a ledger entry in the post process queue<br/>" +
//   "to be \"mandatory\" for the EOD task.<br/>" + 
//   "The task will wait for all of these ledger entries<br/>" +
//   "not processed yet, to be processed before starting<br/>";

String pastDaysHint = 
  "Number of days in the past that should be analized by the task.<br/>" +
  "For each of these days the task calculates the amount that has not<br/>" +
  "been moved yet and distribute it to the proper ledger accounts.<br/>" +
	"<br/>" +
	"<b>Example scenario:</b><br/>" +
	"<i>Reference date -> Previous fiscal date</i><br/>" +
	"<i>Days in the past -> 10</i><br/>" +
	"<i>Task executed on April 22nd 5:15:00am</i><br/>" +
	"<br/>" +
	"<b>Result:</b><br/>" +
	"The task analizes dates from April 11th to April 21st.<br/>" +
	"<br/>" +
	"<b>Example scenario:</b><br/>" +
  "<i>Reference date -> Previous fiscal date</i><br/>" +
  "<i>Days in the past -> 0</i><br/>" +
  "<i>Task executed on April 22nd 5:15:00am</i><br/>" +
  "<br/>" +
  "<b>Result:</b><br/>" +
  "The task analizes only April 21st.<br/>" +
  "<br/>" +
  "<b>Example scenario:</b><br/>" +
  "<i>Reference date -> Current fiscal date</i><br/>" +
  "<i>Days in the past -> 10</i><br/>" +
  "<i>Task executed on April 22nd 10:30:00am</i><br/>" +
  "<br/>" +
  "<b>Result:</b><br/>" +
  "The task analizes dates from April 12th to April 22nd<br/>";
  
  int pastDays = 0;
  if (!cfg.getChildField("PastDays").isNull())
    pastDays = cfg.getChildField("PastDays").getInt();
%>



<v:widget caption="@Common.Configuration">
	<v:widget-block>
<%-- 	  <v:form-field caption="Ledger entries offset hours" hint="<%=offsetHoursHint%>"> --%>
<%--       <v:input-text field="cfg.OffsetHours" placeholder="12"/> --%>
<%--     </v:form-field> --%>
    <v:form-field caption="@Common.ReferenceDate">
      <v:lk-combobox field="cfg.ReferenceDateType" lookup="<%=LkSN.ReferenceDateType%>" allowNull="false" enabled="true"/>
    </v:form-field>
    <v:form-field caption="Days in the past" hint="<%=pastDaysHint%>">
      <v:input-text field="cfg.PastDays" placeholder="0"/>
    </v:form-field>
	</v:widget-block>
</v:widget>

<v:widget caption="Settings">	
	<v:widget-block>
	  <v:form-field caption="Sports revenue percentage" hint="Percentage of the ticket value per entry">
      <v:input-text field="cfg.SportsRevenuePerc" placeholder="4.6%"/>
    </v:form-field>
    <v:form-field caption="OT revenue amount" hint="Fix amount per entry ">
      <v:input-text field="cfg.OTRevenueAmount" placeholder="15"/>
    </v:form-field>
	</v:widget-block>
</v:widget>    
<v:widget caption="TP attendance locations">	
	<v:widget-block>
	  <v:form-field caption="MK attendance locations">
	    <v:multibox field="cfg.MKAttLocationIDs" lookupDataSet="<%=pageBase.getBL(BLBO_Account.class).getLocationDS()%>" idFieldName="AccountId" captionFieldName="DisplayName"/>
	  </v:form-field>
	  <v:form-field caption="EC attendance locations">
	    <v:multibox field="cfg.ECAttLocationIDs" lookupDataSet="<%=pageBase.getBL(BLBO_Account.class).getLocationDS()%>" idFieldName="AccountId" captionFieldName="DisplayName"/>
	  </v:form-field>
	  <v:form-field caption="DHS attendance locations">
	    <v:multibox field="cfg.DHSAttLocationIDs" lookupDataSet="<%=pageBase.getBL(BLBO_Account.class).getLocationDS()%>" idFieldName="AccountId" captionFieldName="DisplayName"/>
	  </v:form-field>
	  <v:form-field caption="DAK attendance locations">
	    <v:multibox field="cfg.DAKAttLocationIDs" lookupDataSet="<%=pageBase.getBL(BLBO_Account.class).getLocationDS()%>" idFieldName="AccountId" captionFieldName="DisplayName"/>
	  </v:form-field>
	</v:widget-block>
</v:widget>
<v:widget caption="OGA attendance locations">
  <v:widget-block>	  
	  <v:form-field caption="OT attendance locations">
	    <v:multibox field="cfg.OTAttLocationIDs" lookupDataSet="<%=pageBase.getBL(BLBO_Account.class).getLocationDS()%>" idFieldName="AccountId" captionFieldName="DisplayName"/>
	  </v:form-field>
	  <v:form-field caption="NBA attendance locations">
	    <v:multibox field="cfg.DQAttLocationIDs" lookupDataSet="<%=pageBase.getBL(BLBO_Account.class).getLocationDS()%>" idFieldName="AccountId" captionFieldName="DisplayName"/>
	  </v:form-field>
	  <v:form-field caption="MG attendance locations">
	    <v:multibox field="cfg.MGAttLocationIDs" lookupDataSet="<%=pageBase.getBL(BLBO_Account.class).getLocationDS()%>" idFieldName="AccountId" captionFieldName="DisplayName"/>
	  </v:form-field>
	</v:widget-block>
</v:widget>
<v:widget caption="WP attendance locations">
  <v:widget-block>	  
	  <v:form-field caption="BB attendance locations">
	    <v:multibox field="cfg.BBAttLocationIDs" lookupDataSet="<%=pageBase.getBL(BLBO_Account.class).getLocationDS()%>" idFieldName="AccountId" captionFieldName="DisplayName"/>
	  </v:form-field>
	  <v:form-field caption="TL attendance locations">
	    <v:multibox field="cfg.TLAttLocationIDs" lookupDataSet="<%=pageBase.getBL(BLBO_Account.class).getLocationDS()%>" idFieldName="AccountId" captionFieldName="DisplayName"/>
	  </v:form-field>
	</v:widget-block>
</v:widget>		
<v:widget caption="TP default attendance percentages for days without attendances">
	<v:widget-block>
	  <v:form-field caption="MK percentage">
      <v:input-text field="cfg.MKNoAttendancePerc" placeholder="100%"/>
    </v:form-field>
    <v:form-field caption="EC percentage">
      <v:input-text field="cfg.ECNoAttendancePerc" placeholder="0%"/>
    </v:form-field>
    <v:form-field caption="DHS percentage">
      <v:input-text field="cfg.DHSNoAttendancePerc" placeholder="0%"/>
    </v:form-field>
    <v:form-field caption="DAK percentage">
      <v:input-text field="cfg.DAKNoAttendancePerc" placeholder="0%"/>
    </v:form-field>
	</v:widget-block>
</v:widget>
<v:widget caption="WP default attendance percentages for days without attendances">
	<v:widget-block>
	  <v:form-field caption="BB percentage">
      <v:input-text field="cfg.BBNoAttendancePerc" placeholder="50%"/>
    </v:form-field>
    <v:form-field caption="TL percentage">
      <v:input-text field="cfg.TLNoAttendancePerc" placeholder="50%"/>
    </v:form-field>
	</v:widget-block>
</v:widget>
<v:widget caption="WPF&M average price">	
	<v:widget-block>
	  <v:form-field caption="WP average price">
	    <v:input-text field="cfg.WPAveragePrice" placeholder="40"/>
	  </v:form-field>
	  <v:form-field caption="NBA average price">
	    <v:input-text field="cfg.DQAveragePrice" placeholder="30"/>
	  </v:form-field>
	  <v:form-field caption="MG average price">
	    <v:input-text field="cfg.MGAveragePrice" placeholder="12"/>
	  </v:form-field>
	</v:widget-block>
</v:widget>
<v:widget caption="Earned revenue account pools - TAXED / NON TAXED">
	<v:widget-block>
	  <v:form-field caption="TP earned revenue">
      <snp:dyncombo clazz="double-col" field="cfg.TPEarRevLedgerAccountId" entityType="<%=LkSNEntityType.LedgerAccount%>" showItemCode="true" allowNull="true"/>
  	  &nbsp;/&nbsp;
			<snp:dyncombo clazz="double-col" field="cfg.TPEarRevTELedgerAccountId" entityType="<%=LkSNEntityType.LedgerAccount%>" showItemCode="true" allowNull="true"/>
	  </v:form-field>
	  <v:form-field caption="OGA earned revenue">
	    <snp:dyncombo clazz="double-col" field="cfg.OGAEarRevLedgerAccountId" entityType="<%=LkSNEntityType.LedgerAccount%>" showItemCode="true" allowNull="true"/>
	    &nbsp;/&nbsp;
	    <snp:dyncombo clazz="double-col" field="cfg.OGAEarRevTELedgerAccountId" entityType="<%=LkSNEntityType.LedgerAccount%>" showItemCode="true" allowNull="true"/>
	  </v:form-field>
	</v:widget-block>
</v:widget>
<v:widget caption="TP revenue accounts - TAXED / NON TAXED">
	<v:widget-block>
    <v:form-field caption="MK revenue">
      <snp:dyncombo clazz="double-col" field="cfg.MKRevLedgerAccountId" entityType="<%=LkSNEntityType.LedgerAccount%>" showItemCode="true" allowNull="true"/>
      &nbsp;/&nbsp;
      <snp:dyncombo clazz="double-col" field="cfg.MKRevTELedgerAccountId" entityType="<%=LkSNEntityType.LedgerAccount%>" showItemCode="true" allowNull="true"/> 
	  </v:form-field>
	  <v:form-field caption="EC revenue">
      <snp:dyncombo clazz="double-col" field="cfg.ECRevLedgerAccountId" entityType="<%=LkSNEntityType.LedgerAccount%>" showItemCode="true" allowNull="true"/> 
      &nbsp;/&nbsp;
      <snp:dyncombo clazz="double-col" field="cfg.ECRevTELedgerAccountId" entityType="<%=LkSNEntityType.LedgerAccount%>" showItemCode="true" allowNull="true"/>
	  </v:form-field>
	  <v:form-field caption="DHS revenue">
	    <snp:dyncombo clazz="double-col" field="cfg.DHSRevLedgerAccountId" entityType="<%=LkSNEntityType.LedgerAccount%>" showItemCode="true" allowNull="true"/>
      &nbsp;/&nbsp;
      <snp:dyncombo clazz="double-col" field="cfg.DHSRevTELedgerAccountId" entityType="<%=LkSNEntityType.LedgerAccount%>" showItemCode="true" allowNull="true"/>
 	  </v:form-field>
	  <v:form-field caption="DAK revenue">
      <snp:dyncombo clazz="double-col" field="cfg.DAKRevLedgerAccountId" entityType="<%=LkSNEntityType.LedgerAccount%>" showItemCode="true" allowNull="true"/>  
      &nbsp;/&nbsp;
      <snp:dyncombo clazz="double-col" field="cfg.DAKRevTELedgerAccountId" entityType="<%=LkSNEntityType.LedgerAccount%>" showItemCode="true" allowNull="true"/>
     </v:form-field>
	</v:widget-block>
</v:widget>
<v:widget caption="OGA revenue accounts - TAXED / NON TAXED">
	<v:widget-block>
	  <v:form-field caption="Sports revenue">
			<snp:dyncombo clazz="double-col" field="cfg.SportsRevLedgerAccountId" entityType="<%=LkSNEntityType.LedgerAccount%>" showItemCode="true" allowNull="true"/>
      &nbsp;/&nbsp;
			<snp:dyncombo clazz="double-col" field="cfg.SportsRevTELedgerAccountId" entityType="<%=LkSNEntityType.LedgerAccount%>" showItemCode="true" allowNull="true"/>
	  </v:form-field>
	  <v:form-field caption="OT revenue">
			<snp:dyncombo clazz="double-col" field="cfg.OTRevLedgerAccountId" entityType="<%=LkSNEntityType.LedgerAccount%>" showItemCode="true" allowNull="true"/>
      &nbsp;/&nbsp;
			<snp:dyncombo clazz="double-col" field="cfg.OTRevTELedgerAccountId" entityType="<%=LkSNEntityType.LedgerAccount%>" showItemCode="true" allowNull="true"/>
	  </v:form-field>
	  <v:form-field caption="WP revenue">
			<snp:dyncombo clazz="double-col" field="cfg.WPRevLedgerAccountId" entityType="<%=LkSNEntityType.LedgerAccount%>" showItemCode="true" allowNull="true"/>
      &nbsp;/&nbsp;
			<snp:dyncombo clazz="double-col" field="cfg.WPRevTELedgerAccountId" entityType="<%=LkSNEntityType.LedgerAccount%>" showItemCode="true" allowNull="true"/>
	  </v:form-field>
	  <v:form-field caption="NBA revenue">
			<snp:dyncombo clazz="double-col" field="cfg.DQRevLedgerAccountId" entityType="<%=LkSNEntityType.LedgerAccount%>" showItemCode="true" allowNull="true"/>
      &nbsp;/&nbsp;
			<snp:dyncombo clazz="double-col" field="cfg.DQRevTELedgerAccountId" entityType="<%=LkSNEntityType.LedgerAccount%>" showItemCode="true" allowNull="true"/>
	  </v:form-field>
	  <v:form-field caption="MG revenue">
			<snp:dyncombo clazz="double-col" field="cfg.MGRevLedgerAccountId" entityType="<%=LkSNEntityType.LedgerAccount%>" showItemCode="true" allowNull="true"/>
      &nbsp;/&nbsp;
			<snp:dyncombo clazz="double-col" field="cfg.MGRevTELedgerAccountId" entityType="<%=LkSNEntityType.LedgerAccount%>" showItemCode="true" allowNull="true"/>
	  </v:form-field>
	</v:widget-block>
</v:widget>
<v:widget caption="WP revenue accounts - TAXED / NON TAXED">
	<v:widget-block>
	  <v:form-field caption="BB revenue">
			<snp:dyncombo clazz="double-col" field="cfg.BBRevLedgerAccountId" entityType="<%=LkSNEntityType.LedgerAccount%>" showItemCode="true" allowNull="true"/>
      &nbsp;/&nbsp;
			<snp:dyncombo clazz="double-col" field="cfg.BBRevTELedgerAccountId" entityType="<%=LkSNEntityType.LedgerAccount%>" showItemCode="true" allowNull="true"/>
	  </v:form-field>
	  <v:form-field caption="TL revenue">
			<snp:dyncombo clazz="double-col" field="cfg.TLRevLedgerAccountId" entityType="<%=LkSNEntityType.LedgerAccount%>" showItemCode="true" allowNull="true"/>
      &nbsp;/&nbsp;
			<snp:dyncombo clazz="double-col" field="cfg.TLRevTELedgerAccountId" entityType="<%=LkSNEntityType.LedgerAccount%>" showItemCode="true" allowNull="true"/>
	  </v:form-field>
	</v:widget-block>
</v:widget>
<v:widget caption="EWWS taxable percentage & accounts">
  <v:widget-block>
    <v:form-field caption="EWWS taxable revenue percentage">
      <v:input-text field="cfg.EWWSTaxablePerc" placeholder="7.5%"/>
    </v:form-field>
    <v:form-field caption="Orange county tax account">
			<snp:dyncombo clazz="double-col" field="cfg.OrangeTaxLedgerAccountId" entityType="<%=LkSNEntityType.LedgerAccount%>" showItemCode="true" allowNull="true"/>
    </v:form-field>
    <v:form-field caption="Osceola county tax account">
			<snp:dyncombo clazz="double-col" field="cfg.OsceolaTaxLedgerAccountId" entityType="<%=LkSNEntityType.LedgerAccount%>" showItemCode="true" allowNull="true"/>
    </v:form-field>
  </v:widget-block>
</v:widget>

<script>

$(document).ready(function() {
	var sel = $("#cfg\\.ReferenceDateType");
	  $(sel).find("option").each(function(i){
	    if ($(this).val() == <%=cfg.getChildField("ReferenceDateType").getInt()%>)
		    $(this).attr("selected","selected");
		});
	  
	$("#cfg\\.PastDays").val(<%=pastDays%>);  
		  
	var $percField = $("#cfg\\.SportsRevenuePerc"); 
	$percField.val(formatPercValue($percField.val()));
	
	$percField = $("#cfg\\.MKNoAttendancePerc"); 
	$percField.val(formatPercValue($percField.val()));
	
	$percField = $("#cfg\\.ECNoAttendancePerc"); 
	$percField.val(formatPercValue($percField.val()));
	
	$percField = $("#cfg\\.DHSNoAttendancePerc"); 
	$percField.val(formatPercValue($percField.val()));
	
	$percField = $("#cfg\\.DAKNoAttendancePerc"); 
	$percField.val(formatPercValue($percField.val()));
	
	$percField = $("#cfg\\.BBNoAttendancePerc"); 
	$percField.val(formatPercValue($percField.val()));
	
	$percField = $("#cfg\\.TLNoAttendancePerc"); 
	$percField.val(formatPercValue($percField.val()));
	
	$percField = $("#cfg\\.EWWSTaxablePerc"); 
	$percField.val(formatPercValue($percField.val()));
});

function convertValue(value) {
	var result = null;
	value = value.replace("%", "");
	value = value.replace(",", ".");
	if (value != "") {
	  result = parseFloat(value);
	  if (isNaN(result))
	    result = null;
	}
	return result;
}

function formatPercValue(value) {
	var result = value;
	if (value) 
		if (value.indexOf("%") == -1) 
			result = value + "%";
	return result;
}

function saveTaskConfig(reqDO) {
	var pastDays = parseInt($("#cfg\\.PastDays").val());
	if (isNaN(pastDays) || (pastDays < 0))
		pastDays = 0;
		
	var sportsRevenuePerc = convertValue($("#cfg\\.SportsRevenuePerc").val());
	var MKNoAttPerc = convertValue($("#cfg\\.MKNoAttendancePerc").val());
	var ECNoAttPerc = convertValue($("#cfg\\.ECNoAttendancePerc").val());
	var DHSNoAttPerc = convertValue($("#cfg\\.DHSNoAttendancePerc").val());
	var DAKNoAttPerc = convertValue($("#cfg\\.DAKNoAttendancePerc").val());
	var BBNoAttPerc = convertValue($("#cfg\\.BBNoAttendancePerc").val());
	var TLNoAttPerc = convertValue($("#cfg\\.TLNoAttendancePerc").val());
	var OTRevenueAmount = convertValue($("#cfg\\.OTRevenueAmount").val());
	var WPAvgPrice = convertValue($("#cfg\\.WPAveragePrice").val());
	var DQAvgPrice = convertValue($("#cfg\\.DQAveragePrice").val());
	var MGAvgPrice = convertValue($("#cfg\\.MGAveragePrice").val());
	var EWWSTaxPerc = convertValue($("#cfg\\.EWWSTaxablePerc").val());
	
	var config ={
			  ReferenceDateType: $("#cfg\\.ReferenceDateType").val(),
			  PastDays : pastDays,
			  SportsRevenuePerc: sportsRevenuePerc,
			  OTRevenueAmount: OTRevenueAmount,
				MKAttLocationIDs: $("#cfg\\.MKAttLocationIDs").val(),
				ECAttLocationIDs: $("#cfg\\.ECAttLocationIDs").val(),
				DHSAttLocationIDs: $("#cfg\\.DHSAttLocationIDs").val(),
				DAKAttLocationIDs: $("#cfg\\.DAKAttLocationIDs").val(),
				OTAttLocationIDs: $("#cfg\\.OTAttLocationIDs").val(),
				DQAttLocationIDs: $("#cfg\\.DQAttLocationIDs").val(),
				MGAttLocationIDs: $("#cfg\\.MGAttLocationIDs").val(),
				BBAttLocationIDs: $("#cfg\\.BBAttLocationIDs").val(),
				TLAttLocationIDs: $("#cfg\\.TLAttLocationIDs").val(),
			  TPEarRevLedgerAccountId: $("#cfg\\.TPEarRevLedgerAccountId").val(),
			  MKRevLedgerAccountId: $("#cfg\\.MKRevLedgerAccountId").val(),
				ECRevLedgerAccountId: $("#cfg\\.ECRevLedgerAccountId").val(),
				DHSRevLedgerAccountId: $("#cfg\\.DHSRevLedgerAccountId").val(),
				DAKRevLedgerAccountId: $("#cfg\\.DAKRevLedgerAccountId").val(),
				TPEarRevTELedgerAccountId: $("#cfg\\.TPEarRevTELedgerAccountId").val(),
				MKRevTELedgerAccountId: $("#cfg\\.MKRevTELedgerAccountId").val(),
				ECRevTELedgerAccountId: $("#cfg\\.ECRevTELedgerAccountId").val(),
				DHSRevTELedgerAccountId: $("#cfg\\.DHSRevTELedgerAccountId").val(),
				DAKRevTELedgerAccountId: $("#cfg\\.DAKRevTELedgerAccountId").val(),
				OGAEarRevLedgerAccountId: $("#cfg\\.OGAEarRevLedgerAccountId").val(),
				SportsRevLedgerAccountId: $("#cfg\\.SportsRevLedgerAccountId").val(),
				OTRevLedgerAccountId: $("#cfg\\.OTRevLedgerAccountId").val(),
		 		WPRevLedgerAccountId: $("#cfg\\.WPRevLedgerAccountId").val(),
		 		DQRevLedgerAccountId: $("#cfg\\.DQRevLedgerAccountId").val(),
		 		MGRevLedgerAccountId: $("#cfg\\.MGRevLedgerAccountId").val(),
		 		OGAEarRevTELedgerAccountId: $("#cfg\\.OGAEarRevTELedgerAccountId").val(),
				SportsRevTELedgerAccountId: $("#cfg\\.SportsRevTELedgerAccountId").val(),
				OTRevTELedgerAccountId: $("#cfg\\.OTRevTELedgerAccountId").val(),
		 		WPRevTELedgerAccountId: $("#cfg\\.WPRevTELedgerAccountId").val(),
		 		DQRevTELedgerAccountId: $("#cfg\\.DQRevTELedgerAccountId").val(),
		 		MGRevTELedgerAccountId: $("#cfg\\.MGRevTELedgerAccountId").val(),
		 		BBRevLedgerAccountId: $("#cfg\\.BBRevLedgerAccountId").val(),
		 		TLRevLedgerAccountId: $("#cfg\\.TLRevLedgerAccountId").val(),
		 		BBRevTELedgerAccountId: $("#cfg\\.BBRevTELedgerAccountId").val(),
		 		TLRevTELedgerAccountId: $("#cfg\\.TLRevTELedgerAccountId").val(),
		 		MKNoAttendancePerc: MKNoAttPerc,
		 		ECNoAttendancePerc: ECNoAttPerc,
		 		DHSNoAttendancePerc: DHSNoAttPerc,
		 		DAKNoAttendancePerc: DAKNoAttPerc,
		 		BBNoAttendancePerc: BBNoAttPerc,
		 		TLNoAttendancePerc: TLNoAttPerc,
				WPAveragePrice: WPAvgPrice,
				DQAveragePrice: DQAvgPrice,
				MGAveragePrice: MGAvgPrice,
				EWWSTaxablePerc: EWWSTaxPerc,
				OrangeTaxLedgerAccountId: $("#cfg\\.OrangeTaxLedgerAccountId").val(),
				OsceolaTaxLedgerAccountId: $("#cfg\\.OsceolaTaxLedgerAccountId").val()
		};

	reqDO.TaskConfig = JSON.stringify(config);
}
</script>