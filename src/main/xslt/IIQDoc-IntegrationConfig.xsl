<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:iiqdoc="http://iiqdoc.config.data">
	<xsl:output omit-xml-declaration="yes" indent="yes" method="html" />

	<xsl:template name="integrationConfigReferenceLink">
		<xsl:param name="integrationConfigName"/>
		<xsl:choose>
			<xsl:when test="//IntegrationConfig[@name=$integrationConfigName]">
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="concat('#IntegrationConfig - ', $integrationConfigName)"/>
					</xsl:attribute>
					<xsl:value-of select="$integrationConfigName"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$integrationConfigName"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="processIntegrationConfigs">
		<xsl:if test="/sailpoint/IntegrationConfig">
			<a name="Heading-IntegrationConfig"/>
			<h1>IntegrationConfigs</h1>
			<xsl:for-each select="/sailpoint/IntegrationConfig">
				<a>
					<xsl:attribute name="name">
	          <xsl:value-of select="concat('IntegrationConfig - ', @name)" />
					</xsl:attribute>
				</a>
				<h2><xsl:value-of select="@name"/></h2>
				<table class="headerTable">
					<xsl:if test="Description">
						<tr>
							<td class="property">Description</td>
							<td class="value"><pre><xsl:value-of select="Description/text()" /></pre></td>
						</tr>
					</xsl:if>
					<tr>
						<td class="property">Executor</td>
						<td class="value"><pre><xsl:value-of select="@executor" /></pre></td>
					</tr>
					<tr>
						<td class="property">Execution Style</td>
						<td class="value"><pre><xsl:value-of select="@execStyle" /></pre></td>
					</tr>
					<tr>
						<td class="property">Role Sync Style</td>
						<td class="value"><pre><xsl:value-of select="@roleSyncStyle" /></pre></td>
					</tr>
					<tr>
						<td class="property">Operations</td>
						<td class="value">
							<xsl:call-template name="splitToList">
								<xsl:with-param name="pText" select="Attributes/Map/entry[@key='operations']/@value" />
								<xsl:with-param name="delim" select="','"/>
							</xsl:call-template>
						</td>
					</tr>
					<tr>
						<td class="property">Universal Manager</td>
						<td class="value">
							<xsl:call-template name="parseTextToBooleanIcon">
								<xsl:with-param name="boolVal" select="normalize-space(Attributes/Map/entry[@key='universalManager']/@value | Attributes/Map/entry[@key='universalManager']/value/Boolean/text())" />
							</xsl:call-template>
						</td>
					</tr>
					<xsl:if test="ManagedResources/ManagedResource/ApplicationRef/Reference[@class='sailpoint.object.Application']">
						<tr>
							<td class="property">Managed Resources</td>
							<td class="value">
								<ol>
									<xsl:for-each select="ManagedResources/ManagedResource/ApplicationRef/Reference[@class='sailpoint.object.Application']">
										<li>
											<xsl:call-template name="applicationReferenceLink">
												<xsl:with-param name="applicationName" select="@name" />
											</xsl:call-template>
										</li>
									</xsl:for-each>
								</ol>
							</td>
						</tr>
					</xsl:if>
				</table>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
