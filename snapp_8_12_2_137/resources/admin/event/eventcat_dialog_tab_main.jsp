<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<div class="tab-content">

  <v:widget caption="@Common.General" icon="profile.png">
    <v:widget-block>
      <table class="form-table">
        <tr>
          <th><label for="eventcat.EventCategoryCode"><v:itl key="@Common.Code"/></label></th>
          <td><v:input-text field="eventcat.EventCategoryCode" /></td>
        </tr>
        <tr>
          <th><label for="eventcat.EventCategoryName"><v:itl key="@Common.Name"/></label></th>
          <td><v:input-text field="eventcat.EventCategoryName" /></td>
        </tr>
        <tr>
          <th><label for="eventcat.EventCategoryType"><v:itl key="@Common.Type"/></label></th>
          <td><v:lk-combobox field="eventcat.EventCategoryType" lookup="<%=LkSN.EventCategoryType%>" allowNull="false"/></td>
        </tr>
      </table>
    </v:widget-block>
    <v:widget-block>
      <table class="form-table">
        <tr>
          <th>&nbsp;</th>
          <td><v:db-checkbox field="eventcat.Enabled" caption="@Common.Enabled" value="true"/></td>
        </tr>
      </table>
    </v:widget-block>
    <%-- 
    <v:widget-block>
      <table class="form-table">
        <tr>
          <th>&nbsp;</th>
          <td><div id="mycombo"></div></td>
        </tr>
      </table>
    </v:widget-block>
    --%>
  </v:widget>

<script>





$(document).ready(function() {
  $("#mycombo").vcombo({
    EntityType: <%=LkSNEntityType.ProductType.getCode()%>
  });
});

</script>

</div>