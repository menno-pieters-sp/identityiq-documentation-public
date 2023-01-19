<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:iiqdoc="http://iiqdoc.config.data">

	<xsl:output omit-xml-declaration="yes" indent="yes"/>

	<xsl:template name="processAuditConfig">

		<xsl:if test="/sailpoint/AuditConfig[@name='AuditConfig'] or /sailpoint/ImportAction[@name='merge' or @name='execute']/AuditConfig[@name='AuditConfig']">
			<a name="Heading-AuditConfig"/>
			<h1>Audit Configuration</h1>

			<xsl:if test="//AuditConfig[@name='AuditConfig']/AuditActions/AuditAction">
				<h2>Audit Actions</h2>
				<table class="mapTable">

					<xsl:for-each select="//AuditConfig[@name='AuditConfig']/AuditActions/AuditAction">
						<tr>
							<th class="rowHeader">
								<xsl:call-template name="localize">
									<xsl:with-param name="key" select="@displayName"/>
								</xsl:call-template>
							</th>
							<td class="mapTable">
								<xsl:call-template name="parseTextToBooleanIcon">
									<xsl:with-param name="boolVal" select="@enabled"/>
								</xsl:call-template>
							</td>
						</tr>
					</xsl:for-each>
				</table>
			</xsl:if>

			<xsl:if test="//AuditConfig[@name='AuditConfig']/AuditAttributes/AuditAttribute[@class='Identity']">
				<h2>Identity Attribute Changes</h2>
				<table class="mapTable">
					<xsl:for-each select="//AuditConfig[@name='AuditConfig']/AuditAttributes/AuditAttribute">
						<tr>
							<th class="rowHeader">
								<xsl:call-template name="localize">
									<xsl:with-param name="key" select="@displayName"/>
								</xsl:call-template>
							</th>
							<td class="mapTable">
								<xsl:call-template name="parseTextToBooleanIcon">
									<xsl:with-param name="boolVal" select="@enabled"/>
								</xsl:call-template>
							</td>
						</tr>
					</xsl:for-each>
				</table>
			</xsl:if>

			<xsl:if test="//AuditConfig[@name='AuditConfig']/AuditClasses/AuditClass">
				<h2>Class Actions</h2>
				<table class="mapTable">
					<tr>
						<th>Attribute</th>
						<th>Create</th>
						<th>Update</th>
						<th>Delete</th>
					</tr>
					<xsl:for-each select="//AuditConfig[@name='AuditConfig']/AuditClasses/AuditClass">
						<tr>
							<th class="rowHeader">
								<xsl:value-of select="@displayName | @name"/>
							</th>
							<td class="mapTable">
								<xsl:call-template name="parseTextToBooleanIcon">
									<xsl:with-param name="boolVal" select="@create"/>
								</xsl:call-template>
							</td>
							<td class="mapTable">
								<xsl:call-template name="parseTextToBooleanIcon">
									<xsl:with-param name="boolVal" select="@update"/>
								</xsl:call-template>
							</td>
							<td class="mapTable">
								<xsl:call-template name="parseTextToBooleanIcon">
									<xsl:with-param name="boolVal" select="@delete"/>
								</xsl:call-template>
							</td>
						</tr>
					</xsl:for-each>
				</table>
			</xsl:if>

			<xsl:if test="//AuditConfig[@name='AuditConfig']/AuditSCIMResources/AuditSCIMResource">
				<h2>SCIM Resource Actions</h2>
				<table class="mapTable">
					<tr>
						<th>Attribute</th>
						<th>Read</th>
						<th>Create</th>
						<th>Update</th>
						<th>Delete</th>
					</tr>
					<xsl:for-each select="//AuditConfig[@name='AuditConfig']/AuditSCIMResources/AuditSCIMResource">
						<tr>
							<th class="rowHeader">
								<xsl:value-of select="@displayName | @name"/>
							</th>
							<td class="mapTable">
								<xsl:call-template name="parseTextToBooleanIcon">
									<xsl:with-param name="boolVal" select="@read"/>
								</xsl:call-template>
							</td>
							<td class="mapTable">
								<xsl:call-template name="parseTextToBooleanIcon">
									<xsl:with-param name="boolVal" select="@create"/>
								</xsl:call-template>
							</td>
							<td class="mapTable">
								<xsl:call-template name="parseTextToBooleanIcon">
									<xsl:with-param name="boolVal" select="@update"/>
								</xsl:call-template>
							</td>
							<td class="mapTable">
								<xsl:call-template name="parseTextToBooleanIcon">
									<xsl:with-param name="boolVal" select="@delete"/>
								</xsl:call-template>
							</td>
						</tr>
					</xsl:for-each>
				</table>
			</xsl:if>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
