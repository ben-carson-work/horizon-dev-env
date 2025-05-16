<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<style>

#rights-dialog {
  padding: 0;
  background: var(--body-bg-color);
}

#rights-menu {
  position: absolute;
  top: 0;
  left: 0;
  bottom: 0;
  width: 170px;
  border-right: 1px var(--tab-side-border-color) solid;
  padding: 0;
  margin: 0;
}

#rights-body {
  position: absolute;
  top: 0;
  left: 171px;
  bottom: 0;
  right: 0;
  overflow-x: hidden;
  overflow-y: auto;
}

.rights-body-content {
  padding: 20px;
}

#rights-menu li {
  border-bottom: 1px var(--tab-side-border-color) solid;
  font-weight: bold;
}

#rights-menu .rgticon {
  font-size: 16px;
  width: 24px;
  line-height: 24px;
  text-align: center;
  border-radius: 4px;
  float: left;
  margin-top: 4px;
  margin-right: 4px;
  color: white;  
}

#rights-menu .rgticon-purple {background-color: var(--base-purple-color)}
#rights-menu .rgticon-red {background-color: var(--base-red-color)}
#rights-menu .rgticon-orange {background-color: var(--base-orange-color)}
#rights-menu .rgticon-blue {background-color: var(--base-blue-color)}
#rights-menu .rgticon-green {background-color: var(--base-green-color)}
#rights-menu .rgticon-gray {background-color: #808080}

#rights-body .checkbox-label {
  line-height: 28px;
}

.rights-menu-item {
  background-color: white;
  background-repeat: no-repeat;
  background-position: 3px center;
  cursor: pointer;
  line-height: 32px;
  padding-left: 4px;
  padding-right: 8px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  -webkit-touch-callout: none;
  -webkit-user-select: none;
  -khtml-user-select: none;
  -moz-user-select: none;
  -ms-user-select: none;
  user-select: none;
}

.rights-menu-item:hover {
  background-color: rgba(0,0,0,0.03);
}

.rights-menu-item.selected {
  background-color: var(--highlight-color);
}

.rights-menu-divider {
  line-height: 20px;
}

.rights-menu-search {
  padding: 10px;
}

.rights-content-block {
  background: white;
  border-radius: var(--widget-border-radius);
}

.rights-content-block .rights-item:last-child {
  border: none;
}

.rights-content-section {
  margin-bottom: 20px;
}

.rights-content-section>h3 {
  color: #717177;
  margin: 2px 8px 2px 8px;
  text-transform: uppercase;
  font-size: 1em; 
}

.rights-item {
  margin: 0;
  padding: 4px 8px 4px 8px;
  border-bottom: 1px var(--body-bg-color) solid;
}

.rights-item-label {
  float: left;
  width: 40%;
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
}

.rights-item-checkbox:focus  {
  outline: none !important;
}

.rights-item-value {
  float: right;
  text-align: right;
  width: 58%;
}

.rights-inherited-text {
  text-align: right;
  line-height: 28px;
  color: #808080;
  font-weight: bold;
}

.rights-item-value input[type='text'],
.rights-item-value input[type='password'] {
  text-align: right;
  width: 100%;
}

.rights-item-value textarea {
  width: 100%;
  padding: 0;
  height: 150px;
  resize: none;
  font-family: monospace;
  word-wrap: normal;
}

.rights-item-value input:focus,
.rights-item-value textarea:focus,
.rights-item-value select:focus {
  outline: 0;
}

.rights-item-value .tag-item {
  float: right;
}

.rights-item .rights-item-label {
  font-weight: bold;
}

.rights-item.default-value .rights-item-label {
  font-weight: normal;
}

.rights-item .this-control {
  display: block;
}

.rights-item .def-control {
  display: none;
}

.rights-item.default-value .this-control {
  display: none;
}

.rights-item.default-value .def-control {
  display: block;
}

.rights-subset {
  margin-left: 16px;
}

select.rights-grouplevel {
  width: 33.33%;
}

#rights-dialog .v-switch {
  margin-top: 4px;
}

.rights-color-preview {
  display: inline-block;
  border: 1px solid #cecece;
  width: 20px;
  height: 20px;
  margin-top: 4px;
  background-image: repeating-linear-gradient(135deg, rgba(0,0,0,.15), rgba(0,0,0,.15) 1px, transparent 2px, transparent 2px, rgba(0,0,0,.15) 3px);
}

</style>
