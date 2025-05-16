<%@page import="com.vgs.web.tag.ConfigTag"%>
<%@page import="com.vgs.snapp.lookup.*"%>
<%@ taglib uri="vgs-tags" prefix="v" %>

<div id="step-csv-input">
  <v:alert-box type="info" title="@Common.Info" style="max-height:350px;overflow:auto">
      This wizard will import product types from a CSV file into the system.<br/>
      The first line of the input file will be used to identify the field matching as follows:
      <ul>
        <li><b>Code</b> <i>(mandatory)</i>: unique product code</li>
        <li><b>Name</b> <i>(mandatory)</i>: product name</li>
        <li><b>Name_XX</b> <i>(optional)</i>: product name translation ('XX' refers to the ISO-639-1 code: 'IT' for Italian, 'EN' for English, etc...)</li>
        <li><b>Desc</b> <i>(optional)</i>: product description</li>
        <li><b>Desc_XX</b> <i>(optional)</i>: product description translation ('XX' refers to the ISO-639-1 code: 'IT' for Italian, 'EN' for English, etc...)</li>
        <li><b>CatCode</b> <i>(optional)</i>: product category code</li>
        <li><b>AttributeItemCodes</b> <i>(optional)</i>: attribute item codes separated by | (no spaces)</li>
        <li><b>AttributeSelectionTypeIDs</b> <i>(optional)</i>: attribute selection codes separated by | (no spaces)<br/>
               &nbsp;&nbsp;&nbsp;&nbsp;Allowed values ['1'(default) refers to Fixed, '2' refers to Dynamic, '3' refers to DynForce]</li>
        <li><b>AttributeDynamicEntitlements</b> <i>(optional)</i>: dynamic entitlements separated by | (no spaces)<br/>
               &nbsp;&nbsp;&nbsp;&nbsp;Allowed values ['1' refers to Yes, '0' refers to No]<br/>
               &nbsp;&nbsp;&nbsp;&nbsp;Attributes with dynamic selection cannot be set as <b>Dynamic entitlement</b></li>
        <li><b>Price</b> <i>(optional)</i>: product default price</li>
        <li><b>CodeAliases</b> <i>(optional)</i>: product code aliases separated by | (no spaces)</li>
        <li><b>PrintGrpCode</b> <i>(optional)</i>: product print group code</li>
        <li><b>FinanceGrpCode</b> <i>(optional)</i>: product finance group code</li>
        <li><b>AdmissionGrpCode</b> <i>(optional)</i>: product admission group code</li>
        <li><b>AreaGrpCode</b> <i>(optional)</i>: product area group code</li>
        <li><b>LocationCode</b> <i>(optional)</i>: location code </li>
        <li><b>Tags</b> <i>(optional)</i>: product tags separated by | (no spaces)</li>
        <li><b>GrpQtyMin</b> <i>(optional)</i>: groups quantity min (default 1)</li>
        <li><b>GrpQtyStep</b> <i>(optional)</i>: groups quantity step (default 1)</li>
        <li><strong>MF:<i>{CODE}</i></strong>: where {CODE} matches a <span class="metafield-tooltip-link">metafield code</span>; ie: <b>MF:FT1</b> for first name</li>
        <li><strong>MF$<i>{NUMBER}</i></strong>: where {NUMBER} matches the <span class="lk-tooltip-link" data-LookupTable="<%=LkSN.MetaFieldType.getCode()%>">Meta Field Type</span> lookup item; ie: <b>MF$1</b> for first name</li>
        <li><b>Refundable</b> <i>(optional)</i>: allowed values ['1' refers to Yes, '0' refers to No] </li>
        <li><b>TaxCalcTypeCode</b> <i>(optional)</i>: tax calc type (allowed values [1:Tax Included, 2:Tax Excluded, 3: Tax Exempt] )</li>
        <li><b>TaxProfileCode</b> <i>(optional)</i>: product tax profile code</li>
        <li><b>LedgerProfileCodes</b> <i>(optional)</i>: product ledger profile codes separated by | (no spaces)</li>
        <li><b>CommonOrderTemplateIDs</b> <i>(optional)</i>: common order templates separated by | (no spaces)</li>
        <li><b>SpecificOrderTemplateIDs</b> <i>(optional)</i>: specific order templates separated by | (no spaces)</li>
        <li><b>ProfilePictureUrl</b> <i>(optional)</i>: profile picture URL link compliant with HTTP protocol; ie: <b>https://images.squarespace-cdn.com/image.png</b></li>
        <li><strong>Price:<i>{CODE}</i></strong>: where {CODE} matches a <span class="metafield-tooltip-link">sale channel and performance type codes</span><br/>
                    &nbsp;&nbsp;<b>Allowed field codes</b><br/>
                    &nbsp;&nbsp;&nbsp;&nbsp;<b>PRICE:#:#</b> for default price value<br/>
                    &nbsp;&nbsp;&nbsp;&nbsp;<b>PRICE:#:{PERFORMANCETYPECODE}</b> for default sale channel and performance type combination price value<br/>
                    &nbsp;&nbsp;&nbsp;&nbsp;<b>PRICE:{SALECHANNELCODE}:{PERFORMANCETYPECODE}</b> for sale channel and performance type combination price value<br/>
                    &nbsp;&nbsp;<b>Allowed values examples</b><br/>
                    &nbsp;&nbsp;&nbsp;&nbsp;<b>'='</b> Do not touch price value <br/>
                    &nbsp;&nbsp;&nbsp;&nbsp;<b>''</b> Inherited price value<br/>
                    &nbsp;&nbsp;&nbsp;&nbsp;<b>'/'</b> Not sellable<br/>
                    &nbsp;&nbsp;&nbsp;&nbsp;<b>'10.0'</b> Absolute $10<br/>
                    &nbsp;&nbsp;&nbsp;&nbsp;<b>'+10.0'</b> Add absolute $10<br/>
                    &nbsp;&nbsp;&nbsp;&nbsp;<b>'-10.0'</b> Subtract absolute $10<br/>
                    &nbsp;&nbsp;&nbsp;&nbsp;<b>'+10.0%'</b> Add Percentage $10<br/>
                    &nbsp;&nbsp;&nbsp;&nbsp;<b>'-10.0%'</b> Subtract Percentage $10<br/>
        <li><b>DatedCalendarCode</b> <i>(optional)</i>: dated calendar code </li>
        <% int codeEUT = LkSN.ExpirationUsageType.getCode();%>
        <li><b>ExpirationUsageRule</b> <i>(optional)</i>: expiration usage rule (<a href="<%=ConfigTag.getValue("site_url") + "/admin?page=doc_lookup_list&LookupTable=" + codeEUT%>" target="_blank">Lookup table documentation</a>)</li> 
        <% int codeNT = LkSN.ProductNegativeTransaction.getCode();%>       
        <li><b>NegativeTransaction</b> <i>(optional)</i>: negative transaction (<a href="<%=ConfigTag.getValue("site_url") + "/admin?page=doc_lookup_list&LookupTable=" + codeNT%>" target="_blank">Lookup table documentation</a>)</li>
        <li><b>Upgradable</b> <i>(optional)</i>: allowed values ['1' refers to Yes, '0' refers to No] </li>
        <li><b>Downgradable</b> <i>(optional)</i>: allowed values ['1' refers to Yes, '0' refers to No] </li>       
      </ul>
        Status and Category of the product can be set using the parameters above.<br/>
        If 'CatCode' parameter is empty (or column missing) the value of 'Category' will be used.
  </v:alert-box>
</div>