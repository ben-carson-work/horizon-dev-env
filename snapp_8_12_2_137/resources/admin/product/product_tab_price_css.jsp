<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageProduct" scope="request"/>
<jsp:useBean id="product" class="com.vgs.snapp.dataobject.DOProduct" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% boolean canEdit = pageBase.getRightCRUD().canUpdate(); %>

<style>

#matrix-container {
  overflow: auto;
}

.matrix-grid {
  background-color: #d3d3d3;
  border-spacing: 1px;
  margin-left: 10px;
  margin-bottom: 20px;
}

.matrix-title {
  font-weight: bold;
  border-bottom: 1px solid rgba(0,0,0,0.1);
  line-height: 20px;
  margin-bottom: 10px;
  padding-left: 10px;
}

.matrix-grid td {
  min-width: 65px;
  padding: 6px;
}

.matrix-grid td.fixed {
  background-color: #e6e6e6;
  text-align: center;
}

.matrix-grid td.value {
  background-color: white;
  text-align: right;
  <% if (canEdit) { %>
    cursor: pointer;
  <% } %>
}

.matrix-grid td.value.custom {
  background-color: #fffedd;
}

.matrix-grid td.value:hover {
  <% if (canEdit) { %>
    background-color: #ebf3fa;
  <% } %>
}

.matrix-grid td.setup {
  <% if (canEdit) { %>
    cursor: pointer;
  <% } %>
}

.matrix-grid td.setup:hover {
  <% if (canEdit) { %>
    background-color: #d3d3d3;
  <% } %>
}

.matrix-grid td.setup-click {
  background-color: red;
}

.matrix-grid span.value-params {
  font-size: 0.7em;
  color: #666666;
}

#mempt.matrix-grid td.value {
  padding: 0;
}

#mempt.matrix-grid td.value input {
  padding: 6px 12px;
  border: none;
  border-radius: 0;
  text-align: right;
}

#mempt.matrix-grid td.value input:focus {
  outline: none;
  background-color: #fffedd;
}

.matrix-tab {
  list-style-type: none;
  padding: 0;
  padding-left: 20px;
  margin: 0;
  margin-bottom: 10px;
  border-bottom: 1px solid #d3d3d3;
  height: 45px;
}

.matrix-tab li {
  position: relative;
  float: left;
  padding: 4px 20px 4px 10px;  
  background-color: #eeeeee;
  border: 0px #d3d3d3 solid;
  border-top-width: 1px;
  border-right-width: 1px;
  cursor: pointer;
  line-height: 18px;
  height: 44px;
}

.matrix-tab li:first-child {
  border-left-width: 1px;
}

.matrix-tab li:hover {
  background-color: #e6e6e6;
}

.matrix-tab li.matrix-tab-active {
  background-color: white;
  border-bottom: 1px solid white;
  height: 45px;
}

.matrix-tab li.ui-sortable-helper {
  border: 1px black solid;
}

.matrix-tab-plus {
  width: 10px;
  height: 24px !important;
  margin-top: 20px;
}

.matrix-tab-text {
  display: flex;
  justify-content: space-between;
}

.matrix-tab-serial {
  margin-right: 10px;
}

.matrix-tab-caption {
  display: inline-block;
  vertical-align: middle;
}

.matrix-tab-caption .date-always {
  color: rgba(0,0,0,0.6);
}

.matrix-tab-caption .date-fixed {
  font-weight: bold;
}

.matrix-tab-caption.single-line,
.matrix-tab-serial {
  line-height: 36px;
}

.matrix-tab-btn {
  position: absolute;
  right: 2px;
  width: 16px;
  height: 16px;
  margin-left: 4px;
  background-repeat: no-repeat;
  background-position: center center;
  text-align: center;
  vertical-align: middle;
  font-size: 10px;
  opacity: 0.2;
  visibility: hidden;
}

.matrix-tab-remove {
  top: 4px;
  font-size: 13px;
  text-align: center;
}

.matrix-tab-edit {
  bottom: 4px;
}

.matrix-tab li:hover .matrix-tab-remove {
  visibility: visible;
}

.matrix-tab-active:hover .matrix-tab-edit {
  visibility: visible;
}

.matrix-tab-btn:hover {
  opacity: 1;
}

.matrix-tab-remove:hover {
  color: var(--base-red-color);
}

#price-date {
  margin-bottom: 10px;
}

.price-date-field {
  display: inline-block;
  margin-right: 10px;
}

.price-date-value {
  font-weight: bold;
}

tr.spaceUnder > td {
  padding-bottom: 1em;
}

.varprice-preset-amount {
  display: inline-block;
  border-radius: 4px;
  padding: 6px 12px;
  margin-right: 4px;
  background-color: var(--base-gray-color);
  font-weight: bold;
  cursor: grab;
}

.varprice-preset-amount-value {
  display: inline-block;
}

.varprice-preset-amount-del {
  display: inline-block;
  cursor: pointer;
  margin-left: 5px;
}

.varprice-preset-amount-del:hover {
  color: var(--base-blue-color);
}

.varprice-preset-amount.disabled .varprice-preset-amount-del {
  display:none;
}

</style>
