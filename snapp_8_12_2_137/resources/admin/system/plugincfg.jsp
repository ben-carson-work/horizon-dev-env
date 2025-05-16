<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:include page="/resources/common/header.jsp"/>
<v:page-title-box/>

<v:tab-group name="tab" main="true">
  <v:tab-item caption="@Plugin.Plugins" fa="plug" tab="plugin" jsp="/admin?page=webplugin_tab_widget" menuBind="plugin-config-plugin" default="true"/>
   <v:tab-item caption="@Common.Driver" fa="microchip" tab="driver" jsp="plugincfg_tab_driver.jsp" menuBind="plugin-config-driver"/>
  <v:tab-item caption="@Common.Fonts" fa="font" tab="font" jsp="software_tab_font.jsp" menuBind="plugin-config-font"/>
</v:tab-group>

<jsp:include page="/resources/common/footer.jsp"/>