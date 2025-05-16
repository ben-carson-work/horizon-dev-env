<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<style>
.item-grid{
  padding: 5px;
  height: 451px;
  overflow: auto;
}

/* Recap */

.recap .widget-content{
  height: 487px;
  overflow: auto;
  padding: 10px;
}

div.recap-group {
  margin-bottom: 10px;
}

div.recap-body {
  margin-left: 20px;
}

div.recap-body span.item-name {
  color: #666666;
  text-decoration: underline;
}

span.item-name:HOVER {
  cursor: pointer;
}

div.recap-total{
  border-bottom: 1px #000000 solid;
  padding-bottom: 10px;
  margin-bottom: 10px;
  font-weight: bold;
  width: 100%;
}

span.recap-title {
  font-weight: bold;
  margin-right: 10px;
}


.steps {
  pointer-events: none;
}

.wizard > .steps > ul > li {
    width: 33%;
}

.wizard ul {
    width: 101%;
}

</style>