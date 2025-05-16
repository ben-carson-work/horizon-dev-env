<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<style>

#accesspointlist .body {
  position: absolute;
  top: 11vh;
  left: 0px;
  right: 0px;
  padding: 0.8vmin;
  bottom:0;
  margin-top:30px;
}
#accesspointlist .body.back {
  top: 24vh;
  margin-top: 0px;
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
@media screen and (max-height: 552px) {
	#accesspointlist .body.back {
		top: 150px;
		margin-top: 0px;
	}
}
</style>