<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>

/* attribute/items list */

#step1-table,
#step2-table {
  width: 100%;
}

#step1-table td,
#step2-table td {
  vertical-align: top;
}

#attribute-widget .widget-block,
#attribute-item-widget .widget-content {
  height: 450px;
  overflow: auto;
}

#attribute-widget .widget-block {
  padding: 0;
}

#attribute-widget .attribute-row {
  cursor: pointer;
  padding: 5px;
}

#attribute-widget .attribute-row:hover {
  background-color: #ebf3fa;
}

#attribute-widget .attribute-row.selected, 
#attribute-widget .attribute-row.selected:hover {
  background-color: #b8dbfa;
}

#attribute-item-widget .form-control {
  margin: 0;
}

#attribute-item-widget .attribute-block {
  display: none;
}
#attribute-item-widget .attribute-block.selected {
  display: block;
}

/* Recap */

.recap-widget .recap-block {
  height: 454px;
  overflow: auto;
}

.recap-widget .recap-total {
  font-weight: bold;
}

.recap-group {
  margin-bottom: 10px;
}

.recap-group .recap-title-attribute {
  font-weight: bold;
  margin-right: 10px;
}

.recap-group .recap-body {
  margin-left: 20px;
}

.recap-group .recap-item {
  color: #666666;
  text-decoration: underline;
}

/* Product list */

.product-list{
  border-radius: 4px;
  border: 1px #dfdfdf solid;
}

.product-list-body, .product-list-header{
  width: 100%;
}

.product-list-header{
  font-weight: bold;
}

.product-list-body{
  height: 485px;
  overflow: auto;
}

.product-list input{
  float: left;
  margin-right: 10px;
  padding: 6px 12px;
  margin-bottom: 5px;
}

.product-row{
  border-bottom: 1px #dfdfdf solid;
  padding-top: 4px;
}

.product-row:HOVER{
  background-color: #ebf3fa !important;
  cursor: pointer;
}

.product-row:nth-of-type(odd){
  background-color: #f9f9f9;
}

.product-row:nth-of-type(even){
  background-color: #ffffff;
}

.steps {
  pointer-events: none;
}

.attr-search-box{
  padding: 6px 12px;
  margin-bottom: 5px;
}

.item-name{
  margin-left: 5px;
}

.attribute-name{
  padding: 2px 3px 3px 3px;
}

.form-control{
  margin-bottom: 10px;
}

.invalid-entry{
  border-color: red !important;
}

.attribute-selected div{
  font-weight: bold !important;
}

.wizard > .steps > ul > li {
    width: 33%;
}

.wizard ul {
    width: 101%;
}

.product-parameters .widget-block{
  height: 494px;
}

.product-list .product-row.modified {
  border-left: 4px solid var(--base-orange-color);
}

</style>