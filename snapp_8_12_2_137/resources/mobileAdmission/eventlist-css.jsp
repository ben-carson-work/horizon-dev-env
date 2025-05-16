<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<style>

#eventlist .body {
  position: absolute;
  top: 11vh;
  left: 0px;
  right: 0px;
  padding: 0.8vmin;
  bottom:0;
  margin-top:30px;

}
.ios-list {
-webkit-user-select: none;
}
.ios-list .apt-name {
  padding: 0;
  color: #474e67;
  font-weight: bold;
  font-size:16px;
}
.ios-list .apt-detail {
  padding: 0;
  color: #474e67;
  font-weight: bold;
  font-size:12px;
 
}
 @media screen and (max-height: 600px) {
		#eventlist .body {
			top: 60px;
		}
	}
</style>