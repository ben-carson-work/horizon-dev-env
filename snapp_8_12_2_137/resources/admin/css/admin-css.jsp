<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<% // This IF-BLOCK is supposed to always fail. Just a workaround to have this page highlighted as javascript. %>
<% if (request.getAttribute("BB63A701FB6F4C04B70C44E3CB161795") != null) { %>
<style>
<% } %>

<%@ include file="/resources/common/css/common.css" %>

:root {
  --adminbody-tabcontent-top: 150px;
  --admintopbar-height: 28px;
  --adminnavbar-width: 190px;
  --profile-sidebar-width: 300px;
}
 
body {
  font-family: 'Open Sans', sans-serif;
  font-size: 13px;
  line-height: 1.4em;
  min-width: 800px;
  margin: 0px;
  padding: 0px;
  background-color: var(--body-bg-color);
}

table {
  border-collapse: initial; /* bootstrap fix */
}

label {
  margin: 0; /* bootstrap fix */
  font-weight: normal; /* bootstrap fix */
}

.ui-widget {
  font-family: inherit;
  font-size: inherit;
}

.ui-widget input, .ui-widget select, .ui-widget textarea, .ui-widget button {
  font-family: 'Open Sans', sans-serif;
}

a:not(.btn) {
  color: #21759b;
  text-decoration: none;
}

a:hover:not(.btn), a:active, a:focus {
  color: #d54e21;
}

a.button:hover {
  color: inherit;
  text-decoration: inherit;
  text-shadow: inherit;
}

.button {
  -webkit-touch-callout: none;
  -webkit-user-select: none;
  -khtml-user-select: none;
  -moz-user-select: none;
  -ms-user-select: none;
  user-select: none;
}

.no-select {
  -webkit-touch-callout: none;
  -webkit-user-select: none;
  -khtml-user-select: none;
  -moz-user-select: none;
  -ms-user-select: none;
  user-select: none;
}

fieldset {
  border: 1px #dfdfdf solid;
  border-radius: 3px;
  padding: 10px;
}

fieldset legend {
  border: none;
  font-size: inherit;
  width: initial;
  padding: 0 5px;
  margin: 0;
  font-weight: bold;
}

.ui-dialog {
  background: var(--body-bg-color);
  padding: 0;
  box-shadow: 0px 0px 20px rgba(0,0,0,0.2);
  position: fixed;
}

.ui-dialog-titlebar {
  background-color: #e9e9e9;
  background-image: linear-gradient(#fefefe, #d9d9d9);
  border: 0;
  border-radius: 0;
  border-bottom: 1px #aaaaaa solid;
  padding: 10px !important;
}

.ui-dialog-title {
  text-shadow: 0px 1px 0px rgba(255,255,255,0.8);
  font-size: 15px;
  line-height: normal;
}

.ui-dialog.ui-corner-all {
  border-radius: 6px;
}

.ui-dialog .ui-dialog-buttonpane {
  background: inherit;
  margin: 0;
}

.ui-dialog .ui-dialog-content {
  padding: 10px;
}

.ui-dialog .ui-dialog-titlebar-close {
  position: absolute;
  width: 20px;
  height: 20px;
  right: 10px;
  border: 0;
  background-color: initial;
  font-size: 1.2em;
  cursor: pointer;
  opacity: 0.4;
}

.ui-dialog .ui-dialog-titlebar-close:focus {
  outline: none;
}

.ui-dialog .ui-dialog-titlebar-close:hover {
  opacity: 1;
}

.ui-dialog-titlebar-close .ui-button-text {
  display: none;
}

.icon-dialog {
  min-width: 500px;
}
.icon-dialog .ui-dialog-titlebar-close {
  visibility: hidden;
}
.msg-dialog-body {
  overflow: hidden;
  padding: 10px;
}
.msg-dialog-icon {
  float: left;
  width: 70px;
  height: 70px;
  font-size: 40px;
  text-align: center;
  color: var(--base-orange-color);
}
.msg-dialog-text {
  margin-left: 90px;
}

.ui-button {
  background: linear-gradient(#f7f7f7, #dadada) !important;
  border-color: #d0d0d0 !important;
  text-shadow: 0 1px 0 rgba(255,255,255,0.5);
}

.ui-button:hover {
  background: linear-gradient(#f0f0f0, #cacaca) !important;
  border-color: #c0c0c0 !important;
  box-shadow: 1px 1px 4px rgba(0,0,0,0.1);
}

.ui-button[disabled='disabled'],
.ui-button[disabled='disabled']:hover {
  background: #f7f7f7 !important;
  border-color: #d0d0d0 !important;
  cursor: default !important;
  text-shadow: none !important;
  box-shadow: none !important;
  color: #888888;
}

.ui-button[disabled='disabled'] .ab-icon {
  opacity: 0.5 !important;
}

.page-footer {
  color: #999999;
  text-align: right;
  padding: 6px;
  margin-top: 50px;
}

#page-title-box {
  padding: 12px 0px 21px 12px;
  background-color: var(--pagetitle-bg-color);
}

[data-pagestatus='ARCHIVED'] #page-title-box {
  background-color: var(--base-blue-color);
}

.page-title-box-archived {
  display: none;
}

[data-pagestatus='ARCHIVED'] .page-title-box-archived {
  display: block; 
  color: white;
  position: absolute;
  top: 72px;
  right: 15px;
  font-size: 2.3em;
  text-transform: uppercase;
}


#page-title-box img {
  float: left;
  width: 48px;
  height: 48px;
  background-repeat: no-repeat;
  background-position: center center;
}

#page-title-box .page-title {
  font-size: 2.3em; 
  line-height: 32px;
  color: rgba(0,0,0,0.7); 
  font-weight: normal;
  padding-left: 6px;
}

[data-pagestatus='ARCHIVED'] #page-title-box .page-title {
  color: white;
}

#page-title-box .page-path,
#page-title-box .page-path a {
  font-size: 1.1em;
  color: rgba(0,0,0,0.5);
}

#page-title-box .page-path {
  padding: 4px 0px 4px 0px;
}

#page-title-box .page-path a {
  padding: 2px 4px 2px 22px;
  margin: 0px 4px 0px 4px;
  background-repeat: no-repeat;
  background-position: 4px center;
}

#page-title-box .page-path a:hover {
  background-color: rgba(255,255,255,0.5);
  color: rgba(0,0,0,0.8);
  border-radius: 4px;
} 

#page-title-box .page-back-to-list {
  font-size: 1.3em;
  color: #888888;
  cursor: pointer;
  margin-left: 20px;
  padding: 4px 10px;
  float: right;
}

#page-title-box .page-back-to-list:hover {
  color: black;
  background-color: #ececec;
  border-radius: 4px;
}

select:disabled {
  background-color: #fafafa;
}

.widefat, div.updated, div.error, .wrap .add-new-h2, textarea, input[type="file"]:not(.form-control), 
input[type="reset"]:not(.form-control), input[type="email"]:not(.form-control), input[type="number"]:not(.form-control), input[type="search"]:not(.form-control), 
input[type="tel"]:not(.form-control), input[type="url"]:not(.form-control), select, .tablenav .tablenav-pages a, .tablenav-pages span.current, #titlediv #title, .postbox, 
#postcustomstuff table, #postcustomstuff input, #postcustomstuff textarea, .imgedit-menu div, .plugin-update-tr .update-message, #poststuff 
.inside .the-tagcloud, .login form, #login_error, .login .message, #menu-management .menu-edit, .nav-menus-php .list-container, .menu-item-handle, 
.link-to-original, .nav-menus-php .major-publishing-actions .form-invalid, .press-this #message, #TB_window, .tbtitle, .highlight, .feature-filter, 
#widget-list .widget-top, .editwidget .widget-inside {
  border-radius: var(--widget-border-radius);
  border-width: 1px;
  border-style: solid;
  border-color: var(--border-color);
}

.checkbox-label {
  cursor: pointer;
  line-height: 20px;
  -webkit-touch-callout: none;
  -webkit-user-select: none;
  -khtml-user-select: none;
  -moz-user-select: none;
  -ms-user-select: none;
  user-select: none;
}

.radio-inline-label {
  margin-right: 10px;
}

.checkbox-inline-label {
  display: inline-block;
  margin-right: 10px;
}

input[type='checkbox'],
input[type='radio'],
input[type='checkbox']:focus,
input[type='radio']:focus {
  appearance: none;
  cursor: pointer;
  height: 18px;
  width: 18px;
  line-height: 16px;
  border: 1px solid var(--base-gray-color);
  background-color: white;
  color: rgba(0,0,0,0);
  outline: 0;
  box-shadow: none;
  display: inline-block;
}

input[type='checkbox'] {
  border-radius: 3px;
  font-family: var(--fa-style-family,"Font Awesome 6 Pro");
  font-weight: var(--fa-style,900);
  text-rendering: auto;
  -webkit-font-smoothing: antialiased;
  text-align: center;
}

input[type='checkbox']::before {
  content: "\f00c";
}

input[type='radio'] {
  border-radius: 50%;
  vertical-align: text-bottom;
}

input[type='checkbox']:hover:not(:disabled),
input[type='radio']:hover:not(:disabled) {
  border-color: var(--base-blue-color);
}

input[type='checkbox']:checked,
input[type='radio']:checked {
  border-color: var(--base-blue-color);
  background-color: var(--base-blue-color);
  color: white;
}

input[type='radio']:checked {
  background-color: white;
  border-width: 5px;
}

input[type='checkbox']:disabled,
input[type='radio']:disabled {
  opacity: 0.5;
}

.multipage-selected input[type='checkbox'].header:checked::before {
  content: "\f00d";
}

input:disabled:not([type='checkbox']), isindex:disabled, textarea:disabled,
input[readonly='readonly'] {
  color: #545454;
  background-color: #fafafa;
}

body.login {
  background-color: #fbfbfb; 
  background-image: url('imagecache?name=horizon-color-med.png&size=100');
  background-repeat: no-repeat;
  background-position: 15px 0px;
}

span.ab-icon {
  background-repeat: no-repeat;
  background-position: center center;
  position: relative;
  float: left;
  width: 16px;
  height: 16px;
}

.errorbox {
  background-color: #ffffe0;
  background-image: url('imagecache?name=%5Bfont-awesome%5Dexclamation-triangle%7CColorizeOrange&size=24');
  background-repeat: no-repeat;
  background-position: 6px 6px;
  border: 1px #e6db55 solid;
  border-radius: 4px;
  padding: 10px 10px 10px 36px;
  margin: 10px 0px 10px 0px;
  color: #333333;
}

.successbox {
  background-color: #e8fdec;
  background-image: url('imagecache?name=%5Bfont-awesome%5Dcheck%7CCircleGreen&size=24');
  background-repeat: no-repeat;
  background-position: 6px 6px;
  border: 1px #75c684 solid;
  border-radius: 4px;
  padding: 10px 10px 10px 36px;
  margin: 10px 0px 10px 0px;
  color: #333333;
}

.warning-box {
  border: 1px rgba(0,0,0,0.1) solid;
  background: rgba(0,0,0,0.01);
  border-left: 4px var(--base-orange-color) solid;
  padding: 10px;
}

.error-box {
  border: 1px rgba(0,0,0,0.1) solid;
  background: rgba(0,0,0,0.01);
  border-left: 4px var(--base-red-color) solid;
  padding: 10px;
}

label.disabled {
  color: rgba(0,0,0,0.5);
}

select.spinner {
  background-image: url('resources/admin/images/spinner.gif');
  background-repeat: no-repeat;
  background-position: center center;
}

#main-container {
  position: relative;
}

#main-container .right-column {
  position: absolute;
  right: 0px;
  width: 300px;
  margin-top: 34px;
}

#main-container .left-body {
  margin-right: 310px;
}

#main-container .center-body {
  margin-left: 310px;
  margin-right: 310px;
}

#login {
  width: 320px;
  padding: 0px;
  padding-top: 114px;
  margin: auto;
}

.login form {
  background-color: var(--content-bg-color);
  padding-top: 26px;
  padding-right: 24px;
  padding-bottom: 46px;
  padding-left: 24px;
  border: #e5e5e5 solid 1px;
  box-shadow: 0pt 4px 10px -1px rgba(200, 200, 200, 0.7);
  border-radius: 3px;
}

.login label {
  color: #777777;
  font-size: 14px;
  margin-left: 2px;
}

.login form .input {
  font-size: 24px;
  line-height: 1;
  width: 96%;
  color: #555555;
  padding: 3px;
  border: #e5e5e5 solid 1px;
  background-color: #fbfbfb;
  box-shadow: 1px 1px 2px rgba(200, 200, 200, 0.2) inset;
}

.login button {
  float: right;
}

#login form p {
  margin: 0px;
  margin-bottom: 14px;
}

.login form .forgetmenot {
  font-weight: normal;
  float: left;
  margin-bottom: 0pt;
}

.login h1 a {
  background-color: transparent;
  background-image: url('imagecache?name=snapp-logo.png&size=400');
  background-repeat: no-repeat;
  background-attachment: scroll;
  background-position: center center;
  background-clip: border-box;
  background-origin: padding-box;
  background-size: 100% auto;
  width: 326px;
  height: 120px;
  text-indent: -9999px;
  overflow-x: hidden;
  overflow-y: hidden;
  padding-bottom: 15px;
  display: block;
}

.login-footer {
  position: absolute;
  left: 0px;
  right: 0px;
  bottom: 0px;
  background: #f7f7f7;
  border-top: 1px #e0e0e0 solid;
  color: #999999;
  line-height: 36px;
  text-align: center;
}

.login-dialog .login-item {
  margin-bottom: 5px;
  overflow: hidden;
}

.login-dialog .login-item span {
  display: inline-block;
  width: 100px;
}

.login-dialog .login-item input {
  width: 170px;
}

.login-dialog .login-error {
  padding: 10px;
  color: red;
  font-weight: bold;
  font-size: 1.2em;
  text-align: center;
}

.login-dialog .login-wait {
  text-align: center;
  padding: 10px;
}


#admincontainer {
  padding-top: var(--admintopbar-height);
}

#adminbody {
  margin-left: var(--adminnavbar-width);
  padding: 0;
}

.mainlist-container {
  padding: 12px;
}

.main-tab-fixed {
  position: fixed;
  top: var(--adminbody-tabcontent-top);
  left: var(--adminnavbar-width);
  bottom: 0;
  right: 0;  
}

/*
  NAV MENU
*/

<%@ include file="menu.css" %>


/*
  TABLE
*/


td {
  padding: 0px;
  margin: 0px;
}

table.listcontainer {
  width: 100%;
}

table.listcontainer td {
  border-bottom: 1px var(--border-color) solid;
  padding: 4px 6px 4px 6px;
  color: rgba(0,0,0,0.8);
}

table.listcontainer tr[data-status='draft']     td:first-child {border-left: 4px var(--base-gray-color) solid}
table.listcontainer tr[data-status='active']    td:first-child {border-left: 4px var(--base-green-color) solid}
table.listcontainer tr[data-status='warning']   td:first-child {border-left: 4px var(--base-orange-color) solid}
table.listcontainer tr[data-status='error']     td:first-child {border-left: 4px var(--base-red-color) solid}
table.listcontainer tr[data-status='completed'] td:first-child {border-left: 4px var(--base-blue-color) solid}
table.listcontainer tr[data-status='fatal']     td:first-child {border-left: 4px var(--base-orange-color) solid}

table.listcontainer td[nowrap] {
  white-space: nowrap;
}

table.listcontainer tr.header td,
table.listcontainer thead tr td {
  font-size: 13px;
  font-weight: bold;
  color: #333333;
  text-shadow: 0pt 1px 0pt #ffffff;
}

table.listcontainer .title td {
  padding: 0px;
}

table.listcontainer tbody tr.grid-row {
  cursor: pointer;
}

table.listcontainer tbody tr.grid-row:nth-child(odd) {
  background-color: #fbfcfd;
}

table.listcontainer tbody tr.grid-row.row-clicked,
table.listcontainer tbody tr.grid-row.selected,
table.listcontainer tbody tr.grid-row.selected:hover {
  background-color: #deedfe;
}

table.listcontainer tbody tr.grid-row:hover {
  background-color: #ebf3fa;
}

table.listcontainer tbody tr.no-items {
  cursor: inherit;
}

table.listcontainer tbody tr.no-items:hover {
  background: inherit;
}

table.listcontainer .list-icon {
  float: left;
  width: 32px;
  height: 32px;
  line-height: 32px;
  font-size: 21px;
  text-align: center;
  background-repeat: no-repeat;
  background-position: center center;
  background-size: 100%;
}

table.listcontainer tr .row-hover-visible {
  visibility: hidden;
}

table.listcontainer tr:hover .row-hover-visible {
  visibility: visible;
}

table.listcontainer tr.group {
  cursor: inherit;
}

table.listcontainer tr.group td {
  background-color: var(--header-bg-color);
  font-weight: bold;
}

table.listcontainer tbody.toolbar td {
  padding: 10px;
  background-color: #f2f2f2;
}

table.listcontainer .drag-handle {
  cursor: move;
  opacity: 0.2;
}

table.listcontainer .drag-handle:hover {
  opacity: 1;
}

.listcontainer .note-grid-icon {
  text-align: center;
  font-size: 16px;
} 

.grid-shadow {
  box-shadow: 0px 0px 10px #555;
}

.list-title {
  font-weight: bold;
}

.list-subtitle {
  color: #888888;
}

.listicon {
  width: 32px;
  height: 32px;
}

.grid-move-handle {
  display: inline-block;
  width: 20px;
  height: 20px;
  background-image: url('imagecache?name=move_item.png&size=16');
  background-repeat: no-repeat;
  background-position: center center;
}

.grid-widget-container {
  position: relative;
}

.grid-overlay {
  background-color: rgba(0,0,0,0.2);
  z-index: 101;
  position: absolute;
  top: 0;
  left: 0;
  bottom: 0;
  right: 0;
  border-radius: 3px;
  color: white;
  font-size: 40px;
  text-align: center;
  padding: 20px;
}

.spinner32-bg {
  background-image: url('<v:config key="resources_url"/>/admin/images/spinner32.gif'); 
  background-repeat: no-repeat;
  background-position: center center;
}

.recap-table {
  border-spacing: 0;
  border-collapse: collapse;
}

.recap-table td {
  padding-right: 10px;
  vertical-align: top;
}

.recap-table td:last-child {
  padding-right: 0px;
}

/* ITEM PAGE */


.postbox,
.listcontainer {
  border: 1px var(--border-color) solid;
  border-radius: var(--widget-border-radius);
  background-color: var(--content-bg-color);
  margin-bottom: 10px;
}

.widget-title,
table.listcontainer td.widget-title {
  padding: 8px;
  color: #464646;
  border-bottom: 1px var(--border-color) solid;
  font-size: 16px;
  line-height: initial;
}

.widget-title-icon {
  float: left;
  width: 22px;
  height: 22px;
  margin-right: 4px;
  background-repeat: no-repeat;
  background-position: center center;
}

.widget-title-caption {
  font-weight: bold;
  color: rgba(0,0,0,0.8);
  text-shadow: none;
}

.postbox .widget-block {
  border-bottom: 1px var(--border-color) solid;
  padding: 10px;
}

.postbox .widget-content .widget-block:last-child {
  border-bottom: 0;
}

.widget-block .recap-value-item {
  overflow: hidden;
}

.widget-block.group  {
  padding: 4px 10px 4px 10px;
  font-weight: bold;
  background-color: #F2F2F2;
}

span.postbox-title-icon,
.listcontainer .title .title-icon {
  background-repeat: no-repeat;
  background-position: center center;
  position: relative;
  float: left;
  width: 30px;
  height: 30px;
}

.postbox a .edit-icon {
  float: right;
  width: 16px;
  height: 16px;
  font-size: 16px;
  line-height: 16px;
  opacity: 0.2;
  color: #000;
  margin-left: 5px;
}

.postbox a:hover .edit-icon {
  opacity: 1;
}

span.recap-value {
  font-weight: bold;
  float: right;
}

.form-table {
  width: 100%;
}

.form-table th {
  color: #222;
  text-shadow: white 0 1px 0;
  text-align: left;
  font-weight: normal;
  width: 150px;
}

.form-table label {
  cursor: pointer;
}

.form-table td {
  line-height: 20px;
}

p.help, p.description, span.description, .form-wrap p {
  font-size: 12px;
  font-style: italic; 
}

textarea, 
select,
input[type="text"], 
input[type="password"], 
input[type="file"], 
input[type="reset"], 
input[type="email"], 
input[type="number"], 
input[type="search"], 
input[type="tel"], 
input[type="url"] {
  width: 100%;
  box-sizing: border-box;
}



.ui-tabs.ui-widget-content {
  border: 0px;
}

.ui-tabs .ui-tabs-nav li.ui-tabs-active {
  background-color: var(--content-bg-color);
  border-color: #aaa;
}

.ui-tabs .ui-tabs-nav li.ui-tabs-active .ui-tabs-anchor {
  cursor: pointer;
  color: #454545;
} 

.ui-tabs li.ui-state-default:hover a { 
  color: #212121; 
  text-decoration: none; 
}

.ui-tabs .ui-tabs-nav {
  background: transparent;
  border: 0px;
  border-radius: 0px;
  border-bottom: 1px #aaaaaa solid;
  padding-left: 8px;
}

.ui-tabs .ui-tabs-panel {
  border: 1px #aaaaaa solid;
  border-top-width: 0px;
  padding: 0px;
  box-shadow: 1pt 1px 5px 0px rgba(0, 0, 0, 0.2);
}

.ui-tabs li.plus-menu-item {
  margin-top: 6px;
}

.ui-tabs li.plus-menu-item .btn {
  padding: 2px 6px;
  margin: 0;
  background: none;
}

.ui-tabs li.plus-menu-item ul li {
  float: none;
  margin: 0;
}

.ui-tabs li.plus-menu-item ul li .ui-tabs-anchor {
  float: none;
  padding: 3px 20px;
}

.ui-tabs-tab:focus {
  outline: 0;
}


span.divider {
  border: 0px;
  border-left: 1px #dfdfdf solid;
  padding-top: 10px;
  padding-bottom: 14px;
  margin-left: 6px;
  margin-right: 10px;
}

.form-toolbar {
  margin-bottom: 10px;
  padding: 6px;
  border: 1px #dfdfdf solid;
  border-radius: var(--widget-border-radius);
  min-height: 48px;
  background-color: var(--header-bg-color);
}

.tab-toolbar {
  border: none;
  border-radius: 0px;
  border-bottom: 1px var(--border-color) solid;
  padding: 10px;
  min-height: 53px;
}

.tab-content {
  padding: 12px;
}

input[type="file"] {
  border: 0px;
}

.v-hidden {
  display: none;
}

.search-hide {
  display: none;
}

.line-through {
  text-decoration: line-through;
}

iframe.v-hidden {
  width: 0px;
  height: 0px;
}

.readonly-text {
  color: #6d6d6d;
  text-shadow: 1px 1px 0px white;
}

.ui-progressbar-value { 
  background-image: url('resources/admin/images/pbar-ani.gif'); 
}

.ui-progressbar{
  height: 21px;
}

.ui-widget-overlay {
  background-color: rgba(0,0,0,0.4);
  opacity: 1;
}

.v-wait-glass-spinner {
  color: white;
  text-align: center;
  font-size: 52px;
}

.tab-toolbar .ui-state-default,
.form-toolbar .ui-state-default {
  background: #dadada url('resources/admin/css/smoothness/images/ui-bg_glass_75_dadada_1x400.png') 50% 50% repeat-x;
}


/*** SPLIT BUTTON ***/

.split-button {
  width: 25px;
}

.split-button .ui-button-text {
  background-image: url('resources/admin/images/drop-down.gif');
  background-repeat: no-repeat;
  background-position: center center;
}

ul.popup-menu {
  background: var(--content-bg-color);
  list-style: none;
  position: absolute;
  min-width: 170px;
  margin: 23px 0px 0px 0px;
  padding: 3px 0px 3px 0px;
  border: 1px #dfdfdf solid;
  box-shadow: 2px 2px 4px -1px rgba(128, 128, 128, 0.5);
  z-index: 2000;
}

ul.popup-menu li a {
  display: block;
  line-height: 28px;
  padding-left: 10px;
  padding-right: 10px;
  color: inherit;
}

ul.popup-menu li a:hover {
  background-color: #eaf2fa;
  color: #333333;
}

ul.popup-menu li span.ab-icon {
  margin: 6px 6px 0px 0px;
}

ul.popup-menu li.divider {
  background-color: #cecece;
  height: 1px;
  margin: 4px;
}

ul.popup-menu li .fa {
  width: 18px;
  font-size: 18px;
  margin-right: 5px;
  line-height: inherit;
  text-align: center;
}


/*** PROFILE PICTURE ***/

.profile-pic-div {
  position: absolute;
  width: var(--profile-sidebar-width);
}

.profile-cont-div {
  margin-left: calc(var(--profile-sidebar-width) + 12px);
}

.profile-pic-container {
  background: var(--content-bg-color);
  border: 1px var(--border-color) solid;
  border-radius: 6px;
  height: 300px;
  padding: 4px;
  margin-bottom: 10px;
  cursor: pointer;
}

.profile-pic-inner {
  height: 100%;
  position: relative;
  background-repeat: no-repeat;
  background-size: 100%;
}

.profile-pic-container .choose-pic {
  position: absolute;
  bottom: 0;
  display: none;
  line-height: 22px;
  background: rgba(0, 0, 0, .5);
  color: white;
  width: 100%;
  text-align: center;
  text-shadow: 0px 0px 5px black;
}

.profile-pic-container:hover .choose-pic {
  display: block;
}

.profile-pic-container .profile-pic-hint {
  margin-top: 110px;
  text-align: center;
  font-size: 40px;
  color: #cecece;
  line-height: normal;
  float: left;
  width: 100%;
}

.profile-pic-inner.drag-over {
  border: 3px #156ee6 solid;
}


/*** REPOSITORY PICKUP ***/

.thumb-container {
  float: left;
  width: 150px;
  height: 150px;
  padding: 4px;
  margin: 4px;
  background: var(--content-bg-color);
  border: 1px #dfdfdf solid;
  cursor: pointer;
}

.thumb-container:hover {
  border-color: #3b5998;
}

.thumb-content {
  height: 100%;
  background-repeat: no-repeat;
  background-size: 100%;
  position: relative;
}

.thumb-name {
  background: -webkit-linear-gradient(top, transparent, rgba(0, 0, 0, .7));
  width: 100%;
  font-size: 11px;
  color: white;
  position: absolute;
  bottom: 0;
  padding: 4px;
}

input[type='text'].hasDatepicker {
  background-image: url('<%=ImageCacheLinkTag.getLink("calendar_sym.png", 16)%>');
  background-repeat: no-repeat;
  background-position: right -5px center;
  background-origin: content-box;
}

select.timepicker {
  display: inline-block;
  width: 70px;
  margin-right: 5px;
}


/*** ENTITLEMENT ***/

ul#ent-tree {
  margin: 0px;
  padding: 0px;
}

ul#ent-tree ul {
  padding-left: 16px;
}

ul#ent-tree li {
  list-style-type: none;
  line-height: 22px;
}

ul#ent-tree span.title {
  background-repeat: no-repeat;
  background-position: 2px center;
  padding: 2px 4px 2px 22px;
  border: 1px transparent solid;
  border-radius: 3px;
  cursor: default;
}

ul#ent-tree span.title:hover {
  border-color: #d9d9d9;
}

ul#ent-tree li.selected>span.title,
ul#ent-tree li.selected>span.title:hover {
  background-color: #e6f0fa;
  border-color: #a0afc3;
}

.filter-divider {
  height: 6px;
}

.filter-label {
  margin-top: 6px;
}
.filter-label:first-child {
  margin-top: 0;
}

/****/

.cke_focus {
  outline: none !important;
}

<%@ include file="topbar.css" %>
<%@ include file="tree.css" %>
<%@ include file="calendar.css" %>
<%@ include file="combo.css" %>
<%@ include file="dyncombo.css" %>
<%@ include file="lkdialog.css" %>
<%@ include file="listview.css" %>
<%@ include file="itl-edit.css" %>
<%@ include file="bootstrap-enhance.css" %>
<%@ include file="fontawe-enhance.css" %>
<%@ include file="switch.css" %>
<%@ include file="colorpicker.css" %>
<%@ include file="repository_file_drop.css" %>
<%@ include file="tabs.css" %>
<%@ include file="button.css" %>
<%@ include file="pagebox.css" %>
<%@ include file="side-filter.css" %>
<%@ include file="nav-wizard.css" %>
<%@ include file="icon-alias.css" %>
<%@ include file="/libraries/selectize/selectize.default.css" %>
<%@ include file="crud_control.css" %>
<%@ include file="task-progress-bar.css" %>
<%@ include file="icon-pane.css" %>
<%@ include file="input-upload-drop.css" %>
<%@ include file="richdesc.css" %>
<%@ include file="section.css" %>
<%@ include file="cfgform.css" %>
<%@ include file="cal-month.css" %>
<%@ include file="upload-tile.css" %>
<%@ include file="time-picker.css" %>
<%@ include file="filter-field.css" %>


.selectize-dropdown {
  z-index: 999999;
}
.selectize-input {
  border-color: #ccc;
  border-radius: 4px;
}

.tooltipster-text-overflow {
  border-radius: 0; 
  border: 1px solid rgba(0,0,0,0.2);
  background: var(--content-bg-color);
  color: black;
}
.tooltipster-text-overflow .tooltipster-content {
  font-size: 13px;
  line-height: 18px;
  padding: 10px;
}

.entity-tooltip-baloon {
  min-width: 370px; 
  max-height: 370px;
  overflow: hidden;
}

.entity-tooltip-baloon .profile-pic-icon,
.entity-tooltip-baloon .profile-pic-img {
  float: left;
  width: 100px;
  height: 100px;
  background-repeat: no-repeat;
  background-position: center center;
  border: 1px #efefef solid;
}

.entity-tooltip-baloon .profile-pic-img {
  background-size: cover;
}

.entity-tooltip-baloon .content {
  margin-left: 110px;
  line-height: 16px;
  color: #666666;
}

.entity-tooltip-baloon .entity-name {
  font-size: 14px;
  font-weight: bold;
}

.entity-tooltip-baloon .entity-type {
  font-weight: bold;
  margin-bottom: 10px;
}

.tooltip-title {
  font-size: 20px;
  border-bottom: 1px rgba(0,0,0,0.2) solid;
  padding: 5px;
  margin-bottom: 10px;
}

.tooltip-section {
  margin-bottom: 20px;
}

.lk-tooltip-link,
.metafield-tooltip-link {
  font-weight: bold;
  border-bottom: 2px dotted black;
  cursor: help;
}


/*** JQUERY WIZARD ***/



/*** FORM FIELD ***/
.form-field {
  padding: 4px;
  min-height: 42px;
  line-height: 34px;
}

.form-field-caption {
  float: left;
  width: 150px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.form-field-caption.include-hint {
  width: 130px;
}

.form-field-multicol .form-field-caption,
.form-field-multicol .form-field-hint {
  margin-top: 18px;
}

.form-field-value {
  margin-left: 155px;
}

.form-field-multicol .form-field-value {
  margin: -5px -5px -5px 150px;
} 

.form-field-hint {
  display: inline;
  margin-left: 5px;
  font-size: 16px;
  color: rgba(0,0,0,0.2);
  cursor: help;
  font-family: var(--fa-style-family,"Font Awesome 6 Pro");
  font-weight: var(--fa-style,900);
}

.form-field-hint::before {
  content: "\f059"; /*fa-question-circle*/
}

.form-field-hint:hover {
  color: var(--base-clue-color);
}

.form-field > .form-field-hint {
  float: left;
}

.form-field-caption .checkbox-label input[type='checkbox'] {
  margin-left: 0;
  margin-right: 1px;
}

.form-field-caption.mandatory-field {
  text-decoration: underline;
}

.form-field select.timepicker {
  display: inline-block;
  width: 70px;
  margin-right: 5px;
}

.form-field input.hasDatepicker {
  width: 120px;
}

.form-field-optionset {
  line-height: normal;
}

.btn-notes .btn-notes-count {
  display: none;
}

.has-notes-highlighted .fa.fa-comments {
  color: var(--base-red-color);
}

.btn-notes.btn-notes-empty {
  display: none;
}

.import-hint-box,
.info-hint-box {
  color: var(--info-text-color);
  background-color: var(--info-bg-color);
  border: 1px var(--info-border-color) solid;
  border-radius: 4px;
  padding: 10px;
  margin-bottom: 10px;
}

.meta-field-value.missing-required,
.default-multilanguage-text.missing-required {
  border-color: var(--base-red-color);
}

.infoicon-stats {
  width: 16px;
  height: 16px;
  background-image: url('imagecache?name=infoicon-stats.png&size=16');
  display: inline-block;
  vertical-align: sub;
}

.tz-datetime {
  white-space: nowrap;
}

.listcontainer .tz-datetime {
  font-size: 0.9em;
}

.tz-datetime .fa {
  opacity: 0.8;
}

.snp-inline-legend {
  display: inline-block;
  width: 9px;
  height: 9px;
}

.table-import-help {
  width: 100%;
  color: var(--text-color);
  background-color: var(--base-gray-color);
  border-spacing: 1px;
}
.table-import-help td {
  background-color: white;
  padding: 1px 5px;
  vertical-align: top;
}
.table-import-help thead td {
  font-weight: bold;
  background: #dfdfdf;
}
.table-import-help td.table-import-help-fieldname {
  font-weight: bold;
  white-space: nowrap;
}
.table-import-help td.table-import-help-types {
  white-space: nowrap;
  text-align: center;
}
.table-import-help td.table-import-help-mandatory {
  text-align: center;
}

/*** TABLEDEF GRID ***/
.grid-content {
  border: 1px var(--border-color) solid;
  color: rgba(0,0,0,0.8);
  background-color: white;
  border-radius: 4px;
}

.grid-content .grid-row {
  display: flex;
  border-bottom: 1px var(--border-color) solid;
  color: rgba(0,0,0,0.8);
  height: 48px;
}

.grid-content .grid-row.header{
  height: 45px;
}

.grid-content .grid-row.content {
  cursor: pointer;
}

.grid-content .grid-row.header {
  font-size: 13px;
  font-weight: bold;
  color: #333333;
  text-shadow: 0pt 1px 0pt #ffffff;
}

.grid-content .grid-row.content:nth-child(even) {
  background-color: #fbfcfd;
}

.grid-content .grid-row.content:hover {
  background-color: #ebf3fa;
}

.grid-cell-container {
  flex: 1;
  position: relative;
}

.grid-cell {
  display: flex;
  position: absolute;
  padding: 0px 6px 0px 6px;
}

.grid-cell-container.header {
  background-color: white;
}

.icon-cell {
  flex-grow: 0;
  align-self: center;
  padding: 4px 6px 4px 6px;
}

.grid-row.group {
  background-color: var(--header-bg-color);
  font-weight: bold;
  height: 27px;
}

.grid-row.group .grid-cell {
  height: 100.0%;
  align-items: center;
  margin-left: 4px;
}

.grid-row.header .icon-cell {
  width: 48px;
}

.grid-row[data-status='archived'] td {
  background-color: var(--base-blue-color);
  color: white;
}

.grid-row[data-status='archived'] td a:not(.btn) {
  color: white;
}

.grid-row[data-status='archived'] td a:not(.btn):hover {
  color: var(--highlight-color);
}

.grid-row[data-status='archived'] .list-subtitle {
  color: rgba(255,255,255,0.6);
}

.common-status-cell {
  padding: 4px 6px 4px 6px;
  display: flex;
  justify-content: space-around;
  flex-direction: column;
}

.cell-content {
  text-overflow: ellipsis;
  overflow: hidden;
  white-space: nowrap;
}

input[type='checkbox'].cblist {
  margin : 0px;
}

.search-code-container {
  display: flex; 
  justify-content: space-between; 
  align-items:center;
}

.multi-col-container {
  display: flex;
  justify-content: space-between;
  margin: -5px;
}

.multi-col-item {
  flex: 1 1 0px;
  margin: 5px;
}

.multi-col-item-title {
  line-height: normal;
}

.v-height-to-bottom {
  position: relative;
}

.stat-section {
  padding-top: 10px;
  padding-bottom: 10px;
}

.stat-section-title {
  font-size: 1.5em;
  font-weight: bold;
  text-align: center;
  padding-bottom: 10px;
  margin-top: 10px;
  margin-bottom: 10px;
  line-height: normal;
  border-bottom: 1px solid var(--base-gray-color);
  color: rgba(0, 0, 0, 0.8);
}

.stats-table {
  width: 100%;
}
.stats-table td {
  padding: 5px;
}


input.is-valid,
input.is-invalid {
  padding-right: calc(1.5em + .75rem);
  background-repeat: no-repeat;
  background-position: right .4em center;
  background-size: 1.6em;
}

input.is-valid {
  background-image: url(<v:image-link name="[font-awesome]circle-check|ColorizeGreen" size="32"/>);
}

input.is-invalid {
  background-image: url(<v:image-link name="[font-awesome]circle-exclamation|ColorizeRed" size="32"/>);
}

.thin-scrollbar::-webkit-scrollbar, 
.profile-fixed-view .profile-pic-div::-webkit-scrollbar             {width:6px}

.thin-scrollbar::-webkit-scrollbar-track, 
.profile-fixed-view .profile-pic-div::-webkit-scrollbar-track       {visibility:hidden}

.thin-scrollbar::-webkit-scrollbar-thumb, 
.profile-fixed-view .profile-pic-div::-webkit-scrollbar-thumb       {background:rgba(0,0,0,0.3); border-radius:10px}

.thin-scrollbar::-webkit-scrollbar-thumb:hover, 
.profile-fixed-view .profile-pic-div::-webkit-scrollbar-thumb:hover {background:black}

.thin-scrollbar:hover, 
.profile-fixed-view .profile-pic-div:hover                          {overflow-y:auto !important}

.profile-fixed-view {
  position: fixed;
  top: var(--adminbody-tabcontent-top);
  left: var(--adminnavbar-width);
  bottom: 0;
  right: 0; 
  display: flex;
  justify-content: space-between;
  flex-direction: column; 
}

.profile-fixed-view .tab-toolbar {
  flex-grow: 0;
  flex-shrink: 0;
}

.profile-fixed-view .tab-content {
  flex-grow: 1;
  flex-shrink: 1;
  overflow: auto; 
  display: flex;
  justify-content: space-between;
  overflow: hidden; 
}

.profile-fixed-view .profile-pic-div {
  position: relative;
  flex-grow: 0;
  flex-shrink: 0;
  overflow: hidden;
}

.profile-fixed-view .profile-cont-div {
  flex-grow: 1;
  flex-shrink: 1;
  margin-left: 10px;
  overflow: auto;
}



<% // This IF-BLOCK is supposed to always fail. Just a workaround to have this page highlighted as javascript. %>
<% if (request.getAttribute("BB63A701FB6F4C04B70C44E3CB161795") != null) { %>
</style>
<% } %>
