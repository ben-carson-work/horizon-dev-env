<%@page import="com.vgs.snapp.api.DOApiInfo"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@page import="com.vgs.dataobject.*"%>
<%@page import="java.net.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageDocServiceEasy" scope="request"/>

<jsp:include page="/resources/common/header.jsp"/>
<v:page-title-box/>

<style>

.command-list .command {
  display: block;
}

.command-list .command.deprecated {
  text-decoration: line-through;
}

.command-list .command.selected {
  font-weight: bold; 
}

.service-tree {
  line-height: 18px;
  position: relative;
}

ul.doc-easy-tree {
  list-style-type: none;
  padding-left: 15px;
}

.service-tree .widget-block>ul.doc-easy-tree {
  margin: 0;
  padding: 0;
}

.docnode span {
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  vertical-align: middle;
  color: #333333;
} 

.docnode .treemark {
  display: inline-block;
  width: 18px;
  height: 18px;
  color: rgba(0,0,0,0.5);
  cursor: pointer;
}

.docnode .tm-collapsed {
  display: none;
}

.service-tree li.collapsed .tm-collapsed {
  display: inline;
}

.service-tree li.collapsed .tm-exploded {
  display: none;
}

.docnode:not(.has-children) .treemark {
  visibility: hidden;
}

.service-tree li.collapsed ul {
  display: none;
}

.docnode-name {
  width: 25%;
  font-weight: bold;
}

.docnode.required .docnode-name {
  border-bottom: 1px dashed black;
  color: black;
}

.docnode.deprecated .docnode-name {
  text-decoration: line-through;
} 

.docnode-type {
  position: absolute;
  width: 100px;
  left: 400px;
}

.docnode-comment {
  position: absolute;
  left: 500px;
  width: 500px;
  height: 20px;
  color: rgba(0,0,0,0.8);
  font-style: italic;
}

.docnode-comment:hover {
  white-space: normal;
  background: white;
  height: auto;
  padding: 10px;
  margin-left: -10px;
  margin-top: -10px;
  z-index: 100;
  box-shadow: 0 0 10px rgba(0,0,0,0.3);
}
</style>

<script>
$(document).ready(function() {
  $(".docnode .treemark").click(function() {
    $(this).closest("li").toggleClass("collapsed");
  });
  
  var $commonMark = $(".common-mark");
  var reader = new commonmark.Parser();
  var writer = new commonmark.HtmlRenderer();
  var plainText = $commonMark.text().trim(); 
  var parsedText = writer.render(reader.parse(plainText)); 
  $commonMark.html(parsedText);
});

</script>

<%
String cmd = pageBase.getNullParameter("cmd");
String selCommand = pageBase.getNullParameter("command"); 
DOCmdBase dummy = JvUtils.create(Service2Manager.getDOClass(null, cmd));
JvNode nodeRequest = dummy.findChildNode("Request");
JvNode nodeSelCommandDoc = (nodeRequest == null) ? null : nodeRequest.findChildNode(selCommand);
DOApiInfo apiInfo = new DOApiInfo(null, cmd, selCommand);
%>

<v:tab-group name="tab" main="true">
  <v:tab-item-embedded tab="tabs-dashboard" caption="@Common.Profile" default="true">
    <div class="tab-content">
      <div class="profile-pic-div">
        <v:widget clazz="command-list" caption="Commands">
          <v:widget-block>
            <% if (selCommand == null) { %>
              <div class="command selected"><v:itl key="@Common.All"/></div>
            <% } else { %>
              <% String href = pageBase.getContextURL() + "?page=doc_service_easy&cmd=" + cmd; %>
              <a href="<%=href%>" class="command"><v:itl key="@Common.All"/></a>
            <% } %>
          </v:widget-block>
          <% String[] commands = Service2Manager.getCommandList(dummy); %>
          <% if (commands.length > 0) { %>
            <v:widget-block>
            <% for (String command : commands) { %>
              <% JvNode nodeCommandDoc = (nodeRequest == null) ? null : nodeRequest.findChildNode(command); %>
              <% String href = pageBase.getContextURL() + "?page=doc_service_easy&cmd=" + cmd + "&command=" + URLEncoder.encode(command, "UTF-8"); %>
              <% String clazz = " command" + (nodeCommandDoc.isDeprecated() ? " deprecated" : ""); %>
              <% if (JvString.isSameText(selCommand, command)) { %>
                <div class="<%=clazz%> selected"><%=JvString.escapeHtml(command)%></div>
              <% } else { %>
                <a href="<%=href%>" class="<%=clazz%>"><%=JvString.escapeHtml(command)%></a>
              <% } %>
            <% } %>
            </v:widget-block>
          <% } %>
        </v:widget>
      </div>

      <div class="profile-cont-div">
        <% String title = (selCommand != null) ? "Command: " + selCommand : "Structure"; %>
        <v:widget clazz="service-tree" caption="<%=title%>">
          <% 
          String serviceComment = JvUtils.getVgsComment(Service2Manager.getCmdClass(null, cmd)); 
          String commandComment = PageDocServiceEasy.findCommandComment(null, cmd, selCommand);
          if ((commandComment == null) && (nodeSelCommandDoc != null))
            commandComment = nodeSelCommandDoc.getAnnotation();
          %>
          
          <v:widget-block include="<%=apiInfo.ReadOnly.getBoolean()%>">
            <b>READ-ONLY</b> <v:hint-handle hint="READ-ONLY APIs, in case a SQLServer availabilty group has been set up,  will use a read-only replica database to get data from"/>
          </v:widget-block>

          <v:widget-block clazz="common-mark" include="<%=!apiInfo.ServiceDescription.isNull()%>">
            <i><%=JvString.encodeCommonMark(apiInfo.ServiceDescription.getString())%></i>
          </v:widget-block>

          <v:widget-block clazz="common-mark" include="<%=!apiInfo.CommandDescription.isNull()%>">
            <i><%=JvString.encodeCommonMark(apiInfo.CommandDescription.getString())%></i>
          </v:widget-block>
          
          <v:widget-block include="<%=!apiInfo.ControlledRights.isEmpty()%>">
            <v:itl key="@Right.InvolvedRights"/>:
            <ul>
            <% for (LookupItem item : apiInfo.ControlledRights.getLkArray()) { %>
              <li>[<%=item.getCode()%>] <%=JvString.escapeHtml(item.getDescription(pageBase.getLang()))%></li>
            <% } %>
            </ul>
          </v:widget-block>

          <v:widget-block>
            <%=pageBase.renderService(dummy, selCommand)%>
          </v:widget-block>
        </v:widget>
      </div>

    </div>
  </v:tab-item-embedded>
</v:tab-group>


<jsp:include page="/resources/common/footer.jsp"/>
