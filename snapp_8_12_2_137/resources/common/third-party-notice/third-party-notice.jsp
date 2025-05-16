<%@page import="com.vgs.web.library.VgsWebInit"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="pageBase" scope="request" class="com.vgs.web.page.PageThirdPartyNotice"/>
<jsp:useBean id="tpn" scope="request" class="com.vgs.snapp.dataobject.DOThirdPartyNotice"/>
<jsp:include page="../header.jsp"/>

<%!private DOThirdPartyNotice.DOLicenseTerm getLicense(DOThirdPartyNotice tpn, String licenceCode) {
  return tpn.LicenseTermList.getChildItem("Code", licenceCode);
}%>


<style>
  :root {
    --tpn-title-color: #2f5496;
  }
  
  @media print {
    body * {
      visibility: hidden;
    }
    .tpn-document, .tpn-document * {
      visibility: visible;
    }
    #adminbody {
      margin: 0;
    }
    .pagebreak { 
      page-break-before: always; 
      padding-top: 0 !important;
      margin-top: 50px !important;
    }
    .tpn-library-container {
      page-break-inside: avoid;
    }
    .tpn-license-file .tpn-license-title {
      page-break-after: avoid;
    }
    pre {
      page-break-inside: auto;
    }
  }
  
  .tpn-document {
    padding: 20px;
    font-size: 12pt;
    line-height: normal;
  }
  
  .tpn-title {
    color: var(--tpn-title-color);
    font-size: 2.0em;
    font-weight: bold;
    text-align: center;
    padding-top: 50px;
    padding-bottom: 25px;
  }
  
  .tpn-docver {
    text-align: center;
  }
  
  .tpn-section-title {
    color: var(--tpn-title-color);
    font-size: 1.4em;
    font-weight: bold;
    text-align: center;
    padding-top: 200px;
    padding-bottom: 50px;
  }
  
  .tpn-menu {
    padding-bottom: 20px;
  }
  
  .tpn-library-container {
    padding-top: 30px;
  }
  
  .tpn-library-title {
    font-weight: bold;
    border-bottom: 1px solid black;
  }
  
  .tpn-library-copyright,
  .tpn-library-license-caption {
    padding-top: 10px;
  }
  
  .tpn-license-disclaimer {
    margin-top: 10px;
  }
  
  .tpn-license pre {
    margin: auto;
    margin-top: 20px;
    width: 600px;
  }
  
  .tpn-license-title {
    padding-top: 50px;
    font-weight: bold;
    font-size: 1.2em;
    text-align: center;
  }
  
  .tpn-dev-table {
    margin-left: 20px;
  }
  
  .tpn-dev-table td {
    padding-right: 30px;
  }
  
  .tpn-dev-table thead td {
    font-weight: bold;
    border-bottom: 1px solid black;
  }
</style>


<div class="tpn-document">
  <div class="tpn-title">VGS Third Party Library Notice</div>
  <div class="tpn-docver">
    Third Party Libraries embedded into
      <a href="https://www.accesso.com/solutions/ticketing/ticketing-visitor-management" target="_new" class="snapp-info">
      Horizon by VGS <%=VgsWebInit.get(getServletContext()).getServletInit().DisplayVersion.getString()%> &mdash; &copy; 2023 accesso Technology Group, plc
    </a>
  </div>
  
  <div class="tpn-section">
    <div class="tpn-section-title">NOTICES AND INFORMATION</div>
      <p>Do Not Translate or Localize.</p>
      <p>This software incorporates material from third parties.</p>
      <p>Third Party licenses and references are included into the document when possible. Online links to the libraries download and license terms are included for convenience. In case of discrepancy between the provided references, or embedded licensing terms, and the official data or terms, the official versions prevail.</p>
      <p>Notwithstanding any other terms or information included hereafter, consult the official and specific software license to verify your rights on the use, debug and modification of the Third Party libraries referred in this document.</p>
      <p>Third Party software is embedded in this software as is without modifications. If desired, and subject to what permitted by the applicable licenses, copy of the code embedded into SnApp can be obtained using the provided links or any other links available online.</p>
      <p>To simplify the access to the license terms, and to avoid text redundancy, copy of the licenses terms and conditions are included in the last section of the document (“COPY OF THE LICENSES TERMS AND CONDITIONS”) and specifically referred within the description of each third party library based on their applicability.</p>
  </div>
  
  <!-- LIBRARIES -->
  <div class="tpn-section">
    <div class="tpn-section-title pagebreak">THIRD PARTY SOFTWARE</div>
    <ul class="tpn-menu">
    <% for (DOThirdPartyNotice.DOLibrary lib : tpn.LibraryList) { %>
      <li><a href="#library-<%=lib.Name.getString()%>"><%=lib.Name.getHtmlString()%> &mdash; v<%=lib.Version.getHtmlString()%></a></li>
    <% } %>    
    </ul>

    <div class="tpn-library-details pagebreak">
      <% for (DOThirdPartyNotice.DOLibrary lib : tpn.LibraryList) { %>
        <div class="tpn-library-container" id="library-<%=lib.Name.getString()%>">
          <div class="tpn-library-title"><%=lib.Name.getHtmlString()%> &mdash; v<%=lib.Version.getHtmlString()%></div>
          <div class="tpn-library-url"><a href="<%=lib.Url.getString()%>" target="_new"><%=lib.Url.getHtmlString()%></a></div>
          <div class="tpn-library-copyright"><%=lib.Copyright.getHtmlString()%></div>
          
          <div class="tpn-library-license-caption">Licenses:</div>
          <ul class="tpn-library-license-list">
          <% for (String licenceCode : lib.LicenseTerms.getArray()) { %>
            <% DOThirdPartyNotice.DOLicenseTerm lic = getLicense(tpn, licenceCode); %>
            <li class="tpn-library-license"><a href="#license-<%=lic.Code.getString()%>"><%=lic.Name.getHtmlString()%></a></li>
          <% } %>
          </ul>
          
          <% if (!lib.DepLicenseTerms.isEmpty()) { %>
            <div class="tpn-library-license-caption">Includes various dependencies licensed under the license terms of:</div>
            <ul class="tpn-library-license-list">
            <% for (String licenceCode : lib.DepLicenseTerms.getArray()) { %>
              <% DOThirdPartyNotice.DOLicenseTerm lic = getLicense(tpn, licenceCode); %>
              <li class="tpn-library-license"><a href="#license-<%=lic.Code.getString()%>"><%=lic.Name.getHtmlString()%></a></li>
            <% } %>
            </ul>
          <% } %>
          
          <% if (!lib.DeveloperList.isEmpty()) { %>
            <div class="tpn-library-license-caption">Developers:</div>
            <table class="tpn-dev-table">
              <thead>
                <tr>
                  <td>Name</td>
                  <td>Email</td>
                  <td>Dev ID</td>
                  <td>Roles</td>
                  <td>Organization</td>
                </tr>
              </thead>
              <tbody>
              <% for (DOThirdPartyNotice.DOLibrary.DODeveloperRef dev : lib.DeveloperList) { %>
                <tr>
                  <td><%=dev.Name.getHtmlString()%></td>
                  <td><%=dev.Email.getHtmlString()%></td>
                  <td><%=dev.DevID.getHtmlString()%></td>
                  <td><%=dev.Roles.getHtmlString()%></td>
                  <td><%=dev.Organization.getHtmlString()%></td>
                </tr>
              <% } %>
              </tbody>
            </table>
          <% } %>
          
          <% if (!lib.Notes.isEmpty()) { %>
            <div class="tpn-library-notes">
            <% for (String note : lib.Notes.getArray()) { %>
              <%=JvString.escapeHtml(note)%><br/>
            <% } %>
            </div>
          <% } %>
        </div>
      <% } %>
    </div>
  
  <!-- LICENSES -->
  <div class="tpn-section">
    <div class="tpn-section-title pagebreak">LICENSES</div>
      <ul class="tpn-menu">
      <% for (DOThirdPartyNotice.DOLicenseTerm lic : tpn.LicenseTermList) { %>
        <li><a href="#license-<%=lic.Code.getString()%>"><%=lic.Name.getHtmlString()%></a></li>
      <% } %>    
      </ul>
    </div>
  </div>

  <% for (DOThirdPartyNotice.DOLicenseTerm lic : tpn.LicenseTermList) { %>
    <div class="tpn-section tpn-license" id="license-<%=lic.Code.getString()%>">
      <div class="tpn-section-title pagebreak"><%=lic.Name.getHtmlString()%></div>
      <div class="tpn-license-link">Online version: <a href="<%=lic.Url.getString()%>"><%=lic.Url.getHtmlString()%></a></div>
      <div class="tpn-license-disclaimer">
        <div style="text-decoration:underline">Note:</div>
        T&amp;C are here included for convenience. Refer to the online link embedded in each section for the most updated T&amp;C online version.<br/>
        In case of discrepancies between the document included and the official online version, the online version prevails.<br/>
      </div>
      
      <% for (DOThirdPartyNotice.DOLicenseTerm.DOLicenseTermFilePart file : lic.FileList) { %>
        <div class="tpn-license-file">
          <% if (!file.Title.isNull()) { %>
            <div class="tpn-license-title"><%=file.Title.getHtmlString()%></div>
          <% } %>
          <pre><%=JvString.loadStringFromStream(getServletContext().getResourceAsStream("/resources/common/third-party-notice/license-files/" + file.FileName.getString()))%></pre>
        </div>
      <% } %>
    </div>
  <% } %>

</div>

<jsp:include page="../footer.jsp"/>
