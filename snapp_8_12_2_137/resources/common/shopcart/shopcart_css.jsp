<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.cl.JvString"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>
<% PageBO_Base<?> pageBase = (PageBO_Base<?>)request.getAttribute("pageBase"); %>
<% BOSessionBean boSession = (pageBase == null) ? null : pageBase.getSession(); %>

<style>
  .ui-dialog {
    background-color: var(--body-bg-color);
  }

  .v-button {
    background-color: rgba(0,0,0,0.1);
    border-radius: 6px;
    padding: 0 10px 0 10px;
    line-height: 36px;
    color: black;
    min-width: 70px;
    text-align: center;
    font-size: 13px;
    cursor: default;
    border: none;
    
    -webkit-touch-callout: none;
    -webkit-user-select: none;
    -khtml-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
    user-select: none;
  }
  
  .v-button:not(.v-hidden) {
    display: inline-block;
  }
  
  .v-button.disabled {
    color: rgba(0,0,0,0.6);
    background-color: rgba(0,0,0,0.05);
  }
  
  .v-button:not(.disabled):hover {
    cursor: pointer;
    color: black;
    background-color: var(--highlight-color);
  }
  
  .v-button.hl-purple:not(.disabled):hover {
    color: white;
    background-color: var(--base-purple-color);
  }
  
  .v-button.hl-red:not(.disabled):hover {
    color: white;
    background-color: var(--base-red-color);
  }
  
  .v-button.hl-orange:not(.disabled):hover {
    color: white;
    background-color: var(--base-orange-color);
  }
  
  .v-button.hl-blue:not(.disabled):hover {
    color: white;
    background-color: var(--base-blue-color);
  }
  
  .v-button.hl-green:not(.disabled):hover {
    color: white;
    background-color: var(--base-green-color);
  }
  
  .v-button img {
    vertical-align: middle;
    margin-top: -2px;
  }
  
  .v-button.split-button {
    width: 25px;
    padding-left: 0;
    padding-right: 0;
  }
  
  .buttonset .v-button {
    min-width: inherit;
  }
  
  .buttonset .v-button:not(:first-child) {
    border-top-left-radius: 0;
    border-bottom-left-radius: 0;
  }
  
  .buttonset .v-button:not(:last-child) {
    border-top-right-radius: 0;
    border-bottom-right-radius: 0;
    border-right: 1px rgba(255,255,255,0.4) solid;
  }

  .v-button {
    font-size: 1.3em;
    line-height: 20px;
    padding: 10px;
    background-repeat: no-repeat;
    background-position: center center;
  }
  
  .btn-float-left {
    float: left;
    margin-right: 5px;
  }
  
  .btn-float-right {
    float: right;
    margin-left: 5px;
  }

  .mainlist-container {
    position: fixed;
    top: 28px;
    left: 190px;
    bottom: 0px;
    right: 0px;
    border: none;
    padding: 0;
    background: var(--body-bg-color);
  }

  #catalog-block,
  #event-block,
  #product-block,
  #cart-block {
    width: 25%;
    height: 100%;
    float: left;
    vertical-align: top;
  }
  
  .block-inner {
    border-left: 1px var(--tab-border-color) solid;
    height: 100%;
    position: relative;
  }
  
  .block-title {
    position: relative;
    background: #d9d7ce;
    text-align: center;
    height: 70px;
    border-bottom: 1px var(--tab-border-color) solid;
  }
  
  .title-caption {
    font-size: 2em;
    line-height: 70px;
  }
  
  .title-image {
    background-position: center center;
    background-repeat: no-repeat;
    background-size: cover;
    position: absolute;
    top: 4px;
    left: 4px;
    width: 62px;
    height: 62px;
  }
  
  .block-body {
    position: absolute;
    top: 70px;
    left: 0;
    bottom: 0;
    right: 0;
  }
  
  .item-container {
    height: 100%;
    overflow: auto;
  }
  
  #event-block .title-caption,
  #product-block .title-caption {
    position: absolute;
    left: 76px;
    top: 0;
    right: 0;
    height: 40px;
    text-align: left;
    line-height: 45px;
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
  }
  
  .block-title .subtitle-caption {
    font-size: 1.3em;
    position: absolute;
    left: 76px;
    top: 40px;
    right: 0;
    bottom: 0;
    text-align: left;
    color: rgba(0,0,0,0.8);
  }
  
  #event-container {
    height: 25%;
  }
  
  #perf-container {
    height: 75%;
    position: relative;
  }
  
  #perf-container .item-container {
    position: absolute;
    top: 64px;
    left: 0;
    bottom: 0;
    right: 0;
    height: initial;
  }
  
  #catalog-container .item-container,
  #product-container .item-container {
    position: absolute;
    top: 0;
    left: 0;
    bottom: 0;
    right: 0;
  }
  
  #perf-filters {
    background-color: var(--pagetitle-bg-color);
    border-top: 1px var(--tab-border-color) solid;
    padding: 10px;
    height: 62=3px;
  }
  
  #lblFilterAvailMin,
  #perf-filters input[type='text'] {
    font-size: 1.3em;
  }
  
  #PerfDateFilter-picker {
    width: 120px;
  }
    
  #txt-perf-filter {
    line-height: 20px;
    padding: 10px;
    border-radius: 6px;
    font-size: 17px;
    width: calc(100% - 52px);
  }
  
  #btn-perf-filter {
    min-width: 0;
    width: 42px;
    height: 42px;
    margin-left: 5px;
  }
  
  #txtFilterAvailMin {
    width: 50px;
    text-align: center;
  }
  
  .item-container {
    min-height: 50px;
  }
  
  .level-spanner {
    display: inline-block;
    width: 25px;
  } 
  
  .catalog-item {
    position: relative;
    cursor: pointer;
    height: 40px;
    overflow: hidden;
  }
  
  .catalog-item:hover {
    background-color: rgba(0,0,0,0.05);
  }
  
  .catalog-item.selected {
    background-color: var(--highlight-color);
    cursor: default;
  }
  
  .item-indent {
    position: absolute;
    top: 0;
    left: 0;
    bottom: 0;
    right: 0;
  }
  
  .item-img {
    position: absolute;
    top: 4px;
    left: 4px;
    width: 32px;
    height: 32px;
  }
  
  .item-caption {
    margin-left: 42px;
    top: 0;
    right: 0;
    bottom: 0;
    line-height: 40px;
    font-size: 1.3em;
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
  }
  
  .waiting {
    background-image: url('<v:config key="resources_url"/>/admin/images/new-spinner32.gif');
    background-repeat: no-repeat;
    background-position: center 20px;
    min-height: 50px;
  }
  
  .no-elem-found {
    font-size: 1.5em;
    text-align: center;
    padding: 20px;
    color: rgba(0,0,0,0.5);
  }
  
  .perf-date {
    padding: 2px 4px 2px 4px;
    margin: 10px 10px 2px 10px;
    font-weight: bold;
    border-bottom: 1px var(--tab-border-color) solid;
    color: rgba(0,0,0,0.8);
  }
  
  .perf-warning {
    background-color: white;
    border-left: 4px var(--base-orange-color) solid;
    padding: 10px;
    margin: 10px;
    box-shadow: 1px 1px 4px rgba(0,0,0,0.2);
  }
  
  .perf-item .item-img {
    width: 28px;
    height: 32px;
    padding: 7px 0px 7px 10px;
    opacity: 0.6;
  }
  
  .avail-box {
    float: right;
    margin-right: 4px;
  }
  
  .avail-quantity {
    font-size: 1.3em;
    margin-top: 5px;
    text-align: center;
  }
  
  .avail-progressbar {
    background-color: var(--base-gray-color);
    width: 50px;
  }
  
  .perf-item .avail-box.avail-soldout .avail-progressbar {
    background-color: var(--base-red-color);
  }
  
  .avail-progress-split {
    background-color: var(--base-green-color);
    height: 5px;
  }
  
  .perf-item .avail-box.avail-warn .avail-progress-split {
    background-color: var(--base-orange-color);
  }

  .product-item.seat-item .item-caption {
    line-height: 24px;
  }
  
  .product-item .avail-progressbar {
    position: absolute;
    left: 45px;
    bottom: 9px;
  }
  
  .product-item .avail-quantity {
    font-size: inherit;
    position: absolute;
    left: 100px;
    bottom: 4px;
  }
  
  .price-box {
    float: right;
    font-size: 1.3em;
    margin: 4px;
    line-height: 32px;
  }
  
  .product-item[data-HasDynamicOptions='true'] .price-box {
    border-bottom: 2px dotted rgba(0,0,0,0.8);
    margin-top: 11px;
    line-height: 18px;
  }
  
  #cart-block .block-title {
    height: 183px;
    padding: 10px;
  }

  #cart-block .block-body {
    top: 184px;
    bottom: 80px;
    background-color: white;
  }
  
  #cart-block.empty-cart .block-body {
    bottom: 0;
  }

  #cart-block .block-footer {
    position: absolute;
    bottom: 0;
    left: 0;
    right: 0;
    height: 90px;
    background-color: var(--pagetitle-bg-color);
    border-top: 1px var(--tab-border-color) solid;
    padding: 10px;
    box-sizing: border-box;
    line-height: 20px;
  }
  
  #cart-block.empty-cart .block-footer {
    display: none;
  }

  #cart-block .block-footer .field-value {
    font-weight: bold;
  }
  
  #cart-total-container {
    padding: 10px;
    border-radius: 6px;
    background-color: var(--menu-bg-color);
    color: var(--menu-fg-color);
  }
  
  #cart-block .cart-field {
    overflow: hidden;
    font-size: 1.3em;
    padding-top: 4px;
  }
  
  #cart-block .cart-field .field-caption {
    float: left;
  }
  
  #cart-block .cart-field:first-child {
    padding-top: 0;
  }
  
  #cart-block .cart-field .field-value {
    float: right;
  }
  
  #cart-block .trntype-container { 
    display: none; 
    padding: 10px; 
    background-color: var(--info-bg-color); 
    font-weight: bold; 
    border-bottom: 1px solid rgba(0,0,0,0.2); 
  } 

  #cart-block.special-trntype .trntype-container { 
    display: block; 
  } 

  #cart-total-paid {
    padding-bottom: 6px;
  }

  #cart-total-due {
    font-size: 1.6em;
    font-weight: bold;
    padding: 4px 0 0 0;
    color: white;
    border-top: 1px rgba(255,255,255,0.2) solid;
  }
  
  #cart-tools {
    margin-top: 10px;
  }
  
  #cart-tools .v-button {
    width: auto;
    min-width: 80px;
  }
  
  #cart-tools .float-left {
    float: left;
    margin-right: 5px;
  }
  
  #cart-tools .float-right {
    float: right;
    margin-left: 5px;
  }
  
  .empty-cart-tools {
    display: none;
    text-align: left;
  }
  
  .empty-cart .empty-cart-tools {
    display: block;
  } 
  
  .empty-cart .full-cart-tools {
    display: none;
  } 
  
  #shopcart-timer {
    margin-left: 10px;
  }
  
  .timer-alert {
    animation: ALERT_ANIMATION 1s infinite;
  }
  
  @keyframes ALERT_ANIMATION {
    0% {background-color: rgba(0, 0, 0, 0.1);}
    15% {background-color: var(--base-orange-color);}
    30% {background-color: var(--base-orange-color);}
    100% {background-color: rgba(0, 0, 0, 0.1);}
  }
  
  #txt-search {
    line-height: 20px;
    padding: 10px;
    border-radius: 6px;
    font-size: 17px;
    text-transform: uppercase;
    border: 0; 
    <% if (pageBase.isVgsContext("B2B")) { %>
      <% if (pageBase.getSession().getOrgAllowInventory()) { %>
        width: calc(100% - 102px);
      <% } else { %>
        width: calc(100% - 52px);
      <% } %>
    <% } else { %>
      <% if (pageBase.getSession().getOrgAllowInventory()) { %>
        width: calc(100% - 152px);
      <% } else { %>
        width: calc(100% - 102px);
      <% } %>
    <% } %>
  }
  
  <% if (pageBase.isVgsContext("B2B")) { %>
    #btn-account {
      display: none;
    }
  <% } %>
  
  <% if (!pageBase.getSession().getOrgAllowInventory()) { %>
    #btn-handover {
      display: none;
    }
  <% } %>
  
  #txt-search:focus {
    outline: 0;
  }
  
  #cart-block .v-button.icon-button {
    width: 42px;
    height: 42px;
    line-height: 42px; 
    font-size: 24px;
    min-width: 0;
    padding: 0;
    color: rgba(0,0,0,0.8);
  }

  #cart-block .v-button.icon-button img {
    margin: 9px;
  }
  
  #cart-block .v-button.icon-button.disabled img {
    opacity: 0.2;
  }
  
  #cart-block #btn-salemenu {
    float: right;
    margin-top: 14px;
    margin-left: 10px;
  }
  
  #cart-menu {
    background-color: white;
    border: 1px solid var(--border-color);
    border-radius: 2px;
    box-shadow: 0px 0px 16px 0px rgba(0,0,0,0.2);
    width: 300px;
  }
  
  .menu-item {
    height: 40px;
    font-size: 1.3em;
    cursor: pointer;
    position: relative;
  }
  
  .menu-item:hover {
    background-color: var(--highlight-color);
  }
  
  .menu-item .item-img {
    width: 24px;
    height: 24px;
    line-height: 40px;
    top: 0;
    left: 8px;
  }

  .cart-group:first-child .cart-group-title {
    border-top: none;
  }
  
  .cart-group .cart-group-title {
    padding: 4px 10px 4px 10px;
    font-weight: bold;
    border-bottom: 1px var(--tab-border-color) solid;
    border-top: 1px var(--tab-border-color) solid;
    background-color: var(--pagetitle-bg-color);
  }
  
  .cart-item {
    position: relative;
    padding: 0;
    height: auto;
    border-bottom: 1px var(--body-bg-color) solid;
  }
  
  .cart-item.not(.selected):hover {
    background-color: var(--body-bg-color);
  }
  
  .cart-item-main {
    padding: 8px;
  }
    
  .cart-item-subitems {
    margin-left: 40px;
    background-color: white;
    border-left: 1px var(--tab-border-color) solid;
  }
  
  .cart-item:last-child {
    border-bottom: none;
  }

  .cart-item-data-line {
    overflow: hidden;
    padding: 2px;
  }
    
  .cart-item .line1 {
    font-size: 1.3em;
  }
  
  .cart-item .data-value-l1,
  .cart-item .data-value-l2 {
    float: left;
  }
  
  .cart-item .data-value-r1,
  .cart-item .data-value-r2 {
    float: right;
  }
  
  .cart-item-btns {
    display: none;
    overflow: hidden;
    
    .v-button {
      float: right;
      height: 40px;
      margin: 2px;
      min-width: 60px;
      font-size: 22px;
    }
  }
  
  .cart-item.selected>.cart-item-main>.cart-item-btns {
    display: block;
  }

  .ui-dialog .body-block {
    position: absolute;
    left: 0;
    right: 0;
    top: 0;
    bottom: 60px;
    padding: 10px;
    overflow: auto;
  }
  
  .ui-dialog .toolbar-block {
    position: absolute;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: var(--body-bg-color);
    border-top: 1px var(--border-color) solid;
    overflow: hidden;
    padding: 10px;
  }
  
  .ui-dialog .toolbar-block>.v-button { 
    float: right;
    margin-left: 10px;
  }
  
  .folder-collapse, 
  .folder-explode {
    display: none;
    position: absolute;
    top: 4px;
    left: 4px;
    width: 16px;
    height: 32px;
    line-height: 28px;
  }
  
  [folder-status='exploded'].has-subfolders>*>*>.folder-collapse {
    display: block; 
  }
  
  [folder-status='collapsed'].has-subfolders>*>*>.folder-explode {
    display: block; 
  }
  
  [folder-status='collapsed']>.subfolder-container {
    display: none; 
  }
  
  .subfolder-container .item-img {
    left: 24px;
  }
  
  .subfolder-container .item-caption {
    margin-left: 60px;
  }
  
   
  
</style>
