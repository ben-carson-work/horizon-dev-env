<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommon_MessageUserList" scope="request"/>

<jsp:include page="../header.jsp"/>
<v:page-title-box/>
<v:last-error/>

<div id="main-container">
  <snp:list-tab caption="@Common.Search" fa="search"/>
  <div class="mainlist-container">
    <div class="form-toolbar">
      <v:button caption="@Common.Refresh" fa="sync-alt" href="javascript:changeGridPage('#message-user-grid', 1)"/>
      <v:pagebox gridId="message-user-grid"/>
    </div>
    
    <v:async-grid id="message-user-grid" jsp="../common/message/message_user_grid.jsp" />
  </div>
</div>
 
<jsp:include page="../footer.jsp"/>
