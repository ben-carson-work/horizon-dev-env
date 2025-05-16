<%@page import="com.vgs.snapp.library.SnappUtils"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<!DOCTYPE html>
<html>


<head>
  <jsp:useBean id="pageBase" class="com.vgs.web.page.PagePOSEmail" scope="request"/>
  <jsp:useBean id="action" class="com.vgs.snapp.dataobject.DOAction" scope="request"/>
  <jsp:useBean id="email" class="com.vgs.snapp.dataobject.DODocTemplateEmail" scope="request"/>
  <% boolean readonly = !action.ActionStatus.isLookup(LkSNActionStatus.Draft) || pageBase.isParameter("ReadOnly", "true"); %>
  
  <title></title>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <link rel="shortcut icon" href="<v:config key="resources_url"/>/admin/images/favicon.ico">

  <link type="text/css" href="<v:config key="resources_url"/>/admin/css/smoothness/jquery-ui-1.8.20.custom.css" rel="stylesheet" />
  <script type="text/javascript" src="<v:config key="site_url"/>/libraries/jquery/jquery-3.6.0.min.js"></script>
  <script type="text/javascript" src="<v:config key="site_url"/>/libraries/jquery-ui-1.14.1/jquery-ui.min.js"></script>

  <link type="text/css" href="<%=pageBase.getContextURL()%>?page=admin-css<%=pageBase.isNewStyle()?"&newstyle=true":""%>" rel="stylesheet" media="all" />
  <script type="text/javascript" src="<%=pageBase.getContextURL()%>?page=admin-js"></script>
  <script type="text/javascript" src="<v:config key="site_url"/>/libraries/ckeditor/ckeditor.js"></script>
   
  <style>
  
    .successbox, .errorbox {
      margin: 12px;
    }
  
    .email-address-block {
      background-color: #f5f5f5;
      padding: 12px;
      <% if (readonly) { %>
        border-bottom: 1px #dddddd solid;
      <% } %>
    }
  
    <% if (readonly) { %>
    .email-body-block {
      background-color: white;
      padding: 12px;
    }
    <% } %>
  
  </style>
  
  <script>
    <%JvDateTime posTimestamp = JvDateTime.now();%>
    posTimestamp = <%=JvString.jsString(posTimestamp.getXMLDateTime())%>;
    vgsSessionToken = <%=JvString.jsString(SnappUtils.generatePosRequestToken(posTimestamp, pageBase.getSession().getLicenseId(), pageBase.getSession().getStationSerial()))%>;

    $(function() {
      javaApp.setActionStatus(<%=action.ActionStatus.getInt()%>);
    });
   
    function doSave() {
      sendPost("#email-form", "action.email-save");
    }
    
    function doSend() {
      var body = null;
      <% if (readonly) { %>
        body = $("#email-body-block").html();
      <% } else { %>
        body = CKEDITOR.instances.editor1.getData();
      <% } %>
      
      var reqDO = {
        ForceWorkstationId: <%=JvString.sqlStr(pageBase.getParameter("WorkstationId"))%>,
        Command: "SendEmailAction",
        SendEmailAction: {
          ActionId: <%=action.ActionId.getJsString()%>,
          AddressTo: $("#email\\.AddressTo").val(),
          AddressFrom: $("#email\\.AddressFrom").val(),
          AddressCC: $("#email\\.AddressCC").val(),
          Subject: $("#email\\.Subject").val(),
          Body: body
        }
      };

      vgsService("Action", reqDO, true, function(ans) {
        var errorMsg = getVgsServiceError(ans);
        $(function() {
          javaApp.sendCallBack(errorMsg);
        });
      });
    }
  </script>
</head>

<body>

<v:last-error/>
<v:page-form id="email-form">

<div class="email-address-block">
    <table class="form-table">
      <tr>
      <% if (action.CloseDateTime.isNull()) { %>
        <% action.CreateDateTime.setDisplayFormat(pageBase.getShortDateTimeFormat()); %>
        <th><label for="action.CreateDateTime"><v:itl key="@Common.DateTime"/></label></th>
        <td><v:input-text enabled="false" field="action.CreateDateTime"/></td>
      <% } else { %>
        <% action.CloseDateTime.setDisplayFormat(pageBase.getShortDateTimeFormat()); %>
        <th><label for="action.CloseDateTime"><v:itl key="@Common.DateTime"/></label></th>
        <td><v:input-text enabled="false" field="action.CloseDateTime"/></td>
      <% } %>
      </tr>
      <tr>
        <th><label for="email.AddressFrom"><v:itl key="@DocTemplate.Email_From"/></label></th>
        <td><v:input-text enabled="<%=!readonly%>" field="email.AddressFrom"/></td>
      </tr>
      <tr>
        <th><label for="email.AddressTo"><v:itl key="@DocTemplate.Email_To"/></label></th>
        <td><v:input-text enabled="<%=!readonly%>" field="email.AddressTo"/></td>
      </tr>
      <% if (!email.AddressCC.isNull()) { %>
        <tr>
          <th><label for="email.AddressCC"><v:itl key="@DocTemplate.Email_CC"/></label></th>
          <td><v:input-text enabled="<%=!readonly%>" field="email.AddressCC"/></td>
        </tr>
      <% } %>
      <tr>
        <th><label for="email.Subject"><v:itl key="@DocTemplate.Email_Subject"/></label></th>
        <td><v:input-text enabled="<%=!readonly%>" field="email.Subject"/></td>
      </tr>
    </table>
</div>

<div id="email-body-block" class="email-body-block">
  <% if (readonly) { %>
    <%=email.Body.getString()%>
  <% } else { %>
    <textarea id="editor1" name="email.Body"><%=email.Body.getString()%></textarea>
    <script type="text/javascript">CKEDITOR.replace("editor1", {toolbar:"Full"});</script>
  <% } %>
</div>

</v:page-form>

</body>


</html>

