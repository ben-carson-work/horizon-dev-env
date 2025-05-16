<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageMaskSetup" scope="request"/>

<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>
  
<v:tab-group name="tab" main="true">
  <v:tab-item caption="@Common.Forms" icon="mask.png" tab="mask" jsp="mask_list_widget.jsp" default="true"/>
  <v:tab-item caption="@Common.Surveys" icon="survey.png" tab="survey" jsp="survey_list.jsp"/>
  <v:tab-item caption="@Common.Fields" icon="maskfield.png" tab="meta" jsp="metafield_list.jsp"/>
  <v:tab-item caption="@Common.FieldGroups" fa="layer-group" tab="group" jsp="metafieldgroup_list.jsp"/>
  <v:tab-item caption="@Common.Grids" fa="table" tab="grid" jsp="grid_list.jsp"/>
  <v:tab-item caption="@Common.FieldMasking" fa="asterisk" tab="maskerable" jsp="maskerable_field_list.jsp"/>
</v:tab-group>
 
<jsp:include page="/resources/common/footer.jsp"/>
