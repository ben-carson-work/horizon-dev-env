<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageRewardPointList" scope="request"/>

<jsp:include page="/resources/common/header.jsp"/>

<v:page-title-box/>
<v:last-error/>

<v:tab-group name="tab" main="true">
  <v:tab-item tab="search" caption="@Product.MembershipPoints" icon="membershippoint.png" jsp="rewardpoint_list_tab_search.jsp" default="true"/>
  <v:tab-item tab="ppurule" caption="@Product.PPURules" icon="wallet.png" jsp="rewardpoint_list_tab_ppurule.jsp"/>
</v:tab-group>

 
<jsp:include page="/resources/common/footer.jsp"/>
