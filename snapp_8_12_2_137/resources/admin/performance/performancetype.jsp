<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PagePerformanceType" scope="request"/>
<jsp:useBean id="perfType" class="com.vgs.snapp.dataobject.DOPerformanceType" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>

<v:tab-group name="tab" main="true">
  <v:tab-item-embedded caption="@Common.Profile" tab="main" default="true">
    <v:tab-toolbar>
      <v:button id="btn-perftype-save" caption="@Common.Save" fa="save"/>
      <v:button id="btn-perftype-export" caption="@Common.Export" fa="sign-out" include="<%=!pageBase.isNewItem()%>"/>
      <snp:notes-btn id="btn-perftype-notes" entityId="<%=pageBase.getId()%>" entityType="<%=LkSNEntityType.PerformanceType%>"/>
    </v:tab-toolbar>
  
    <v:tab-content id="perftype">
      <v:widget caption="@Common.General">
        <v:widget-block>
          <v:form-field caption="@Common.Code" mandatory="true">
            <v:input-text field="perfType.PerformanceTypeCode"/>
          </v:form-field>
          <v:form-field caption="@Common.Name" mandatory="true">
            <snp:itl-edit field="perfType.PerformanceTypeName" entityType="<%=LkSNEntityType.PerformanceType%>" entityId="<%=pageBase.getId()%>" langField="<%=LkSNHistoryField.PerformanceType_Name%>"/>
          </v:form-field>
          <v:form-field caption="@Common.Parent" mandatory="false">
            <snp:parent-pickup placeholder="@Common.NotAssigned" field="perfType.ParentEntityId" id="<%=pageBase.getId()%>" entityType="<%=LkSNEntityType.PerformanceType.getCode()%>" parentEntityType="<%=perfType.ParentEntityType.getInt()%>"/>
          </v:form-field>
          <v:form-field caption="@Common.Color">
            <v:color-picker field="perfType.PerformanceTypeColor"/>
          </v:form-field>
        </v:widget-block>
        <v:widget-block>
          <v:form-field caption="@Common.ValidFrom">
            <v:input-text type="datepicker" field="perfType.ValidFrom" placeholder="@Common.Unlimited"/>
          </v:form-field>
          <v:form-field caption="@Common.ValidTo">
            <v:input-text type="datepicker" field="perfType.ValidTo" placeholder="@Common.Unlimited"/>
          </v:form-field>
        </v:widget-block>
      </v:widget>
      
      <v:widget caption="@Product.PriceRule">
        <v:widget-block>
          <v:form-field caption="@Product.PriceFormulaTitle">
            <v:lk-radio 
                field="perfType.PriceActionType" 
                lookup="<%=LkSN.PriceActionType%>" 
                allowNull="false" 
                inline="true" 
                limitItems="<%=LookupManager.getArray(LkSNPriceActionType.NotSellable, LkSNPriceActionType.Add, LkSNPriceActionType.Subtract)%>"
                customLabels="<%=LookupCustomLabels.create().put(LkSNPriceActionType.NotSellable, \"@Common.None\")%>"/>
          </v:form-field>
        </v:widget-block>

        <v:widget-block id="PriceValueType-widget" clazz="hidden">
          <v:form-field caption="@Common.Type">
            <v:lk-radio field="perfType.PriceValueType" lookup="<%=LkSN.PriceValueType%>" allowNull="false" inline="true"/>
          </v:form-field>
          <v:form-field caption="@Product.PriceAmountTitle">
            <v:input-text field="perfType.PriceValue" placeholder="@Common.Value"/>
          </v:form-field>
        </v:widget-block>
      </v:widget>
    </v:tab-content>

  </v:tab-item-embedded>
  
  <v:tab-plus include="<%=!pageBase.isNewItem()%>">
    <v:popup-item id="menu-perftype-notes" caption="@Common.Notes" fa="comments"/>
    <v:popup-item id="menu-perftype-history" caption="@Common.History" fa="history" include="<%=rights.History.getBoolean()%>"/>
  </v:tab-plus>
</v:tab-group>

  
<script>
$(document).ready(function() {
  var performanceTypeId = <%=perfType.PerformanceTypeId.getJsString()%>;
  var entityType_PerformanceType = <%=LkSNEntityType.PerformanceType.getCode()%>;
  var priceActionType_NotSellable = <%=LkSNPriceActionType.NotSellable.getCode()%>;
  var $priceActionType = $("input[name='perfType\\.PriceActionType']");
  
  $("#btn-perftype-save").click(_save);
  $("#btn-perftype-export").click(_export);
  $("#menu-perftype-notes").click(_notes);
  $("#menu-perftype-history").click(_history);
  $priceActionType.change(_refreshVisibility);
   
  _refreshVisibility();
  
  function _refreshVisibility() {
    setVisible("#PriceValueType-widget", $priceActionType.filter(":checked").val() != priceActionType_NotSellable);
  }
  
  function _notes() {
    asyncDialogEasy("common/notes_dialog", "id=" + performanceTypeId + "&EntityType=" + entityType_PerformanceType);
  }
  
  function _export() {
    var urlo = BASE_URL + "/admin?page=export&EntityIDs=" + performanceTypeId + "&EntityType=" + entityType_PerformanceType + "&ts=" + (new Date()).getTime();
    window.open(urlo, "_black");
  }
  
  function _history() {
    asyncDialogEasy("common/history_detail_dialog", "id=" + performanceTypeId);
  }
  
  function _save() {
    checkRequired("#perftype", function() {
      snpAPI
        .cmd("Performance", "SavePerformanceType", {
          PerformanceType: {
            PerformanceTypeId: performanceTypeId,
            ParentEntityType: $("#perfType\\.ParentEntityType").val(),
            ParentEntityId: $("#perfType\\.ParentEntityId").val(),
            PerformanceTypeCode: $("#perfType\\.PerformanceTypeCode").val(),
            PerformanceTypeName: $("#perfType\\.PerformanceTypeName").val(),
            PerformanceTypeColor: $("[name='perfType\\.PerformanceTypeColor']").val(),
            ValidFrom: $("#perfType\\.ValidFrom-picker").getXMLDate(),
            ValidTo: $("#perfType\\.ValidTo-picker").getXMLDate(),
            PriceActionType: $("input[name='perfType\\.PriceActionType']:checked").val(),
            PriceValueType: $("input[name='perfType\\.PriceValueType']:checked").val(),
            PriceValue: convertPriceValue($("#perfType\\.PriceValue").val())
          }
        })
        .then(ansDO => entitySaveNotification(entityType_PerformanceType, ansDO.PerformanceTypeId));
    });
  }
});
</script>
 
<jsp:include page="/resources/common/footer.jsp"/>
