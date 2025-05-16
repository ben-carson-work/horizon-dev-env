<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<jsp:useBean id="pageBase" class="com.vgs.web.page.PageMobileAdmission" scope="request"/>

<style>

.attendance-item {
  background-color: white;
  border-bottom: 1px solid rgba(0,0,0,0.15);
  overflow: hidden;
  border-left: 2vw solid var(--base-gray-color);
}

.attendance-item.status-busy {
  border-left: 2vw solid var(--base-orange-color);
}

.attendance-item.status-open {
  border-left: 2vw solid var(--base-green-color);
}

.attendance-item-pic {
  float: left;
  width: 18vw;
  height: 18vw;
  background-size: cover;
  background-repeat: no-repeat;
}

.attendance-item-detail {
  margin-left: 18vw;
  padding-left: 2vw;
  padding-right: 2vw;
}

.attendance-item-line {
  overflow: hidden;
}

.attendance-item-time {
  float: left;
  width: 30vw;
  font-size: 1.5em;
}

.attendance-item-event {
  float: left;
  width: 50vw;
}

.attendance-item-quantity {
  margin-left: 30vw;
  font-size: 1.5em;
  text-align: right;
}

.attendance-item-pbout {
  height: 2vw;
  margin-top: 3vw;
  margin-left: 50vw;
  background-color: var(--pagetitle-bg-color);
}

.attendance-item-pbin {
  float: left;
  height: 2vw;
  background-color: var(--base-green-color);
}

</style>