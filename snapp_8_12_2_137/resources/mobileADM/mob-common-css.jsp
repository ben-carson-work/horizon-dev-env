<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<jsp:useBean id="pageBase" class="com.vgs.web.page.PageMobileAdmission" scope="request"/>

<style>

<%@ include file="/resources/common/css/common.css" %>


body {
  font-size: 4.5vw;
  font-family: 'Open Sans', sans-serif;
  background-color: var(--body-bg-color);
}

:focus {
  outline:none;
}

.form-control {
  font-size: inherit;
  line-height: inherit;
  height: inherit;
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
  cursor: wait;
}

.mobile-dialog {
  position: fixed;
  top: 12vw;
  left: 12vw;
  right: 12vw;
  border-radius: 3vw;
  background-color: white;
  box-shadow: 0 0 10vw rgba(0,0,0,0.15);
  overflow: hidden;
  cursor: default;
}

#wait-glass .mobile-dialog {
  left: 20vw;
  right: 20vw;
  height: 20vh;
  top: 40vh;
  background-image: url("<v:config key="resources_url" />/admin/images/spinner32.gif");
  background-repeat: no-repeat;
  background-position: center center;
}

.mobile-dialog-title {
  text-align: center;
  font-weight: bold;
  font-size: 1.2em;
  line-height: 10vw;
}

.mobile-dialog-body {
  padding: 3vw;
  padding-bottom: 6vw;
  text-align: center;
  overflow: hidden;
}

.mobile-dialog-button {
  text-align: center;
  font-weight: bold;
  border: 1px solid rgba(0,0,0,0.1); 
  border-width: 1px 0 0 1px;
  line-height: 12vw;
  padding: 1vw;
  color: var(--base-blue-color);
  cursor: pointer;
}

.mobile-dialog-button:first-child {
	border-left-width: 0;
}

.tab-content-container {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 20vw;
  visibility: hidden;
}

.tab-content-container.active-tab {
  visibility: visible;
}

.tab-content {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
}

.tab-button-list {
  height: 20vw;
  position: fixed;
  bottom: 0;
  left: 0;
  right: 0;
  background-color: var(--menu-bg-color);
  display: flex;
  justify-content: space-between;
}

.tab-header {
  background-color: var(--pagetitle-bg-color);
  height: 20vw;
  border-bottom: 1px solid rgba(0,0,0,0.1);
  overflow: hidden;
  display: flex;
  justify-content: space-between;
}

.tab-body {
  position: absolute;
  top: 20vw;
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
  font-size: 7vw;
  padding: 3vw;
  line-height: 14vw;
  text-align: center;
  flex-shrink: 1;
  flex-grow: 1;
}

.tab-button {
  flex-grow: 1;
  flex-shrink: 1;
  height: 100%;
  position: relative;
  opacity: 0.5;
  cursor: pointer;
  border-top: 1.5vw solid rgba(0,0,0,0);
}

.tab-button.active-tab {
  opacity: 1;
  border-top: 1.5vw solid var(--highlight-color);
}

.tab-button-icon {
  position: absolute;
  top: 3vw;
  bottom: 6vw;
  left: 4.5vw;
  right: 4.5vw;
  background-size: contain;
  background-position: center;
  background-repeat: no-repeat;
  color: white;
  font-size: 8vw;
  text-align: center;
}

.tab-button-caption {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  color: white;
  font-size: 3vw;
  text-align: center;
}

.toolbar-button {
  float: none;
  opacity: 1;
}

.btn-toolbar-back {
  background-image: url(<v:image-link name="bkoact-back.png" size="128"/>);
}

.pref-section {
  margin-bottom: 10vw;
}

.pref-section-spacer {
  height: 10vw;
}

.pref-section-title {
  padding-left: 3vw;
  line-height: 8vw;
  font-size: 0.8em;
  font-weight: bold;
  text-transform: uppercase;
  color: rgba(0,0,0,0.4);
}

.pref-item-list {
  background-color: white;
  border: 1px solid rgba(0,0,0,0.15);
  border-width: 1px 0 1px 0;
  padding-left: 3vw;
}

.pref-item  {
  border-bottom: 1px solid rgba(0,0,0,0.15);
  line-height: 13vw;
  overflow: hidden;
}

.pref-item:not(.hidden):last-child {
  border: none;
}

.pref-item-caption {
  float: left;
  width: 38vw;
}

.pref-item.pref-item-check .pref-item-caption {
  width: 84vw;
}

.pref-item.pref-item-check.selected {
  background-image: url(<v:image-link name="bkoact-check.png" size="128"/>);
  background-repeat: no-repeat;
  background-position: right 3vw center;
  background-size: 6vw;
}

.pref-item-value {
  margin-left: 38vw;
  text-align: right;
  color: rgba(0,0,0,0.5);
  padding-right: 3vw;
}

.pref-item.active-radio .pref-item-value {
  height: 13vw;
  background-image: url(<v:image-link name="bkoact-check.png" size="128"/>);
  background-size: 6vw;
  background-repeat: no-repeat;
  background-position: center right 3vw;
}  

.pref-item-arrow .pref-item-value {
  padding-right: 8vw;
  background-image: url(<v:image-link name="bkoact-forward-grey.png" size="128"/>);
  background-size: 6vw;
  background-repeat: no-repeat;
  background-position: center right 1vw;
  min-height: 13vw;
}

.pref-item-value .badge {
  padding: 1.25vw 2.4vw;
  border-radius: 4vw;
  font-size: inherit;
  background-color: var(--menu-bg-color);
}

.badge-red {
  background-color: var(--base-red-color) !important;
}

.status-border {border-left: 1vw solid var(--base-gray-color)}
.status-border-draft {border-left-color: var(--base-gray-color)}
.status-border-active {border-left-color: var(--base-green-color)}
.status-border-warn {border-left-color: var(--base-orange-color)}
.status-border-deleted {border-left-color: var(--base-red-color)}
.status-border-completed {border-left-color: var(--base-blue-color)}
.status-border-fatal {border-left-color: var(--base-purple-color)}

.profile-picture {
  background-position: center center;
  background-size: cover;
  background-repeat: no-repeat;
}

.glyicon {
  background-position: center center;
  background-size: 70%;
  background-repeat: no-repeat;
}

[data-glyicon='event']       {background-image:url(<v:image-link name="bkoact-event.png" size="128"/>)}
[data-glyicon='location']    {background-image:url(<v:image-link name="bkoact-location-black.png" size="128"/>)}
[data-glyicon='payment']     {background-image:url(<v:image-link name="bkoact-pay.png" size="128"/>)}
[data-glyicon='performance'] {background-image:url(<v:image-link name="bkoact-calendar.png" size="128"/>)}
[data-glyicon='print']       {background-image:url(<v:image-link name="bkoact-print.png" size="128"/>)}
[data-glyicon='product']     {background-image:url(<v:image-link name="bkoact-product.png" size="128"/>)}
[data-glyicon='status']      {background-image:url(<v:image-link name="bkoact-flag.png" size="128"/>)}

</style>