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
<jsp:useBean id="rcorule" class="com.vgs.snapp.dataobject.DORedemptionCommissionRule" scope="request"/>
<jsp:useBean id="product" class="com.vgs.snapp.dataobject.DOProduct" scope="request"/>


<div class="tab-content">
  <v:widget caption="@Common.Restrictions">
    <v:widget-block>
      <v:form-field caption="@Account.Location" hint="@RedemptionCommissionRule.RestrictionsLocationHint">
        <snp:dyncombo field="rcorule.LocationId" entityType="<%=LkSNEntityType.Location%>"/>
      </v:form-field>
      <v:form-field caption="@Account.OpArea" hint="@RedemptionCommissionRule.RestrictionsOperatingAreaHint">
        <snp:dyncombo field="rcorule.OpAreaId" entityType="<%=LkSNEntityType.OperatingArea%>" parentComboId="rcorule.LocationId"/>
      </v:form-field>
       <v:form-field caption="@AccessPoint.AccessPoint" hint="@RedemptionCommissionRule.RestrictionsAccessPointHint">
        <snp:dyncombo field="rcorule.AccessPointId" entityType="<%=LkSNEntityType.AccessPoint%>" parentComboId="rcorule.OpAreaId"/>
      </v:form-field>
      <v:form-field caption="@Event.Events" hint="@RedemptionCommissionRule.RestrictionsEventsHint">
        <% JvDataSet dsEvent = pageBase.getBL(BLBO_Event.class).getEventDS(); %>
        <v:multibox field="rcorule.EventIDs" lookupDataSet="<%=dsEvent%>" idFieldName="EventId" captionFieldName="EventName" allowNull="true" />
      </v:form-field>
    </v:widget-block>
    <v:widget-block>
      <v:form-field caption="@SaleChannel.SaleChannels" hint="@RedemptionCommissionRule.RestrictionsSaleChannelsHint">
        <% JvDataSet dsSaleChannels = pageBase.getBL(BLBO_SaleChannel.class).getSaleChannelLookupDS((LookupItem)null); %>
        <v:multibox field="rcorule.SaleChannelIDs" lookupDataSet="<%=dsSaleChannels%>" idFieldName="SaleChannelId" captionFieldName="SaleChannelName" allowNull="true" />
      </v:form-field>
      <v:form-field caption="@Product.ProductTypes" hint="@RedemptionCommissionRule.RestrictionsProductTypesHint">
        <% JvDataSet dsTag = pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.ProductType); %>
        <v:multibox field="rcorule.ProductTagIDs" lookupDataSet="<%=dsTag%>" idFieldName="TagId" captionFieldName="TagName" allowNull="true" />
      </v:form-field>
    </v:widget-block>
  </v:widget>
</div>

