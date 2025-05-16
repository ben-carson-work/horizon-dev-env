<%@page import="com.vgs.snapp.dataobject.DOExtMediaGroup"%>
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
String extMediaGroupId = pageBase.getParameter("id");
BLBO_ExtMediaGroup bl = pageBase.getBL(BLBO_ExtMediaGroup.class);
DOExtMediaGroup extMediaGroup = pageBase.isNewItem() ? new DOExtMediaGroup() : bl.loadExtMediaGroup(extMediaGroupId); 
request.setAttribute("extMediaGroup", extMediaGroup);
%>

<v:dialog id="extmediagroup_dialog" title="@Product.ExtMediaGroups" tabsView="true" width="800" height="600">

<script>
  $(document).ready(function(){
    $("#extmediagroup_dialog .tabs").tabs();
    var dlg = $("#extmediagroup_dialog");
    dlg.on("snapp-dialog", function(event, params) {
      params.buttons = [
        {
          text: <v:itl key="@Common.Save" encode="JS"/>,
          click: doSave,
        }, 
        {
          text: <v:itl key="@Common.Cancel" encode="JS"/>,
          click: doCloseDialog
        }                     
      ];
    });
  });

  function doSave() {
    var reqDO = {
      Command: "SaveExtMediaGroup",
      SaveExtMediaGroup: {
        ExtMediaGroup: {
          ExtMediaGroupId : <%=extMediaGroup.ExtMediaGroupId.isNull() ? null : "\"" + extMediaGroup.ExtMediaGroupId.getHtmlString() + "\""%>,
          ExtMediaGroupCode : $("#extMediaGroup\\.ExtMediaGroupCode").val(),
          ExtMediaGroupName: $("#extMediaGroup\\.ExtMediaGroupName").val(),
          NotifyQuantityLow: $("#extMediaGroup\\.NotifyQuantityLow").val(),
          NotifyQuantityCritical: $("#extMediaGroup\\.NotifyQuantityCritical").val(),
          NotifyExpirationDays: $("#extMediaGroup\\.NotifyExpirationDays").val()
        }
      }
    };
   console.log(reqDO);
    vgsService("ExternalMedia", reqDO, false, function(ansDO) {
      triggerEntityChange(<%=LkSNEntityType.ExtMediaGroup.getCode()%>);
      $("#extmediagroup_dialog").dialog("close");
    });
   }
</script>

<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="extmediagroup-tab-profile" caption="@Common.Profile" icon="profile.png" default="true">
    <div class="tab-content">
      <v:widget caption="@Common.General">
        <v:widget-block>
          <v:form-field caption="@Common.Code" mandatory="true">
            <v:input-text field="extMediaGroup.ExtMediaGroupCode" />
          </v:form-field>
          <v:form-field caption="@Common.Name" mandatory="true">
            <v:input-text field="extMediaGroup.ExtMediaGroupName" />
          </v:form-field>
          </v:widget-block>
      </v:widget>
      <v:widget caption="@Common.Notifications">
        <v:widget-block>
          <v:form-field caption="@Common.NotifyQuantityLow" hint="@Common.NotifyQuantityLowHint">
            <v:input-text type="number" field="extMediaGroup.NotifyQuantityLow"/>
          </v:form-field>
          <v:form-field caption="@Common.NotifyQuantityCritical"  hint="@Common.NotifyQuantityCriticalHint">
            <v:input-text type="number" field="extMediaGroup.NotifyQuantityCritical"/>
          </v:form-field>
          <v:form-field caption="@Common.NotifyExpirationDays"  hint="@Common.NotifyExpirationDaysHint">
            <v:input-text type="number" field="extMediaGroup.NotifyExpirationDays"/>
          </v:form-field>
          </v:widget-block>
      </v:widget>
    </div>
  </v:tab-item-embedded>

  <% if(!pageBase.isNewItem()) { %>
    <v:tab-item-embedded tab="extmediagroup-tab-history" caption="@Common.History" fa="history">
      <jsp:include page="../common/page_tab_historydetail.jsp"/>
    </v:tab-item-embedded>
  <% } %>
</v:tab-group>

</v:dialog>
