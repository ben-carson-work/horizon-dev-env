<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageAccount" scope="request"/>
<jsp:useBean id="account" scope="request" class="com.vgs.snapp.dataobject.DOAccount"/>

<div class="tab-content">
  <v:tab-group name="tab_extmedia">
  
   <% if (account.ExtMediaCount.getInt() > 0){%>
      <!-- media groups -->
      <v:tab-item caption="@Common.Dashboard" icon="chart.png" tab="mediaGroups" jsp="account_tab_extmedia_dashboard.jsp" default="true"/>
    <%} %>
   <% if (account.ExtMediaCount.getInt() > 0){%>
      <!-- media codes -->
      <v:tab-item caption="@Media.ExtMediaCodeTab" icon="media.png" tab="medias" jsp="account_tab_extmedia_media.jsp" default="false"/>
    <%} %>
    <%if (account.ExtMediaBatchCount.getInt() > 0){ %>
      <!-- media batches -->
      <v:tab-item caption="@Media.ExtMediaBatches" icon="media.png" tab="mediaBatch" jsp="account_tab_extmedia_batch.jsp" default="<%=(account.ExtMediaCount.getInt() <= 0) %>" />
    <%} %>
   <% if (account.ExtProductTypeCount.getInt() > 0){%>
      <!-- media groups -->
      <v:tab-item caption="@Media.ExtProductTypes" icon="<%=LkSNEntityType.ProductType.getIconName()%>" tab="extProductType" jsp="account_tab_ext_product_type.jsp" default="false"/>
    <%} %>
  </v:tab-group>
</div>
