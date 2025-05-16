<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<jsp:useBean id="apt" class="com.vgs.snapp.dataobject.DOAccessPointRef" scope="request"/>
<% PageMobileSales pageBase = (PageMobileSales)request.getAttribute("pageBase"); %>

<style id="form-medialookup-css.jsp">


#frm-medialookup-template .tab-header-title,
#frm-medialookup-media-template .tab-header-title,
#frm-medialookup-ticket-template .tab-header-title,
#frm-medialookup-usages-template .tab-header-title,
#frm-medialookup-medias-template .tab-header-title,
#frm-medialookup-tickets-template .tab-header-title {
  margin-right: 20vw;
}

#pref-medialookup-template .account-section .pref-item-list {
  overflow: hidden;
  border-top: none;
  padding: 0;
}

#pref-medialookup-template .account-pic {
  background-color: var(--body-bg-color);
  float: left;
  height: 50vw;
  width: 50vw;
  background-size: cover;
}

#pref-medialookup-template .account-detail {
  margin-left: 50vw;
  padding: 1vw;
}

#pref-medialookup-template .account-caption {
  font-weight: bold;
  text-transform: uppercase;
  color: rgba(0,0,0,0.5);
  font-size: 0.8em;
  padding-top: 2vw;
}

#pref-medialookup-template .account-caption,
#pref-medialookup-template .account-value {
  text-align: center;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

#pref-medialookup-template .account-name {
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

#frm-medialookup-ticket-template .product-section .pref-item-list {
  overflow: hidden;
  border-top: none;
  padding: 0;
}

#frm-medialookup-ticket-template .product-pic {
  background-color: var(--body-bg-color);
  float: left;
  height: 20vw;
  width: 20vw;
}

#frm-medialookup-ticket-template .product-pic.glyicon {
  opacity: 0.5;
}

#frm-medialookup-ticket-template .product-detail {
  margin-left: 21vw;
  padding: 1vw;
}

#frm-medialookup-ticket-template .product-name {
  font-weight: bold;
}

#frm-medialookup-ticket-template .product-code {
  font-size: 0.8em;
}

.medialookup-rec-item {
  border-bottom: 1px solid rgba(0,0,0,0.1);
  padding: 2vw;
  background-color: white;
  background-repeat: no-repeat;
  background-position: 2vw 2vw;
  background-size: 16vw;
}

.medialookup-rec-icon {
  display: inline-block;
  height: 4vw;
  width: 4vw;
  vertical-align: middle;
  background-repeat: no-repeat;
  background-position: center center;
  background-size: 4vw;
  opacity: 0.4;
  margin-right: 1vw;
}

#rec-medialookup-usage-template.medialookup-rec-item {
  padding-left: 20vw;  
}
div#rec-medialookup-pmedia-template:last-child,div#rec-medialookup-pticket-template:last-child {
    margin-bottom: 100px;
}
.medialookup-rec-item[data-CommonStatus='<%=LkCommonStatus.Draft.getCode()%>'] {
  border-left: 2vw solid var(--base-gray-color);
}
.medialookup-rec-item[data-CommonStatus='<%=LkCommonStatus.Active.getCode()%>'] {
  border-left: 2vw solid var(--base-green-color);
}
.medialookup-rec-item[data-CommonStatus='<%=LkCommonStatus.Warn.getCode()%>'] {
  border-left: 2vw solid var(--base-orange-color);
}
.medialookup-rec-item[data-CommonStatus='<%=LkCommonStatus.Deleted.getCode()%>'] {
  border-left: 2vw solid var(--base-red-color);
}
.medialookup-rec-item[data-CommonStatus='<%=LkCommonStatus.Completed.getCode()%>'] {
  border-left: 2vw solid var(--base-blue-color);
}
.medialookup-rec-item[data-CommonStatus='<%=LkCommonStatus.FatalError.getCode()%>'] {
  border-left: 2vw solid var(--base-purple-color);
}

.medialookup-rec-item .rec-title {
  font-size: 1.2em;
  font-weight: bold;
}

.medialookup-rec-item .rec-small {
  color: rgba(0,0,0,0.5);
}

</style>