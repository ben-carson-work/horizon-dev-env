<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<style>

.btn-catalog {
  float: left;
  position: relative;
  width: 25%;
  padding: 0.5rem;
}

.btn-catalog .btn-catalog-body {
  position: relative;
  height: 20vw;
  background-color: var(--content-bg-color);
  background-position: center center;
  background-repeat: no-repeat;
  background-size: cover;
}

.btn-catalog .btn-catalog-name {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  background: rgba(0,0,0,0.5);
  color: white;
  text-align: center;
  font-size: 3rem;
}

.btn-catalog[data-buttondisplaytype='2x1'],
.btn-catalog[data-buttondisplaytype='2x2'] {
  width: 50%;
}

.btn-catalog[data-buttondisplaytype='1x2'] .btn-catalog-body,
.btn-catalog[data-buttondisplaytype='2x2'] .btn-catalog-body {
  height: 40vw;
}

.btn-catalog-prodtype .btn-catalog-price,
.btn-catalog-prodtype .btn-catalog-qty {
  position: absolute;
  bottom: 5rem;
  background-color: rgba(0,0,0,0.9);
  padding: 1rem 3rem;
  color: white;
}

.btn-catalog-prodtype .btn-catalog-price {
  right: 0;
  border-top-left-radius: 1rem;
  border-bottom-left-radius: 1rem;
}

.btn-catalog-prodtype .btn-catalog-qty {
  display: none;
  left: 0;
  border-top-right-radius: 1rem;
  border-bottom-right-radius: 1rem;
}

.btn-catalog-prodtype.prod-in-cart .btn-catalog-qty {
  display: block;
}

</style>