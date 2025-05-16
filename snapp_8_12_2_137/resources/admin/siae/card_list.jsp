<%@page import="com.vgs.cl.lookup.LookupManager"%>
<%@page import="com.vgs.cl.JvArray"%>
<%@page import="com.vgs.cl.lookup.LookupItem"%>
<%@page import="com.vgs.web.library.BLBO_Siae"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageSiaeCardList" scope="request"/>
<jsp:include page="/resources/common/header.jsp"/>
<% int[] defaultStatusFilter = LookupManager.getIntArray(LkSN.SiaeCardStatus.getItems()); %>

<v:page-title-box/>
<%
BLBO_Siae bl = pageBase.getBLDef();
%>
<div id="main-container">
  <div class="mainlist-container">
      <jsp:include page="/resources/admin/siae/siae_alert.jsp" />
    <div class="profile-pic-div">
      <div class="form-toolbar">
        <input type="text" id="full-text-search" class="form-control default-focus" placeholder="<v:itl key="@Common.FullSearch"/>" value="<%=pageBase.getEmptyParameter("FullText")%>"/>
        <script>
          $("#full-text-search").keypress(function(e) {
            if (e.keyCode == KEY_ENTER) {
              search();
              return false;
            }
          });
        </script>
      </div>
      <v:widget caption="@Common.Status" icon="flag.png">
        <v:widget-block>
        <% for (LookupItem status : LkSN.SiaeCardStatus.getItems()) { %>
          <v:db-checkbox field="Status" caption="<%=status.getDescription()%>" value="<%=String.valueOf(status.getCode())%>" checked="<%=JvArray.contains(status.getCode(), defaultStatusFilter)%>" /><br/>
        <% } %>
        </v:widget-block>
      </v:widget>
    </div>
    
    <div class="profile-cont-div">      
      <div class="form-toolbar">
        <v:button caption="@Common.Search" fa="search" href="javascript:search()"/>
        <span class="divider"></span>
        <v:button id="del-btn" caption="@Common.Delete" fa="trash" enabled="<%=bl.isSiaeEnabled()%>" href="javascript:doDelete()"/>
        <v:pagebox gridId="card-grid"/>
      </div>
      <div>
        <v:last-error/>
        <v:async-grid id="card-grid" jsp="siae/card_grid.jsp" />
      </div>
    </div>  
  </div>
</div>
<script>

function doDelete() {
  var ids = $("[name='CardCode']").getCheckedValues();
  if (ids == "")
    showMessage("<v:itl key="@Common.NoElementWasSelected" encode="UTF-8"/>");
  else {
    confirmDialog(null, function() {
      var reqDO = {
        Command: "DeleteCards",
        DeleteCards: {
          Codes: ids
        }
      };
      
      vgsService("Siae", reqDO, false, function(ansDO) {
        triggerEntityChange(<%=LkSNEntityType.SiaeCard.getCode()%>);
      });
    });
  }
}

function search() {
  setGridUrlParam("#card-grid", "CardStatus", $("[name='Status']").getCheckedValues());
  setGridUrlParam("#card-grid", "FullText", $("#full-text-search").val(), true);
}

</script>
<jsp:include page="/resources/common/footer.jsp"/>