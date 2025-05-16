<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
  pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v"%>

<style id="event-css.jsp">

/*
	default colors:
	orange: rgb(225,106,19) o rgba(225,106,19,x)
	green: rgb(0,133,155) o rgba(0,133,155,x)
	black: rgba(0,0,0,0.7)
*/
#eventContainer{
  margin-top:-50px;
}
.performance {
  width: 100%;
  border: 1px solid #eee;
  cursor:pointer;
  display: flex;
}

.performanceDate {
}

.Availability {
  text-align: center;
}
#dateChoosen {
  
}
#ProductContainer {
  width: 100%;
  position: fixed;
  background: #efefef;
  top: 100px;
  bottom: 0;
  right:-100%;
  -webkit-box-shadow: -5px 0px 15px 0px rgba(186, 186, 186, 1);
  -moz-box-shadow: -5px 0px 15px 0px rgba(186, 186, 186, 1);
  box-shadow: -5px 0px 15px 0px rgba(186, 186, 186, 1);
  transition: all linear .2s;
}
#ProductContainer #productList {
  margin:30px;
}
#ProductContainer #productList .Product {
  width: 100%;
  border: 1px solid #eee;
  cursor: pointer;
  background:#fff;
}
.PerformanceProduct {
  height: 80px;
  width: 80px;
  float: right;
  border: none;
}

.closeProductcontainer {
  float: right;
}

.quantitytoadd {
  width: 50px !important;
  float: left;
  background: none;
  font-size: 20px;
  text-align: center;
  border: 0 !important;
    box-shadow: none !important;
}
.btn.quantity {
    float: left;
    height: 40px;
    border-radius: 20px;
    width: 40px;
    font-size: 18px;
  }
 
 .capacitycategorycontainer{
 margin:30px 30px -20px 30px;
 }
 .capacitycategory{
    font-size: 22px;
    background: white;
    margin: 2px -12px;
    padding: 8px 8px 1px 8px;
    border-radius: 4px;
 }
 .capacitycategorytitle{
 	max-width: 80%;
    text-overflow: ellipsis;
    white-space: nowrap;
    overflow: hidden;
    float: left!important;
    }
    .capacitycategorycount{
    max-width: 20%;
    overflow: hidden;
    text-overflow: clip;
    float: right!important;
    }
 
</style>
