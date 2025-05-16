<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="com.vgs.web.library.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.cl.lookup.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.cl.document.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>
<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>
<jsp:useBean id="rights" class="com.vgs.snapp.dataobject.DORightRoot" scope="request"/>

<% List<DOFont> availableFontList = pageBase.getBL(BLBO_Font.class).getPdfFonts(); %>

<div class="snp-page-properties snp-section">
    <h1>Page</h1>
    <div class="snp-property">
      <label for="page-title">Title</label>
      <div class="snp-property-value">
        <input id="page-title" type="text">
      </div>
    </div>
    <div class="snp-property">
      <label for="page-unitofmeasure">Unit of measure</label>
      <div class="snp-property-value">
        <input id="page-unitofmeasure" type="text" value="cm" readonly disabled>
      </div>
    </div>
    <div class="snp-property">
      <label for="page-pagewidth">Width</label>
      <div class="snp-property-value">
        <input id="page-pagewidth" type="number" step="0.01" min="0" required>
      </div>
    </div>
    <div class="snp-property">
      <label for="page-pageheight">Height</label>
      <div class="snp-property-value">
        <input id="page-pageheight" type="number" step="0.01" min="0" required>
      </div>
    </div>
    <div class="snp-property">
      <label for="page-margintop">Margin top</label>
      <div class="snp-property-value">
        <input id="page-margintop" type="number" step="0.01" min="0" required>
      </div>
    </div>
    <div class="snp-property">
      <label for="page-marginright">Margin right</label>
      <div class="snp-property-value">
        <input id="page-marginright" type="number" step="0.01" min="0" required>
      </div>
    </div>
    <div class="snp-property">
      <label for="page-marginbottom">Margin bottom</label>
      <div class="snp-property-value">
        <input id="page-marginbottom" type="number" step="0.01" min="0" required>
      </div>
    </div>
    <div class="snp-property">
      <label for="page-marginleft">Margin left</label>
      <div class="snp-property-value">
        <input id="page-marginleft" type="number" step="0.01" min="0" required>
      </div>
    </div>
    <div class="snp-property">
      <label for="page-defaultfontsize">Default Font size</label>
      <div class="snp-property-value">
        <input id="page-defaultfontsize" type="number" step="0.5" min="0" required>
      </div>
    </div>
    <div class="snp-property">
      <label for="page-includepageheader">Include header</label>
      <div class="snp-property-value">
        <select id="page-includepageheader">
          <option value="true">Yes</option>
          <option value="false">No</option>
        </select>
      </div>
    </div>
    <div class="snp-property">
      <label for="page-includepagefooter">Include footer</label>
      <div class="snp-property-value">
        <select id="page-includepagefooter">
          <option value="true">Yes</option>
          <option value="false">No</option>
        </select>
      </div>
    </div>
  </div>
  
  <div class="snp-band-properties snp-section">
    <h1>Band</h1>
    <div class="snp-property">
      <label for="band-bandtype">Band type</label>
      <div class="snp-property-value">
        <input id="band-bandtype" type="text" readonly disabled>
      </div>
    </div>
    <div class="snp-property">
      <label for="band-comp-height">Height</label>
      <div class="snp-property-value">
        <input id="band-comp-height" type="number" step="0.01" min="0" required>
      </div>
    </div>
    <div class="snp-property">
      <label for="band-datasourcename">Datasource name</label>
      <div class="snp-property-value">
        <select id="band-datasourcename">
          <option></option>
        </select>
      </div>
    </div>
    <div class="snp-property">
      <label for="band-indexvars">Index vars</label>
      <div class="snp-property-value snp-prop-with-btn">
        <input id="band-indexvars" type="text"><button class="snp-multi-select-btn snp-input-btn">&hellip;</button>
      </div>
    </div>
    <div class="snp-property snp-text-property">
      <label for="comp-text" title="Valid only on 'detail' bands and when 'datasource' is specified, it is used along with 'Filter B' where the resulting value of 'Filter A' and 'Filter B' need to be the same in order to print the dataset record">Filter A</label>
      <div class="snp-property-value snp-prop-with-btn">
        <input id="band-filtera" type="text"><button class="snp-text-editor snp-input-btn">&hellip;</button>
      </div>
    </div>
    <div class="snp-property snp-text-property">
      <label for="comp-text" title="Valid only on 'detail' bands and when 'datasource' is specified, it is used along with 'Filter A' where the resulting value of 'Filter A' and 'Filter B' need to be the same in order to print the dataset record">Filter B</label>
      <div class="snp-property-value snp-prop-with-btn">
        <input id="band-filterb" type="text"><button class="snp-text-editor snp-input-btn">&hellip;</button>
      </div>
    </div>
    <div class="snp-property snp-property-checkbox">
      <label for="band-forcenewpage">Force new page</label>
      <div class="snp-property-value">
        <input id="band-forcenewpage" type="checkbox">
      </div>
    </div>
    <div class="snp-property snp-property-checkbox">
      <label for="band-groupchangeonly">Group change only</label>
      <div class="snp-property-value">
        <input id="band-groupchangeonly" type="checkbox">
      </div>
    </div>
    <div class="snp-property">
      <label for="band-comp-backgroundcolor">Bg color</label>
      <div class="snp-property-value">
        <input id="band-comp-backgroundcolor" type="color"> <span class="snp-unset-color">X</span>
      </div>
    </div>
  </div>
  <div class="snp-band-properties snp-section">
    <h1>Borders</h1>
    <div class="snp-property">
      <label for="band-comp-bordertopcolor">Border top color</label>
      <div class="snp-property-value">
        <input id="band-comp-bordertopcolor" type="color"> <span class="snp-unset-color">X</span>
      </div>
    </div>
    <div class="snp-property">
      <label for="band-comp-bordertopwidth">Border top width</label>
      <div class="snp-property-value">
        <input id="band-comp-bordertopwidth" type="number" min="0" step="0.5">
      </div>
    </div>
    <div class="snp-property">
      <label for="band-comp-borderrightcolor">Border right color</label>
      <div class="snp-property-value">
        <input id="band-comp-borderrightcolor" type="color"> <span class="snp-unset-color">X</span>
      </div>
    </div>
    <div class="snp-property">
      <label for="band-comp-borderrightwidth">Border right width</label>
      <div class="snp-property-value">
        <input id="band-comp-borderrightwidth" type="number" min="0" step="0.5">
      </div>
    </div>
    <div class="snp-property">
      <label for="band-comp-borderbottomcolor">Border bottom color</label>
      <div class="snp-property-value">
        <input id="band-comp-borderbottomcolor" type="color"> <span class="snp-unset-color">X</span>
      </div>
    </div>
    <div class="snp-property">
      <label for="band-comp-borderbottomwidth">Border bottom width</label>
      <div class="snp-property-value">
        <input id="band-comp-borderbottomwidth" type="number" min="0" step="0.5">
      </div>
    </div>
    <div class="snp-property">
      <label for="band-comp-borderleftcolor">Border left color</label>
      <div class="snp-property-value">
        <input id="band-comp-borderleftcolor" type="color"> <span class="snp-unset-color">X</span>
      </div>
    </div>
    <div class="snp-property">
      <label for="band-comp-borderleftwidth">Border left width</label>
      <div class="snp-property-value">
        <input id="band-comp-borderleftwidth" type="number" min="0" step="0.5">
      </div>
    </div>
  </div>
  
  <div class="snp-comp-properties snp-section">
    <h1>Info</h1>
    <div class="snp-property">
      <label for="comp-bulk-count">Selected count</label>
      <div class="snp-property-value">
        <input id="comp-bulk-count" type="number" step="1" min="0" readonly disabled>
      </div>
    </div>
  </div>
  
  <div class="snp-comp-properties snp-section">
    <h1>Component</h1>
    <div class="snp-property">
      <label for="comp-type">Type</label>
      <div class="snp-property-value">
        <input id="comp-type" type="text" disabled readonly>
      </div>
    </div>
    <div class="snp-property">
      <label for="comp-width">Width</label>
      <div class="snp-property-value">
        <input id="comp-width" type="number" step="0.01" min="0" required>
      </div>
    </div>
    <div class="snp-property">
      <label for="comp-height">Height</label>
      <div class="snp-property-value">
        <input id="comp-height" type="number" step="0.01" min="0" required>
      </div>
    </div>
    <div class="snp-property">
      <label for="comp-x">Left</label>
      <div class="snp-property-value">
        <input id="comp-x" type="number" step="0.01" min="0" required>
      </div>
    </div>
    <div class="snp-property">
      <label for="comp-y">Top</label>
      <div class="snp-property-value">
        <input id="comp-y" type="number" step="0.01" min="0" required>
      </div>
    </div>
    <div class="snp-property snp-text-property">
      <label for="comp-text">Text</label>
      <div class="snp-property-value snp-prop-with-btn">
        <input id="comp-text" type="text"><button class="snp-text-editor snp-input-btn">...</button>
      </div>
    </div>
    <div class="snp-property snp-image-property">
      <label for="comp-image">Images</label>
      <div class="snp-property-value snp-prop-with-btn">
        <select id="comp-image">
        </select>
      </div>
    </div>
    <div class="snp-property snp-resizestyle-property">
      <label for="comp-resizestyle"><v:itl key="@DocTemplate.ResizeStyle"/></label>
      <div class="snp-property-value snp-prop-with-btn">
        <select id="comp-resizestyle">
          <option value="unset"><v:itl key="@Common.None"/></option>
          <option value="cover"><v:itl key="@DocTemplate.ResizeStyle_Cover"/></option>
          <option value="contain"><v:itl key="@DocTemplate.ResizeStyle_Contain"/></option>
        </select>
      </div>
    </div>
    <div class="snp-property">
      <label for="comp-fontsize">Font size</label>
      <div class="snp-property-value">
        <input id="comp-fontsize" type="number" step="0.5" min="0">
      </div>
    </div>
    <div class="snp-property">
      <label for="comp-fontname">Font name</label>
      <div class="snp-property-value">
        <select id="comp-fontname">
          <option label=" "></option>
          <% for (DOFont font : availableFontList) { %>
            <% String name = font.FontName.getHtmlString(); %>
            <option value="<%=name%>"><%=name%></option>
          <% } %>
        </select>
      </div>
    </div>
    <div class="snp-property">
      <label for="comp-fontcolor">Font color</label>
      <div class="snp-property-value">
        <input id="comp-fontcolor" type="color"> <span class="snp-unset-color">X</span>
      </div>
    </div>
    <div class="snp-property">
      <label for="comp-backgroundcolor">Bg color</label>
      <div class="snp-property-value">
        <input id="comp-backgroundcolor" type="color"> <span class="snp-unset-color">X</span>
      </div>
    </div>
    <div class="snp-property">
      <label for="comp-rotation">Rotation</label>
      <div class="snp-property-value">
        <input id="comp-rotation" type="number" step="1" min="0">
      </div>
    </div>
  </div>
  <div class="snp-comp-properties snp-section">
    <h1>Borders</h1>
    <div class="snp-property">
      <label for="comp-bordertopcolor">Border top color</label>
      <div class="snp-property-value">
        <input id="comp-bordertopcolor" type="color"> <span class="snp-unset-color">X</span>
      </div>
    </div>
    <div class="snp-property">
      <label for="comp-bordertopwidth">Border top width</label>
      <div class="snp-property-value">
        <input id="comp-bordertopwidth" type="number" min="0" step="0.5">
      </div>
    </div>
    <div class="snp-property">
      <label for="comp-borderrightcolor">Border right color</label>
      <div class="snp-property-value">
        <input id="comp-borderrightcolor" type="color"> <span class="snp-unset-color">X</span>
      </div>
    </div>
    <div class="snp-property">
      <label for="comp-borderrightwidth">Border right width</label>
      <div class="snp-property-value">
        <input id="comp-borderrightwidth" type="number" min="0" step="0.5">
      </div>
    </div>
    <div class="snp-property">
      <label for="comp-borderbottomcolor">Border bottom color</label>
      <div class="snp-property-value">
        <input id="comp-borderbottomcolor" type="color"> <span class="snp-unset-color">X</span>
      </div>
    </div>
    <div class="snp-property">
      <label for="comp-borderbottomwidth">Border bottom width</label>
      <div class="snp-property-value">
        <input id="comp-borderbottomwidth" type="number" min="0" step="0.5">
      </div>
    </div>
    <div class="snp-property">
      <label for="comp-borderleftcolor">Border left color</label>
      <div class="snp-property-value">
        <input id="comp-borderleftcolor" type="color"> <span class="snp-unset-color">X</span>
      </div>
    </div>
    <div class="snp-property">
      <label for="comp-borderleftwidth">Border left width</label>
      <div class="snp-property-value">
        <input id="comp-borderleftwidth" type="number" min="0" step="0.5">
      </div>
    </div>
  </div>
  <div class="snp-comp-properties snp-section snp-barcode">
    <h1>Barcode</h1>
    <div class="snp-property">
      <label for="comp-barcodetype">Barcode type</label>
      <div class="snp-property-value">
        <select id="comp-barcodetype">
          <option value="">Barcode 128</option>
          <option value="qrcode">QR code</option>
        </select>
      </div>
    </div>
  </div>
