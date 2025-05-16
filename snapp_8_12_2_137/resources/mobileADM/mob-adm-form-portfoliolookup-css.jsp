<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<jsp:useBean id="pageBase" class="com.vgs.web.page.PageMobileAdmission" scope="request"/>
<jsp:useBean id="wks" class="com.vgs.entity.dataobject.DOEnt_Workstation" scope="request"/>

<style>

#frm-portfoliolookup-template .tab-header-title,
#frm-portfoliolookup-media-template .tab-header-title,
#frm-portfoliolookup-ticket-template .tab-header-title,
#frm-portfoliolookup-usages-template .tab-header-title,
#frm-portfoliolookup-medias-template .tab-header-title,
#frm-portfoliolookup-tickets-template .tab-header-title {
  margin-right: 20vw;
}

#pref-portfoliolookup-template .account-section .pref-item-list {
  overflow: hidden;
  border-top: none;
  padding: 0;
}

#pref-portfoliolookup-template .account-pic {
  background-color: var(--body-bg-color);
  float: left;
  height: 50vw;
  width: 50vw;
  background-size: cover;
  line-height: 50vw;
  text-align: center;
  font-size: 30vw;
  color: rgba(0, 0, 0, 0.4);
}

#pref-portfoliolookup-template.has-profile-picture .nopic {
  display: none;
}

#pref-portfoliolookup-template .account-detail {
  margin-left: 50vw;
  padding: 1vw;
}

#pref-portfoliolookup-template .account-caption {
  font-weight: bold;
  text-transform: uppercase;
  color: rgba(0,0,0,0.5);
  font-size: 0.8em;
  padding-top: 2vw;
}

#pref-portfoliolookup-template .account-caption,
#pref-portfoliolookup-template .account-value {
  text-align: center;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

#pref-portfoliolookup-template .account-name {
  font-size: 1.2em;
  font-weight: bold;
}

.pref-item-value.good-status {
  color: var(--base-green-color);
}

.pref-item-value.warn-status {
  color: var(--base-orange-color);
}

.pref-item-value.bad-status .pref-item-value {
  color: var(--base-red-color);
}

#frm-portfoliolookup-ticket-template .product-section .pref-item-list {
  overflow: hidden;
  border-top: none;
  padding: 0;
}

#frm-portfoliolookup-ticket-template .product-pic {
  background-color: var(--body-bg-color);
  float: left;
  height: 20vw;
  width: 20vw;
  line-height: 20vw;
  font-size: 10vw;
  opacity: 0.4;
  text-align: center;
}

#frm-portfoliolookup-ticket-template .product-pic.glyicon {
  opacity: 0.5;
}

#frm-portfoliolookup-ticket-template .product-detail {
  margin-left: 21vw;
  padding: 1vw;
}

#frm-portfoliolookup-ticket-template .product-name {
  font-weight: bold;
}

#frm-portfoliolookup-ticket-template .product-code {
  font-size: 0.8em;
}

.portfoliolookup-rec-item {
  border-bottom: 1px solid rgba(0,0,0,0.1);
  padding: 2vw;
  background-color: white;
  background-repeat: no-repeat;
  background-position: 2vw 2vw;
  background-size: 16vw;
}

.portfoliolookup-rec-icon {
  display: inline-block;
  height: 4vw;
  width: 5vw;
  line-height: 4vw;
  font-size: 3.5vw;
  background-repeat: no-repeat;
  background-position: center center;
  background-size: 4vw;
  opacity: 0.4;
}

#rec-portfoliolookup-usage-template.portfoliolookup-rec-item {
  padding-left: 20vw;  
}

.portfoliolookup-rec-item[data-CommonStatus='<%=LkCommonStatus.Draft.getCode()%>'] {
  border-left: 2vw solid var(--base-gray-color);
}
.portfoliolookup-rec-item[data-CommonStatus='<%=LkCommonStatus.Active.getCode()%>'] {
  border-left: 2vw solid var(--base-green-color);
}
.portfoliolookup-rec-item[data-CommonStatus='<%=LkCommonStatus.Warn.getCode()%>'] {
  border-left: 2vw solid var(--base-orange-color);
}
.portfoliolookup-rec-item[data-CommonStatus='<%=LkCommonStatus.Deleted.getCode()%>'] {
  border-left: 2vw solid var(--base-red-color);
}
.portfoliolookup-rec-item[data-CommonStatus='<%=LkCommonStatus.Completed.getCode()%>'] {
  border-left: 2vw solid var(--base-blue-color);
}
.portfoliolookup-rec-item[data-CommonStatus='<%=LkCommonStatus.FatalError.getCode()%>'] {
  border-left: 2vw solid var(--base-purple-color);
}

.portfoliolookup-rec-item .rec-title {
  font-size: 1.2em;
  font-weight: bold;
}

.portfoliolookup-rec-item .rec-small {
  color: rgba(0,0,0,0.5);
}


#frm-portfoliolookup-notes-template .tab-body.highlighted-filter #rec-portfoliolookup-note-template:not(.highlighted-note) {
  display: none;
}

#rec-portfoliolookup-note-template {
  display: flex;
  justify-content: space-between;
}

#rec-portfoliolookup-note-template.highlighted-note {
  border-left-color: var(--base-red-color);
}

#rec-portfoliolookup-note-template.highlighted-note .note-text {
  color: var(--base-red-color);
}

#rec-portfoliolookup-note-template.has-profile-picture .nopic {
  display: none;
}

#rec-portfoliolookup-note-template .note-userpic {
  flex-shrink: 0;
  flex-grow: 0;
  width: 16vw;
  height: 16vw;
  background-position: center center;
  background-repeat: no-repeat;
  background-size: cover;
  font-size: 12vw;
  text-align: center;
  line-height: 16vw;
  color: rgba(0, 0, 0, 0.5);
}

#rec-portfoliolookup-note-template .note-body {
  flex-shrink: 1;
  flex-grow: 1;
  margin-left: 2vw;
}

#rec-portfoliolookup-note-template .note-datetime {
  color: rgba(0,0,0,0.5);
}

#rec-portfoliolookup-note-template .note-text {
  margin-top: 1vw;
  padding-top: 1vw;
  border-top: 1px solid rgba(0,0,0,0.1);
}

</style>