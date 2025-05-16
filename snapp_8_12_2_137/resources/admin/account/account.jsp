<%@page import="com.vgs.vcl.JvImageCache"%>
<%@page import="com.vgs.web.library.right.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" scope="request" class="com.vgs.web.page.PageAccount"/>
<jsp:useBean id="account" scope="request" class="com.vgs.snapp.dataobject.DOAccount"/>
<jsp:useBean id="rights" scope="request" class="com.vgs.snapp.dataobject.DORightRoot"/>
<% 
String[] accountLocationIDs = pageBase.getBLDef().getAccountLocationIDs(account);
FtCRUD rightCRUD = (FtCRUD)request.getAttribute("rightCRUD");
FtCRUD securityRightCRUD = pageBase.getBLDef().getEntityRightCRUD(rights.SecurityEdit, rights, accountLocationIDs);
if (account.EntityType.isLookup(LkSNEntityType.Person))
  securityRightCRUD = pageBase.getBL(BLBO_Account.class).applyCategoryRestrictions(LkSNEntityType.User, account.AccountId.getString(), securityRightCRUD);
boolean canEdit = rightCRUD.canUpdate(); 
boolean canRead = rightCRUD.canRead(); 
boolean canDelete = rightCRUD.canDelete(); 
boolean securityRead = securityRightCRUD.canRead(); 
boolean securityEdit = securityRightCRUD.canUpdate(); 
boolean securityCreate = securityRightCRUD.canCreate(); 
%>

<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>

<div id="main-container">
  <%-- TAB-GROUP --%>
  <v:tab-group name="tab" main="true">
    <v:tab-item caption="@Common.Profile" icon="profile.png" tab="main" jsp="account_tab_main.jsp" default="true" />
    <% if (pageBase.isMasterAccount()) { %>
      <v:tab-item caption="@Common.License" icon="license.png" tab="license" jsp="account_tab_license.jsp" />
    <% } %>
    <% if (!pageBase.isNewItem()) { %>
      <%-- FINANCE --%>
      <% boolean canReadFinance = rights.CreditLine.canRead() || rights.SalesTerms.canRead(); %>
      <% if ((account.HasFinance.getBoolean() && canReadFinance) || pageBase.isTab("tab", "finance")) { %>
        <v:tab-item caption="@Account.Credit.Finance" icon="coins.png" tab="finance" jsp="account_tab_finance.jsp" />
      <% } %>
      
      <%-- OUTBOUND FINANCE --%>
      <% if (rights.SystemSetupCrossPlatform.canRead()) { %>
        <% if (account.EntityType.isLookup(LkSNEntityType.CrossPlatform) || pageBase.isTab("tab", "xpifinance")) { %>
          <v:tab-item caption="@Account.Credit.FinanceOutbound" icon="coins.png" tab="xpifinance" jsp="account_tab_xpi_finance.jsp" />
        <% } %>
      <% } %>
      
      <%-- SECURITY --%>
      <% if ((account.HasSecurity.getBoolean() || pageBase.isTab("tab", "security")) && (securityRead)) { %>
        <v:tab-item caption="@Account.Security" icon="lock.png" tab="security" jsp="account_tab_security.jsp" />
      <% } %>
      
      <%-- RICHDESC --%>
      <% if (account.EntityType.isLookup(LkSNEntityType.Location, LkSNEntityType.Organization, LkSNEntityType.Person)) { %>
        <v:tab-item caption="@Common.Description" icon="<%=BLBO_RichDesc.ICONNAME_RICHDESC%>" tab="description" jsp="account_tab_description.jsp" />
      <% } %>
      
      <%-- SYSTEM --%>
      <% if (account.EntityType.isLookup(LkSNEntityType.Licensee, LkSNEntityType.Location, LkSNEntityType.CrossPlatform)) { %>
        <v:tab-item caption="@Common.Topology" icon="account_tree.png" tab="system" jsp="account_tab_topology.jsp" />
      <% } %>
      
      <%-- SEAT/CAPACITY ALLOCATION --%>
      <% if (account.AllowCapacityAllocation.getBoolean() || account.AllowSeatAllocation.getBoolean()) { %>
        <v:tab-item caption="@Seat.LimitedCapacity" icon="<%=LkSNEntityType.SeatMap.getIconName()%>" tab="seat" jsp="account_tab_seat.jsp" />
      <% } %>
      
      <%-- WKS MONITOR --%>
      <% if (account.EntityType.isLookup(LkSNEntityType.Location, LkSNEntityType.OperatingArea, LkSNEntityType.AccessArea)) { %>
        <% String jsp_wks_monitor = pageBase.getContextURI() + "?page=workstation_monitor&widget=true&id=" + pageBase.getId() + "&EntityType=" + account.EntityType.getInt() + "&readonly=" + !canEdit; %>
        <v:tab-item caption="@Common.Monitor" fa="monitor-waveform" tab="wks_monitor" jsp="<%=jsp_wks_monitor%>" />
      <% } %>
      
      <%-- RESOURCE SERIAL --%>
      <% if (account.EntityType.isLookup(LkSNEntityType.Resource) && account.ResourceSerialTrack.isLookup(LkSNResourceSerialTrack.Static)) { %>
        <v:tab-item caption="@Resource.Serials" icon="barcode.png" tab="resserial" jsp="account_tab_resserial.jsp" />
      <% } %>
      
      <%-- PLANNER --%>
      <% if (account.EntityType.isLookup(LkSNEntityType.Person, LkSNEntityType.Location)) { %>
        <% String jsp_planner = pageBase.getContextURI() + "?page=calendar_widget&EntityType=" + account.EntityType.getInt() + "&EntityId=" + pageBase.getId(); %>
        <v:tab-item caption="@Common.Calendar" icon="calendar.png" tab="planner" jsp="<%=jsp_planner%>" />
      <% } %>
      
      <%-- WORKSTATION --%>
      <% if (account.EntityType.isLookup(LkSNEntityType.OperatingArea)) { %>
        <% request.setAttribute("OpAreaAccountId", pageBase.getId()); %>
        <% request.setAttribute("Xpi", pageBase.getBL(BLBO_Account.class).getEntityType(account.ParentAccountId.getString()).isLookup(LkSNEntityType.CrossPlatform));%>
        <v:tab-item caption="@Common.Workstations" icon="station.png" tab="wks" jsp="../workstation/workstation_list_widget.jsp" />
      <% } %>
      
      <%-- CHILD ACCOUNTS --%>
      <% if (account.EntityType.isLookup(LkSNEntityType.Association)) { %>
          <v:tab-item caption="@Account.AssociationMembers" icon="account_prs.png" tab="account" jsp="account_tab_member.jsp" />
       <% } else { %>
      <% if ((account.ChildAccountCount.getInt() > 0) || pageBase.isTab("tab", "account")) { %>
          <v:tab-item caption="@Account.Accounts" icon="account_prs.png" tab="account" jsp="account_tab_account.jsp" />
        <% } %>
      <% } %>
      
      <%-- LOCATIONS --%>
      <% if ((account.LocationCount.getInt() > 0) || pageBase.isTab("tab", "location")) { %>
        <v:tab-item caption="@Account.Locations" icon="location.png" tab="location" jsp="account_tab_location.jsp" />
      <% } %>
      
      <%-- API-FIREWALL --%>
      <% if (rights.MonitorIT.getBoolean() && ((account.ApiFirewallCount.getInt() > 0) || pageBase.isTab("tab", "apifw"))) { %>
       <% request.setAttribute("EntityType", account.EntityType.getString()); %>
       <% request.setAttribute("EntityId", pageBase.getId()); %>
       <v:tab-item caption="@System.ApiFirewall" fa="block-brick-fire" tab="apifw" jsp="../common/api_firewall_widget.jsp" />
      <% } %>
      
      <%-- TAX EXEMPT --%>
      <% if ((account.TaxExemptCount.getInt() > 0) || pageBase.isTab("tab", "taxexempt")) { %>
        <v:tab-item caption="@Account.TaxExemptTab" icon="tax.png" tab="taxexempt" jsp="account_tab_taxexempt.jsp" />
      <% } %>

      <%-- EVENT --%>
      <% if ((account.EventCount.getInt() > 0) || pageBase.isTab("tab", "event")) { %>
        <% String jsp_event = pageBase.getContextURI() + "?page=event_list&widget=true&AccountId=" + pageBase.getId(); %>
        <v:tab-item caption="@Event.Events" icon="<%=LkSNEntityType.Event.getIconName()%>" tab="event" jsp="<%=jsp_event%>" />
      <% } %>
      
      <%-- PRODUCT TYPE --%>
      <% if ((account.ProductCount.getInt() > 0) || pageBase.isTab("tab", "product")) { %>
        <% String jsp_product = pageBase.getContextURI() + "?page=product_list&widget=true&ParentEntityType=" + account.EntityType.getInt() + "&ParentEntityId=" + pageBase.getId(); %>
        <v:tab-item caption="@Product.ProductTypes" icon="<%=LkSNEntityType.ProductType.getIconName()%>" tab="product" jsp="<%=jsp_product%>" />
      <% } %>
      
      <%-- PRODUCT FAMILY --%>
      <% if ((account.ProductFamilyCount.getInt() > 0) || pageBase.isTab("tab", "productfamily")) { %>
        <% String jsp_productfamily = pageBase.getContextURI() + "?page=prodfamily_list&widget=true&ParentEntityType=" + account.EntityType.getInt() + "&ParentEntityId=" + pageBase.getId(); %>
        <v:tab-item caption="@Product.ProductFamilies" icon="<%=LkSNEntityType.ProductFamily.getIconName()%>" tab="productfamily" jsp="<%=jsp_productfamily%>" />
      <% } %>
      
      <%-- ASSOCIATION PRODUCTS --%>
      <% if (account.EntityType.isLookup(LkSNEntityType.Association)) { %>
        <v:tab-item caption="@Product.ProductTypes" icon="<%=LkSNEntityType.ProductType.getIconName()%>" tab="association_product" jsp="account_tab_association_product.jsp" />
        <%-- ASSOCIATION PROMORULES --%>
        <v:tab-item caption="@Product.PromoRules" icon="promorule.png" tab="association_promorule" jsp="account_tab_association_promorule.jsp" />
        <%-- MEMBER RIGHTS --%>
        <%
        request.setAttribute("EntityRight_CanEdit", canEdit);
        request.setAttribute("EntityRight_DocEntityType", LkSNEntityType.Association);
        request.setAttribute("EntityRight_DocEntityId", pageBase.getId());
        request.setAttribute("EntityRight_EntityTypes", new LookupItem[] {LkSNEntityType.Workstation, LkSNEntityType.Person});
        request.setAttribute("EntityRight_ShowRightLevelEdit", false);
        request.setAttribute("EntityRight_ShowRightLevelDelete", false);
        request.setAttribute("EntityRight_HistoryField", LkSNHistoryField.Account_MemberEntityRights);
        %>
        <v:tab-item caption="@Account.AssociationMemberEditRights" icon="<%=LkSNEntityType.Login.getIconName()%>" jsp="../common/page_tab_rights.jsp" tab="rights"/>
      <% } %>
      
      <%-- ATTRIBUTE --%>
      <% if ((account.AttributeCount.getInt() > 0) || pageBase.isTab("tab", "attribute")) { %>
        <% String jsp_attribute = pageBase.getContextURI() + "?page=attribute_list&widget=true&ParentEntityType=" + account.EntityType.getInt() + "&ParentEntityId=" + pageBase.getId(); %>
        <v:tab-item caption="@Product.Attributes" icon="attribute.png" tab="attribute" jsp="<%=jsp_attribute%>" />
      <% } %>
      
      <%-- PERF.TYPE --%>
      <% if ((account.PerfTypeCount.getInt() > 0) || pageBase.isTab("tab", "perftype")) { %>
        <% String jsp_perftype = pageBase.getContextURI() + "?page=widget&jsp=dynprice/dynprice_tab_perftype&ParentEntityType=" + account.EntityType.getInt() + "&ParentEntityId=" + pageBase.getId(); %>
        <v:tab-item caption="@Performance.PerformanceTypes" icon="pricetable.png" tab="perftype" jsp="<%=jsp_perftype%>" />
      <% } %>
      
      <%-- MEDIA --%>
      <% if ((account.MediaCount.getInt() > 0) || pageBase.isTab("tab", "media")) { %>
        <v:tab-item caption="@Common.Medias" icon="media.png" tab="media" jsp="account_tab_media.jsp" />
      <% } %>
      
      <%-- TICKET --%>
      <% if ((account.TicketCount.getInt() > 0) || pageBase.isTab("tab", "ticket")) { %>
        <v:tab-item caption="@Ticket.Tickets" icon="ticket-new.png" tab="ticket" jsp="account_tab_ticket.jsp" />
      <% } %>
      
      <%-- PORTFOLIO --%>
      <% if ((account.PortfolioCount.getInt() > 0) || pageBase.isTab("tab", "portfolio")) { %>
        <% String jsp_portfolio = pageBase.getContextURI() + "?page=portfolio_list&widget=true&AccountId=" + pageBase.getId(); %>
        <v:tab-item caption="@Common.Portfolios" icon="<%=JvImageCache.ICON_FOLDER%>" tab="portfolio" jsp="<%=jsp_portfolio%>" />
      <% } %>
      
      <%-- INSTALLMENT CONTRACTS --%>
      <% if ((account.InstallmentContractCount.getInt() > 0) || pageBase.isTab("tab", "instcontr")) { %>
        <v:tab-item caption="@Installment.InstallmentContracts" icon="installment.png" tab="instcontr" jsp="account_tab_instcontr.jsp" />
      <% } %>
      
      <%-- ORDER --%>
      <% if ((account.SaleCount.getInt() > 0) || pageBase.isTab("tab", "sale") || account.EntityType.isLookup(LkSNEntityType.Association)) { %>
        <% String jsp_sale = pageBase.getContextURI() + "?page=sale_list&widget=true&AccountId=" + pageBase.getId(); %>
        <v:tab-item caption="@Common.Sales" icon="order.png" tab="sale" jsp="<%=jsp_sale%>" />
      <% } %>
      
      <%-- TRANSACTION --%>
      <% if (account.SaleCount.getInt() > 0 || pageBase.isTab("tab", "transaction")) { %>
        <% String jsp_trn = pageBase.getContextURI() + "?page=transaction_list&widget=true&AccountId=" + pageBase.getId(); %>
        <v:tab-item caption="@Common.Transactions" icon="transaction.png" tab="transaction" jsp="<%=jsp_trn%>" />
      <% } %>
              
      <%-- MEMBERSHIP --%>
      <% if ((account.MembershipCount.getInt() > 0) || pageBase.isTab("tab", "membership")) { %>
        <% String jsp_sale = pageBase.getContextURI() + "?page=sale_list&widget=true&MembershipAccountId=" + pageBase.getId(); %>
        <v:tab-item caption="@Common.Membership" icon="membership.png" tab="membership" jsp="<%=jsp_sale%>" />
      <% } %>
              
      <%-- ACTION --%>
      <% if ((account.ActionCount.getInt() > 0) || pageBase.isTab("tab", "action")) { %>
        <v:tab-item caption="@Common.Email" fa="envelope" tab="action" jsp="../common/page_tab_actions.jsp" />
      <% } %>
              
      <%-- WAREHOUSE --%>
      <% if ((account.WarehouseCount.getInt() > 0) || pageBase.isTab("tab", "warehouse")) { %>
        <v:tab-item caption="@Common.Warehouses" icon="warehouse.png" tab="warehouse" jsp="account_tab_warehouse.jsp" />
      <% } %>
              
      <%-- EXT-MEDIA --%>
      <% if (((account.ExtMediaCount.getInt() > 0) || (account.ExtMediaBatchCount.getInt() > 0)) || pageBase.isTab("tab", "extmedia")) { %>
        <v:tab-item caption="@Media.ExtMediaCodeTab" icon="media.png" tab="extmedia" jsp="account_tab_extmedia.jsp" />
      <% } %>
      
      <%-- CROSS PLATFORM PRODUCTS --%>
      <% if (rights.SystemSetupCrossPlatform.canRead()) { %>
        <% if ((account.XPIProdCrossSellCount.getInt() > 0) || pageBase.isTab("tab", "xpi_sales")) { %>
          <v:tab-item caption="@Product.ProductTypes" icon="<%=LkSNEntityType.ProductType.getIconName()%>" jsp="account_tab_xpi_product.jsp" tab="xpi_sales"/>
        <% } %>
      <% } %>
      
      <%-- CROSS PLATFORM TRANSACTIONS --%>
      <% if (rights.SystemSetupCrossPlatform.canRead()) { %>      
        <% if ((account.XPITransactionCount.getInt() > 0) || pageBase.isTab("tab", "xpi_trans")) { %>
          <v:tab-item caption="@XPI.CrossTransactions" icon="transaction.png" jsp="account_tab_xpi_transaction.jsp" tab="xpi_trans"/>
        <% } %>
      <% } %>
      
      <%-- SALE TABLE --%>
      <% if (LkSNEntityType.OperatingArea.equals(account.EntityType.getLkValue()) && ((account.OpentabTableCount.getInt() > 0) || pageBase.isTab("tab", "opentab_table"))) { %>
        <v:tab-item caption="@OpenTab.Tables" icon="table.png" tab="opentab_table" jsp="account_tab_opentab_table.jsp" />
      <% } %>
      
      <%-- REPOSITORY --%>
      <% if ((account.RepositoryCount.getInt() > 0) || pageBase.isTab("tab", "repository")) { %>
        <% String jsp_repository = pageBase.getContextURI() + "?page=repositorylist_widget&id=" + pageBase.getId() + "&EntityType=" + account.EntityType.getInt() + "&readonly=" + !canEdit; %>
        <v:tab-item caption="@Common.Documents" icon="attachment.png" tab="repository" jsp="<%=jsp_repository%>" />
      <% } %>
      
      <%-- USR ACTIVITY --%>
      <% if (LkSNEntityType.Person.equals(account.EntityType.getLkValue()) && ((account.UserActivityCount.getInt() > 0))) { %>
        <% String jsp_activity = pageBase.getContextURI() + "?page=grid_widget&jsp=account/user_activity_tab.jsp&EntityType=" + LkSNEntityType.Person.getCode();%>
        <v:tab-item caption="@Account.UserActivity" fa="sign-in-alt" tab="user_activity" jsp="<%=jsp_activity%>" />
      <% } %>
      
      <%-- LOGS --%>
      <% if (pageBase.isTab("tab", "logs") || pageBase.getBLDef().hasLogs(pageBase.getId())) { %>
        <v:tab-item caption="@Common.Logs" icon="<%=LkSNEntityType.Log.getIconName()%>" tab="logs" jsp="../log/log_tab_widget.jsp" />
      <% } %>
      
    <% } %>
    
    
    <% if (!pageBase.isNewItem() && !BLBO_DBInfo.isSystemUser(account.AccountCode.getString())) { %>
      <%-- ADD --%>
      <v:tab-plus>
        <% if(canEdit) { %>
          <% if (account.EntityType.isLookup(LkSNEntityType.Person) && !pageBase.isNewItem() && canDelete) { %>
            <v:popup-item caption="@Common.Merge" fa="merge" href="javascript:doAddToMerge()"/>
          <% } %> 
	        <v:popup-divider/>
	        <%-- FINANCE --%>
	        <% if (!account.HasFinance.getBoolean() && account.EntityType.isLookup(LkSNEntityType.Organization) && (pageBase.getRights().CreditLine.canCreate() || pageBase.getRights().CreditLine.canUpdate() || pageBase.getRights().CreditLine.canDelete())) { %>
	          <% String hrefFinance = pageBase.getContextURL() + "?page=account&id=" + pageBase.getId() + "&tab=finance"; %>
	          <v:popup-item caption="@Account.Credit.FinanceSetup" title="@Account.Credit.FinanceSetupHint" fa="money-check-alt" href="<%=hrefFinance%>"/>
	        <% } %>
	        <%-- SECURITY --%>
	        <% if (!account.HasSecurity.getBoolean() && account.EntityType.isLookup(LkSNEntityType.Person) && securityCreate) { %>
	          <% boolean defaultB2B = pageBase.getBL(BLBO_Account.class).isB2BOrganization(account.ParentAccountId.getString()); %>
	          <% String hrefAddSecurity = "javascript:asyncDialogEasy('account/security_dialog', 'id=" + pageBase.getId() + "&loginUserName=" + "&DefaultB2B=" + defaultB2B + "')"; %>
	          <v:popup-item caption="@Account.SecuritySetup" title="@Account.SecuritySetupHint" fa="lock" href="<%=hrefAddSecurity%>"/>
	        <% } %>
	        <%-- API FIREWALL --%>
	        <% if ((account.ApiFirewallCount.getInt() == 0) && account.EntityType.isLookup(LkSNEntityType.Licensee, LkSNEntityType.Location, LkSNEntityType.OperatingArea)) { %>
	          <% String hrefApiFW = pageBase.getContextURL() + "?page=account&id=" + pageBase.getId() + "&tab=apifw"; %>
	          <v:popup-item caption="@System.ApiFirewall" fa="block-brick-fire" href="<%=hrefApiFW%>"/>
	        <% } %>
	        <%-- TAX EXEMPT --%>
	        <% if ((account.TaxExemptCount.getInt() == 0) && account.EntityType.isLookup(LkSNEntityType.Organization, LkSNEntityType.Person)) { %>
	          <% String hrefTaxExempt = pageBase.getContextURL() + "?page=account&id=" + pageBase.getId() + "&tab=taxexempt"; %>
	          <v:popup-item caption="@Account.TaxExemptCertificates" fa="certificate" href="<%=hrefTaxExempt%>"/>
	        <% } %>
	        <%
	        if (account.EntityType.isLookup(LkSNEntityType.Person) && LkSNBiometricOverrideLevel.isAllowed(pageBase.getRights().BiometricOverrideLevel.getLkValue())) {
	        %>
            <v:popup-item caption="@Ticket.BiometricOverrideLevel" fa="fingerprint" onclick="showBiometricOverrideDialog()"/>
          <% } %>
	        <v:popup-divider/>
	        <% if (account.EntityType.isLookup(LkSNEntityType.Location)) { %>
	          <%-- LOCATION --%>
	          <% String hrefNewLocation = pageBase.getContextURL() + "?page=account&id=new&ParentAccountId=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.Location.getCode(); %>
	          <v:popup-item caption="@Account.NewLocation" icon="location.png" href="<%=hrefNewLocation%>"/>
	          <%-- EVENT --%>
	          <% String hrefNewEvent = pageBase.getContextURL() + "?page=event&id=new&AccountId=" + pageBase.getId(); %>
	          <v:popup-item caption="@Event.NewEvent" icon="<%=LkSNEntityType.Event.getIconName()%>" href="<%=hrefNewEvent%>"/>
	          <%-- NEW PRODUCT TYPE --%>
	          <% String hrefProduct = "javascript:asyncDialogEasy('product/product_create_dialog', 'ParentEntityType=" + account.EntityType.getInt() + "&ParentEntityId=" + pageBase.getId() + "')"; %>
	          <v:popup-item caption="@Product.NewProductType" icon="<%=LkSNEntityType.ProductType.getIconName()%>" href="<%=hrefProduct%>"/>
	          <%-- PRODUCT FAMILY --%>
	          <% String hrefProductFamily = pageBase.getContextURL() + "?page=prodfamily&id=new&ParentEntityType=" + account.EntityType.getInt() + "&ParentEntityId=" + pageBase.getId(); %>
	          <v:popup-item caption="@Product.NewProductFamily" icon="<%=LkSNEntityType.ProductFamily.getIconName()%>" href="<%=hrefProductFamily%>"/>
	          <%-- ATTRIBUTE --%>
	          <% String hrefAttribute = "javascript:asyncDialogEasy('attribute/attribute_dialog', 'id=new&ParentEntityType=" + account.EntityType.getInt() + "&ParentEntityId=" + pageBase.getId() + "')"; %>
	          <v:popup-item caption="@Product.NewAttribute" icon="attribute.png" href="<%=hrefAttribute%>"/>
	          <%-- PERF.TYPE --%>
	          <% String hrefPerfType = pageBase.getContextURL() + "?page=performancetype&id=new&ParentEntityType=" + account.EntityType.getInt() + "&ParentEntityId=" + pageBase.getId(); %>
	          <v:popup-item caption="@Performance.NewPerformanceType" icon="pricetable.png" href="<%=hrefPerfType%>"/>
	          <%-- WAREHOUSE --%>
	          <% String hrefWarehouse = pageBase.getContextURL() + "?page=warehouse&id=new&LocationId=" + pageBase.getId(); %>
	          <v:popup-item caption="@Common.WarehouseNew" icon="warehouse.png" href="<%=hrefWarehouse%>"/>
	        <% } %>
	        
	        <% if (account.EntityType.isLookup(LkSNEntityType.CrossPlatform)) { %>
	          <%-- CROSS PLATFORM SALES --%>
	          <% if (rights.SystemSetupCrossPlatform.canRead()) { %>
	            <% String hrefXPI = ConfigTag.getValue("site_url") + "/admin?page=account&tab=xpi_sales&id=" + pageBase.getId(); %>
	            <v:popup-item caption="@Product.ProductTypes" icon="crossplatform.png" href="<%=hrefXPI%>"/>
	          <% } %>
	        <% } %>
	        
	        <% if (account.EntityType.isLookup(LkSNEntityType.Organization, LkSNEntityType.Location)) { %>
	          <v:popup-divider/>
	          <%-- ORGANIZATION --%>
	          <% if (rights.AccountORGs.getOverallCRUD().canCreate()) { 
	               String hrefNewOrganization= pageBase.getContextURL() + "?page=account&id=new&ParentAccountId=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.Organization.getCode(); %>
	               <v:popup-item caption="@Account.NewOrganization" fa="building" href="<%=hrefNewOrganization%>"/>
	          <% }%>
	        <% } %>  
	        <% if (account.EntityType.isLookup(LkSNEntityType.Organization, LkSNEntityType.Location)) { %>
	          <%-- PERSON --%>
	          <% if (rights.AccountPRSs.getOverallCRUD().canCreate()) { 
                   String hrefNewPerson = pageBase.getContextURL() + "?page=account&id=new&ParentAccountId=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.Person.getCode(); %>
                   <v:popup-item caption="@Account.NewPerson" fa="address-card" href="<%=hrefNewPerson%>"/>
	          <% }%>
	        <% } %>  	        
	        <% if (!pageBase.isNewItem() && account.EntityType.isLookup(LkSNEntityType.Licensee)) { %>
	          <%-- MASTER KEY --%>
	          <% if (rights.SuperUser.getBoolean() || rights.Encryption.getBoolean()) { %>
	            <v:popup-item caption="@Common.Encryption" fa="file-lock" href="javascript:asyncDialogEasy('common/masterkey_dialog')"/>
	          <% } %>
	          
	          <%-- UPLOAD STAT DATE --%>
	          <v:popup-item caption="Import Stat Date" fa="sign-in" href="javascript:asyncDialogEasy('statdate_import_dialog')"/>
	          
	          <%-- UPLOAD STAT TIME --%>
	          <v:popup-item caption="Import Stat Time" fa="sign-in" href="javascript:asyncDialogEasy('stattime_import_dialog')"/>
	          
	        <% } %>
	        
	        <v:popup-divider/>
          <% } %>
        
        <% if (!pageBase.isNewItem() && canRead && !account.EntityType.isLookup(LkSNEntityType.Resource)) { %>
          <%
          RightEditBean reb = pageBase.getBL(BLBO_Right.class).getRightEditBean(account.EntityType.getLkValue(), account.AccountId.getString(), accountLocationIDs);

          boolean b2bFilter = false;
          if (account.EntityType.isLookup(LkSNEntityType.Person)) {
            reb.getRightsCRUD().setRead(reb.getRightsCRUD().canRead() && account.HasSecurity.getBoolean());
            b2bFilter = account.AccountLogin.LoginB2B.getBoolean();
          }
          else if (account.EntityType.isLookup(LkSNEntityType.Organization, LkSNEntityType.CrossPlatform, LkSNEntityType.Association, LkSNEntityType.AssociationMember)) 
            b2bFilter = account.HasFinance.getBoolean() && !account.AccountFinance.B2BWorkstationId.isNull();
          %>
          <%-- CONFIG --%>
          <% if (reb.getConfigCRUD().canRead()) { %>
             <% String hrefConfig = "javascript:asyncDialogEasy('right/rights_dialog', 'Filter=setup&EntityType=" + account.EntityType.getInt() + "&EntityId=" + pageBase.getId()  + "&ReadOnly=" + !reb.getConfigCRUD().canUpdate() + "')"; %>
             <v:popup-item caption="@Common.Configuration" fa="tools" href="<%=hrefConfig%>"/>
          <% } %>
          <%-- RIGHTS --%>
          <% if (reb.getRightsCRUD().canRead()) { %>
            <% String filter = b2bFilter ? "rightB2B" : "right"; %>
            <% String hrefRight = "javascript:asyncDialogEasy('right/rights_dialog', 'Filter=" + filter + "&EntityType=" + account.EntityType.getInt() + "&EntityId=" + pageBase.getId() + "&ReadOnly=" + !reb.getRightsCRUD().canUpdate() + "')"; %>
            <v:popup-item caption="@Common.Rights" fa="key" href="<%=hrefRight%>"/>
          <% } %>
        <% } %>
        
        <% if (canEdit) { %>
        
          <%-- RELATED LOCATIONS --%>
          <% if (account.EntityType.isLookup(LkSNEntityType.Organization) || account.EntityType.isLookup(LkSNEntityType.Person)) { %>
            <% String hrefLocationTab = "javascript:asyncDialogEasy('common/location_list_dialog', 'id=" + pageBase.getId() + "&EntityType=" + account.EntityType.getInt() + "')"; %>
            <v:popup-item caption="@Common.RelatedLocations" fa="map-marker" href="<%=hrefLocationTab%>"/>
          <% } %>
      
          <% if (account.EntityType.isLookup(LkSNEntityType.Organization)) { %>
            <v:popup-divider/>
            <%-- IMPORT EXTERNAL MEDIA CODE --%>
            <% String hrefImport = "javascript:asyncDialogEasy('account/account_extmedia_import_dialog', 'id=" + pageBase.getId() + "')"; %>
            <v:popup-item caption="@Account.ImportExtMediaCodes" title="@Account.ImportExtMediaCodesHint" fa="sign-in" href="<%=hrefImport%>"/>
          <% } %>

          <% if (account.EntityType.isLookup(LkSNEntityType.OperatingArea)) { %>
            <%-- OPENTAB TABLE --%>
            <% String hrefOpentabTable = ConfigTag.getValue("site_url") + "/admin?page=account&tab=opentab_table&id=" + pageBase.getId(); %>
            <v:popup-item caption="@OpenTab.Tables" icon="table.png" href="<%=hrefOpentabTable%>"/>
          <% } %>
          
          <v:popup-divider/>
          
	      <%-- SIAE --%>
	      <% if (BLBO_DBInfo.isSiae() && rights.FiscalSystemView.getBoolean() && !pageBase.isNewItem()) { %>
	        <v:popup-divider/>
	        <% if (account.EntityType.isLookup(LkSNEntityType.Organization)) { %>
	          <% String hrefSIAE = "javascript:asyncDialogEasy('siae/organizer_dialog', 'id=" + pageBase.getId() + "')"; %>
	          <v:popup-item caption="SIAE" icon="siae.png" href="<%=hrefSIAE%>"/>
	        <% } %>
	        <% if (account.EntityType.isLookup(LkSNEntityType.Location)) { %>
	          <% String hrefSIAE = "javascript:asyncDialogEasy('siae/location_dialog', 'id=" + pageBase.getId() + "')"; %>
	          <v:popup-item caption="SIAE" icon="siae.png" href="<%=hrefSIAE%>"/>
	        <% } %>
	      <% } %>
	        
	      <v:popup-divider/>
	      <%-- UPLOAD --%>
	      <% String hrefUpload = "javascript:showUploadDialog(" + account.EntityType.getInt() + ", '" + account.AccountId.getString() + "', " + (account.RepositoryCount.getInt() == 0) + ");"; %>
	      <v:popup-item caption="@Common.UploadFile" title="@Common.UploadFileHint" fa="upload" href="<%=hrefUpload%>"/>
	    <% } %>
	    <% if (canRead) { %>
	      <% if (account.EntityType.isLookup(LkSNEntityType.Organization)) { %>
            <v:popup-divider/>
            <%-- CODE ALIASES--%>
            <% String hrefCodeAlias = "javascript:asyncDialogEasy('code_alias_dialog', 'id=" + pageBase.getId() + "&EntityType=" + LkSNEntityType.Organization.getCode() + "&readonly=" + !canEdit + "')"; %>
            <v:popup-item caption="@Common.CodeAliases" fa="barcode" href="<%=hrefCodeAlias%>"/>
          <% } %>    
	        <%-- NOTES --%>
	        <% String hrefNotes = "javascript:asyncDialogEasy('common/notes_dialog', 'id=" + pageBase.getId() + "&EntityType=" + account.EntityType.getInt() + "&ReadOnly=" + !canEdit + "');"; %>
	        <v:popup-item caption="@Common.Notes" fa="comments" href="<%=hrefNotes%>"/>
	        <%-- HISTORY --%>
	        <% if (rights.History.getBoolean()) { %>
	          <% String hrefHistory = "javascript:asyncDialogEasy('common/history_detail_dialog', 'id=" + pageBase.getId() + "');"; %>
	          <v:popup-item caption="@Common.History" fa="history" href="<%=hrefHistory%>"/>
	        <% } %>  
        <% } %>
      </v:tab-plus>
    <% } %>
  </v:tab-group>
</div>

<script>
  $(document).on('OnEntityChange', function(event, bean) {
    if (<%=(account.ProductCount.getInt() == 0)%> && (bean.EntityType == <%=LkSNEntityType.ProductType.getCode()%>))
      window.location.reload();
  });
  
  function showBiometricOverrideDialog() {
	  var params = "AccountId=<%=pageBase.getId()%>" + "&BiometricOverride=" + <%=account.BiometricOverride.getInt()%>;
	  asyncDialogEasy("account/account_biometric_override_dialog", params);
	}
</script>
 
<jsp:include page="/resources/common/footer.jsp"/>
