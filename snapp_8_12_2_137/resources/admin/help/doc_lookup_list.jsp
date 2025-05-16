<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageDocLookupList" scope="request"/>

<jsp:include page="/resources/common/header.jsp"/>
<v:page-title-box/>

<v:tab-group name="tab" main="true" clazz="sidenav-large">
  <v:tab-item-embedded tab="tabs-dashboard" caption="@Common.Search" default="true">
    <v:tab-content clazz="v-height-to-bottom">
      <v:tab-group id="nav-lookup" name="" sideNav="true" showSearch="true">
        <% for (LookupTable table : LookupManager.getTables(LkSN.class)) { %>
          <%
          String tab = "tab" + table.getCode();
          String caption = "[" + table.getCode() + "] " + table.getDescription();
          %>
          <v:tab-item-embedded tab="<%=tab%>" caption="<%=caption%>">
            <v:tab-content>
              <% String[] additionalColumns = table.getAdditionalDocColumns(); %>
              <v:grid>
                <thead>
                  <v:grid-title caption="<%=caption%>"/>
                  <tr>
                    <td align="right">
                      <v:itl key="@Common.Code"/>
                    </td>
                    <td width="25%">
                      <div><v:itl key="@Common.Name"/></div>
                      <div>Internal name</div>
                    </td>
                    <td width="<%=75-additionalColumns.length*15%>%"><v:itl key="@Common.Description"/></td>
                    <% for (String col : additionalColumns) { %>
                      <td width="15%"><v:itl key="<%=col%>"/></td>
                    <% } %>
                  </tr>
                </thead>
                <tbody>
                  <% for (LookupItem item : table.getItems()) { %>
                    <tr class="grid-row">
                      <td align="right">
                        <b><%=item.getCode()%></b>
                      </td>
                      <td>
                        <a href="" class="list-title"><%=item.getHtmlDescription(pageBase.getLang())%></a>
                        <div class="list-subtitle"><%=item.getHtmlInternalDescription()%></div>
                      </td>
                      <td><span class="list-subtitle"><v:itl key="<%=item.getRawHint()%>"/></span></td>
                      <% for (int i=0; i<additionalColumns.length; i++) { %>
                        <td><%=JvString.htmlEncode(item.getAdditionalDocColumnValue(i, pageBase.getLang()))%></td>
                      <% } %>
                    </tr>
                  <% } %>
                </tbody>
              </v:grid>
            </v:tab-content>
          </v:tab-item-embedded> 
        <% } %>
      </v:tab-group>
    </v:tab-content>
  </v:tab-item-embedded>
</v:tab-group>


<script>
$(document).ready(function() {
  var $nav = $("#nav-lookup");
  var $txtSearch = $nav.find(".txt-search");
  
  var lookupTable = parseInt(<%=JvString.escapeHtml(pageBase.getNullParameter("LookupTable"))%>);
  if (!isNaN(lookupTable)) 
    $("a[href='#tab" + lookupTable + "']").closest(".v-tabs-item").activateTab();
  
  $txtSearch.keyup(_search);
  
  function _search() {
    $nav.find(".search-hide").removeClass("search-hide");

    var keys = getSearchKeys($txtSearch.val());
    if (keys.length > 0) {
      $nav.find(".v-tabs-item").addClass("search-hide").each(function(idx, item) {
        var $item = $(item);
        if (isTextFullSearch($item.find(".v-tabs-caption").text(), keys))
          $item.removeClass("search-hide");
      });
    }
  }
});
</script>

<jsp:include page="/resources/common/footer.jsp"/>
