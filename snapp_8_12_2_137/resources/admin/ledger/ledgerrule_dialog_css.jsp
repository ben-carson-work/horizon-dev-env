<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>
 tr .txt-perc {width:100%}
 tr .usage-filter-loc-select {width:65%}
 tr .gate-cat-select {width:100%}
 tr .LedgerAccountTemplate-Select {margin-bottom: -10px;} 
 
 tr [data-weighttype='perc'] .txt-perc {width:100%; margin-bottom: -20px;}
 tr [data-weighttype='perc'] .usage-filter-loc-select {display:none;}
 tr [data-weighttype='perc'] .gate-cat-select {display:none;}

 tr [data-weighttype='perc-loc'] .txt-perc {width:35%}
 tr [data-weighttype='perc-loc'] .gate-cat-select {display:none;}

 tr [data-weighttype='gate-cat'] .txt-perc {display:none;}
 tr [data-weighttype='gate-cat'] .usage-filter-loc-select {display:none;}
 
 div.relative {
    position: relative;
    top:6px;
 } 

</style>
