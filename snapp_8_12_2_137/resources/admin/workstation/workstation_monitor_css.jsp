<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="java.sql.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageWorkstationMonitor" scope="request"/>

<style>

#wks-monitor-tab {
  overflow: hidden;
}

#wks-monitor-tab[data-Status='online'] .offline-box {
  display: none;
}

.apt-container {
  display: inline-block;
  float: left;
  margin: 10px;
  border-radius: 5px;
  width: 200px;
  height: 245px;
  background-color: var(--base-orange-color);
  overflow: hidden;
  cursor: pointer;
  position: relative;
  border: 6px solid rgba(0,0,0,0);
}

.apt-container .apt-checkbox {
  position: absolute;
  left: 0;
  top: 0;
  width: 35px;
  height: 35px;
  background-color: rgba(0,0,0,0.5);
  background-image: url(<v:image-link name="bkoact-check.png|TransformNegative" size="24"/>);
  background-position: 3px 3px;
  background-repeat: no-repeat;
  border-bottom-right-radius: 8px;
  visibility: hidden;
}

.apt-container .apt-body {
  position: absolute;
  top: 40px;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(255,255,255,0.85);
  border-radius: 3px;
  overflow: hidden;
  display: none;
  font-size: 12px;
}

.apt-container.selected {
  border: 6px solid rgba(0,0,0,0.5);
  border-radius: 8px;
}

.apt-container.selected .apt-checkbox {
  visibility: visible;
}

.apt-container .apt-name {
  padding: 10px;
  padding-bottom: 5px;
  text-align: center;
  font-weight: bold;
  color: white;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.apt-container .apt-op-message {
  border: 1px solid rgba(0,0,0,0.15);
  border-left: none;
  border-right: none;
  margin: 5px;
  padding: 5px;
  margin-top: 0;
  text-align: center;
  height: 50px;
  overflow: hidden;
}

.apt-container .apt-properties {
  padding-left: 10px;
  padding-right: 10px;
}

.apt-container .apt-passage-status {
  padding: 5px;
  text-align: center;
}

.apt-container .apt-icon {
  width: 32px;
  height: 32px;
  opacity: 0.2;
}

.apt-container .apt-icon.active {
  opacity: 1;
}

.apt-container .apt-light-status {
  padding: 5px;
  text-align: center;
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
}

.apt-container .apt-value {
  font-weight: bold;
  float: right;
}

.apt-container[data-status=''] .apt-body-unknown {
  display: block;
  padding: 10px;
  text-align: center;
}

.apt-container .spinner-icon {
  position: absolute;
  top: 40%;
  left: 0;
  right: 0;
  text-align: center;
  font-size: 36px;
  opacity: 0.5;
}

.apt-container[data-status='<%=LkSNAccessPointStatus.Active.getCode()%>'] .apt-body-normal,
.apt-container[data-status='<%=LkSNAccessPointStatus.Warning.getCode()%>'] .apt-body-normal {
  display: block;
}

.apt-container[data-status='<%=LkSNAccessPointStatus.Error.getCode()%>'] {
  background: var(--base-red-color);
}

.apt-container[data-status='<%=LkSNAccessPointStatus.Error.getCode()%>'] .apt-body-error {
  display: block;
}
.apt-container[data-status='<%=LkSNAccessPointStatus.Error.getCode()%>'] .apt-name {
}

.apt-container[data-status='<%=LkSNAccessPointStatus.Active.getCode()%>'] {
  background-color: var(--base-blue-color);
}

.apt-rot-line {
  box-sizing: border-box;
}

.apt-rotin {
  float:left;
}

.apt-rotout {
  float:left;
}
</style>
