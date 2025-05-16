<%@page import="com.vgs.web.page.*"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
  pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v"%>

<jsp:useBean id="pageBase" class="com.vgs.web.page.PageMobileAdmission"
  scope="request" />

<script type="text/javascript">

$(document).ready(function() {
	$('.scrolling').bind("touchmove", function(e) {
	    e.stopPropagation();
	});
});
$(document).on("click", "#closeperf-btn", function() {
  	var performanceId = localStorage.getItem("performanceId");
  	//alert(performanceId);
		$("#peoplelist #alertmsgbg").show();
		  	$(document).on("click","#peoplelist #alertmsgBtnYes",function() {
				$("#peoplelist #alertmsgbg").hide();
				$('#floatingBarsG').show();
				
				 var reqDO = {
						   	Command: "Update",
						   	Update: {
			    		    	PerformanceIDs: performanceId,
			    		    	PerformanceStatus: 4
				    		}
						};
			   			//alert(JSON.stringify(reqDO));
					vgsService("performance", reqDO, false, function(ansDO) {
						
    					//alert(JSON.stringify(ansDO.Answer));
    					localStorage.removeItem("performanceId");
    					var aptId = localStorage.getItem("aptId");
    					
    					
					
					setTimeout(function() {mainactivity(mainactivity_step.checkActPerf);$('#floatingBarsG').hide();}, 1000);
				});
		});
		  	//$(document).off("click", "#closeperf-btn");
});
$(document).on("click","#peoplelist #alertmsgBtnCancel",function() {
	$("#peoplelist #alertmsgbg").hide();
});
     
$(document).on("<%=pageBase.getEventMouseDown()%>","#peoplelist-tab",function() {
	$('#ULpeoplelist').html('');
						//AccessAreaList = JSON.parse(AccessAreaList);
						//alert(AccessAreaList);

						//$('#peoplelist .infobar').html(eventName);
						var reqDO = {
							Command : "GetRunningPerformances",
							GetRunningPerformances : {
								AccessPointId : localStorage.getItem("aptId"),
								FillInsidePortfolioList : true
							}
						};

						vgsService("performance",reqDO,false,function(ansDO) {
									var accessarealisthtml = '';
									var peoplelisthtml = '';
									//------------------------------------------------------ access area loop -------------------------------------------

									$.each(ansDO.Answer.GetRunningPerformances.AccessAreaList,function(key2, AccessArea) {
										//if (AccessArea.PerformanceList.length>0) {
														//alert(JSON.stringify(AccessArea));
														//peoplelisthtml += "<li class='accessarea' rel=''>"+
														'<span class="thumb" style="background-image:url(\'<v:image-link name="accesspoint.png" size="100"/>\'); background-size:80%">'
																+ '</span>'
																+ '<span class="apt-name">'
																+ AccessArea.AccessAreaName
																+ '</span>'
																+ '<br/>'
																+ '<span class="apt-detail">'
																+ ''
																+ '</span>'
																+ '<br/>'
																+ '<span class="apt-detail">'
																+ ''
																+ '</span><br/><br/>';
														//peoplelisthtml += '<ul class="ios-list">';
														//------------------------------------------------------ performances loop -------------------------------------------
														$.each(AccessArea.PerformanceList,function(key2,Performance) {
																			//alert(JSON.stringify(Performance));
																			//peoplelisthtml += "<li class='performance' rel=''>"+
																			'<span class="thumb" style="background-image:url(\'<v:image-link name="calendar.png" size="100"/>\'); background-size:80%">'
																					+ '</span>'
																					+ '<span class="apt-name">'
																					+ Performance.PerformanceId
																					+ '</span>'
																					+ '<br/>'
																					+ '<span class="apt-detail">'
																					+ 'People inside: '
																					+ Performance.InsidePortfolioList.length
																					+ '</span>'
																					+ '<br/>'
																					+ '<span class="apt-detail">'
																					+ ''
																					+ '</span><br/><br/>';
																			//peoplelisthtml += '<ul class="ios-list">';
																			//------------------------------------------------------ entered people loop -------------------------------------------
																			$.each(Performance.InsidePortfolioList,function(key3,Portfolio) {
																								if (Portfolio.ProfilePictureId) {
																									var image = '<v:config key="site_url"/>/repository?id='
																											+ Portfolio.ProfilePictureId
																											+ '&type=small';
																								} else {
																									var image = '<v:image-link name="account_prs.png" size="100"/>';
																								}
																								peoplelisthtml += "<li class='people' rel=''>"
																										+ '<div id="apt-info" class="vblock">'
																										+ '<span class="thumb" style="background-image:url('
																										+ image
																										+ '); background-size:80%">'
																										+ '</span>'
																										+ '<span class="apt-name">'
																										+ Portfolio.AccountName
																										+ '</span>'
																										+ '<br/>'
																										+ '<span class="apt-detail">'
																										+ ''
																										+ '</span>'
																										+ '<br/>'
																										+ '<span class="apt-detail">'
																										+ ''
																										+ '</span><br/><br/>'
																										+ '</div>'
																										+ '</li>';
																							});
																			//------------------------------------------------------ end entered people loop -------------------------------------------
																			//peoplelisthtml += "</ul>";
																			//peoplelisthtml += "</li>";
																		});
														/*} else {
															mainactivity(mainactivity_step.createPerf);
														}*/
														//------------------------------------------------------ end performances loop -------------------------------------------
														//peoplelisthtml += "</ul>";
														//peoplelisthtml += "</li>";
														//------------------------------------------------------ end access area loop -------------------------------------------						
													});
									
									$('#ULpeoplelist').html(peoplelisthtml);
								});
						return false;

					});
</script>
