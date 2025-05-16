<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageProduct" scope="request"/>
<jsp:useBean id="product" class="com.vgs.snapp.dataobject.DOProduct" scope="request"/>

<style>

#bom-grid-body [name='quantity'] {
  text-align: right;
}

.bom-placeholder td {
  padding: 2px;
}

.bom-placeholder-item {
  background-color: var(--base-gray-color);
  border: 2px dashed rgba(0,0,0,0.25);
  line-height: 30px;
  text-align: center;
}

.bom-placeholder-item .alt-option {
  visibility: hidden;
}

.bom-placeholder.indent .bom-placeholder-item {
  background-color: var(--base-orange-color);
  margin-left: 30px;
}

.bom-placeholder.indent .bom-placeholder-item .alt-option {
  visibility: visible;
  font-size: 1.2em;
  font-weight: bold;
  color: rgba(0,0,0,0.5);
}

#bom-grid-body .indent-item {
  display: none;
  font-weight: bold;
}

#bom-grid-body tr.indent .indent-item {
  display: inline;
  line-height: 34px;
}

#bom-grid-body tr.indent .material-input-group {
  width: 85%;
  float: right;
}

#bom-grid-body tr.indent [name='optional'] {
  display: none;
}

</style>