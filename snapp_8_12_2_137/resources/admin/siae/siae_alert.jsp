<%@page import="com.vgs.web.page.PageBO_Base"%>
<%@page import="com.vgs.web.page.PageSiaeCardList"%>
<%@page import="com.vgs.web.library.BLBO_Siae"%>

<%
Object obj = request.getAttribute("pageBase"); 
if (obj != null && obj instanceof PageBO_Base<?>) {
  PageBO_Base<?> pageBase = (PageBO_Base<?>) obj;
  BLBO_Siae bl = pageBase.getBL(BLBO_Siae.class);
%>
  <% if (!bl.isSiaeSystemVerified()) { %>
     <div id="main-system-error" class="errorbox">Funzioni SIAE disabilitate - Controllare che il Codice Sistema del database sia lo stesso riportato nel file di configurazione del server Tomcat</div>      
  <% } %>

  <% if (!bl.existsSiaePackage()) { %> 
    <div id="main-system-error" class="errorbox">Funzioni SIAE disabilitate - Package SIAE disabilitato o non installato</div>
  <% } %>

  <% if (!bl.existsMainSystem()) { %>
    <div id="main-system-error" class="errorbox">Il sistema SIAE non è inizializzato.</div>
  <% } else if (bl.isBadCardInserted()) { %>
    <div id="main-system-error" class="errorbox">Carta SIAE inserita non valida</div>
  <% } else if (!bl.isValidCardInserted()) { %>
    <div id="main-system-error" class="errorbox">Non è presente alcuna carta SIAE valida</div>
  <% } else if (bl.areCardsExpired()) { %> 
    <div id="main-system-error" class="errorbox">Tutte le carte SIAE sono scadute</div>
  <% } %>
  
<% }%>