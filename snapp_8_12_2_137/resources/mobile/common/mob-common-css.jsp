<%@page import="com.vgs.snapp.web.mob.page.PageMOB_Base"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<% PageMOB_Base<?> pageBase = (PageMOB_Base<?>)request.getAttribute("pageBase"); %>

<style>

<%@ include file="/resources/common/css/common.css" %>

html {
  font-size: 1vw;
}

body {
  font-size: 4.5rem;
  font-family: 'Open Sans', sans-serif;
  background-color: var(--body-bg-color);
}

:focus {
  outline:none;
}

.mobile-ellipsis,
.pref-item-caption,
.pref-item-value,
.mobile-dialog-title,
.mobile-dialog-button,
.tab-header-title {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.mobile-dialog-layover {
  position: fixed;
  top: 0;
  bottom: 0;
  left: 0;
  right: 0;
  z-index: 999999;
  background-color: rgba(0,0,0,0.3);
}

.mobile-dialog {
  position: fixed;
  top: 12vw;
  left: 12vw;
  right: 12vw;
  border-radius: 3rem;
  background-color: white;
  box-shadow: 0 0 10vw rgba(0,0,0,0.15);
  overflow: hidden;
  cursor: default;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  max-height: 90vh;
}

#wait-glass {
  text-align: center;
  padding-top: 45vh;
}

#wait-glass .fa {
  font-size: 10vh;
  color: white;
  opacity: 1;
}

.main-spinner {
  font-size: 3em;
  padding: 5rem;
  text-align: center;
  color: var(--tab-border-color);
}

.mobile-dialog-title {
  text-align: center;
  font-weight: bold;
  font-size: 1.2em;
  line-height: 7rem;
  padding: 3rem;
  flex-shrink: 0;
}

.mobile-dialog-body {
  padding: 3rem;
  padding-bottom: 6rem;
  text-align: center;
  overflow: hidden;
}

.mobile-dialog-button {
  text-align: center;
  font-weight: bold;
  border: 1px solid rgba(0,0,0,0.1); 
  border-width: 1px 0 0 1px;
  line-height: 12rem;
  padding: 1rem;
  color: var(--base-blue-color);
  cursor: pointer;
  flex-shrink: 0;
}

.mobile-dialog-button:first-child {
	border-left-width: 0;
}

.mobile-dialog .dlg-spinner-mode {
  display: none;
}

.mobile-dialog .dlg-error-mode {
  display: none;
}

.mobile-dialog.spinner-mode .dlg-spinner-mode,
.mobile-dialog.error-mode .dlg-error-mode {
  display: block;
}

.mobile-dialog.spinner-mode .dlg-idle-mode {
  display: none;
}

.mobile-dialog.dlg-mediapickup input {
  width: 100%;
  border: none;
  border-bottom: 1px solid var(--border-color);
}

.mobile-dialog.dlg-mediapickup .dlg-spinner-mode .spinner-icon {
  font-size: 2em;
  text-align: center;
  padding: 5rem;
  padding-bottom: 10rem;
}

.mobile-dialog.dlg-mediapickup .error-box {
  font-weight: bold;
  text-align: center;
  color: var(--base-red-color);
}




.mobile-dialog.dlg-datetime .mobile-dialog-body {
  display: flex;
  justify-content: space-between;
  text-align: center;
}

.mobile-dialog.dlg-datetime .dtpick-list {
  padding: 50rem 0; 
  height: 50rem;
  overflow: auto;
  line-height: 7rem;
}






.mobile-popup {
  position: fixed;
  padding: 2rem;
}

.mobile-popup-inner {
  border-radius: 2rem;
  overflow: hidden;
  min-width: 60rem;
  background-color: white;
}

.mobile-popup-item {
  position: relative;
  padding: 1rem;
  padding-right: 3rem;
  height: 13rem;
  background-color: white;
  border-bottom: 1px solid var(--border-color);
  cursor: pointer;
}

.mobile-popup-item:not(.disabled):hover {
  background-color: var(--highlight-color);
}

.mobile-popup-item.disabled .mobile-popup-item-inner {
  opacity: 0.4;
  cursor: default;
}

.mobile-popup-item:last-child {
  border: none;
}

.mobile-popup-item-icon {
  position: absolute;
  top: 0;
  left: 0;
  width: 13rem;
  height: 13rem;
  line-height: 13rem;
  font-size: 7rem;
  text-align: center;  
}

.mobile-popup-item-caption,
.mobile-popup-item-hint {
  margin-left: 11rem;
  max-width: 80rem;
}

.mobile-popup-item-caption {
  line-height: 6rem;
  color: black;
}

.mobile-popup-item-hint {
  line-height: 5rem;
  color: rgba(0,0,0,0.6);
  font-size: 0.85em;
}


.tab-content {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 20rem;
  background-color: var(--body-bg-color);
  display: none;
}

.tab-content.active-tab {
  display: block;
}

.hidden-nav-content {
  display: none;
}

.tab-button-list {
  height: 20rem;
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  background-color: var(--menu-bg-color);
}

.tab-header {
  background-color: var(--pagetitle-bg-color);
  height: 20rem;
  border-bottom: 1px solid rgba(0,0,0,0.1);
  overflow: hidden;
}

.tab-body {
  position: absolute;
  top: 20rem;
  bottom: 0;
  left: 0;
  right: 0;
  overflow-x: hidden;
  overflow-y: auto;
}

.tab-body.waiting {
  background-image: url(<v:config key="resources_url"/>/admin/images/new-spinner32.gif);
  background-repeat: no-repeat;
  background-position: center 5vw;
  padding-top: 20vw;
}

.tab-header-title {
  font-size: 7rem;
  padding: 3rem;
  line-height: 14rem;
  text-align: center;
}

.tab-header-title-top {
  line-height: 9rem;
}

.tab-header-title-bottom {
  font-size: 5rem;
  line-height: 5rem;
}

.tab-button {
  width: 20rem;
  height: 20rem;
  float: left;
  position: relative;
  opacity: 0.5;
  cursor: pointer;
  border-top: 1.5rem solid rgba(0,0,0,0); 
}

.tab-button.active-tab {
  opacity: 1;
  border-top-color: var(--highlight-color);
}

.tab-button-icon {
  position: absolute;
  top: 3rem;
  bottom: 6rem;
  left: 4.5rem;
  right: 4.5rem;
  text-align: center;
  font-size: 7rem;
  color: white;
  background-size: contain;
  background-position: center;
  background-repeat: no-repeat;
}

.tab-button-caption {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  color: white;
  font-size: 3rem;
  text-align: center;
}

.toolbar-button {
  float: left;
  width: 20rem;
  height: 20rem;
  background-size: 12rem;
  background-position: center;
  background-repeat: no-repeat;
  font-size: 2em;
  line-height: 20rem;
  text-align: center; 
  cursor: pointer;
  color: rgba(0,0,0,0.8);
}

.toolbar-button.disabled {
  opacity: 0.4;
  cursor: default;
}

.btn-float-right {
  float: right;
}

.btn-toolbar-back {
  font-family: var(--fa-style-family,"Font Awesome 6 Pro");
  font-weight: var(--fa-style,900);
}

.btn-toolbar-back:before {
  content: "\f053"; /* chevron-left */
}

.pref-section {
  margin-bottom: 10rem;
}

.pref-section-spacer {
  height: 10rem;
}

.pref-section-title {
  padding-left: 3rem;
  line-height: 8rem;
  font-size: 0.8em;
  font-weight: bold;
  text-transform: uppercase;
  color: rgba(0,0,0,0.4);
}

.pref-item-list {
  background-color: white;
  border: 1px solid rgba(0,0,0,0.15);
  border-width: 1px 0 1px 0;
  padding-left: 3rem;
}

.pref-item  {
  border-bottom: 1px solid rgba(0,0,0,0.15);
  line-height: 13rem;
  overflow: hidden;
  display: flex;
  flex-wrap: nowrap;
  justify-content: space-between;
  padding-right: 3rem;
}

.pref-item:not(.hidden):last-child {
  border: none;
}

.pref-item-caption {
  flex-grow: 1;
  min-width: 10rem;
}

.pref-item.required-field .pref-item-caption::after {
  content: " (*)";
}

.pref-item.missing-required .pref-item-caption {
  color: var(--base-red-color);
}

.pref-item.pref-item-check .pref-item-caption {
  width: 84rem;
}

.pref-item.pref-item-check {
  cursor: pointer;
}

.pref-item.pref-item-check.selected {
  background-image: url(<v:image-link name="bkoact-check.png" size="128"/>);
  background-repeat: no-repeat;
  background-position: right 3rem center;
  background-size: 6rem;
}

.pref-item-value {
  flex-grow: 1;
  text-align: right;
  color: rgba(0,0,0,0.5);
  min-width: 10rem;
}

.pref-item-arrow {
  cursor: pointer;
}

.pref-item-arrowicon {
  display: none;
  text-align: right;
  flex: none;
  padding-left: 3rem;
  color: rgba(0,0,0,0.25);
  font-size: 1.3em;
}

.pref-item-arrow .pref-item-arrowicon {
  display: block;
}

.pref-item.active-radio .pref-item-value {
  height: 13rem;
  background-image: url(<v:image-link name="bkoact-check.png" size="128"/>);
  background-size: 6rem;
  background-repeat: no-repeat;
  background-position: center right 3rem;
}  

.pref-item-value .badge {
  padding: 1.25rem 2.4rem;
  border-radius: 4rem;
  font-size: inherit;
  background-color: var(--menu-bg-color);
}

.good-status {color: var(--base-green-color);}
.warn-status {color: var(--base-orange-color);}
.bad-status {color: var(--base-red-color);}

.pref-item-value .pref-value-text {
  border: none;
  text-align: right;
  background: white;
}

.pref-item-value .pref-value-text:focus {
  color: black;
}




.profile-picture {
  background-position: center center;
  background-size: cover;
  background-repeat: no-repeat;
}

.templates {
  display: none;
}

.list-item {
  position: relative;
  padding: 2rem;
  border-bottom: 1px solid var(--border-color);
  border-left: 2rem solid rgba(0,0,0,0);
  min-height: 20rem;
}

.list-item.draft {border-left-color:var(--base-gray-color)}
.list-item.active {border-left-color:var(--base-green-color)}
.list-item.warn {border-left-color:var(--base-orange-color)}
.list-item.deleted {border-left-color:var(--base-red-color)}
.list-item.completed {border-left-color:var(--base-blue-color)}
.list-item.fatal {border-left-color:var(--base-purlpe-color)}

.list-item .list-item-icon {
  position: absolute;
  top: 0;
  left: 0;
  width: 20rem;
  height: 20rem;
  background-repeat: no-repeat;
  background-position: center center;
  background-size: 16vw;
}

.list-item .list-item-icon.profilepic {
  background-size: cover;
}

.list-item .list-item-icon.icon-alias {
  font-size: 8rem;
  line-height: 20rem;
  text-align: center;
  color: rgba(0,0,0,0.6);
}

.list-item.show-icon .list-item-body {
  margin-left: 20rem;
}

.list-item .list-item-texticon {
  opacity: 0.4;
  width: 5rem;
  margin-right: 1rem;
  text-align: center;
  font-size: 0.9em;
}

.list-item .list-item-title {
  font-size: 1.2em;
  font-weight: bold;
}

.list-item .list-item-subtitle {
  color: rgba(0,0,0,0.5);
}










.mob-widget {
  background-color: white;
  margin: 3rem;
  border: 1px solid var(--border-color);
  border-radius: 1rem;
  overflow: hidden;
}

.mob-widget-header {
  line-height: 13rem;
  border-bottom: 1px solid var(--border-color);
  text-align: center;
  font-size: 1.2em;
  font-weight: bold;
}

.mob-widget-header:last-child {
  border: none;
}

.mob-widget-block {
  border-bottom: 1px solid var(--border-color);
}

.mob-widget-block:last-child {
  border: none;
}

.mob-widget-block>.pref-item {
  flex-grow: 1;
  margin-left: 3rem;
}








.mob-card {
  display: flex;
  justify-content: space-between;
}

.mob-card-icon {
  height: 34rem;
  width: 34rem;
  line-height: 34rem;
  background-size: cover;
  flex-shrink: 0;
  flex-grow: 0;
  text-align: center;
  font-size: 14rem;
  color: var(--menu-bg-color);
}

.mob-card-icon.mob-card-icon-small {
  height: 20rem;
  width: 20rem;
  line-height: 20rem;
  font-size: 10rem;
}

.mob-card-body {
  flex-grow: 1;
  overflow: hidden;
  padding: 2vw;
}

.mob-card-title {
  font-size: 1.2em;
  margin-bottom: 1rem;
  font-weight: bold;
}

.mob-card-data-icon {
  color: rgba(0,0,0,0.4);
  width: 6rem;
  text-align: center;
}








.breadcrumb-container {
  background-color: var(--menu-bg-color);
  color: white;
  padding: 0 2rem;
  line-height: 10rem;
}

.breadcrumb-item,
.breadcrumb-caption,
.breadcrumb-icon {
  display: inline-block;
}

.breadcrumb-item {
  cursor: pointer;
}

.breadcrumb-item:hover {
  color: var(--highlight-color);
}

.breadcrumb-icon {
  margin: 0 1rem;
}













/* Desktops */
@media (min-width: 1200px) {
}

/* Tablets (portrait) */
@media (min-width: 768px) and (max-width: 1024px) and (orientation: portrait) {
  html {
    font-size: 0.55vw;
  }
  
  .pref-section {
    margin-left: 5rem;
    margin-right: 5rem;
  }
  
  .pref-item-list {
    border: none;
    border-radius: 1rem;
  }
}

/* Tablets (landscape) */
@media (min-width: 768px) and (max-width: 1024px) and (orientation: landscape) {
}

/* Phones (Portrait) */
@media (min-width: 320px) and (max-width: 480px) {
}
</style>

<jsp:include page="mob-common-catalog-css.jsp"/>