<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:iiqdoc="http://iiqdoc.config.data">
    <xsl:output omit-xml-declaration="yes" indent="yes" method="html" />
    <!-- Create Link References -->
    <xsl:template name="quickLinkReferenceLink">
        <xsl:param name="quickLinkName" />
        <xsl:choose>
            <xsl:when test="//QuickLink[@name=$quickLinkName]">
                <a>
                    <xsl:attribute name="href">
						<xsl:value-of select="concat('#QuickLink - ', $quickLinkName)" />
					</xsl:attribute>
                    <xsl:value-of select="$quickLinkName" />
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$quickLinkName" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>    
    <!--
    
        Document each QuickLink
         
     -->
    <xsl:template name="processQuickLinks">
        <xsl:if test="document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='documentQuickLinks']/@value='true' and /sailpoint/QuickLink">
            <a name="Heading-QuickLinks" />
            <h1>QuickLinks</h1>
            <xsl:for-each select="//QuickLink">
                <xsl:sort select="@name" />
                <a>
                    <xsl:attribute name="name">
    	                <xsl:value-of select="concat('QuickLink - ', @name)" />
	       			</xsl:attribute>
                </a>
                <h2>
                    <xsl:value-of select="@name" />
                </h2>
                <table class="mapTable">
                    <tr>
                        <th class="mapTable">Application</th>
                        <th class="mapTable">Attribute</th>
                    </tr>
                    <tr>
                        <td class="mapTable">Message</td>
                        <td>
                            <pre class="description">
                                <xsl:call-template name="localize">
                                    <xsl:with-param name="key" select="@messageKey" />
                                </xsl:call-template>
                            </pre>
                        </td>
                    </tr>
                    <xsl:if test="Description">
                        <tr>
                            <td class="mapTable">Description</td>
                            <td>
                                <pre class="description">
                                    <xsl:call-template name="localize">
                                        <xsl:with-param name="key" select="Description" />
                                    </xsl:call-template>
                                </pre>
                            </td>
                        </tr>
                    </xsl:if>
                    <tr>
                        <td class="mapTable">Disabled</td>
                        <td class="mapTable">
                            <xsl:call-template name="parseTextToBooleanIcon">
                                <xsl:with-param name="boolVal" select="@disabled"/>
                            </xsl:call-template>
                        </td>
                    </tr>
                    <tr>
                        <td class="mapTable">Category</td>
                        <td class="mapTable">
                            <xsl:value-of select="@category" />
                        </td>
                    </tr>
                    <tr>
                        <td class="mapTable">Action</td>
                        <td class="mapTable">
                            <xsl:value-of select="@action" />
                        </td>
                    </tr>
                    <xsl:if test="@action = 'workflow'">
                        <tr>
                            <td class="mapTable">Workflow</td>
                            <td class="mapTable">
                                <xsl:call-template name="workflowReferenceLink">
                                    <xsl:with-param name="workflowName" select="Attributes/Map/entry[@key='workflowName']/@value | Attributes/Map/entry[@key='workflowName']/value/String/text()" />
                                </xsl:call-template>
                            </td>
                        </tr>
                    </xsl:if>
                    <!-- TODO: Add QuickLink Populations -->
					<td>QuickLinkOptions</td>
					<td>
						<xsl:if test="QuickLinkOptions">
							<ul>
								<xsl:for-each select="QuickLinkOptions">
									<xsl:sort select="DynamicScopeRef/Reference/@name" />
									<li><xsl:value-of select="DynamicScopeRef/Reference/@name" /></li>
								</xsl:for-each>
							</ul>
						</xsl:if>
					</td>
                </table>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>