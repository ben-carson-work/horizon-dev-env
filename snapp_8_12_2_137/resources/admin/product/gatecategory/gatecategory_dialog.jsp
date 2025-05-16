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
String gateCategoryId = pageBase.getParameter("id");
BLBO_GateCategory bl = pageBase.getBL(BLBO_GateCategory.class);
DOGateCategory gateCategory = pageBase.isNewItem() ? bl.prepareNewGateCategory() : bl.loadGateCategory(gateCategoryId); 
request.setAttribute("gateCategory", gateCategory);

%>

<v:dialog id="gatecategory_dialog" title="@Product.GateCategory" tabsView="true" width="800" height="600">

<script>
  $(document).ready(function(){
    $("#gatecategory_dialog .tabs").tabs();
    var dlg = $("#gatecategory_dialog");
    dlg.on("snapp-dialog", function(event, params) {
      params.buttons = [
        {
          text: itl("@Common.Save"),
          click: doSave,
        }, 
        {
          text: itl("@Common.Cancel"),
          click: doCloseDialog
        }                     
      ];
    });
  });

  function doSave() {
    var reqDO = {
      Command: "SaveGateCategory",
      SaveGateCategory: {
        GateCategory: {
          GateCategoryId : <%=gateCategory.GateCategoryId.isNull() ? null : "\"" + gateCategory.GateCategoryId.getHtmlString() + "\""%>,
          GateCategoryCode : $("#gateCategory\\.GateCategoryCode").val(),
          GateCategoryName: $("#gateCategory\\.GateCategoryName").val()
        } 
      }
    };
    
    vgsService("GateCategory", reqDO, false, function(ansDO) {
      triggerEntityChange(<%=LkSNEntityType.GateCategory.getCode()%>);
      $("#gatecategory_dialog").dialog("close");
    });
   }
</script>

<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="gatecat-tab-profile" caption="@Common.Profile" icon="profile.png" default="true">
    <div class="tab-content">
      <v:widget caption="@Common.General">
        <v:widget-block>
          <v:form-field caption="@Common.Code" mandatory="true">
            <v:input-text field="gateCategory.GateCategoryCode" enabled="<%=rights.SystemSetupWorkstations.getOverallCRUD().canUpdate()%>"/>
          </v:form-field>
          <v:form-field caption="@Common.Name" mandatory="true">
            <v:input-text field="gateCategory.GateCategoryName" enabled="<%=rights.SystemSetupWorkstations.getOverallCRUD().canUpdate()%>"/>
          </v:form-field>
        </v:widget-block>
      </v:widget>
    </div>
  </v:tab-item-embedded>

  <% if(!pageBase.isNewItem()) { %>
    <v:tab-item-embedded tab="gatecat-tab-history" caption="@Common.History" fa="history">
      <jsp:include page="../../common/page_tab_historydetail.jsp"/>
    </v:tab-item-embedded>
  <% } %>
</v:tab-group>

</v:dialog>
