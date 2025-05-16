<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@page import="com.vgs.snapp.query.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>


<jsp:useBean id="pageBase" class="com.vgs.web.page.PageMobileAptPicture" scope="request"/>
<jsp:useBean id="account" scope="request" class="com.vgs.snapp.dataobject.DOAccount"/>
<!DOCTYPE html> 
<html> 
<head> 
  <title>Mobile VGS</title> 
  
  <meta name="viewport" content="width=device-width, initial-scale=1"> 
  <meta http-equiv="X-Frame-Options" content="SAMEORIGIN">

  <link rel="stylesheet" href="<v:config key="resources_url"/>/mobile/jquery/jquery.mobile-1.1.1.min.css" />
  <link type="text/css" href="<v:config key="resources_url"/>/mobile/css/mobile-css.jsp" rel="stylesheet" media="all" />
  <script type="text/javascript" src="<v:config key="site_url"/>/libraries/jquery/jquery-2.2.0.min.js"></script>
  <script src="<v:config key="resources_url"/>/mobile/jquery/jquery.mobile-1.1.1.min.js"></script>
  <script type="text/javascript" src="<v:config key="resources_url"/>/mobile/script/admin-js.jsp"></script>
  <script type="text/javascript" src="<v:config key="resources_url"/>/mobile/script/WebHub.js"></script> 
  
</head> 

<body> 

  <!-- Header -->
  <div id="header" data-role="header" data-position="fixed" data-theme="c">
    <a href="javascript:history.back();" class="ui-btn-right"><v:itl key="@Common.Done"/></a>
    <h1><v:itl key="Account picture"/></h1>
  </div>
  
  <!-- Body -->
  <div data-role="content">
    <div id="account-pic" style="width:100%; height:100%"></div>
  </div>

  <!-- Footer -->
  <div id="footer" data-role="footer" data-position="fixed" data-theme="c">
    <a href="javascript:takePicture();" class="ui-btn-left"><v:itl key="@Common.New"/></a>
    <h1>&nbsp;</h1>
  </div>
  
  <style>
    [data-role="content"] {
      margin: 0px;
      padding: 0px;
    }
    
    #account-pic {
      background-image: url('<v:config key="site_url"/>/repository?id=<%=account.ProfilePictureId.getEmptyString()%>&type=medium>');
      background-repeat: no-repeat;
      background-size: 100% auto;
      background-position: top center;
    }
  </style>
  
  <script>

    $(document).ready(function() {
      <% if (account.ProfilePictureId.isNull()) { %>
      takePicture();
      <% } else { %>
        var h = $("body").height() - $("#header").height() - $("#footer").height() - 5;
        $("#account-pic").css("height", h + "px");
      <% } %>
    });

//    var is_android = /Android/i.test(navigator.userAgent);
    
    function takePicture() {
    	alert(1);
        NativeBridge.call("CaptureImage", ["onUpdateRegistrationImageCapture"], null);
    }
    
    function onUpdateRegistrationImageCapture(imageData) {
//    	  var takenImage = imageData;
//    	  $("#existSaveAccount .ProfilePictureId").attr("src","data:image/png;base64,"+takenImage);
      var reqDO = {
              Command: 'Save',
              Save: {
                  EntityType: <%=LkSNEntityType.Person.getCode()%>,
                  EntityId: <%=account.ProfilePictureId.getString()%>,
                  Description: 'Profile picture',
                  FileName: 'Image.jpg',
                  DocData: unescape(imageData).replace(/[\n\r]+/g, '').replace(/\s{2,10}/g, ' '),
                  ProfilePicture: true
                }
            };
    }
    
    function pictureDone() {
      window.location = "<v:config key="site_url"/>/admin?page=mobile_apt";
    }
    
    function testPicture(entityType, entityId, imageData) {
      alert("test picture");
    }
    
    function reloadPage() {
       $.mobile.showPageLoadingMsg();
       location.reload(true);
     }
    
    function savePicture(entityType, entityId, imageData) {  
        var reqDO = {
          Command: 'Save',
          Save: {
                  EntityType: entityType,
                  EntityId: entityId,
                  Description: 'Profile picture',
                  FileName: 'Image.jpg',
                  DocData: unescape(imageData),
                  ProfilePicture: true
                }
        };
        
        vgsService("Repository", reqDO, false, function() { pictureDone();});
    }


  </script>
 </body>

</html>  
