<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<style>

#peoplelist .body {
  position: fixed;
	top: 24vh;
	left: 0px;
	right: 0px;
	padding: 0.8vmin;

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
		#peoplelist .body {
			top: 150px;
		}
	}
}
</style>