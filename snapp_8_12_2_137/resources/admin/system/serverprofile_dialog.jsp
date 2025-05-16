<%@page import="com.vgs.snapp.dataobject.DOServerProfile"%>
<%@page import="com.vgs.snapp.dataobject.DOGateCategory"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% 
String serverProfileId = pageBase.getParameter("id");
BLBO_ServerProfile bl = pageBase.getBL(BLBO_ServerProfile.class);
DOServerProfile serverProfile = pageBase.isNewItem() ? bl.prepareNewServerProfile() : bl.loadServerProfile(serverProfileId); 
request.setAttribute("serverProfile", serverProfile);
%>

<v:dialog id="serverprofile_dialog" title="@ServerProfile.ServerProfile" tabsView="true" width="800" height="600">

<script>
  $(document).ready(function(){
    $("#serverprofile_dialog .tabs").tabs();
    var dlg = $("#serverprofile_dialog");
    dlg.on("snapp-dialog", function(event, params) {
      params.buttons = [
        {
          text: <v:itl key="@Common.Settings" encode="JS"/>,
          click: function() {
            asyncDialogEasy("right/rights_dialog", "Filter=server&EntityType=<%=LkSNEntityType.ServerProfile.getCode()%>&EntityId=<%=serverProfileId%>");
          },
          disabled: <%=serverProfileId.equals("new")%> ? true : false
        },
        {
          text: <v:itl key="@Common.Save" encode="JS"/>,
          click: doSave
        },
        {
          text: <v:itl key="@Common.Cancel" encode="JS"/>,
          click: doCloseDialog
        }
      ] 
    });
  });

  function searchKeyPress() {
    if (event.keyCode == KEY_ENTER) {
      doSave();
      event.preventDefault(); 
    }
  }
  
  function doSave() {
    var reqDO = {
      Command: "SaveServerProfile",
      SaveServerProfile: {
        ServerProfile: {
          ServerProfileId : <%=serverProfile.ServerProfileId.isNull() ? null : "\"" + serverProfile.ServerProfileId.getHtmlString() + "\""%>,
          ServerProfileCode : $("#serverProfile\\.ServerProfileCode").val(),
          ServerProfileName: $("#serverProfile\\.ServerProfileName").val()
        } 
      }
    };
    
    vgsService("ServerProfile", reqDO, false, function(ansDO) {
      triggerEntityChange(<%=LkSNEntityType.ServerProfile.getCode()%>);
      $("#serverprofile_dialog").dialog("close");
    });
   }
</script>

<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="serverprofile-tab-profile" caption="@Common.Profile" icon="profile.png" default="true">
    <div class="tab-content">
      <v:widget caption="@Common.General">
        <v:widget-block>
          <v:form-field caption="@Common.Code" mandatory="true">
            <v:input-text field="serverProfile.ServerProfileCode"/>
          </v:form-field>
          <v:form-field caption="@Common.Name" mandatory="true">
            <v:input-text field="serverProfile.ServerProfileName"/>
          </v:form-field>
        </v:widget-block>
      </v:widget>
    </div>
  </v:tab-item-embedded>

  <% if(!pageBase.isNewItem()) { %>
    <v:tab-item-embedded tab="gatecat-tab-history" caption="@Common.History" fa="history">
      <jsp:include page="../common/page_tab_historydetail.jsp"/>
    </v:tab-item-embedded>
  <% } %>
</v:tab-group>

</v:dialog>
