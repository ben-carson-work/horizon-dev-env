<%@page import="com.vgs.cl.document.FtTimestamp"%>
<%@page import="com.vgs.cl.JvString"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageAction" scope="request"/>
<jsp:useBean id="action" class="com.vgs.snapp.dataobject.DOAction" scope="request"/>
<jsp:useBean id="phoneAction" class="com.vgs.snapp.dataobject.DODocTemplatePhoneDelivery" scope="request"/>

<script type="text/javascript" src="<v:config key="site_url"/>/libraries/ckeditor/ckeditor.js"></script>
<style>

#email-header {
}

#email-header .form-field {
  min-height: 24px;
  line-height: inherit;
}

#email-header .form-field-value {
  font-weight: bold;
}

#email-content .readonly {
  padding: 40px;
}

</style>

<% 
  boolean isDraft = action.ActionStatus.isLookup(LkSNActionStatus.Draft);
  boolean readonly = !isDraft;
%>

<v:page-form id="phone-form">

<div class="tab-toolbar">
  <v:button id="sendBtn" caption="@Action.Send" fa="upload" onclick="send()" clazz="v-hidden"/>
  <v:button id="resendBtn" caption="@Action.ReSend" fa="upload" onclick="send(true)" clazz="v-hidden"/>
</div>
 
<div class="tab-content">
  <div class="profile-pic-div">
    <jsp:include page="action_link_widget.jsp"></jsp:include>
  </div>
  
  <div class="profile-cont-div">
    <v:widget>
      <v:widget-block id="email-header">
        <v:form-field caption="@Common.DateTime">
          <% FtTimestamp field = action.CloseDateTime.isNull() ? action.CreateDateTime : action.CloseDateTime; %>
          <snp:datetime timezone="local" timestamp="<%=field%>" format="longdatetime"/>
        </v:form-field>
        <v:form-field caption="@DocTemplate.Email_To">
          <v:input-text field="phoneAction.PhoneNumberTo" enabled="<%=!readonly%>"/>
        </v:form-field>
      </v:widget-block>
      
      <v:widget-block id="email-content">
				<div class="readonly">
				  <%=JvString.replace(phoneAction.Body.getString(), '\n', "</br>")%>
				</div>
      </v:widget-block>
    </v:widget>
  </div>
</div>

</v:page-form>

<script>

$(document).ready(function() {
  $("#sendBtn").setClass("v-hidden", <%=!isDraft%>);
  $("#resendBtn").setClass("v-hidden", <%=isDraft%>);
});

function send(resend) {
  if (resend) {
		inputDialog(itl("@Action.ReSend"), null, null, <%=phoneAction.PhoneNumberTo.getJsString()%>, false, function(addressTo) {
      var reqDO = {
          Command: "PhoneDeliveryAction",
          PhoneDeliveryAction: {
            ActionId: <%=JvString.jsString(pageBase.getId())%>,
            PhoneNumberTo: addressTo
          }
       };
       
        vgsService("Action", reqDO, false, function(ansDO) {
         triggerEntityChange(<%=LkSNEntityType.PhoneDelivery.getCode()%>);
         window.location.reload(true);
       });
   });
 }
 else {
	var reqDO = {
	    Command: "PhoneDeliveryAction",
	    PhoneDeliveryAction: {
	      ActionId: <%=JvString.jsString(pageBase.getId())%>,
	      PhoneNumberTo: $("#phoneAction\\.PhoneNumberTo").val()
	    }
	 };
	  
	  vgsService("Action", reqDO, false, function(ansDO) {
	    triggerEntityChange(<%=LkSNEntityType.PhoneDelivery.getCode()%>);
	    window.location.reload(true);
	  });
 }
}
</script>