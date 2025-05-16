<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ taglib uri="ksk-tags" prefix="ksk" %>

<jsp:useBean id="kiosk" class="com.vgs.snapp.dataobject.DOKioskUI" scope="request"/>

<div id="status-idle" class="position-absolute-full vert-flex">
  
  <jsp:include page="../common/kiosk-header.jsp"></jsp:include>
      

  <div id="idle-video-container">
    <video style="width:100%; max-height:100%" autoplay loop muted>
      <source src="<%=kiosk.VideoURL.getHtmlString()%>" type="video/mp4">
    </video>
  </div>
    

  <div id="status-idle-content">

    <div class="carousel slide" data-bs-ride="carousel">
      <div class="carousel-inner">
        <% 
        for (String repositoryURL : kiosk.CarouselURLs.getArray()) {
          %><div class="carousel-item active" style="background-image:url(<%=JvString.htmlEncode(repositoryURL)%>)"></div><%
        }
        %>
      </div>
    </div>
    
    <div id="idle-footer">
      <div><ksk:itl key="@StepIdle.Footer1"/></div>
      <div><ksk:itl key="@StepIdle.Footer2"/></div>
    </div>
  </div>
</div>
