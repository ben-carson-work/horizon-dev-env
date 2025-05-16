
<%@page import="com.vgs.snapp.dataobject.DOFullTextLookupFilters"%>
<%@page import="com.vgs.snapp.dataobject.DOMerchant"%>
<%@page import="com.vgs.cl.lookup.LkCreditCardType"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
  DOMerchant merchant = pageBase.isNewItem() ? new DOMerchant() : pageBase.getBL(BLBO_Merchant.class).loadMerchant(pageBase.getId());
  request.setAttribute("merchant", merchant);
  
  String maskEditURL = pageBase.getContextURL() + "?page=maskedit_widget&LoadData=true&id="+pageBase.getId()+"&EntityType=" + LkSNEntityType.Merchants.getCode();
%>

<v:dialog id="merchant-dialog" width="600" height="600" title="@Common.Merchants" tabsView="true" autofocus="false">
	<v:page-form id="merchants-form">
		<v:tab-group name="tab" main="true">
			<v:tab-item-embedded tab="merchant-tab-profile" caption="@Common.Profile" default="true">
				<div class="tab-content">

					<v:widget caption="@Common.General">
						<v:widget-block>
							<v:form-field caption="@Account.Organization" mandatory="true">
								<snp:dyncombo entityType="<%=LkSNEntityType.Organization%>" field="merchant.AccountId" allowNull="false"/>
							</v:form-field>
							<v:form-field caption="@Common.Code" mandatory="true">
								<v:input-text field="merchant.MerchantCode" />
							</v:form-field>
							<v:form-field caption="@Category.Category">
								<v:input-text field="merchant.MerchantCategory" />
							</v:form-field>
							<v:form-field caption="@Common.TerminalId">
								<v:input-text field="merchant.MerchantTerminalId" />
							</v:form-field>
						</v:widget-block>
						<v:widget-block>
							<div>
								<v:db-checkbox field="MerchantEnable" caption="@Common.Enabled" value="true" />
							</div>
						</v:widget-block>
					</v:widget>
					<v:widget caption="@Common.Filter">
						<v:widget-block>
							<v:form-field caption="@Account.Location">
							  <snp:dyncombo field="merchant.LocationId" id="merchant.LocationId" entityType="<%=LkSNEntityType.Location%>" auditLocationFilter="true"/>
							</v:form-field>
							<v:form-field caption="@Account.OpArea">
								<snp:dyncombo field="merchant.OperatingAreaId" id="merchant.OperatingAreaId" entityType="<%=LkSNEntityType.OperatingArea%>" auditLocationFilter="true" parentComboId="merchant.LocationId"/>
							</v:form-field>
							<v:form-field caption="@Common.Workstation">
								<% 
		            DOFullTextLookupFilters wsFilters = new DOFullTextLookupFilters();
								wsFilters.Workstation.WorkstationTypes.setLkArray(LkSNWorkstationType.POS, LkSNWorkstationType.WEB, LkSNWorkstationType.KSK, LkSNWorkstationType.B2C);
	  	          %>
								<snp:dyncombo filters="<%=wsFilters%>"  field="merchant.WorkstationId" id="merchant.WorkstationId" entityType="<%=LkSNEntityType.Workstation%>" auditLocationFilter="true" parentComboId="merchant.OperatingAreaId"/>
							</v:form-field>
							<v:form-field caption="@Payment.CardType">
								<v:lk-combobox field="merchant.CardType" lookup="<%=LkSN.CreditCardType%>" allowNull="true" />
							</v:form-field>
						</v:widget-block>
					</v:widget>

					<div id="maskedit-container"></div>
				</div>
			</v:tab-item-embedded>

			<v:tab-item-embedded tab="tabs-history" caption="@Common.History" include="<%=!pageBase.isNewItem() && rights.History.getBoolean()%>">
				<jsp:include page="../common/page_tab_historydetail.jsp" />
			</v:tab-item-embedded>

		</v:tab-group>
<script>
 $(document).ready(function(){
	 asyncLoad("#maskedit-container", <%=JvString.jsString(maskEditURL)%>);

	  var dlg = $("#merchant-dialog");
	  dlg.on("snapp-dialog", function(event, params) {
	    params.buttons = [
	      dialogButton("@Common.Save", doSaveMerchant),
	      dialogButton("@Common.Close", doCloseDialog)
	    ]
	  });
	  
	 <% if (merchant.MerchantStatus.isLookup(LkSNMerchantStatus.Active)) { %>
       $("#MerchantEnable").prop('checked', true);
     <% } %>
  
	  function doSave() {
	    checkRequired("#merchant-dialog", function() {
	     doSaveMerchant();
	    }) ;
	  }
	  
	  function doSaveMerchant() {
	    var metaDataList = prepareMetaDataArray("#merchants-form");
	    var merchantEnable = $("#MerchantEnable").isChecked() ? <%=LkSNMerchantStatus.Active.getCode()%> : <%=LkSNMerchantStatus.Disabled.getCode()%>;
	    var reqDO = {
	        Command: "SaveMerchant",
	        SaveMerchant: {
	          Merchant: {
	            MerchantId: (<%=!pageBase.isNewItem()%>)? <%=JvString.jsString(pageBase.getId())%> : null,
	            AccountId: $("#merchant\\.AccountId").val(),
	            MerchantCode: $("#merchant\\.MerchantCode").val(),
	            MerchantStatus: merchantEnable,
	            MerchantCategory: $("#merchant\\.MerchantCategory").val(),
	            MerchantTerminalId: $("#merchant\\.MerchantTerminalId").val(),
	            LocationId: $("#merchant\\.LocationId").val(),
	            OperatingAreaId: $("#merchant\\.OperatingAreaId").val(),
	            WorkstationId: $("#merchant\\.WorkstationId").val(),
	            CardType: $("#merchant\\.CardType").val(),
	            MetaDataList: metaDataList
	          }
	        }
	      };
	    
	    vgsService("Merchant", reqDO, false, function(ansDO) {
	    	dlg.dialog("close");
	    	triggerEntityChange(<%=LkSNEntityType.Merchants.getCode()%>);
	    }); 
	    
	  }
 });

</script>

</v:page-form>
</v:dialog>