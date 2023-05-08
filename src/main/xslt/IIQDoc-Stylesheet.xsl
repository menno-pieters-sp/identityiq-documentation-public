<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:iiqdoc="http://iiqdoc.config.data">
	<xsl:output omit-xml-declaration="yes" indent="yes" method="html" />

	<xsl:template name="insertCssStylesheet">
		<style><![CDATA[
body {
	font-family: Arial, Helvetica, Sans-Serif;
	font-size: 12pt;
	counter-reset: h1counter;
	margin: 10px;
}

h1 {
	counter-reset: h2counter;
	color: #0033a1;
}
h1::before {
	counter-increment: h1counter;
	content: counter(h1counter) ".\0000a0\0000a0";
}

h2 {
	counter-reset: h3counter;
	color: #0033a1;
}
h2::before {
	counter-increment: h2counter;
	content: counter(h1counter) "." counter(h2counter) ".\0000a0\0000a0";
}

h3 {
	counter-reset: h4counter;
	color: #0033a1;
}
h3::before {
	counter-increment: h3counter;
	content: counter(h1counter) "." counter(h2counter) "." counter(h3counter) ".\0000a0\0000a0";
}

h4 {
	counter-reset: h5counter;
	color: #0033a1;
}
h4::before {
	counter-increment: h4counter;
	content: counter(h1counter) "." counter(h2counter) "." counter(h3counter) "." counter(h4counter) ".\0000a0\0000a0";
}

h5 {
	counter-reset: h6counter;
	color: #0033a1;
}
h5::before {
	counter-increment: h5counter;
	content: counter(h1counter) "." counter(h2counter) "." counter(h3counter) "." counter(h4counter) "." counter(h5counter) ".\0000a0\0000a0";
}

h6 {
	counter-reset: h7counter;
	color: #0033a1;
}
h6::before {
	counter-increment: h6counter;
	content: counter(h1counter) "." counter(h2counter) "." counter(h3counter) "." counter(h4counter) "." counter(h5counter) "." counter(h6counter) ".\0000a0\0000a0";
}

h7 {
	counter-reset: h8counter;
	color: #0033a1;
}
h7::before {
	counter-increment: h7counter;
	content: counter(h1counter) "." counter(h2counter) "." counter(h3counter) "." counter(h4counter) "." counter(h5counter) "." counter(h6counter) "." counter(h7counter) ".\0000a0\0000a0";
}

h8 {
	color: #0033a1;
	counter-reset: h9counter;
}
h8::before {
	counter-increment: h8counter;
	content: counter(h1counter) "." counter(h2counter) "." counter(h3counter) "." counter(h4counter) "." counter(h5counter) "." counter(h6counter) "." counter(h7counter) "." counter(h8counter) ".\0000a0\0000a0";
}

h9 {
	color: #0033a1;
}
h9::before {
	counter-increment: h9counter;
	content: counter(h1counter) "." counter(h2counter) "." counter(h3counter) "." counter(h4counter) "." counter(h5counter) "." counter(h6counter) "." counter(h7counter) "." counter(h8counter) "." counter(h9counter) ".\0000a0\0000a0";
}


div#mainBody {
height: 100vh;
width: 100vw;
	display: grid;
	padding: 3px;
	grid-gap: 3px;
	grid-template-columns: 30% 70%;
	overflow: hidden;
	color: black;
}

div#tableOfContents {
	background-color: #f2f5f7;
	margin: 5px;
	overflow-y: scroll;
	box-shadow: 5px 5px 10px #415364;
}

div#tableOfContents ol li a:link {
	text-decoration: none;
	color: black;
}

div#tableOfContents ol li a:visited {
	text-decoration: none;
	color: black;
}

div#mainDocument {
	background-color: #ffffff;
	margin: 10px;
	overflow-y: scroll;
}

pre {
	width: 100%;
	max-width: 1200px;
	max-height: 1200px;
	overflow-x: scroll;
	overflow-y: scroll;
}

svg {
	background-color: white;
	border-color: #415364;
	max-width: 1200px;
	max-height: 1200px;
	overflow-x: scroll;
	overflow-y: scroll;
	box-shadow: 5px 5px 10px #415364;
	border-radius: 10px;
	border-style: solid;
	border-width: 1px;
	padding: 5px;
	margin: 5px;
}

table {
	width: 100%;
	max-width: 1200px;
	border-style: none;
	border-width: 0px;
	border-color: #0033a1;
}

table.headerTable {
	width: 800px;
}

table.mapTable {
	border-width: 0px;
}

td, th {
	max-width: 50%;
	border-style: solid;
	border-width: 0.125px;
	border-color: #0033a1;
	padding: 2px;
}

td {
	vertical-align: top;
}

td.value {
	min-width: 50px;
}

td.mapTable, th.mapTable {
	border-style: solid;
	border-width: 0.125px;
	border-color: #0033a1;
}

td.property, th.property {
	font-weight: bold;
}

td.attributeSource, td.attributeTarget {
	border-width: 0;
	border-style: none;
	background-color: #f2f5f7;
}

th {
	background-color: #0033a1;
	color: white;
	vertical-align: bottom;
}

th.rowHeader {
	background-color: #0071ce;
	vertical-align: top;
	text-align: left;
	width: 1px;
	white-space: nowrap;
}

td.property {
	background-color: #cc27b0;
	color: white;
}

table.ruleDetailsTable tr th {
	text-align: left;
}

table.objectAttributeStatsTable tr th {
  text-align: left;
  width: 50%;
}

pre.description {
	font-family: Arial, Helvetica, Sans-Serif;
	font-size: 12pt;
	font-style: italic;
}

.rotate-ccw {
	/* Safari */
	-webkit-transform: rotate(-90deg);
	/* Firefox */
	-moz-transform: rotate(-90deg);
	/* IE */
	-ms-transform: rotate(-90deg);
	/* Opera */
	-o-transform: rotate(-90deg);
	/* Internet Explorer */
	filter: progid:DXImageTransform.Microsoft.BasicImage(rotation=3);
}

td.sourceCode {
	background-color: #f2f5f7;
	color: #415364;
	font-family: monospace, Courier New, Courier, Andale Mono, Monaco;
	font-size: 10pt;
	white-space: pre;
}

span.triangle-icon {
  cursor: pointer;
  color: #415364;
}

			]]>
		</style>
	</xsl:template>
</xsl:stylesheet>
