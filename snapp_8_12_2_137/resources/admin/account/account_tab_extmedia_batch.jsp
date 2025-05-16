<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageAccount" scope="request"/>

<script>
    function search() {
      setGridUrlParam("#extmediabatch-grid", "FullText", $("#search-text").val());
      setGridUrlParam("#extmediabatch-grid", "BatchStatus", $("[name='Status']").getCheckedValues(), false);
      setGridUrlParam("#extmediabatch-grid", "FromDate", $("#FromDate-picker").getXMLDate(), false);
      setGridUrlParam("#extmediabatch-grid", "ToDate", $("#ToDate-picker").getXMLDate(), true);
    }
       
    function searchKeyPress() {
      if (event.keyCode == KEY_ENTER) {
        search();
        event.preventDefault(); 
      }
    }
</script>

<div class="tab-toolbar">
  <v:button caption="@Common.Search" fa="search" href="javascript:search()" />
  <v:pagebox gridId="extmediabatch-grid"/>
</div>

<div class="tab-content">
  <div id="main-container">
    <div id="filter-column" class="profile-pic-div">
      <div class="form-toolbar">
        <input type="text" id="search-text" class="form-control default-focus v-filter-code" placeholder="<v:itl key="@Common.Search" />" onkeypress="searchKeyPress()" />
      </div>
      <v:widget caption="@ExtMediaBatch.ExpirationDateRange">
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
        </v:widget-block>
      </v:widget>      
      <v:widget caption="@Common.Status">
        <v:widget-block>
          <% for (LookupItem item : LkSN.ExtMediaBatchStatus.getItems()) { %>
          <%
            LookupItem commonStatus = LkSNExtMediaBatchStatus.findCommonStatus(item);
          %>
          <label style="cursor: pointer"><input
            type="checkbox" name="Status"
            value="<%=item.getCode()%>" 
             /> <span
            class="snp-inline-legend"
            style="background-color:<%=LkCommonStatus.findColorHex(commonStatus)%>"></span> <%=item.getHtmlDescription(pageBase.getLang())%>
            </label>
          <br />
          <% } %>
        </v:widget-block>
      </v:widget>
    </div>
  </div>
  <div class="profile-cont-div">
    <% String params = "AccountId=" + pageBase.getId(); %>
    <v:async-grid id="extmediabatch-grid" jsp="account/extmediabatch_grid.jsp" params="<%=params%>" />
  </div>
</div>

