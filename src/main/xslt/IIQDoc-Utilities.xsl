<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:java="http://xml.apache.org/xalan/java" xmlns:exsl="http://exslt.org/common" xmlns:str="http://exslt.org/str" exclude-result-prefixes="java" xmlns:iiqdoc="http://iiqdoc.config.data">
    <xsl:output omit-xml-declaration="yes" indent="yes" method="html" />
    <xsl:template name="getConfigBoolean">
        <xsl:param name="name" />
        <xsl:param name="default" select="'false'" />
        <xsl:call-template name="parseTextToBoolean">
            <xsl:with-param name="boolVal">
                <xsl:choose>
                    <xsl:when test="//Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key=$name]/@value | //Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key=$name]/value/Boolean">
                        <xsl:value-of select="//Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key=$name]/@value | //Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key=$name]/value/Boolean/text()" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$default" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    <xsl:template name="getConfigBooleanIcon">
        <xsl:param name="name" />
        <xsl:param name="default" select="'false'" />
        <xsl:call-template name="parseTextToBooleanIcon">
            <xsl:with-param name="boolVal">
                <xsl:choose>
                    <xsl:when test="//Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key=$name]/@value | //Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key=$name]/value/Boolean">
                        <xsl:value-of select="//Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key=$name]/@value | //Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key=$name]/value/Boolean/text()" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$default" />
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    <xsl:template name="getConfigValue">
        <xsl:param name="name" />
        <xsl:value-of select="//Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key=$name]/@value | //Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key=$name]/value/node()/text()" />
    </xsl:template>
    <xsl:template name="getConfigStringBulletList">
        <xsl:param name="name" />
        <xsl:if test="//Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key=$name]/value/List/String">
            <ul>
                <xsl:for-each select="//Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key=$name]/value/List/String">
                    <li><xsl:value-of select="./text()"/></li>
                </xsl:for-each>
            </ul>
        </xsl:if>
    </xsl:template>
    <xsl:template name="getConfigNumber">
        <xsl:param name="name" />
        <xsl:variable name="num" select="//Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key=$name]/@value | //Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key=$name]/value/Boolean/text()" />
        <xsl:choose>
            <xsl:when test="normalize-space($num) = ''">
                <xsl:text>0</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="number(normalize-space($num))" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="parseTextToBoolean">
        <xsl:param name="boolVal" />
        <xsl:variable name="boolStr" select="java:java.lang.String.valueOf(normalize-space($boolVal))" />
        <xsl:variable name="lowerBoolVal" select="java:toLowerCase($boolStr)" />
        <xsl:choose>
            <xsl:when test="$lowerBoolVal = 'true'">
                <xsl:value-of select="true()" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="false()" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

	<!-- Parse text and invert boolean -->
    <xsl:template name="parseTextToNotBoolean">
        <xsl:param name="boolVal" />
        <xsl:variable name="boolStr" select="java:java.lang.String.valueOf(normalize-space($boolVal))" />
        <xsl:variable name="lowerBoolVal" select="java:toLowerCase($boolStr)" />
        <xsl:choose>
            <xsl:when test="$lowerBoolVal = 'true'">
                <xsl:value-of select="false()" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="true()" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="parseTextToBooleanIcon">
        <xsl:param name="boolVal" />
        <xsl:variable name="boolStr" select="java:java.lang.String.valueOf(normalize-space($boolVal))" />
        <xsl:variable name="lowerBoolVal" select="java:toLowerCase($boolStr)" />
        <xsl:choose>
            <xsl:when test="$lowerBoolVal = 'true'">
                <xsl:text>&#9745;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>&#9744;</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="parseNodeValue">
        <xsl:choose>
            <xsl:when test="local-name() = 'List'">
		<!-- List -->
                <ul>
                    <xsl:for-each select="node()">
                        <li>
                            <xsl:call-template name="parseNodeValue" />
                        </li>
                    </xsl:for-each>
                </ul>
            </xsl:when>
            <xsl:when test="local-name() = 'Map'">
		<!-- Map -->
                <xsl:for-each select=".">
                    <xsl:call-template name="parseMap" />
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="local-name() = 'Boolean'">
		<!-- Boolean -->
                <xsl:variable name="bv">
                    <xsl:choose>
                        <xsl:when test="normalize-space(text()) = ''">
                            <xsl:text>false</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="normalize-space(text())" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="text()" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="parseMapEntryValue" match="//Map/entry/value">
        <xsl:for-each select="node()">
            <xsl:call-template name="parseNodeValue" />
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="parseMap" match="//Map">
        <xsl:for-each select="Map">
            <table class="mapTable">
                <tr>
                    <th class="mapTable">Key</th>
                    <th class="mapTable">Value</th>
                </tr>
                <xsl:for-each select="entry">
                    <tr>
                        <td>
                            <xsl:for-each select="@key" />
                        </td>
                        <td>
                            <xsl:choose>
                                <xsl:when test="@value">
                                    <xsl:value-of select="@value" />
                                </xsl:when>
                                <xsl:when test="value">
                                    <xsl:for-each select="value">
                                        <xsl:call-template name="parseMapEntryValue" />
                                    </xsl:for-each>
                                </xsl:when>
                            </xsl:choose>
                        </td>
                    </tr>
                </xsl:for-each>
            </table>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="parseAttributes" match="//Attributes">
        <xsl:for-each select="Map">
            <xsl:call-template name="parseMap" />
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="nodeToText" match="*">
        <xsl:param name="indent" />
        <xsl:value-of select="$indent" />
        <xsl:text>&lt;</xsl:text>
        <xsl:value-of select="local-name()" />
        <xsl:for-each select="@*">
            <xsl:text> </xsl:text>
            <xsl:value-of select="local-name()" />
            <xsl:text>=&quot;</xsl:text>
            <xsl:value-of select="." />
            <xsl:text>&quot;</xsl:text>
        </xsl:for-each>
        <xsl:variable name="textValue" select="text()" />
        <xsl:choose>
            <xsl:when test="*">
                <xsl:text>&gt;
</xsl:text>
                <xsl:for-each select="*">
                    <xsl:call-template name="nodeToText">
                        <xsl:with-param name="indent" select="concat($indent, '  ')" />
                    </xsl:call-template>
                </xsl:for-each>
                <xsl:value-of select="$indent" />
                <xsl:text>&lt;/</xsl:text>
                <xsl:value-of select="local-name()" />
                <xsl:text>&gt;
</xsl:text>
            </xsl:when>
            <xsl:when test="not(normalize-space($textValue) = '')">
                <xsl:text>&gt;</xsl:text>
                <xsl:value-of select="$textValue" />
                <xsl:text>&lt;/</xsl:text>
                <xsl:value-of select="local-name()" />
                <xsl:text>&gt;
</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text> /&gt;
</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="splitToDocLinkList">
        <xsl:param name="pText" />
        <xsl:param name="objectType" />
        <xsl:param name="delim" select="','" />
        <xsl:param name="num" select="0" />
        <xsl:if test="string-length($pText)">
            <xsl:choose>
                <xsl:when test="$objectType = 'Application'">
                    <li>
                        <xsl:call-template name="applicationReferenceLink">
                            <xsl:with-param name="applicationName" select="normalize-space(substring-before(concat($pText,$delim),$delim))" />
                        </xsl:call-template>
                    </li>
                </xsl:when>
                <xsl:when test="$objectType = 'TaskDefinition'">
                    <li>
                        <xsl:call-template name="taskDefinitionReferenceLink">
                            <xsl:with-param name="taskDefinitionName" select="normalize-space(substring-before(concat($pText,$delim),$delim))" />
                        </xsl:call-template>
                    </li>
                </xsl:when>
                <xsl:otherwise>
                    <li>
                        <xsl:value-of select="$pText" />
                    </li>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:call-template name="splitToDocLinkList">
                <xsl:with-param name="pText" select="normalize-space(substring-after($pText, $delim))" />
                <xsl:with-param name="objectType" select="$objectType" />
                <xsl:with-param name="delim" select="$delim" />
                <xsl:with-param name="num" select="$num+1" />
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template name="splitToList">
        <xsl:param name="pText" />
        <xsl:param name="delim" select="','" />
        <xsl:param name="num" select="0" />
        <xsl:if test="string-length($pText)">
            <li>
                <xsl:value-of select="substring-before(concat($pText,$delim),$delim)" />
            </li>
            <xsl:call-template name="splitToList">
                <xsl:with-param name="pText" select="substring-after($pText, $delim)" />
                <xsl:with-param name="delim" select="$delim" />
                <xsl:with-param name="num" select="$num+1" />
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template name="absValue">
        <xsl:param name="v" />
        <xsl:choose>
            <xsl:when test="number($v) &lt; 0">
                <xsl:value-of select="-1 * number($v)" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="number($v)" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="distance">
        <xsl:param name="a" />
        <xsl:param name="b" />
        <xsl:value-of select="number($a) - number($b)" />
    </xsl:template>
    <xsl:template name="absDistance">
        <xsl:param name="a" />
        <xsl:param name="b" />
        <xsl:call-template name="absValue">
            <xsl:with-param name="v">
                <xsl:value-of select="number($a) - number($b)" />
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    <xsl:template name="xyDistance" xmlns:math="urn:java:java.lang.Math">
        <xsl:param name="x1" />
        <xsl:param name="y1" />
        <xsl:param name="x2" />
        <xsl:param name="y2" />
        <xsl:variable name="dx">
            <xsl:call-template name="absDistance">
                <xsl:with-param name="a">
                    <xsl:value-of select="$x1" />
                </xsl:with-param>
                <xsl:with-param name="b">
                    <xsl:value-of select="$x2" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="dy">
            <xsl:call-template name="absDistance">
                <xsl:with-param name="a">
                    <xsl:value-of select="$y1" />
                </xsl:with-param>
                <xsl:with-param name="b">
                    <xsl:value-of select="$y2" />
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="p" select="($dx * $dx) + ($dy * $dy)" />
        <xsl:value-of select="java:java.lang.Math.sqrt(number($p))" />
    </xsl:template>
    <xsl:template name="closestSide">
		<!-- top left of source object -->
        <xsl:param name="px1" />
        <xsl:param name="py1" />
		<!-- width and height of source object -->
        <xsl:param name="wd1" />
        <xsl:param name="ht1" />
		<!-- top left of target object -->
        <xsl:param name="px2" />
        <xsl:param name="py2" />
		<!-- width and height of target object -->
        <xsl:param name="wd2" />
        <xsl:param name="ht2" />
		<!-- Middle of target -->
        <xsl:variable name="mx2" select="$px2 + ($wd2 div 2)" />
        <xsl:variable name="my2" select="$py2 + ($ht2 div 2)" />
		<!-- Sides of source -->
        <xsl:variable name="sxTop" select="$px1 + ($wd1 div 2)" />
        <xsl:variable name="syTop" select="$py1" />
        <xsl:variable name="sxLeft" select="$px1" />
        <xsl:variable name="syLeft" select="$py1 + ($ht1 div 2)" />
        <xsl:variable name="sxRight" select="$px1 + $wd1" />
        <xsl:variable name="syRight" select="$py1 + ($ht1 div 2)" />
        <xsl:variable name="sxBottom" select="$px1 + ($wd1 div 2)" />
        <xsl:variable name="syBottom" select="$py1 + $ht1" />
		<!-- Distances -->
        <xsl:variable name="dTop">
            <xsl:call-template name="xyDistance">
                <xsl:with-param name="x1" select="$sxTop" />
                <xsl:with-param name="y1" select="$syTop" />
                <xsl:with-param name="x2" select="$mx2" />
                <xsl:with-param name="y2" select="$my2" />
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="dLeft">
            <xsl:call-template name="xyDistance">
                <xsl:with-param name="x1" select="$sxLeft" />
                <xsl:with-param name="y1" select="$syLeft" />
                <xsl:with-param name="x2" select="$mx2" />
                <xsl:with-param name="y2" select="$my2" />
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="dRight">
            <xsl:call-template name="xyDistance">
                <xsl:with-param name="x1" select="$sxRight" />
                <xsl:with-param name="y1" select="$syRight" />
                <xsl:with-param name="x2" select="$mx2" />
                <xsl:with-param name="y2" select="$my2" />
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="dBottom">
            <xsl:call-template name="xyDistance">
                <xsl:with-param name="x1" select="$sxBottom" />
                <xsl:with-param name="y1" select="$syBottom" />
                <xsl:with-param name="x2" select="$mx2" />
                <xsl:with-param name="y2" select="$my2" />
            </xsl:call-template>
        </xsl:variable>
	<!-- Smallest vertical -->
        <xsl:variable name="nVertical">
            <xsl:choose>
                <xsl:when test="$dTop &lt; $dBottom">
                    <xsl:value-of select="'top'" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'bottom'" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="dVertical">
            <xsl:choose>
                <xsl:when test="$dTop &lt; $dBottom">
                    <xsl:value-of select="$dTop" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$dBottom" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
	<!-- Smallest horizontal -->
        <xsl:variable name="nHorizontal">
            <xsl:choose>
                <xsl:when test="$dLeft &lt; $dRight">
                    <xsl:value-of select="'left'" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'right'" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="dHorizontal">
            <xsl:choose>
                <xsl:when test="$dLeft &lt; $dRight">
                    <xsl:value-of select="$dLeft" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$dRight" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
	<!-- Selection -->
        <xsl:choose>
            <xsl:when test="$dHorizontal &lt; $dVertical">
                <xsl:value-of select="$nHorizontal" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$nVertical" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="sideCoordinate">
	<!-- top left of source object -->
        <xsl:param name="px" />
        <xsl:param name="py" />
	<!-- width and height of source object -->
        <xsl:param name="wd" />
        <xsl:param name="ht" />
	<!-- selected side -->
        <xsl:param name="side" select="'right'" />
	<!-- x or y -->
        <xsl:param name="xy" select="'x'" />
	<!-- Main -->
        <xsl:choose>
            <xsl:when test="$xy = 'x'">
                <xsl:choose>
                    <xsl:when test="$side = 'top' or $side = 'bottom'">
                        <xsl:value-of select="$px + ($wd div 2)" />
                    </xsl:when>
                    <xsl:when test="$side = 'left'">
                        <xsl:value-of select="$px" />
                    </xsl:when>
                    <xsl:when test="$side = 'right'">
                        <xsl:value-of select="$px + $wd" />
                    </xsl:when>
                    <xsl:otherwise />
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$xy = 'y'">
                <xsl:choose>
                    <xsl:when test="$side = 'top'">
                        <xsl:value-of select="$py" />
                    </xsl:when>
                    <xsl:when test="$side = 'bottom'">
                        <xsl:value-of select="$py + $ht" />
                    </xsl:when>
                    <xsl:when test="$side = 'left' or $side='right'">
                        <xsl:value-of select="$py + ($ht div 2)" />
                    </xsl:when>
                    <xsl:otherwise />
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise />
        </xsl:choose>
    </xsl:template>
    <xsl:template name="timeStampToDate">
        <xsl:param name="format" select="'yyyy.MM.dd'" />
        <xsl:param name="timestamp" />
        <xsl:variable name="timestampLong" select="java:java.lang.Long.parseLong($timestamp)" />
        <xsl:variable name="date" select="java:java.util.Date.new($timestampLong)" />
        <xsl:variable name="formatter" select="java:java.text.SimpleDateFormat.new($format)" />
        <xsl:value-of select="java:format($formatter, $date)" />
    </xsl:template>
    <xsl:template name="describeCronExpression">
        <xsl:param name="cronExpression" />
        <xsl:variable name="cronTypeQuartz" select="'QUARTZ'" />
        <xsl:variable name="cronType" select="java:com.cronutils.model.CronType.valueOf($cronTypeQuartz)" />
        <xsl:variable name="cronDef" select="java:com.cronutils.model.definition.CronDefinitionBuilder.instanceDefinitionFor($cronType)" />
        <xsl:variable name="cron" select="java:parse(java:com.cronutils.parser.CronParser.new($cronDef), $cronExpression)" />
        <xsl:variable name="cronDescriptor" select="java:com.cronutils.descriptor.CronDescriptor.instance()" />
        <xsl:value-of select="java:describe($cronDescriptor, $cron)" />
    </xsl:template>
    <xsl:template name="stripHtml">
        <xsl:param name="sourceText" />
        <xsl:variable name="sourceTextStr" select="java:java.lang.String.valueOf(normalize-space($sourceText))" />
        <xsl:variable name="html2text" select="java:com.sailpoint.pse.util.Html2Text.new()" />
        <xsl:variable name="parsedText" select="java:parse($html2text, $sourceTextStr)" />
        <xsl:value-of select="$parsedText" />
    </xsl:template>
    <xsl:template name="localize">
        <xsl:param name="key" />
        <xsl:choose>
            <xsl:when test="document('IdentityIQ-Documenter-Localization.xsl')//iiqdoc:localizations/iiqdoc:localization[@key=$key] ">
                <xsl:call-template name="stripHtml">
                    <xsl:with-param name="sourceText" select="document('IdentityIQ-Documenter-Localization.xsl')//iiqdoc:localizations/iiqdoc:localization[@key=$key]/@value" />
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$key" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>