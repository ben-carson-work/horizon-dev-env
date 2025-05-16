<%@page import="com.vgs.dataobject.*"%>
<%@page import="java.util.*"%>
<%@page import="com.vgs.entity.dataobject.*"%>
<%@page import="com.vgs.cl.*"%>
<%@page import="com.vgs.snapp.library.*"%>
<%@page import="com.vgs.snapp.dataobject.*"%>
<%@page import="com.vgs.web.tag.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="vgs-tags" prefix="v" %>
<%@ taglib uri="snp-tags" prefix="snp" %>

<jsp:useBean id="pageBase" class="com.vgs.snapp.web.common.page.PageCommonWidget" scope="request"/>

<div class="tab-content">

  <v:widget caption="Constants">
    <v:widget-block>
      <table>
        <tr>
          <td>Variable header</td>
          <td><%=JvString.htmlEncode(DocTemplateParser.VARIABLE_HEADER)%></td>
        </tr>
        <tr>
          <td>Variable terminator</td>
          <td><%=JvString.htmlEncode(DocTemplateParser.TAG_TERMINATOR)%></td>
        </tr>
        <tr>
          <td>Declaration header</td>
          <td><%=JvString.htmlEncode(DocTemplateParser.DECLARATION_HEADER)%></td>
        </tr>
        <tr>
          <td>Declaration terminator</td>
          <td><%=JvString.htmlEncode(DocTemplateParser.TAG_TERMINATOR)%></td>
        </tr>
        <tr>
          <td>Parameter header</td>
          <td><%=JvString.htmlEncode(DocTemplateParser.PARAM_HEADER)%></td>
        </tr>
        <tr>
          <td>Parameter terminator</td>
          <td><%=JvString.htmlEncode(DocTemplateParser.PARAM_TERMINATOR)%></td>
        </tr>
        <tr>
          <td>List start</td>
          <td><%=JvString.htmlEncode(DocTemplateParser.VARIABLE_HEADER + DocTemplateParser.LIST_START + DocTemplateParser.TAG_TERMINATOR)%></td>
        </tr>
        <tr>
          <td>List end</td>
          <td><%=JvString.htmlEncode(DocTemplateParser.LIST_END)%></td>
        </tr>
        <tr>
          <td>If start</td>
          <td><%=JvString.htmlEncode(DocTemplateParser.VARIABLE_HEADER + DocTemplateParser.IF_START + DocTemplateParser.TAG_TERMINATOR)%></td>
        </tr>
        <tr>
          <td>If end</td>
          <td><%=JvString.htmlEncode(DocTemplateParser.IF_END)%></td>
        </tr>
        <tr>
          <td>Link start</td>
          <td><%=JvString.htmlEncode(DocTemplateParser.VARIABLE_HEADER + DocTemplateParser.LINK_START + DocTemplateParser.TAG_TERMINATOR)%></td>
        </tr>
        <tr>
          <td>Link end</td>
          <td><%=JvString.htmlEncode(DocTemplateParser.LINK_END)%></td>
        </tr>
      </table>
    </v:widget-block>
  </v:widget>

  <v:widget caption="Examples">
    <v:widget-block>
      <h3>Variable</h3>
      <p><%=JvString.htmlEncode(DocTemplateParser.VARIABLE_HEADER)%>FieldName<%=JvString.htmlEncode(DocTemplateParser.TAG_TERMINATOR)%><br/>
      Account profile image: <%=JvString.htmlEncode(DocTemplateParser.VARIABLE_HEADER)%>DynAccount.ProfilePicture<%=JvString.htmlEncode(DocTemplateParser.TAG_TERMINATOR)%></p>
      <h3>Variable with parameters</h3>
      <p><%=JvString.htmlEncode(DocTemplateParser.VARIABLE_HEADER)%>FieldName<%=JvString.htmlEncode(DocTemplateParser.PARAM_HEADER)%>
      caption:'Reprinted on: '; hideifempty:true; format:CurrencySymbol; transform:uppercase; width:32; align:right<%=JvString.htmlEncode(DocTemplateParser.PARAM_TERMINATOR + DocTemplateParser.TAG_TERMINATOR)%><br/>
      Image from repository: <%=JvString.htmlEncode(DocTemplateParser.VARIABLE_HEADER)%>Template.RepositoryList <%=JvString.htmlEncode(DocTemplateParser.PARAM_HEADER)%>fieldcode:VGS_LOGO<%=JvString.htmlEncode(DocTemplateParser.PARAM_TERMINATOR + DocTemplateParser.TAG_TERMINATOR)%></p>
      <h3>Datasource declaration</h3>
      <p>[#DataSetName {field:FieldName;ClassName:FullClassName;}]<br/>
      [#req {field:Upload.MsgRequest;ClassName:com.vgs.service.dataobject.DOCmd_PostTransaction;}]</p>
      <h3>List</h3>
      <p><%=JvString.htmlEncode(DocTemplateParser.VARIABLE_HEADER + DocTemplateParser.LIST_START + DocTemplateParser.PARAM_HEADER)%>ds:ListName<%=JvString.htmlEncode(DocTemplateParser.PARAM_TERMINATOR + DocTemplateParser.TAG_TERMINATOR)%>
      <br/>&nbsp;&nbsp;...
      <br/>&nbsp;&nbsp;<%=JvString.htmlEncode(DocTemplateParser.VARIABLE_HEADER)%>ListName.FieldName<%=JvString.htmlEncode(DocTemplateParser.TAG_TERMINATOR)%>
      <br/>&nbsp;&nbsp;...
      <br/><%=JvString.htmlEncode(DocTemplateParser.LIST_END)%>
      </p>
      <h3>If</h3>
      <p><%=JvString.htmlEncode(DocTemplateParser.VARIABLE_HEADER + DocTemplateParser.IF_START + DocTemplateParser.PARAM_HEADER)%>fieldname:FieldName; fieldvalue:ValueToTest; [operator:greater|greater_equals|equals|minor|minor_equals]<%=JvString.htmlEncode(DocTemplateParser.PARAM_TERMINATOR + DocTemplateParser.TAG_TERMINATOR)%>
      <br/>&nbsp;&nbsp;...
      <br/>&nbsp;&nbsp;<%=JvString.htmlEncode(DocTemplateParser.VARIABLE_HEADER)%>FieldName<%=JvString.htmlEncode(DocTemplateParser.TAG_TERMINATOR)%>
      <br/>&nbsp;&nbsp;...
      <br/><%=JvString.htmlEncode(DocTemplateParser.IF_END)%>
      </p>
      <h3>Link (only for internal use)</h3>
      <p><%=JvString.htmlEncode(DocTemplateParser.VARIABLE_HEADER + DocTemplateParser.LINK_START + DocTemplateParser.PARAM_HEADER)%>entityType:EntityTypeFieldName; entityId:EntityIdFieldName; entityTooltip:true; openOnNewTab:false<%=JvString.htmlEncode(DocTemplateParser.PARAM_TERMINATOR + DocTemplateParser.TAG_TERMINATOR)%>
      <br/>&nbsp;&nbsp;...
      <br/>&nbsp;&nbsp;<%=JvString.htmlEncode(DocTemplateParser.VARIABLE_HEADER)%>FieldName<%=JvString.htmlEncode(DocTemplateParser.TAG_TERMINATOR)%>
      <br/>&nbsp;&nbsp;...
      <br/><%=JvString.htmlEncode(DocTemplateParser.LINK_END)%>
      </p>
      <h3>Configuration variable</h3>
      <p><%=JvString.htmlEncode(DocTemplateParser.VARIABLE_HEADER + DocTemplateParser.DS_CONFIG)%>.FieldName<%=JvString.htmlEncode(DocTemplateParser.TAG_TERMINATOR)%></p>
      <h3>Language variable</h3>
      <p><%=JvString.htmlEncode(DocTemplateParser.VARIABLE_HEADER + DocTemplateParser.DS_LANG)%>.FieldName<%=JvString.htmlEncode(DocTemplateParser.TAG_TERMINATOR)%></p>
    </v:widget-block>
  </v:widget>

  <v:widget caption="Formatting numbers">
    <v:widget-block>
      <p>Number formatting follows JAVA formatting standards. Here's an extract:</p>
      <v:grid>
        <thead>
          <tr>
            <td>Value</td>
            <td>Pattern</td>
            <td>Output</td>
            <td>Explanation</td>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>123456.789</td>
            <td>###,###.###</td>
            <td>123,456.789</td>
            <td>The pound sign (#) denotes a digit, the comma is a placeholder for the grouping separator, and the period is a placeholder for the decimal separator.</td>
          </tr>
          <tr>
            <td>123456.789</td>
            <td>###.##</td>
            <td>123456.79</td>
            <td>The <b>value</b> has three digits to the right of the decimal point, but the <b>pattern</b> has only two. The <b>format</b> method handles this by rounding up.</td>
          </tr>
          <tr>
            <td>123.78</td>
            <td>000000.000</td>
            <td>000123.780</td>
            <td>The <b>pattern</b> specifies leading and trailing zeros, because the 0 character is used instead of the pound sign (#).</td>
          </tr>
          <tr>
            <td>12345.67</td>
            <td>$###,###.###</td>
            <td>$12,345.67</td>
            <td>The first character in the <b>pattern</b> is the dollar sign ($). Note that it immediately precedes the leftmost digit in the formatted <b>output</b>.</td>
          </tr>
        </tbody>
      </v:grid> 
    </v:widget-block>
  </v:widget>

  <v:widget caption="Parameters">
    <v:widget-block>
      <ul>
        <li>
          <div class="help-doc-paramname"><%=JvString.htmlEncode(DocTemplateParser.PARAM_FIELDCODE)%></div>
          <div class="help-doc-description">Identifies a field by code into a custom fields list.</div>
          <div class="help-doc-description">Accepted string values.</div>
        </li>
        <li>
          <div class="help-doc-paramname"><%=JvString.htmlEncode(DocTemplateParser.PARAM_SHOWITEMNAME)%></div>
          <div class="help-doc-description">Used with <span class="help-doc-paramname"><%=JvString.htmlEncode(DocTemplateParser.PARAM_FIELDCODE)%></span> show the item name instead the code.</div>
          <div class="help-doc-description">Example:</div>
          <div class="help-doc-description">[@Ticket.MetaDataList {fieldcode:FT61}] will show "IT"</div>
          <div class="help-doc-description">[@Ticket.MetaDataList {fieldcode:FT61;showitemname:true}] will show "Italian"</div>
        </li>
        <li>
          <div class="help-doc-paramname"><%=JvString.htmlEncode(DocTemplateParser.PARAM_FIELDTYPE)%></div>
          <div class="help-doc-description">Identifies a field by type into a custom fields list.</div>
          <div class="help-doc-description">Accepted string values.</div>
        </li>
        <li>
          <div class="help-doc-paramname"><%=JvString.htmlEncode(DocTemplateParser.PARAM_FORMAT)%></div>
          <div class="help-doc-description">Format the variable value according to the value of the parameter.</div>
          <div class="help-doc-description">Accepted values for numeric fields: <span class="help-doc-paramname">Currency, CurrencySymbol, CurrencyCents</span>.</div>
          <div class="help-doc-description">Accepted values for date/time fields: <span class="help-doc-paramname">ShortDate, ShortTime, LongDate, ShortDateTime, LongDateTime</span>.</div>
        </li>
        <li>
          <div class="help-doc-paramname"><%=JvString.htmlEncode(DocTemplateParser.PARAM_TRANSFORM)%></div>
          <div class="help-doc-description">Converts all of the characters in this String to upper or lower case according to the value of the parameter.</div>
          <div class="help-doc-description">Accepted values: <span class="help-doc-paramname">uppercase, lowercase</span>.</div>
        </li>
        <li>
          <div class="help-doc-paramname"><%=JvString.htmlEncode(DocTemplateParser.PARAM_MATH)%></div>
          <div class="help-doc-description">For numeric fields only, apply mathematical operations.</div>
          <div class="help-doc-description">Accepted values: <span class="help-doc-paramname">absolute, opposite</span>.</div>
        </li>
        <li>
          <div class="help-doc-paramname"><%=JvString.htmlEncode(DocTemplateParser.PARAM_OPERATOR)%></div>
          <div class="help-doc-description">Accepted values: <span class="help-doc-paramname">greater, greater_equals, equals, minor, minor_equals</span>.</div>
          <div class="help-doc-description">For numeric fields only, apply to if operator only.</div>
          <div class="help-doc-description">This parameter is not mandatory. When not present, variables will be compared as strings.</div>
          <div class="help-doc-description"> <b>greater</b>: condition is verified when <b>FieldName</b> numeric value is greater than <b>ValueToTest</b> numeric value.</div>
          <div class="help-doc-description"> <b>greater_equals</b>: condition is verified when <b>FieldName</b> numeric value is greater or equal to <b>ValueToTest</b> numeric value.</div>
          <div class="help-doc-description"> <b>equals</b>: condition is verified when <b>FieldName</b> numeric value is equal to <b>ValueToTest</b> numeric value.</div>
          <div class="help-doc-description"> <b>minor</b>: condition is verified when <b>FieldName</b> numeric value is minor than <b>ValueToTest</b> numeric value.</div>
          <div class="help-doc-description"> <b>minor_equals</b>: condition is verified when <b>FieldName</b> numeric value is minor or equal to <b>ValueToTest</b> numeric value.</div>
        </li>        
        <li>
          <div class="help-doc-paramname"><%=JvString.htmlEncode(DocTemplateParser.PARAM_WIDTH)%></div>
          <div class="help-doc-description">Sets the string length of the variable's content to the parameter value, filling the missing characters with spaces.</div>
        </li>
        <li>
          <div class="help-doc-paramname"><%=JvString.htmlEncode(DocTemplateParser.PARAM_ALIGN)%></div>
          <div class="help-doc-description">Sets the horizontal alignment of the variable's content.</div>
          <div class="help-doc-description">Accepted values: <span class="help-doc-paramname">right, center</span>.</div>
        </li>
        <li>
          <div class="help-doc-paramname"><%=JvString.htmlEncode(DocTemplateParser.PARAM_PRINT_LENGTH)%></div>
          <div class="help-doc-description">Prints the variable length instead of the variable value. The parameter value will be added to the variable length.</div>
          <div class="help-doc-description">Accepted numeric values.</div>
        </li>
        <li>
          <div class="help-doc-paramname"><%=JvString.htmlEncode(DocTemplateParser.PARAM_AGGREGATE)%></div>
          <div class="help-doc-description">Aggregate the values of a list using the formula entered as value of the parameter.</div>
          <div class="help-doc-description">Accepted values: <span class="help-doc-paramname">sum, cnt, min, max, avg</span>.</div>
        </li>
        <li>
          <div class="help-doc-paramname"><%=JvString.htmlEncode(DocTemplateParser.PARAM_CAPTION)%></div>
          <div class="help-doc-description">String to be added before the variable value.</div>
          <div class="help-doc-description">Accepted string values.</div>
        </li>
        <li>
          <div class="help-doc-paramname"><%=JvString.htmlEncode(DocTemplateParser.PARAM_HIDE_IF_EMPTY)%></div>
          <div class="help-doc-description">Hides the caption if the variable value is empty.</div>
          <div class="help-doc-description">Example: [@Transaction.ReprintDateTime {caption:'Reprinted on: '; hideifempty:true; format:ShortDateTime}]</div>
        </li>
        <li>
          <div class="help-doc-paramname"><%=JvString.htmlEncode(DocTemplateParser.PARAM_REPLACE_WITH_IF_EMPTY)%></div>
          <div class="help-doc-description">Replace the content value if the variable value is empty.</div>
          <div class="help-doc-description">Example: [@AccountName {replacewithifempty:—}]</div>
        </li>
        <li>
          <div class="help-doc-paramname"><%=JvString.htmlEncode(DocTemplateParser.PARAM_AUTOWRAP)%></div>
          <div class="help-doc-description">Wrap the items of a list on a new line. Default: true.</div>
          <div class="help-doc-description">Example: [@liststart {ds:Portfolio.ProductList; autowrap:false}]</div>
        </li>
        <li>
          <div class="help-doc-paramname"><%=JvString.htmlEncode(DocTemplateParser.PARAM_FILTERFIELD)%></div>
          <div class="help-doc-description">Name of the field on which apply the filter. Needs parameter "FilterValue" to work.</div>
        </li>
        <li>
          <div class="help-doc-paramname"><%=JvString.htmlEncode(DocTemplateParser.PARAM_FILTERVALUE)%></div>
          <div class="help-doc-description">Name of the field on which apply the filter. Needs parameter "FilterField" to work.</div>
        </li>
        <li>
          <div class="help-doc-paramname"><%=JvString.htmlEncode(DocTemplateParser.PARAM_WORKSTATION)%></div>
          <div class="help-doc-description">IMPORTANT: The parameter is available for "Pay by link" functionality only.
          <div class="help-doc-description">Extract and append the workstation id using http standards.</div>
          <div class="help-doc-description">Example:</div> 
          <div class="help-doc-description">BEFORE: 127.0.0.1:8080/wpg?page=paybylink_landing&amp;SaleTokenId=[@Sale.SaleTokenId {workstation:PAY-BY-LINK}]</div>
          <div class="help-doc-description">AFTER: 127.0.0.1:8080/wpg?page=paybylink_landing&amp;SaleTokenId=85959AB1-F369-8E25-08D9-017C11C521CF&amp;WorkstationId=E22FF8D0-B86F-E03E-081C-017C2BB9694C</div>
        </li>
        
      </ul>
    </v:widget-block>
  </v:widget>
  
  <style>
  .help-macro-name {color:var(--base-blue-color)}
  .help-macro-paramname {color:var(--base-red-color)}
  .help-macro-paramvalue {color:var(--base-green-color)}
  </style>
  
  <v:widget caption="Receipt printer macros">
    <v:widget-block>
      <h3>FORMAT</h3>
      &lt;<span class="help-macro-name">MACRONAME</span> {<span class="help-macro-paramname">param</span>:<span class="help-macro-paramvalue">value</span>; <span class="help-macro-paramname">param</span>:<span class="help-macro-paramvalue">value</span>; ... ; <span class="help-macro-paramname">param</span>:<span class="help-macro-paramvalue">value</span>}&gt;
      
      <h3>MACRONAME</h3>
      <ul>
        <li>
          <div class="help-doc-paramname"><%=JvString.htmlEncode("BARCODE")%></div>
          <div class="help-doc-description">Print a Code128 ean on receipt</div>
        </li>
        <li>
          <div class="help-doc-paramname"><%=JvString.htmlEncode("QRCODE")%></div>
          <div class="help-doc-description">Print a QRCcode on receipt</div>
        </li>
        <li>
          <div class="help-doc-paramname"><%=JvString.htmlEncode("CUT")%></div>
          <div class="help-doc-description">Cut the receipt</div>
        </li>
        <li>
          <div class="help-doc-paramname"><%=JvString.htmlEncode("MEMORYLOGO")%></div>
          <div class="help-doc-description">Print a logo to the receipt, logo is taken from printer memory</div>
        </li>
        <li>
          <div class="help-doc-paramname"><%=JvString.htmlEncode("FILELOGO")%></div>
          <div class="help-doc-description">Print a logo to the receipt, logo is taken from local file</div>
        </li>
        <li>
          <div class="help-doc-paramname"><%=JvString.htmlEncode("LF")%></div>
          <div class="help-doc-description">Print an empty row on receipt, it works only if there is at least one text row to be printed after this macro</div>
        </li>
        <li>
          <div class="help-doc-paramname"><%=JvString.htmlEncode("FONT")%></div>
          <div class="help-doc-description">Configure receipt font for the template lines to be printed after this macro. </div>
        </li>      
        <li>
          <div class="help-doc-paramname"><%=JvString.htmlEncode("STARTHIGHLIGHT")%></div>
          <div class="help-doc-description">Start macro for highlighted text on receipt. Available only for receipt printers that manage highlighted text</div>
        </li>      
				<li>
          <div class="help-doc-paramname"><%=JvString.htmlEncode("ENDHIGHLIGHT")%></div>
          <div class="help-doc-description">End macro for highlighted text on receipt. Available only for receipt printers that manage highlighted text /div>
        </li>   
        </ul>
      
      <h3>PARAM</h3>
      <ul>
        <li>
          <div class="help-doc-paramname"><%=JvString.htmlEncode(DocTemplateParser.PARAM_WIDTH)%></div>
          <div class="help-doc-description">Sets the length of the macros's content to the parameter value, filling the missing characters with spaces.</div>
           <div class="help-doc-description">Accepted numeric values.</div>
        </li>
        <li>
          <div class="help-doc-paramname"><%=JvString.htmlEncode("height")%></div>
          <div class="help-doc-description">Sets the height of the macros's content to the parameter value, filling the missing characters with spaces.</div>
          <div class="help-doc-description"> Accepted numeric values.</div>
        </li>
        <li>
          <div class="help-doc-paramname"><%=JvString.htmlEncode(DocTemplateParser.PARAM_ALIGN)%></div>
          <div class="help-doc-description">Sets the horizontal alignment of the variable's content.</div>
          <div class="help-doc-description">Accepted values: <span class="help-doc-paramname">left, right, center</span></div>
        </li>
        <li>
          <div class="help-doc-paramname"><%=JvString.htmlEncode("data")%></div>
          <div class="help-doc-description">Sets the data of the macro's content, valid only for BARCODE and QRCODE macro.</div>
          <div class="help-doc-description">Accepted string values.</div>
        </li>
        <li>
          <div class="help-doc-paramname"><%=JvString.htmlEncode("textpos")%></div>
          <div class="help-doc-description">Sets the position of the string representation of the barcode, valid only for BARCODE macro</div>
          <div class="help-doc-description">Accepted values: <span class="help-doc-paramname">above, below, none. Default value is below</span></div>
        </li>
        <li>
          <div class="help-doc-paramname"><%=JvString.htmlEncode("key1")%></div>
          <div class="help-doc-description">Sets the first part of the image memory position, valid only for MEMORYLOGO macro.</div>
          <div class="help-doc-description">Accepted numeric values.</div>
        </li>
        <li>
          <div class="help-doc-paramname"><%=JvString.htmlEncode("key2")%></div>
          <div class="help-doc-description">Sets the second part of the image memory position, valid only for MEMORYLOGO macro.</div>
          <div class="help-doc-description">Accepted numeric values.</div>
        </li>
        <li>
          <div class="help-doc-paramname"><%=JvString.htmlEncode("filename")%></div>
          <div class="help-doc-description">Sets the logo file name of the macro's content, valid only for FILELOGO macro.</div>
          <div class="help-doc-description">Accepted string values.</div>
        </li>
        <li>
          <div class="help-doc-paramname"><%=JvString.htmlEncode("rows")%></div>
          <div class="help-doc-description">Sets the number of empty rows to be printed, valid only for LF macro.</div>
          <div class="help-doc-description">Accepted numeric values.</div>
        </li>
        <li>
          <div class="help-doc-paramname"><%=JvString.htmlEncode("fontname")%></div>
          <div class="help-doc-description">Sets the name of the Font to be used, valid only for FONT macro. Please note that font have to be installed in order to be used</div>
          <div class="help-doc-description">Accepted String values.</div>
        </li>
        <li>
          <div class="help-doc-paramname"><%=JvString.htmlEncode("fontsize")%></div>
          <div class="help-doc-description">Sets the size of the Font to be used, valid only for FONT macro.</div>
          <div class="help-doc-description">Accepted values: (SMALL, NORMAL, MEDIUM, LARGE) or numeric values if the printer supports them.</div>
        </li>
        <li>
          <div class="help-doc-paramname"><%=JvString.htmlEncode("fontstyle")%></div>
          <div class="help-doc-description">Sets the style of the Font to be used, valid only for FONT macro.</div>
          <div class="help-doc-description">Accepted values: <span class="help-doc-paramname">BOLD, ITALIC, UNDERLINE, REVERSE.</span></div>
        </li>        
      </ul>
      
      <h3>EXAMPLES</h3>
      <ul>
        <li>
          <div class="help-doc-paramname">&lt; QRCODE {data:TEXT_TO_PRINT; height:100; width:100} &gt;</div>
          <div class="help-doc-description">A QRCode with dimension of 100x100 with text TEXT_TO_PRINT is printed.</div>
          <div class="help-doc-description">Height and width parameters are used if supported by the printer implementation.</div>
          <div class="help-doc-description">TEXT_TO_PRINT can also be template variables, for example, [@Ticket.MediaCode].</div>
        </li>
        <li>
          <div class="help-doc-paramname">&lt; BARCODE {data:1234567890123; width:100; textpos:below} &gt;</div>
          <div class="help-doc-description">A Code128 barcode representing the value 1234567890123 is printed on receipt, with barcode text representation (1234567890123) printed below the barcode and with specified width.</div>
        </li>
        <li>
          <div class="help-doc-paramname">&lt; FILELOGO {filename:C:\tmp\MyImage.jpg; width:450; align:center} &gt;</div>
          <div class="help-doc-description">The file MyImage.jpg is printed on receipt, center aligned and with specified width.</div>
        </li>
        <li>
          <div class="help-doc-paramname">&lt; MEMORYLOGO {width:46; align:center; key1:0; key2:1} &gt;</div>
          <div class="help-doc-description">The logo loaded on position 01 of the printer memory is printed on receipt, center aligned and with specified width.</div>
        </li>
        <li>
          <div class="help-doc-paramname">&lt; LF {rows:5} &gt;</div>
          <div class="help-doc-description">Five empty rows are printed on receipt.</div>
        </li>
        <li>
          <div class="help-doc-paramname">&lt; FONT {fontname:Consolas; fontsize:10; fontstyle:ITALIC;} &gt;</div>
          <div class="help-doc-description">The Font Consolas with size of 10pt and ITALIC style will be used to print the receipt until new Font macro is reached.</div>
        </li>
      </ul>
    </v:widget-block>
  </v:widget>
  
</div>