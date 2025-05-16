<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% PageBase<?> pageBase = (PageBase<?>)request.getAttribute("pageBase"); %>

<v:page-form>

<div class="tab-toolbar">
  <%
    String hrefNew = ConfigTag.getValue("site_url") + "/admin?page=workstation&id=new";
      if (pageBase.hasParameter("LocationAccountId"))
    hrefNew += "&LocationAccountId=" + pageBase.getParameter("LocationAccountId");
      if (pageBase.hasParameter("OpAreaAccountId"))
    hrefNew += "&OpAreaAccountId=" + pageBase.getParameter("OpAreaAccountId");

      String hrefNewAPT = hrefNew + "&WorkstationType=" + LkSNWorkstationType.APT.getCode();
  %>
  <v:button caption="@Common.New" fa="plus" href="<%=hrefNewAPT%>" enabled="<%=rights.SystemSetupAccessPoints.getOverallCRUD().canCreate()%>"/>
  <v:button caption="@Common.Delete" fa="trash" title="@Common.DeleteSelectedItems" href="javascript:deleteAccessPoints()" enabled="<%=rights.SystemSetupAccessPoints.getOverallCRUD().canDelete()%>"/>

  <v:pagebox gridId="apt-grid"/>
</div>

<div class="tab-content">
  <v:last-error/>
  
  <% String params = "LocationAccountId=" + pageBase.getEmptyParameter("LocationAccountId") + "&OpAreaAccountId=" + pageBase.getEmptyParameter("OpAreaAccountId"); %>
  <v:async-grid id="apt-grid" jsp="workstation/accesspoint_grid.jsp" params="<%=params%>" />
</div>
 
<script>
function deleteAccessPoints() {
  var ids = $("[name='WorkstationId']").getCheckedValues();
  if (ids == "")
    showMessage(<v:itl key="@Common.NoElementWasSelected" encode="JS"/>);
  else {
    confirmDialog(null, function() {
      var reqDO = {
        Command: "DeleteWorkstation",
        DeleteWorkstation: {
          WorkstationIDs: ids
        }
      };
      
      vgsService("Workstation", reqDO, false, function(ansDO) {
        triggerEntityChange(<%=LkSNEntityType.Workstation.getCode()%>);
      });
    });
  }
}
</script>
 
</v:page-form>
