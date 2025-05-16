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
<jsp:useBean id="ppurule" class="com.vgs.snapp.dataobject.DOPPURule" scope="request"/>

<div class="tab-content">
  <v:widget caption="@Common.Restrictions">
    <v:widget-block>
      <v:form-field caption="@Account.Location" hint="@RewardPointRestriction.LocationHint">
        <snp:dyncombo field="ppurule.LocationId" entityType="<%=LkSNEntityType.Location%>"/>
      </v:form-field>
      <v:form-field caption="@Account.OpArea" hint="@RewardPointRestriction.OperatingAreaHint">
        <snp:dyncombo field="ppurule.OpAreaId" entityType="<%=LkSNEntityType.OperatingArea%>" parentComboId="ppurule.LocationId"/>
      </v:form-field>
      <v:form-field caption="@AccessPoint.AccessPoint" hint="@RewardPointRestriction.AccessPointHint">
        <snp:dyncombo field="ppurule.AccessPointId" entityType="<%=LkSNEntityType.AccessPoint%>" parentComboId="ppurule.OpAreaId"/>
      </v:form-field>
      <v:form-field caption="@Event.Events" hint="@RewardPointRestriction.EventsHint">
        <% JvDataSet dsEvent = pageBase.getBL(BLBO_Event.class).getEventDS(); %>
        <v:multibox field="ppurule.EventIDs" lookupDataSet="<%=dsEvent%>" idFieldName="EventId" captionFieldName="EventName" allowNull="true" />
      </v:form-field>
    </v:widget-block>
    <v:widget-block>
      <v:form-field caption="@Product.ProductTypes" hint="@RewardPointRestriction.ProductTypesHint">
        <% JvDataSet dsTag = pageBase.getBL(BLBO_Tag.class).getTagDS(LkSNEntityType.ProductType); %>
        <v:multibox field="ppurule.ProductTagIDs" lookupDataSet="<%=dsTag%>" idFieldName="TagId" captionFieldName="TagName" allowNull="true" />
      </v:form-field>
    </v:widget-block>
  </v:widget>
</div>

