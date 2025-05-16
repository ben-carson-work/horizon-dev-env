<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageBoxList" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<jsp:include page="/resources/common/header.jsp"/>
<v:page-title-box/>

<v:last-error/>

<%
  String defaultFromDate = pageBase.getBrowserFiscalDate().getXMLDate();
  String defaultToDate = pageBase.getBrowserFiscalDate().getXMLDate();
  
  pageBase.setDefaultParameter("FromDate", defaultFromDate);
  pageBase.setDefaultParameter("ToDate", defaultToDate);
%>

<script>

function search() {  
  try {
    var boxCode = $("#BoxCode").val();
    var dateFrom = $("#FromDate-picker").datepicker('getDate');
    var dateTo = $("#ToDate-picker").datepicker('getDate');
    
    if (boxCode!="" || checkMaxDateRange(dateFrom, dateTo, <%=rights.SearchesMaxDateRange.getInt()%>)) {
      setGridUrlParam("#box-grid", "BoxCode", $("#BoxCode").val());
      setGridUrlParam("#box-grid", "FromDate", $("#FromDate-picker").getXMLDate(), false);
      setGridUrlParam("#box-grid", "ToDate", $("#ToDate-picker").getXMLDate(), false);
      setGridUrlParam("#box-grid", "BoxStatus", $("[name='BoxStatus']").getCheckedValues(), false);
      setGridUrlParam("#box-grid", "CashLimitWarnOnly", $("[name='CashLimitWarnOnly']").isChecked(), false);
      setGridUrlParam("#box-grid", "LocationId", $("#LocationId").val() || "", false);
      setGridUrlParam("#box-grid", "OpAreaId", $("#OpAreaId").val() || "", false);
      setGridUrlParam("#box-grid", "UserAccountId", $("#UserAccountId").val() || "", false);
      setGridUrlParam("#box-grid", "LastDepositLocationId", $("#LastDepositLocationId").val() || "", false);
      setGridUrlParam("#box-grid", "LastDepositOpAreaId", $("#LastDepositOpAreaId").val() || "", false);
      setGridUrlParam("#box-grid", "LastDepositWorkstationId", $("#LastDepositWorkstationId").val() || "", false);
      setGridNumericParam("#box-grid", "BagNumber", $("#BagNumber").val());
      
      changeGridPage("#box-grid", "first");
    }
  }
  catch (err) {
    showMessage(err);
  }
}

function searchOnEnterKey() {
  if (event.keyCode == KEY_ENTER) {
    search();
    return false;
  }
}

</script>

<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-dashboard" caption="@Common.Search" default="true">
    <div class="tab-toolbar">
      <v:button caption="@Common.Search" fa="search" href="javascript:search()"/>
      <v:pagebox gridId="box-grid"/>
    </div>

    <div class="tab-content">
      <div class="profile-pic-div">
        <div class="v-filter-container">
          <v:widget>
            <v:widget-block>
              <input type="text" id="BoxCode" class="form-control default-focus v-filter-code" placeholder="<v:itl key="@Common.BoxCode"/>" onkeypress="searchOnEnterKey()"/>
            </v:widget-block>
          </v:widget>
          
          <div class="v-filter-all-condition">
            <v:widget caption="@Common.Filters">
              <v:widget-block>
                <table style="width:100%">
                  <tr>
                    <td>
                      &nbsp;<v:itl key="@Common.From"/><br/>
                      <v:input-text type="datepicker" field="FromDate"/>
                    </td>
                    <td>&nbsp;</td>
                    <td>
                      &nbsp;<v:itl key="@Common.To"/><br/>
                      <v:input-text type="datepicker" field="ToDate"/>
                    </td>
                  </tr>
                </table>
                
                <div class="filter-divider"></div>
                
                <div class="filter-label"><v:itl key="@Common.BagNumber"/></div>
                <input type="text" id="BagNumber" class="form-control" placeholder="<v:itl key="@Common.BagNumber"/>" onkeypress="searchOnEnterKey()"/>
                
                <div class="filter-divider"></div>
                
                <v:itl key="@Account.Location"/><br/>
                <snp:dyncombo id="LocationId" entityType="<%=LkSNEntityType.Location%>" auditLocationFilter="true"/>
                
                <div class="filter-divider"></div>
                
                <v:itl key="@Account.OpArea"/><br/>
                <snp:dyncombo id="OpAreaId" entityType="<%=LkSNEntityType.OperatingArea%>" auditLocationFilter="true" parentComboId="LocationId"/>
                
                <div class="filter-divider"></div>
                
                <div class="filter-label"><v:itl key="@Common.User"/></div>
                <snp:dyncombo id="UserAccountId" entityType="<%=LkSNEntityType.User%>"/>
              </v:widget-block>
            </v:widget>
            
            <v:widget caption="@Common.Status">
              <v:widget-block>
              <% for (LookupItem boxStatus : LkSN.BoxStatus.getItems()) { %>
                <label class="checkbox-label"><input type="checkbox" name="BoxStatus" value="<%=boxStatus.getCode()%>"> <%=boxStatus.getHtmlDescription(pageBase.getLang())%></label><br/>
              <% } %>
              </v:widget-block>
              <v:widget-block>
                <label class="checkbox-label"><input type="checkbox" name="CashLimitWarnOnly" value="true"> <v:itl key="@Box.FilterCashLimitOnly"/></label><br/>
              </v:widget-block>
            </v:widget>
            
            <v:widget caption="@Box.LastOperation">
              <v:widget-block>
                <v:itl key="@Account.Location"/><br/>
                <snp:dyncombo id="LastDepositLocationId" entityType="<%=LkSNEntityType.Location%>" auditLocationFilter="true"/>
                
                <div class="filter-divider"></div>
                
                <v:itl key="@Account.OpArea"/><br/>
                <snp:dyncombo id="LastDepositOpAreaId" entityType="<%=LkSNEntityType.OperatingArea%>" auditLocationFilter="true" parentComboId="LastDepositLocationId"/>
                
                <div class="filter-divider"></div>
                
                <v:itl key="@Common.Workstation"/><br/>
                <snp:dyncombo id="LastDepositWorkstationId" entityType="<%=LkSNEntityType.Workstation%>" auditLocationFilter="true" parentComboId="LastDepositOpAreaId"/>
              </v:widget-block>
            </v:widget>
          </div>
        </div>

      </div>
    
      <div class="profile-cont-div">
        <% String params = "FromDate=" + defaultFromDate + "&ToDate=" + defaultToDate + "&LocationAccountId=" + pageBase.getEmptyParameter("LocationAccountId"); %>
        <v:async-grid id="box-grid" jsp="box/box_grid.jsp" params="<%=params%>"/>
      </div>
    </div>
  </v:tab-item-embedded>
</v:tab-group>


<jsp:include page="/resources/common/footer.jsp"/>
