<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>
<jsp:useBean id="pageBase" class="com.vgs.web.page.PageLockWidget" scope="request"/>
<jsp:useBean id="lockInfo" class="com.vgs.snapp.dataobject.DOLockInfo" scope="request" />

<% 
  boolean canUnlockSale = pageBase.getRights().ManualUnlock.getBoolean();
%>

<div id="lock-inside">
  <v:widget-block>
    <div><v:itl key="@Common.Workstation"/> <span class="recap-value"><a href="<v:config key="site_url"/>/admin?page=workstation&id=<%=lockInfo.WorkstationId.getEmptyString()%>"><%=lockInfo.WorkstationName.getHtmlString()%></a></span></div>
    <div><v:itl key="@Common.User"/> <span class="recap-value"><a href="<v:config key="site_url"/>/admin?page=account&id=<%=lockInfo.UserAccountId.getEmptyString()%>"><%=lockInfo.UserAccountName.getHtmlString()%></a></span></div>
    <div><v:itl key="@Common.DateTime"/> <snp:datetime timezone="local" timestamp="<%=lockInfo.LockDateTime%>" format="shortdatetime" clazz="recap-value"/></div>
  </v:widget-block>
  <% if (canUnlockSale) { %>
    <v:widget-block>
      <v:button caption="Unlock" fa="unlock" href="javascript:showReleaseConfirmDialog()" />
    </v:widget-block>
  <% } %>
  
  <script>
    $(document).ready(initJQueryButtons); 
    
    function showReleaseConfirmDialog() {
      confirmDialog(null, function() {
        var reqDO = {
          Command: "ReleaseLock",
          ReleaseLock: {
            EntityType: <%=lockInfo.EntityType.getInt()%>,
            EntityId: "<%=lockInfo.EntityId.getEmptyString()%>",
            ManualRelease: true
          }
        };
        
        vgsService("Lock", reqDO, false, function() {
          window.location.reload();
        });
      });
    }
  </script>
</div>
