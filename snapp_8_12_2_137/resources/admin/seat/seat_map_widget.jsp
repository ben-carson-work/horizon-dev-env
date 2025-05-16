<%@page import="java.util.*"%>
<%@page import="org.apache.catalina.startup.*"%>
<%@page import="com.vgs.snapp.web.common.library.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@page import="com.vgs.vcl.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="map" class="com.vgs.snapp.dataobject.DOSeatMap" scope="request"/>

<%
boolean renderSeatLines = JvString.isSameText(request.getParameter("RenderSeatLines"), "true");
%>

<div class="vse-desktop">

	<%!private String encodeKey(DOSeatMap.DOSeat seat, boolean next) {
	  int seq = seat.SeqNumber.getInt();
	  if (next)
	    seq++;
	  return /*seat.SeatSectorId.getString() + "|" + */seat.SeatCategoryId.getString() + "|" + seq;  
	}%>
	
	<%
	HashMap<String, DOSeatMap.DOSeat> hm = new HashMap<String, DOSeatMap.DOSeat>(); // <sector|cat|seq, seat> 
	for (DOSeatMap.DOSeat seat : map.SeatList) 
	  hm.put(encodeKey(seat, false), seat);
							
  String backgroundURL = map.BackgroundRepositoryId.isNull() ? "" : ConfigTag.getValue("site_url") + "/repository?id=" + map.BackgroundRepositoryId.getString();
	%> 
  
  <svg xmlns="http://www.w3.org/2000/svg" version="1.1" class="vse-map" width="10000" height="10000" data-BackgroundRepositoryId="<%=map.BackgroundRepositoryId.getHtmlString()%>">
    <g transform="scale(1)" class="gseat">
      <image class="vse-background-image" xlink:href="<%=backgroundURL%>" x="0" y="0"/>
      
      <% if (renderSeatLines) { %>
        <marker id="vse-seat-line-end"
            viewBox="0 0 10 10" refX="10" refY="5" 
            markerUnits="userSpaceOnUse"
            markerWidth="8" markerHeight="6"
            fill="rgba(0,0,0,0.6)"
            orient="auto">
          <path d="M 0 0 L 10 5 L 0 10 z" />
        </marker>
      <% } %>
      
      <g class="vse-seat-container">
	    <% for (DOSeatMap.DOSeat seat : map.SeatList) { %>
	      <%
	        DOSeatMap.DOSeat nextSeat = hm.get(encodeKey(seat, true));
	      	float cx = seat.X.getFloat() + (seat.Width.getFloat() / 2.0f); 
	      	float cy = seat.Y.getFloat() + (seat.Height.getFloat() / 2.0f);
	      %>
	      <rect 
	          class="vse-seat"
	          id="<%=seat.SeatId.getHtmlString()%>"
	          x="<%=seat.X.getFloat()%>" 
	          y="<%=seat.Y.getFloat()%>" 
	          width="<%=seat.Width.getFloat()%>" 
	          height="<%=seat.Height.getFloat()%>" 
	          rx="2" 
	          ry="2" 
	          transform="rotate(<%=seat.Rotation.getFloat()%>, <%=cx%>, <%=cy%>)"
	          data-rotation="<%=seat.Rotation.getFloat()%>"
	          data-row="<%=seat.Row.getHtmlString()%>"
	          data-col="<%=seat.Col.getHtmlString()%>"
	          data-category="<%=seat.SeatCategoryId.getHtmlString()%>"
            data-sector="<%=seat.SeatSectorId.getHtmlString()%>"
            data-envelope="<%=seat.SeatEnvelopeId.getHtmlString()%>"
            data-weight="<%=seat.Weight.getHtmlString()%>"
            data-aisleleft="<%=seat.AisleLeft.getBoolean()%>"
            data-aisleright="<%=seat.AisleRight.getBoolean()%>"
            data-break="<%=seat.BreakType.getInt()%>"
            data-nextseatid="<%=(nextSeat == null) ? "" : nextSeat.SeatId.getHtmlString()%>"
            data-status="free"
	      />
	    <% } %>
	    </g>
	
      <% if (renderSeatLines) { %>
		    <g class="vse-line-container">
		    <% for (DOSeatMap.DOSeat seat : map.SeatList) { %>
		      <%
          float cx = seat.X.getFloat() + (seat.Width.getFloat() / 2.0f); 
          float cy = seat.Y.getFloat() + (seat.Height.getFloat() / 2.0f);
          float dx = 0;
          float dy = 0;
          DOSeatMap.DOSeat dst = hm.get(encodeKey(seat, true));
          if (dst != null) {
            dx = dst.X.getFloat() + (dst.Width.getFloat() / 2.0f); 
            dy = dst.Y.getFloat() + (dst.Height.getFloat() / 2.0f);
          }
          String clsHidden = (dst==null) ? "v-hidden" : "";
          String clsBreakRow = seat.BreakType.isLookup(LkSNSeatBreakType.ChangeRow) ? "break-row" : "";
          String clsBreakDis = seat.BreakType.isLookup(LkSNSeatBreakType.Disjunction) ? "break-dis" : "";
		      %>
		      <line 
		          class="vse-seat-line <%=clsHidden%> <%=clsBreakRow%> <%=clsBreakDis%>" 
		          data-SrcSeatId="<%=seat.SeatId.getHtmlString()%>" 
		          data-DstSeatId="<%=(dst == null) ? "" : dst.SeatId.getHtmlString()%>"
		          x1="<%=cx%>" y1="<%=cy%>" x2="<%=dx%>" y2="<%=dy%>" 
		      />
		    <% } %>
		    </g>
      <% } %>
    </g>
  </svg>
</div>