<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:iiqdoc="http://iiqdoc.config.data">
	<xsl:output omit-xml-declaration="yes" indent="yes" method="html" />

	<xsl:template name="groupFactoryReferenceLink">
		<xsl:param name="groupFactoryName"/>
		<xsl:param name="groupFactoryId"/>
		<xsl:choose>
			<xsl:when test="//GroupFactory[@name=$groupFactoryName] and document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='documentGroupFactories']/@value='true'">
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="concat('#GroupFactory - ', $groupFactoryName)"/>
					</xsl:attribute>
					<xsl:value-of select="//GroupFactory[@name=$groupFactoryName]/@name"/>
				</a>
			</xsl:when>
			<xsl:when test="//GroupFactory[@id=$groupFactoryId] and document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='documentGroupFactories']/@value='true'">
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="concat('#GroupFactory - ', //GroupFactory[@id=$groupFactoryId]/@name)"/>
					</xsl:attribute>
					<xsl:value-of select="//GroupFactory[@id=$groupFactoryId]/@name"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$groupFactoryName"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="processGroupFactories">
		<xsl:if test="/sailpoint/GroupFactory and document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='documentGroupFactories']/@value='true'">
			<a name="Heading-GroupFactory"/>
			<h1>Group Factories</h1>
			<xsl:for-each select="/sailpoint/GroupFactory">
				<xsl:variable name="groupFactoryName" select="@name"/>
				<a>
					<xsl:attribute name="name">
						<xsl:value-of select="concat('GroupFactory - ', @name)" />
					</xsl:attribute>
				</a>
				<h2>
					<xsl:value-of select="@name" />
				</h2>
				<table class="groupFactoryTable">
					<tr>
						<th>Factory Attribute</th>
						<td><xsl:value-of select="@factoryAttribute"/></td>
					</tr>
					<tr>
						<th>Owner</th>
						<td>
							<xsl:call-template name="workgroupOrIdentityLink">
								<xsl:with-param name="identityName" select="Owner/Reference/@name" />
							</xsl:call-template>
						</td>
					</tr>
					<tr>
						<th>Description</th>
						<td><xsl:value-of select="Description/text()"/></td>
					</tr>
					<tr>
						<th>Enabled</th>
						<td><xsl:value-of select="@enabled"/></td>
					</tr>
					<tr>
						<th>Groups</th>
						<td>
							<xsl:if test="//GroupDefinition/Factory/Reference[@name = $groupFactoryName]">
								<ul>
									<xsl:for-each select="//GroupDefinition/Factory/Reference[@name = $groupFactoryName]/../..">
										<li><xsl:value-of select="@name"/></li>
									</xsl:for-each>
								</ul>
							</xsl:if>
						</td>
					</tr>
				</table>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
