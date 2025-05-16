<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<style>

/* attribute/items list */

#table-build-version {
  width: 100%;
}

#table-build-version td {

  vertical-align: top;
  padding: 5px;
}

#project-widget .widget-block,
#version-widget .widget-block, 
#recap-widget .widget-block {
  height: 500px;
  overflow: auto;
}

#project-widget .widget-block,
#version-widget .widget-block {
  padding: 0;
}

#project-widget .project-row,
#version-widget .version-row {
  cursor: pointer;
  padding: 5px;
}

#project-widget .project-row:hover,
#version-widget .version-row:hover {
  background-color: #ebf3fa;
}

#project-widget .project-row.selected, 
#project-widget .project-row.selected:hover,
#version-widget .version-row.selected, 
#version-widget .version-row.selected:hover {
  background-color: #b8dbfa;
}

.version-widget-block {
  font-weight: bold;
}

/* Recap */

.recap-version-block {
  padding: 10px;
}

.recap-description {
  float: right;
}

.recap-description .span-desc {
  margin: 5px;
  padding: 2px 5px;
  border-radius: 3px;
}

.recap-description .label-unreleased {
  border: 1px solid #b3d4ff;
  color: #0052cc;
}

.recap-description .label-released {
  border: 1px solid #abf5d1;
  color: #00875a;
}

.recap-description .label-archived {
  border: 1px solid #c1c7d0;
  color: #42526e;
}

.recap-version {
  display: inline;
}

.recap-version.new {
  color: #0052cc;
  background-color: #fff;
  border-color: #b3d4ff;
}

.recap-version.release {
  color: #00875a;
  background-color: #fff;
  border-color: #abf5d1;
}

.recap-version.archive {
  color: #42526e;
  background-color: #fff;
  border-color: #c1c7d0;
}

.recap-description {
  display: inline;
}

#spinner {
  display: none;
}

.waiting #content{
  display: none;
}

.waiting #spinner{
  display: block;
  text-align: center;
}

</style>