<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.search.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.query.QryBO_PortfolioSlotLog.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<%
PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase");
%>

<div class="tab-toolbar">
  <v:button id="search-btn" caption="@Common.Search" fa="search"/>
  <v:pagebox gridId="wallet-transaction-grid"/>
</div>

<script>
$(document).ready(function() {
  $("#search-btn").click(search);
  
  function search() {
    try {

    	var unbindedOnly = $("input[name='UnbindedOnly']").isChecked();
    	var bindedOnly = $("input[name='BindedOnly']").isChecked();
    	
	    setGridUrlParam("#wallet-transaction-grid", "MembershipPointId", $("#MembershipPointId").val());
	    setGridUrlParam("#wallet-transaction-grid", "PortfolioSlotLogType", $("#PortfolioSlotLogType").val());
	    
	    setGridUrlParam("#wallet-transaction-grid", "UnbindedSlotLogsOnly", "false");
	    
	    if ((unbindedOnly === true) && (bindedOnly === false))
	    	setGridUrlParam("#wallet-transaction-grid", "UnbindedSlotLogsOnly", "true");
	    else
	    	setGridUrlParam("#wallet-transaction-grid", "UnbindedSlotLogsOnly", null);
	    
	    if ((unbindedOnly === false) && (bindedOnly === true))
	      setGridUrlParam("#wallet-transaction-grid", "BindedSlotLogsOnly", "true");
	    else
	    	setGridUrlParam("#wallet-transaction-grid", "BindedSlotLogsOnly", null);
	    
	    changeGridPage("#wallet-transaction-grid", "first");
    }
    catch (err) {
      showMessage(err);
    }
  }
});  
</script>


<div class="tab-content">
  <div class="profile-pic-div">
    <div class="v-filter-container">
    
      <div class="v-filter-all-condition">
        <v:widget caption="@Common.Filters">
          <v:widget-block>
            <v:itl key="@Payment.RewardPoints"/><br/>
            <snp:dyncombo id="MembershipPointId" entityType="<%=LkSNEntityType.WalletAndRewardPoint%>"/>
            <div class="filter-divider"></div>
            <div>
              <div><v:itl key="@Common.Type"/></div>
              <div><v:lk-combobox field="PortfolioSlotLogType" lookup="<%=LkSN.PortfolioSlotLogType%>"/></div>
            </div>
            <div class="filter-divider"></div>
          </v:widget-block>
        </v:widget>
        <v:widget caption="@Common.Flags">
          <v:widget-block>
            <div>
              <label class="checkbox-label"><input type="checkbox" name="UnbindedOnly"/>&nbsp;<v:itl key="@Portfolio.NotBindedSearchFlag"/></label>
              <span title="<%=pageBase.getLang().Portfolio.NotBindedSearchFlagHint.getHtmlText()%>" class="form-field-hint form-field-hint-title v-tooltip hint-tooltip"></span>
            </div>
            <div class="filter-divider"></div>
            <div>
              <label class="checkbox-label"><input type="checkbox" name="BindedOnly"/>&nbsp;<v:itl key="@Portfolio.BindedSearchFlag"/></label>
              <span title="<%=pageBase.getLang().Portfolio.BindedSearchFlagHint.getHtmlText()%>" class="form-field-hint form-field-hint-title v-tooltip hint-tooltip"></span>
            </div>
          </v:widget-block>
        </v:widget>
      </div>
    </div>
  </div>
  
  <div class="profile-cont-div">
    <% String params = "PortfolioId=" + pageBase.getNullParameter("PortfolioId");%>
    <v:async-grid id="wallet-transaction-grid" jsp="portfolio/portfolio_wallet_recap_tab_transaction_grid.jsp" params="<%=params%>"/>
  </div>
</div>