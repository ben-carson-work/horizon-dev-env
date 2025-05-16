<%@page import="com.vgs.snapp.library.SnappUtils"%>
<%@page import="com.vgs.web.library.BLBO_DBInfo"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageSoftware" scope="request"/>
<jsp:useBean id="rights" scope="request" class="com.vgs.snapp.dataobject.DORightRoot"/>

<div class="tab-toolbar">
  <% 
    String hrefNew = "javascript:asyncDialogEasy('system/serverprofile_dialog', '" + "id=new" + "')"; 
  %>
  <v:button caption="@Common.New" fa="plus" href="<%=hrefNew%>"/>
  <v:button caption="@Common.Delete" fa="trash" href="javascript:doDelSelectedServerProfiles()"/>
  <span class="divider"></span>
  <% String hRef="javascript:showHistoryLog(" + LkSNEntityType.ServerProfile.getCode() + ")";%>
  <v:button caption="@Common.History" fa="history" href="<%=hRef%>" enabled="<%=rights.History.getBoolean()%>"/> 
  <v:pagebox gridId="serverprofile-grid"/>
</div>

<div class="tab-content">
  <v:last-error/>
    
  <v:async-grid id="serverprofile-grid" jsp="system/serverprofile_grid.jsp" />
  
</div>


<script>

function doDelSelectedServerProfiles() {
  var ids = $("[name='ServerProfileId']").getCheckedValues();
  if (ids == "")
    showMessage(<v:itl key="@Common.NoElementWasSelected" encode="JS"/>);
  else {
    confirmDialog(null, function() {
      var reqDO = {
        Command: "DeleteServerProfiles",
        DeleteServerProfiles: {
          ServerProfileIDs: $("[name='ServerProfileId']").getCheckedValues()
        }
      };
      
      vgsService("ServerProfile", reqDO, false, function(ansDO) {
        triggerEntityChange(<%=LkSNEntityType.ServerProfile.getCode()%>);
      });
    }); 
  }
}
</script>