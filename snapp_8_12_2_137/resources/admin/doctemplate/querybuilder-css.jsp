<%@page import="java.util.Map.Entry"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageQueryBuilder" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>


<style>

#qb-tab-content.tab-content {
  padding: 0;
  background-color: var(--body-bg-color);
  display: flex;
  justify-content: space-between;
  font-size: 14px;
}

#qb-tab-content .vert-block {
  overflow: auto;
}

#qb-tab-content .vert-split {
  cursor: e-resize;
  width: 6px;
  border: 0 solid var(--border-color);
  border-width: 0 1px;
}

#qb-tab-content.in-column-resizing iframe {
  pointer-events: none;
}

.property-box {
  overflow: hidden;
}

.property-box-header {
  font-weight: bold;
  background-color: var(--body-bg-color);
  padding: 3px 10px;
  white-space: nowrap;
  text-overflow: ellipsis;
  overflow: hidden;
}

.property-box.collapsed .property-box-body {
  display: none;
}

.property-box.collapsed .property-box-header .collapse-btn {
  display: none;
}

.property-box.exploded .property-box-header .explode-btn {
  display: none;
}

#datasource-container {
  background-color: white;
  width: 350px;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
}

#select-container {
  background-color: white;
  width: 350px;
  display: flex;
  justify-content: space-between;
}

#result-container {
  flex-grow: 1;
  background-color: var(--content-bg-color);
  border: none;
}

#collection-body {
  flex-grow: 1;
  overflow: auto;
}

#collection-header {
  flex-shrink: 0;
  display: flex;
  justify-content: space-between;
  align-items: stretch;
  background-color: var(--body-bg-color);
  border: 0 solid var(--border-color);
  border-bottom-width: 1px;
}

#collection-header .btn-collection {
  width: 42px;
  text-align: center;
  font-size: 18px;
  line-height: 38px;
}

#collection-header .btn-collection:hover {
  background-color: var(--highlight-color);
}

#txt-collection-search {
  margin: 0;
  border: 0 solid var(--border-color);
  border-right-width: 1px;
  padding: 10px;
}

#txt-collection-search:focus {
  outline: none;
}

#datasource-container .search-hide {
  display: none;
}

#select-box {
  display: flex;
  flex-direction: column;
  flex-grow: 1;  
}

#select-box .property-box-body {
  flex-grow: 1;
}

#datasource-container .explode-btn,
#datasource-container .collapse-btn {
  cursor: pointer;
}

.collection-field {
  padding: 3px 10px 3px 20px;
  cursor: move;
  white-space: nowrap;
  text-overflow: ellipsis;
  overflow: hidden;
}

.field-icon {
  color: rgba(0,0,0,0.4);
  width: 18px;
  text-align: center;
  flex-shrink: 0;
}

.column-item .column-header {
  padding: 3px;
  background: var(--content-bg-color);
  display: flex;
  justify-content: space-between;
  align-items: baseline;
}

.column-item .column-header .column-alias {
  flex-grow: 1;
  overflow: hidden;
  text-overflow: ellipsis;
}

.column-item .column-header .field-icon {
  visibility: hidden;
}

.column-item .column-header:hover .column-remove-icon {
  visibility: visible;
  cursor: pointer;
}

.column-item .column-header .column-remove-icon:hover {
  color: var(--base-red-color);
}

.column-item .column-header:hover .column-move-icon {
  visibility: visible;
  cursor: row-resize;
}

.column-detail {
  margin: 10px;
  padding: 10px;
  border-radius: 10px;
  background-color: var(--body-bg-color);
}


/*

[name="result-container"] {
  width: 100%;
  height: 750px;
  border: 1px solid #dfdfdf;
}

#column-list-widget .move-handle {
  float: left;
  color: rgba(0,0,0,0.1);
  font-size: 18px;
  line-height: 24px;
  cursor: move;
}

#column-list-widget .field-name {
  margin-left: 34px;
  margin-right: 34px;
  line-height: 24px;
  cursor: pointer;
}

#column-list-widget .move-handle:hover {
  color: rgba(0,0,0,0.6);
}

.column-block .column-detail {
  margin-top: 10px;
}

.column-block.collapsed .column-detail {
  display: none;
}

.column-block.ui-sortable-helper {
  background-color: rgba(200,200,200,0.5);
  border: 2px dashed rgba(0,0,0,0.25) !important;
  overflow: hidden;
}

.btn-remove {
  float: right;
  width: 24px;
  height: 24px;
  background-image: url(<v:image-link name="bkoact-no-black.png" size="16"/>);
  background-repeat: no-repeat;
  background-position: right center;
  cursor: pointer;  
  opacity: 0;
}

.column-block:hover .btn-remove {
  opacity: 0.1;
}

.column-block .btn-remove:hover {
  opacity: 0.5;
}
*/
</style>
