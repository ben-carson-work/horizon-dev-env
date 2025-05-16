<%@page import="com.vgs.snapp.dataobject.DODB.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.snapp.web.bko.library.*"%>
<%@page import="com.vgs.web.page.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.service.dataobject.*"%>
<%@page import="com.vgs.web.dataobject.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.query.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v"%>
<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request" />

<v:dialog id="code_freeze_generation_dialog" width="1000" height="710" title="Code freeze generation">

  <jsp:include page="code_freeze_generation_dialog_css.jsp"/>
  <jsp:include page="code_freeze_generation_dialog_js.jsp"/>

  <div class="wizard">   
    <div class="wizard-step wizard-step-calc-versions">
      <div class="wizard-step-title">Configuration</div>
      <div class="wizard-step-content">
	      <v:widget caption="Configure versions" id="versions-edit-widget">
	        <v:widget-block>
	          <v:form-field caption="Old WIP base version">
	            <v:input-text field="oldWIPVersion"/>
	          </v:form-field>
	          <v:form-field caption="New WIP base version">
              <v:input-text field="newWIPVersion"/>
            </v:form-field>
            <v:form-field caption="Release base version">
              <v:input-text field="releaseVersion"/>
            </v:form-field>
	        </v:widget-block>
	      </v:widget>
      </div>
    </div>
    <div class="wizard-step wizard-step-recap">
      <div class="wizard-step-title">Recap</div>
      <div class="wizard-step-content">
		    <div id="content">
		      <table id="table-build-version">
		        <tr>
		          <td width="33%">
		            <v:widget caption="Old \"WIP\" versions" id="old-wip-version-recap-widget">
		              <v:widget-block/>
		            </v:widget>
		          </td>
		          <td width="33%">
                <v:widget caption="New \"WIP\" versions" id="new-wip-version-recap-widget">
                  <v:widget-block/>
                </v:widget>
              </td>
		          <td width="33%">
		            <v:widget caption="\"Release\" versions" id="release-version-recap-widget">
		              <v:widget-block/>
		            </v:widget>
		          </td>
		        </tr>
		      </table>
		    </div>
		    <div class="recap-version-block template hidden">
          <div class="recap-version"></div>
          <div class="recap-description"></div>
        </div>
		  </div>
    </div>
    <div class="wizard-step wizard-step-calc-versions">
      <div class="wizard-step-title">Execute</div>
      <div class="wizard-step-content">
        <div class="execute-step-recap">
          <v:widget caption="Executing steps...">
	         <v:widget-block>
              <div id="pb-execute" class="progress-block">
                <div class="progressbar-status"><v:itl key="@Common.PleaseWait"/></div>
                <div class="progress"><div class="progress-bar progress-bar-snp-success"></div></div>
              </div>
           
	            <div class="create-branch-step">
	              <span>Creating SVN branch</span>
	              <div class="spinner-step">
	                <i id="spinner-icon" class="fas fa-circle-notch fa-spin fa-2x"></i>
	              </div>
	              <div class="check-step">
	                <i id="step-success-icon" class="fas fa-check fa-2x"></i>
	              </div>
	              <div class="failed-step">
                  <i id="step-fail-icon" class="fas fa-times fa-2x"></i>
                </div>
	            </div>
	            <div class="create-jira-versions-step">
	              <span>Creating JIRA versions</span>
	              <div class="spinner-step">
	                <i id="spinner-icon" class="fas fa-circle-notch fa-spin fa-2x"></i>
	              </div>
	              <div class="check-step">
	                <i id="step-success-icon" class="fas fa-check fa-2x"></i>
	              </div> 
	              <div class="failed-step">
                  <i id="step-fail-icon" class="fas fa-times fa-2x"></i>
                </div> 
	            </div>
	          </v:widget-block>
          </v:widget>
        </div>
      </div>
    </div>
  </div>
</v:dialog>