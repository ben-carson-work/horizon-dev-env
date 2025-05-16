<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<style>

#cal-left-column {
  float: left;
  width: 200px;
}

#cal-center-column {
  margin-left: 210px;
}

#tools-widget {
  margin-top: 5px;
}

#current-year {
  display: block;
  font-size: 26px;
  vertical-align: middle;
  text-align: center;
  margin-left: 32px;
  margin-right: 32px;
  line-height: 32px;
}

.flat-button {
  width: 32px;
  height: 32px;
  background-repeat: no-repeat;
  background-position: center center;
  opacity: 0.5;
  cursor: pointer;
  vertical-align: middle;
}

.flat-button:hover {
  opacity: 1;
}

.flat-button-prev {
  background-image: url(<v:image-link name="bkoact-back.png" size="24" />);
  float: left;
}

.flat-button-next {
  background-image: url(<v:image-link name="bkoact-forward.png" size="24" />);
  float: right;
}

.tool-title {
  font-size: 1.1em;
  font-weight: bold;
  margin-bottom: 10px;
}

.tool-item {
  padding: 4px;
  cursor: pointer;
}

.tool-item:hover {
  background-color: rgba(0, 0, 0, 0.05);
}

.tool-item.selected {
  background-color: var(--highlight-color);
}

.tool-item[data-id='DEFAULT'] {
  border-bottom: 1px solid rgba(0,0,0,0.2);
}

.tool-item-color {
  float: left;
  width: 16px;
  height: 16px;
  vertical-align: middle;
  border: 1px solid black;
  background-color: white;
}

.tool-item-name {
  margin-left: 20px;
}


#calendar {
  margin: -5px;
}

.cal-month-container {
  padding: 5px;
}
 
</style>