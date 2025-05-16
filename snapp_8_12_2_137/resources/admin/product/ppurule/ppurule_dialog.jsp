<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<%
BLBO_PPURule bl = pageBase.getBL(BLBO_PPURule.class);
DOPPURule ppurule = pageBase.isNewItem() ? bl.prepareNewPPURule() : bl.ocPPURule(pageBase.getId());
request.setAttribute("ppurule", ppurule);
%>

<v:dialog id="ppurule_dialog" icon="<%=ppurule.IconName.getString()%>" title="@Product.PPURule" tabsView="true" width="800" height="600">

<v:tab-group name="tab" main="true">

  <%-- PROFILE --%>
  <v:tab-item-embedded tab="tabs-profile" caption="@Common.Profile" fa="info-circle" default="true">
    <jsp:include page="ppurule_dialog_tab_profile.jsp"/>
  </v:tab-item-embedded>

  <%-- RESTRICTIONS --%>
  <v:tab-item-embedded tab="tabs-restriction" caption="@Common.Restrictions" fa="filter">
    <jsp:include page="ppurule_dialog_tab_restriction.jsp"/>
  </v:tab-item-embedded>

  <%-- HISTORY --%>
  <% if (!pageBase.isNewItem() && rights.History.getBoolean()) { %>
    <v:tab-item-embedded tab="tabs-history" caption="@Common.History" fa="history">
      <jsp:include page="../../common/page_tab_historydetail.jsp"/>
    </v:tab-item-embedded>
  <% } %>
</v:tab-group>

<script>
$(document).ready(function() {
  var $dlg = $("#ppurule_dialog");
  $dlg.on("snapp-dialog", function(event, params) {
    params.buttons = [
      {
        text: itl("@Common.Save"),
        click: doSavePPURule
      },
      {
        text: itl("@Common.Cancel"),
        click: doCloseDialog
      }
    ];
  });

  function doSavePPURule() {
    var reqDO = {
      Command: "SavePPURule",
      SavePPURule: {
        PPURule: {
          PPURuleId: <%=pageBase.isNewItem() ? null : ppurule.PPURuleId.getJsString()%>,
          Active: $dlg.find("#ppurule\\.Active").isChecked(),
          StopRule: $dlg.find("#ppurule\\.StopRule").isChecked(),
          PriorityOrder: $dlg.find("#ppurule\\.PriorityOrder").val(),
          MembershipPointId: $dlg.find("#ppurule\\.MembershipPointId").val(),
          MembershipPointValue: $dlg.find("#ppurule\\.MembershipPointValue").val(),
          CalendarId: $dlg.find("#ppurule\\.CalendarId").val(),
          ValidDateFrom: $dlg.find("#ppurule\\.ValidDateFrom-picker").getXMLDate(),
          ValidDateTo: $dlg.find("#ppurule\\.ValidDateTo-picker").getXMLDate(),
          ValidTimeFrom: $("#ppurule\\.ValidTimeFrom").getXMLTime(),
          ValidTimeTo: $("#ppurule\\.ValidTimeTo").getXMLTime(),
          LocationId: $dlg.find("#ppurule\\.LocationId").val(),
          OpAreaId: $dlg.find("#ppurule\\.OpAreaId").val(),
          AccessPointId: $dlg.find("#ppurule\\.AccessPointId").val(),
          EventIDs: $dlg.find("#ppurule\\.EventIDs").val(),
          ProductTagIDs: $dlg.find("#ppurule\\.ProductTagIDs").val()
        }
      }
    };
    
    if (reqDO.SavePPURule.PPURule.ValidTimeFrom)
      reqDO.SavePPURule.PPURule.ValidTimeFrom = "1970-01-01T" + reqDO.SavePPURule.PPURule.ValidTimeFrom;
    if (reqDO.SavePPURule.PPURule.ValidTimeTo)
      reqDO.SavePPURule.PPURule.ValidTimeTo = "1970-01-01T" + reqDO.SavePPURule.PPURule.ValidTimeTo;
    
    showWaitGlass();
    vgsService("Product", reqDO, false, function(ansDO) {
      hideWaitGlass();
      triggerEntityChange(<%=LkSNEntityType.RewardPointRule.getCode()%>);
      $dlg.dialog("close");
    });
  }
});

</script>

</v:dialog>