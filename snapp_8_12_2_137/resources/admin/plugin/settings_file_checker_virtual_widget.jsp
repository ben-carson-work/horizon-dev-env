<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="java.util.Map.*"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="plugin" class="com.vgs.snapp.dataobject.DOPlugin" scope="request"/>

<v:widget>
  <v:widget-block>
    <v:alert-box type="info">
      <br>This plugin provides a virtual anti-virus file checker. System will check if file contains one of these texts:<br/>
      <ul>
        <li><b>virus</b>: if you want to simulate an infected file.</li>
        <li><b>error</b>: if you want to simulate an anti-virus error.</li>
        <li><b>generic</b>: if you want to simulate a generic error. </li>
      </ul>
    </v:alert-box>
  </v:widget-block>
</v:widget>