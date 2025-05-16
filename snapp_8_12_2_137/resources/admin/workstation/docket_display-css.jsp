<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="java.net.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageDocketDisplay" scope="request"/>
<% BOSessionBean boSession = (pageBase == null) ? null : (BOSessionBean)pageBase.getSession(); %>

<style>

body {
  background-color: var(--pagetitle-bg-color);
  font-size: 16px;
}

.docket-container {
  padding: 10px;
  float: left;
  width: 25%;
  line-height: normal;
}

.docket {
  background-color: white;
  border-radius: 4px;
}

.docket-header {
  border-bottom: 1px solid rgba(0,0,0,0.1);
  padding: 10px;
}

.docket-header {
  border-top: 1px solid rgba(0,0,0,0.1);
  padding: 10px;
}

.docket-container[data-status='<%=LkSNDocketStatus.InPreparation.getCode()%>'] .docket-title {
  color: var(--base-orange-color);
}

.docket-container[data-status='<%=LkSNDocketStatus.Ready.getCode()%>'] .docket-title {
  color: var(--base-green-color);
}

.docket-container[data-status='<%=LkSNDocketStatus.Delivered.getCode()%>'] .docket-title {
  color: var(--base-blue-color);
}

.docket-title,
.docket-serial {
  font-size: 1.3em;
  font-weight: bold;  
}

.docket-serial {
  text-align: right;
}

.docket-waiter,
.docket-order-time,
.docket-elapsed-time {
  font-size: 0.85em;
  font-weight: bold;  
}

.docket-elapsed-time {
  text-align: right;
}

.docket-body {
  padding: 10px;
}

.docket-item-bom {
  padding-left: 20px;
  font-size: 0.85em;
  font-weight: bold;
  color: var(--base-orange-color);  
}

.docket-footer {
  border-top: 1px solid rgba(0,0,0,0.1);
  padding: 10px;
  text-align: center;
}

</style>
