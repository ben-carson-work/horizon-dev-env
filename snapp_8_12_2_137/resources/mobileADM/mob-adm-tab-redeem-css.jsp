<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<jsp:useBean id="pageBase" class="com.vgs.web.page.PageMobileAdmission" scope="request"/>

<style>

#redeem-main-tab-content #valres-list {
  padding: 3vw;
}

#redeem-main-tab-content .gate-block {
  background-color: var(--pagetitle-bg-color);
  border-bottom: 1px solid rgba(0,0,0,0.1);
  font-size: 0.8em;
  font-weight: bold;
  text-align: center;
}


#tab-header-redeem-result .tab-header-title {
  color: white;
}

#tab-header-redeem-result.good-result {
  background-color: var(--base-green-color);
} 

#tab-header-redeem-result.warn-result {
  background-color: var(--base-orange-color);
} 

#tab-header-redeem-result.bad-result {
  background-color: var(--base-red-color);
} 

#tab-header-redeem-wait {
  background-image: url(<v:config key="resources_url"/>/mobileADM/snapp-mobile-redeem-spinner.gif);
  background-repeat: no-repeat;
  background-position: center;
  background-size: 18vw;
}

#tab-header-redeem-idle .btn-usagetype {
  opacity: 0.5;
}

#tab-header-redeem-idle .btn-usagetype[data-scantype='entry'] {
  background-image: url(<v:image-link name="adm_entry_green.png" size="128"/>);
}

#tab-header-redeem-idle .btn-usagetype[data-scantype='simulate'] {
  background-image: url(<v:image-link name="adm_entry_gray.png" size="128"/>);
  opacity: 0.7;
}

#tab-header-redeem-idle .btn-usagetype[data-scantype='exit'] {
  background-image: url(<v:image-link name="adm_exit_blue.png" size="128"/>);
}

#tab-header-redeem-idle .btn-usagetype[data-scantype='lookup'] {
  background-image: url(<v:image-link name="adm_lookup_gray.png" size="128"/>);
  opacity: 0.7;
}

#tab-header-redeem-idle .btn-face {
  float: right;
  background-image: url(<v:image-link name="[font-awesome]face-viewfinder" size="128"/>);
}

#tab-header-redeem-idle .btn-camera {
  float: right;
  background-image: url(<v:image-link name="[font-awesome]camera" size="128"/>);
}

#tab-header-redeem-idle .btn-keyboard {
  float: right;
  background-image: url(<v:image-link name="[font-awesome]keyboard" size="128"/>);
}

#tab-header-redeem-manual .btn-keyboard {
  float: right;
  background-image: url(<v:image-link name="[font-awesome]keyboard|TransformNegative" size="128"/>);
  background-color: var(--highlight-color);
}

#tab-header-redeem-manual .btn-media {
  display: none;
  float: right;
  background-image: url(<v:image-link name="[font-awesome]credit-card" size="128"/>);
}
#tab-header-redeem-manual[data-inputtype='<%=LkSNRedemptionInputType.MediaCode.getCode()%>'] .btn-media {
  display: block;
}

#tab-header-redeem-manual .btn-document {
  display: none;
  float: right;
  background-image: url(<v:image-link name="[font-awesome]passport" size="128"/>);
}
#tab-header-redeem-manual[data-inputtype='<%=LkSNRedemptionInputType.DocumentNumber.getCode()%>'] .btn-document {
  display: block;
}

#tab-header-redeem-manual input {
  width: 80vw;
  border: none;
  padding: 3vw;
  margin: 0;
  font-size: 6vw;
  line-height: 14vw;
}

.valres-item {
  background-color: white;
  border-radius: 0.75vw;
  overflow: hidden;
  border: 0 solid gray;
  border-width: 0 1.5vw 1.5vw 1.5vw;
  margin-bottom: 3vw;
  opacity: 0.5;
  font-size: 4.5vw;
}
.valres-item.latest {
  opacity: 1;
}

.valres-header {
  position: relative;
  color: white;
  font-weight: bold;
  background: gray;
  display: flex;
  justify-content: space-between;
}

.valres-header-messages {
  flex-grow: 1;
  overflow: hidden;
}

.valres-header-title,
.valres-header-info
{
  display: flex;
  justify-content: space-between;
  gap: 1.5vw;
}

.valres-datetime {
  white-space: nowrap;
}

.valres-mediacode {
  white-space: nowrap;
  text-overflow: ellipsis;
  overflow: hidden;
}

.valres-header-info {
  font-size: 0.7em;
  opacity: 0.9;
}

.valres-item[data-status='good'] {
  border-color: var(--base-green-color);
}
.valres-item[data-status='good'] .valres-header {
  background-color: var(--base-green-color);
}

.valres-item[data-status='warn'] {
  border-color: var(--base-orange-color);
}
.valres-item[data-status='warn'] .valres-header {
  background-color: var(--base-orange-color);
}

.valres-item[data-status='bad'] {
  border-color: var(--base-red-color);
}
.valres-item[data-status='bad'] .valres-header {
  background-color: var(--base-red-color);
}

.valres-item[data-status='moreinfo'] {
  border-color: var(--base-blue-color);
}
.valres-item[data-status='moreinfo'] .valres-header {
  background-color: var(--base-blue-color);
}

.valres-body {
  overflow: hidden;
}

.valres-pic {
  width: 37.5vw;
  height: 37.5vw;
  line-height: 37.5vw;
  float: left;
  background-color: var(--body-bg-color);
  background-size: cover;
  background-position: center;
  font-size: 1.5em;
  text-align: center;
}

.valres-item:not(.has-profile-picture) .valres-pic {
  height: 20vw; 
  line-height: 20vw;
}

.valres-detail {
  margin-left: 37.5vw;
  padding: 1vw;
}

.valres-detail-item {
  padding: 1vw;
  text-align: center;
}

.valres-detail-item-account {
  font-weight: bold;
}

.valres-detail-item-message {
  font-size: 1.25em;
  font-weight: bold;
  color: var(--base-orange-color);
}

.valres-header-button {
  margin-right: 1px;
  margin-left: 1.5vw;
  font-size: 8vw;
  cursor: pointer;
}

.valres-item:not(.override-allowed) .btn-override {
  display: none;
}

.valres-item:not(.need-more-info) .btn-question {
  display: none;
}

</style>