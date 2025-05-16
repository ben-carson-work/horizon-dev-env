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

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.b2b.page.PageB2B_CreditList" scope="request"/>
<% int[] defaultStatusFilter = new int[] {LkSNCreditStatus.Opened.getCode(), LkSNCreditStatus.Invoiced.getCode()}; %>

<jsp:include page="/resources/common/header.jsp"/>
<v:page-title-box/>


<v:tab-group name="tab" main="true"> 
  <v:tab-item-embedded tab="tabs-dashboard" caption="@Common.Search" default="true">
    <div class="tab-toolbar">
      <v:button caption="@Common.Search" fa="search" onclick="search()" />
      <v:pagebox gridId="credit-grid"/>
    </div>

    <div class="tab-content">
      <div class="profile-pic-div">
        <v:widget caption="@Common.Search">
          <v:widget-block>
            <input type="text" id="SaleCode" class="form-control default-focus" placeholder="<v:itl key="@Sale.PNR"/>"/>
          </v:widget-block>
        </v:widget>

        <v:widget caption="@Account.Credit.DueDate">
          <v:widget-block>
            <label for="FromDueDate"><v:itl key="@Common.From"/></label><br/>
            <v:input-text type="datepicker" field="FromDueDate"/>
              
            <div class="filter-divider"></div>
              
            <label for="ToDueDate"><v:itl key="@Common.To"/></label><br/>
            <v:input-text type="datepicker" field="ToDueDate"/>
          </v:widget-block>
        </v:widget>
    
        <v:widget caption="@Common.Status">
          <v:widget-block>
          <% for (LookupItem status : LkSN.CreditStatus.getItems()) { %>
            <v:db-checkbox field="CreditStatus" caption="<%=status.getDescription(pageBase.getLang())%>" value="<%=String.valueOf(status.getCode())%>" checked="<%=JvArray.contains(status.getCode(), defaultStatusFilter)%>" /><br/>
          <% } %>
          </v:widget-block>
        </v:widget>
      </div>
      
      <div class="profile-cont-div">
        <% String params = "CreditStatus=" + JvArray.arrayToString(defaultStatusFilter, ","); %>
        <v:async-grid id="credit-grid" jsp="credit/credit_grid.jsp" params="<%=params%>" />
      </div>
    </div>
  </v:tab-item-embedded>
</v:tab-group>



<script>

function search() {
  setGridUrlParam("#credit-grid", "SaleCode", $("#SaleCode").val());
  setGridUrlParam("#credit-grid", "FromDueDate", $("#FromDueDate-picker").getXMLDate());
  setGridUrlParam("#credit-grid", "ToDueDate", $("#ToDueDate-picker").getXMLDate());
  setGridUrlParam("#credit-grid", "CreditStatus", $("[name='CreditStatus']").getCheckedValues());
  changeGridPage("#credit-grid", "first");
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
