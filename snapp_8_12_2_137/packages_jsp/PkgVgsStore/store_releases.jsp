<%@page import="com.vgs.snapp.lookup.LkSNModuleType"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>
<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>

<v:tab-group name="tab" main="true">
  <v:tab-item caption="Packages" icon="plugin.png" tab="packages" jsp="store_package_list.jsp" default="true"/>
  <v:tab-item caption="Vgs Boards" icon="station.png" tab="vgsboards" jsp="store_vgsboard_list.jsp" default="false"/>
</v:tab-group> 

<jsp:include page="/resources/common/footer.jsp"/>