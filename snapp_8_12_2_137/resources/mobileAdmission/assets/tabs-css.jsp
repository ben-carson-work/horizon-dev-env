<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v" %>


<style>
#tabs .tabs {
	display:none;
}
#tabs .tabs.show {
	display:block;
}
.footer {
  position: absolute;
  bottom: 0px;
  left: 0px;
  width: 100%;
  background-image: -webkit-linear-gradient(top, #3c3c3c 0%, #282828 100%);
  border-top: 1px #000 solid;
  box-shadow: 0px 0px 5px rgba(0,0,0,0.8);
  z-index:999;
}

.footer .inner {
  border-top: 1px #4b4b4b solid;
  height: 13vmin;
  min-height:60px;
}

.footer .tab {
  position: relative;
  width: 25vw;
  float: left;
  opacity: 0.1;
  padding: 0px 0px 0px 0px;
}

.footer .tab.enabled{
  opacity: 0.4;
}

.footer .tab-pressed {
  background-image: -webkit-linear-gradient(bottom, #242424 0%, #0f0f0f 100%);
  position: relative;
  border-top: 0px #000 solid;
  border-left: 0px #000 solid;
  border-right: 0px #000 solid;
  top: -1px;
  padding: 0px;
  opacity: 1 !important;
}

#tab-container {
  -webkit-overflow-scrolling: touch;
  overflow: auto;    
  position: absolute; 
  top: 0px; 
  left: 0px; 
  right: 0px; 
  bottom: 13.0vmin; 
}

.tab .icon {
  background-repeat: no-repeat;
  background-position: center center;
  height: 13.0vmin;
  background-size: auto 70%;
  min-height:60px;
}

.tab .caption {
  line-height: 1.7vmin;
  font-family: sans-serif;
  font-size: 2.5vmin;
  color: white;
  text-shadow: 0px -1px #000000;
  font-weight: bold;
  text-align: center;
  margin-bottom: 0.6vmin;
}

.tab .bubble {
  position: absolute;
  top: 1px;
  left: 55%;
  background-image: -webkit-linear-gradient(top, #f69ca0 0%, #c50103 100%);
  border: 2px white solid;
  border-radius: 30px;
  text-align: center;
  color: white;
  font-family: arial;
  font-weight: bold;
  font-size: 14px;
  min-width: 14px;
  padding: 1px 2px 1px 2px;
  box-shadow: 0px 3px 5px rgba(0,0,0,0.8);
}

.tab .tab-content {
  display: none !important;
}

.footer .tab-pressed {
  opacity: 1.0;
}
</style>
