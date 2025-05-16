<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.b2b.page.PageB2B_SaleList" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
  String defaultFromDate = JvDateTime.date().getXMLDate();
String defaultToDate = JvDateTime.date().getXMLDate();
pageBase.setDefaultParameter("FromDate", defaultFromDate);
pageBase.setDefaultParameter("ToDate", defaultToDate);

QueryDef qdefUser = new QueryDef(QryBO_Account.class);
qdefUser.addSelect(QryBO_Account.Sel.AccountId, QryBO_Account.Sel.DisplayName);
qdefUser.addSort(QryBO_Account.Sel.DisplayName);
qdefUser.addFilter(QryBO_Account.Fil.HasLogin, "true");
qdefUser.addFilter(QryBO_Account.Fil.ParentAccountId, pageBase.getSession().getOrgAccountId());
JvDataSet dsUser = pageBase.execQuery(qdefUser);
%>

<jsp:include page="/resources/common/header.jsp"/>
<v:page-title-box/>

<v:tab-group name="tab" main="true"> 
  <v:tab-item-embedded tab="tabs-dashboard" caption="@Common.Search" default="true">
    <div class="tab-toolbar">
      <v:button caption="@Common.Search" fa="search" onclick="search()" />
      <v:pagebox gridId="sale-grid"/>
    </div>

    <div class="tab-content">
      <div class="profile-pic-div">
        <v:widget caption="@Common.Search">
          <v:widget-block>
            <div style="display:flex; justify-content:space-between; align-items:center;">
              <input type="text" id="SaleCode" class="form-control default-focus" placeholder="<v:itl key="@Common.Code"/>" value="<%=pageBase.getEmptyParameter("SaleCode")%>"/>
              <v:hint-handle hint="@Sale.SaleCodeSearchHint"/>
            </div>
          </v:widget-block>
        </v:widget>
        <v:widget caption="@Common.DateRange">
          <v:widget-block>
    	      <label for="FromDate"><v:itl key="@Common.From"/></label><br/>
    	      <v:input-text type="datepicker" field="FromDate"/>
    	        
    	      <div class="filter-divider"></div>
    	        
    	      <label for="ToDate"><v:itl key="@Common.To"/></label><br/>
    	      <v:input-text type="datepicker" field="ToDate"/>
          </v:widget-block>
        </v:widget>
    
        <v:widget caption="@Common.Filters">
          <v:widget-block>
            <label for="UserAccountId"><v:itl key="@Common.User"/></label><br/>
            <v:combobox id="UserAccountId" lookupDataSet="<%=dsUser%>" captionFieldName="DisplayName" idFieldName="AccountId"/>
          </v:widget-block>
        </v:widget>
      </div>
      
      <div class="profile-cont-div">
        <% String params = "FromDate=" + defaultFromDate + "&ToDate=" + defaultToDate; %>
        <v:async-grid id="sale-grid" jsp="order/sale_grid.jsp" params="<%=params%>" />
      </div>
    </div>
  </v:tab-item-embedded>
</v:tab-group>



<script>

function search() {
	var saleCode = $("#SaleCode").val();
	var dateFrom = $("#FromDate-picker").datepicker("getDate");
	var dateTo = $("#ToDate-picker").datepicker("getDate");
	
	if (saleCode!="" || checkMaxDateRange(dateFrom, dateTo, <%=rights.SearchesMaxDateRange.getInt()%>)) {
      setGridUrlParam("#sale-grid", "SaleCode", saleCode);
	  setGridUrlParam("#sale-grid", "FromDate", $("#FromDate-picker").getXMLDate());
	  setGridUrlParam("#sale-grid", "ToDate", $("#ToDate-picker").getXMLDate());
	  setGridUrlParam("#sale-grid", "UserAccountId", ($("#UserAccountId").getComboIndex() <= 0) ? "" : $("#UserAccountId").val());
	  changeGridPage("#sale-grid", "first");
	}
}

function searchOnEnter() {
  if (event.keyCode == KEY_ENTER) {
    search();
    return false;
  }
}

$("#SaleCode").keypress(searchOnEnter);

</script>

<jsp:include page="/resources/common/footer.jsp"/>
