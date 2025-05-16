<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<jsp:include page="/resources/common/header.jsp"/>
<v:page-title-box/>

<v:tab-group name="tab" main="true">
    <v:tab-item caption="@Plugin.ExtensionPackages" icon="plugin.png" tab="extpackage" jsp="extpackage_tab_extpackage.jsp" default="true"/>
  	<v:tab-item caption="@Common.Fonts" icon="<%=LkSNEntityType.Font.getIconName()%>" tab="font" jsp="extpackage_tab_font.jsp"/>
    <v:tab-item caption="@Plugin.Plugins" icon="driver.png" tab="plugin" jsp="/admin?page=webplugin_tab_widget"/>
</v:tab-group>

<jsp:include page="/resources/common/footer.jsp"/>
