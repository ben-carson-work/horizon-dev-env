<%@page import="org.apache.commons.lang3.SystemUtils"%>
<%@page import="java.text.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageDocTableList" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<jsp:include page="/resources/common/header.jsp"/>
<v:page-title-box/>

<div class="tab-toolbar">
  <v:button caption="@Common.Search" fa="search" onclick="search()"/>
  <span class="divider"></span>
  <%if (rights.SuperUser.getBoolean()) {%>
  <v:button id="btn-regenerateAllStoreProc" fa="retweet-alt" caption="@Common.RegenerateStoredProcedures" onclick="regenerateStoreProcedure()"/>
  <% } %>
  <v:button caption="ERD Schema" fa="project-diagram" style="float:right" onclick="openErdSchemaMain()" />
</div>

<div class="tab-content">
  <div class="profile-pic-div">
    <v:widget caption="@Common.Search">
      <v:widget-block>
      <input type="text" id="full-text-search" class="form-control default-focus" placeholder="<v:itl key="@Common.FullSearch"/>" value="<%=pageBase.getEmptyParameter("FullText")%>" onkeypress="searchKeyPress()"/>
      </v:widget-block>
    </v:widget>
    <v:widget caption="Sort by:">
      <v:widget-block>
        <v:lk-combobox lookup="<%=LkSN.TableStatSort%>" field="sort-field-search" allowNull="false"/>
      </v:widget-block>
      <v:widget-block id="sort-type-search">
        <input type="radio" id="ASC" name="order" value="ASC" checked="checked">
        <label for="ASC">Ascending</label><br>
        <input type="radio" id="DESC" name="order" value="DESC">
        <label for="DESC">Descending</label><br>
      </v:widget-block>
    </v:widget>
  </div>
  <div class="profile-cont-div">
    <v:async-grid jsp="help/table_grid.jsp" id="table-grid"/>
  </div>
</div>

<script>
$(document).ready(search);

function searchKeyPress() {
  if (event.keyCode == KEY_ENTER) {
    search();
  }
}

function search() {
  setGridUrlParam("#table-grid", "FullText", $("#full-text-search").val(), false);
  setGridUrlParam("#table-grid", "SortBy", $("#sort-field-search").find(":selected").val(), false);
  setGridUrlParam("#table-grid", "SortType", $("input[name=order]").filter(":checked").val(), true);
}

function openErdSchemaMain() {
  window.open("admin?page=erdschema","_blank");
}
      
function regenerateStoreProcedure() {
  var tableNames = $("[name='TableName']").getCheckedValues();
  var tableCount = (getNull(tableNames) == null) ? $("[name='TableName']").length : tableNames.split(",").length; 
  
  confirmDialog(itl("@Common.RegenerateStoredProceduresConfirm", tableCount), function() {
    var reqDO = {
      Command: "RegenerateStoreProcedures",
      RegenerateStoreProcedures: {
        TableNames: tableNames 
      }
    };
    
    showWaitGlass();
    vgsService("SYSTEM", reqDO, false, function(ansDO) {
      hideWaitGlass();
    });
  });
}
</script>

<jsp:include page="/resources/common/footer.jsp"/>