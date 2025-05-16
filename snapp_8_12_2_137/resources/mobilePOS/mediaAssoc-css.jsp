<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
  pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v"%>

<style id="mediaAssoc-css.jsp">
.mediaItem {
  
}
.mediaItem div{
  border:4px solid transparent;
  cursor:pointer;
  padding: 10px;
  font-weight: bold;
  margin: 10px 0;
  font-size: 20px; 
  border-radius:10px;
}
.mediaItem.empty div{
  background: #eee;
  color: rgba(0,0,0,0.3);
}
.mediaItem.full div{
  background: #299a0b;
  color: #fff;
}
.mediaItem.error div {
	background: red;
  	color: #fff;
}
.mediaItem.missingAccountData div,.mediaItem.hasAccountData.empty div {
  background: #D2E638;
  color: #fff;
}
.mediaItem div.selected{
  border:4px solid #7db9e8; 
}
.removeCode {
  position: absolute;
  right: 25px;
  top: 20px;
  background: rgba(255,255,255,0.8);
  border-radius: 15px;
  padding: 4px 8px;
  line-height: 1;
}
</style>
