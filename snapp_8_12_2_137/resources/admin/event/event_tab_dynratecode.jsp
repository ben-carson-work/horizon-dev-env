<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageEvent" scope="request"/>
<jsp:useBean id="event" class="com.vgs.snapp.dataobject.DOEvent" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% 
boolean canEdit = pageBase.getRightCRUD().canUpdate();
%>

<div class="tab-toolbar">
  <v:button id="btn-dynratecode-save" caption="@Common.Save" fa="save" enabled="<%=canEdit%>"/>
  <div class="btn-group">
    <v:button caption="@Common.Add" fa="plus" dropdown="true" enabled="<%=canEdit%>"/>
    <v:popup-menu bootstrap="true">
      <v:popup-item id="menu-add-default" caption="@Common.Default" fa="check"/>
      <v:popup-item id="menu-add-ptype" caption="@Performance.PerformanceType" fa="calendar"/>
    </v:popup-menu>
  </div>
</div>

<div id="dynratecode-tab-content" class="tab-content">

  <v:widget caption="@Common.General">
    <v:widget-block>
      <v:form-field caption="@Event.DynRateCodeType" hint="@Event.DynRateCodeTypeHint">
        <v:lk-radio field="event.DynRateCodeType" lookup="<%=LkSN.DynRateCodeType%>" inline="true" allowNull="false" enabled="<%=canEdit%>"/>
      </v:form-field>
      <v:form-field caption="@Event.DynRateCodeValueType" hint="@Event.DynRateCodeValueTypeHint">
        <v:lk-radio field="event.DynRateCodeValueType" lookup="<%=LkSN.PriceValueType%>" inline="true" allowNull="false" enabled="<%=canEdit%>"/>
      </v:form-field>
    </v:widget-block>

    <v:widget-block>
      <v:form-field caption="@SaleChannel.SaleChannels" hint="@Event.DynSaleChannelsHint">
        <v:multibox field="event.DynSaleChannelIDs" idFieldName="SaleChannelId" captionFieldName="SaleChannelName" linkEntityType="<%=LkSNEntityType.SaleChannel%>" filtersJSON="{\"SaleChannel\":{\"IncludeDefault\":true}}" enabled="<%=canEdit%>"/>
      </v:form-field>
    </v:widget-block>
  </v:widget>

</div>

<div id="dynratecode-templates" class="hidden">

  <v:widget clazz="dynratecode-perftype" caption="@Common.Default" removeHRef="#remove">
    <v:widget-block>
      <v:grid>
        <thead>
          <tr>
            <td><v:grid-checkbox header="true"></v:grid-checkbox></td>
            <td width="34%">Threshold</td>
            <td width="33%"><v:itl key="@Seat.Category"/></td>
            <td width="33%"><v:itl key="@Common.RateCode"/></td>
          </tr>
        </thead>
        <tbody>
          
        </tbody>
      </v:grid>
    </v:widget-block>
    
    <% if (canEdit) { %>
      <v:widget-block>
        <v:button caption="@Common.Add" fa="plus" clazz="btn-add-slot"/>
        <v:button caption="@Common.Remove" fa="minus" clazz="btn-remove-slot"/>
      </v:widget-block>
    <% } %>
  </v:widget>

  <v:grid>
    <tr class="dynratecode-slotrow">
      <td><v:grid-checkbox header="false"></v:grid-checkbox></td>
      <td><v:input-text field="Threashold"/></td>
      <td>
          <v:combobox 
              name="SeatCategoryId"
              lookupDataSet="<%=pageBase.getBL(BLBO_Seat.class).getSeatCategoryDS()%>" 
              idFieldName="AttributeItemId" 
              captionFieldName="AttributeItemName" 
              groupFieldName="AttributeId" 
              groupLabelFieldName="AttributeName"
              allowNull="true"
              enabled="<%=canEdit%>"/>
      </td>
      <td><snp:dyncombo entityType="<%=LkSNEntityType.RateCode%>" name="RateCodeId"/></td>
    </tr>
  </v:grid>

</div>

<jsp:include page="event_tab_dynratecode_js.jsp"/>
