<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageAccount" scope="request"/>
<jsp:useBean id="account" scope="request" class="com.vgs.snapp.dataobject.DOAccount"/>

<div class="tab-toolbar">
  <v:button fa="search" caption="@Common.Search" href="javascript:search()"/>
  <% String hrefImport = "javascript:asyncDialogEasy('account/account_extmedia_import_dialog', 'id=" + pageBase.getId() + "')"; %>
  <v:button fa="sign-in" caption="@Common.Import" href="<%=hrefImport%>"/>

  <v:pagebox gridId="extmedia-grid-container"/>
</div>

<script>
    function search() {
      setGridUrlParam("#extmedia-grid-container", "ExtMediaCode", $("#full-text-search").val(), false);
      setGridUrlParam("#extmedia-grid-container", "FromDate", $("#FromDate-picker").getXMLDate(), false);
      setGridUrlParam("#extmedia-grid-container", "ToDate", $("#ToDate-picker").getXMLDate(), true);
    }
    
    $(document).on("OnEntityChange", search);
</script>

<div class="tab-content">
  <v:last-error/>

  <div id="main-container">
    <div id="filter-column" class="profile-pic-div">
     
      <div class="form-toolbar">
        <input type="text" id="full-text-search" class="form-control default-focus" placeholder="<v:itl key="@Common.Code"/>" style="width:97%" value="<%=pageBase.getEmptyParameter("FullText")%>"/>
        <script>
          $("#full-text-search").keypress(function(e) {
            if (e.keyCode == KEY_ENTER) {
              search();
              return false;
            }
          });
        </script>
      </div>

      <v:widget caption="@ExtMediaBatch.ImportDateRange"><v:widget-block>
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
      </v:widget-block></v:widget>
    </div>
  </div>
  <div class="profile-cont-div">
    <% String params = "AccountId=" + pageBase.getId(); %>
    <v:async-grid id="extmedia-grid-container" jsp="account/extmedia_grid.jsp" params="<%=params%>" />
  </div>
</div>

