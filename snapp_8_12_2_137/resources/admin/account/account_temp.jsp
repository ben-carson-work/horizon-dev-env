<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<jsp:useBean id="pageBase" scope="request" class="com.vgs.web.page.PageAccountTemp"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<!DOCTYPE html>
<html>
<jsp:include page="../../common/header-head.jsp"/>

<style>
  :root {
    --content-bg-color: rgba(255, 255, 255, 0.85);
    --logo-size: 200px;
    --margin: 20px;
    --side-margin: 150px;
  }
  html, body {font-size: 16px;}
  body {padding: var(--margin) var(--side-margin) var(--margin) var(--side-margin); <%=pageBase.formatBackgroundCSS(rights.LoginBkgColor.getString(), rights.LoginBkgRepositoryId.getString(), rights.LoginBkgStyle.getLkValue())%>}
  #logo-container {margin:auto; margin-bottom:var(--margin); border-radius:10px; width:var(--logo-size); height:var(--logo-size); background-image: url(<%=pageBase.getBL(BLBO_Account.class).getLicenseeLogoURL()%>); background-size: cover;}
</style>

<script>
$(document).ready(function() {
  const workstationId = <%=JvString.jsString(pageBase.getParameter("WorkstationId"))%>;
  
  $("#btn-clear").click(function() {
    confirmDialog(null, _reloadPage);
  });
  
  $("#btn-save").click(function() {
    var url = BASE_URL + "/admin?page=account-temp&id=" + workstationId + "&action=save&ts=" + (new Date()).getTime();
    var req = {"MetaDataList": prepareMetaDataArray("#maskedit-container")};

    showWaitGlass();
    $.ajax({
      url: BASE_URL + "/admin?page=account-temp&id=" + workstationId + "&action=save&ts=" + (new Date()).getTime(),
      type: "POST",
      data: JSON.stringify(req),
      dataType: "json",
      contentType: "application/json; charset=UTF-8"
    }).always(function(ans) {
      hideWaitGlass();
      if (ans.ErrorCode)
        showIconMessage("warning", ans.Message);
      else 
        showMessage("Account created! Reference number: " + ans.AccountTempCode, _reloadPage);
    });
  });
  
  function _reloadPage() {
    window.location.reload();
  }
});
</script>

<body>
  <div id="logo-container"></div>
  <%-- 
  <input type="file" accept="image/*" capture="user">
  --%>

  <div id="maskedit-container">
    <jsp:include page="/resources/admin/metadata/maskedit_widget.jsp"></jsp:include>
  </div>
  
  <v:widget>
    <v:widget-block>
      <v:button id="btn-save" fa="save" caption="@Common.Save"/>
      <v:button id="btn-clear" fa="times" caption="@Common.Clear"/>
    </v:widget-block>
  </v:widget>

</body>

</html>
