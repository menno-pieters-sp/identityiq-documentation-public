<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:iiqdoc="http://iiqdoc.config.data" xmlns:wgemailoptions="http://wgemailoptions.data">
	<xsl:output omit-xml-declaration="yes" indent="yes" />

	<wgemailoptions:notifications>
		<wgemailoptions:notification name="Both" description="Notify members and group email"/>
		<wgemailoptions:notification name="Disabled" description="Disable notifications"/>
		<wgemailoptions:notification name="GroupEmailOnly" description="Notify group email only"/>
		<wgemailoptions:notification name="MembersOnly" description="Notify members only"/>
	</wgemailoptions:notifications>

	<xsl:template name="translateWorkgroupNotificationOptions">
		<xsl:param name="option"/>
		<xsl:choose>
			<xsl:when test="document('IIQDoc-Workgroup.xsl')//wgemailoptions:notifications/wgemailoptions:notification[@name=$option]">
				<xsl:value-of select="document('IIQDoc-Workgroup.xsl')//wgemailoptions:notifications/wgemailoptions:notification[@name=$option]/@description"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$option"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="workgroupOrIdentityLinkById">
		<xsl:param name="identityId"/>
		<xsl:if test="//Identity[@id=$identityId or @name=$identityId]">
			<xsl:variable name="identityName" select="//Identity[@id=$identityId or @name=$identityId]/@name"/>
			<xsl:call-template name="workgroupOrIdentityLink">
				<xsl:with-param name="identityName" select="$identityName"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="workgroupOrIdentityLink">
		<xsl:param name="identityName"/>
		<xsl:choose>
			<xsl:when test="//Identity[@workgroup='true' and @name=$identityName] and document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='documentWorkgroups']/@value='true'">
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="concat('#Workgroup - ', $identityName)"/>
					</xsl:attribute>
					<xsl:value-of select="//Identity[@workgroup='true' and @name=$identityName]/Attributes/Map/entry[@key='displayName']/@value"/>
				</a>
			</xsl:when>
			<xsl:when test="//Identity[not(@workgroup='true') and @name=$identityName]">
				<xsl:value-of select="//Identity[not(@workgroup='true') and @name=$identityName]/Attributes/Map/entry[@key='displayName']/@value"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$identityName"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="processWorkgroups">
		<xsl:if test="/sailpoint/Identity[@workgroup='true'] and document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='documentWorkgroups']/@value='true'">
			<a name="Heading-Workgroups"/>
			<h1>Workgroups</h1>
			<xsl:for-each select="/sailpoint/Identity[@workgroup='true']">
				<xsl:sort select="@name"/>
				<xsl:variable name="workgroupName"><xsl:value-of select="@name"/></xsl:variable>
				<a>
					<xsl:attribute name="name">
						<xsl:value-of select="concat('Workgroup - ', @name)"/>
					</xsl:attribute>
				</a>
				<h2><xsl:value-of select="concat('Workgroup: ', @name)"/></h2>
				<table class="managedAttributeConfig">
					<tr>
						<td><b>Display Name</b></td>
						<td><xsl:value-of select="Attributes/Map/entry[@key='displayName']/@value"/></td>
					</tr>
					<tr>
						<td><b>Email</b></td>
						<td><xsl:value-of select="Attributes/Map/entry[@key='email']/@value"/></td>
					</tr>
					<xsl:if test="document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='includeWorkgroupRights']/@value='true'" >
						<tr>
							<td><b>Capabilities</b></td>
							<td>
								<xsl:if test="Capabilities/Reference">
									<ul>
										<xsl:for-each select="Capabilities/Reference">
											<li><xsl:value-of select="@name"/></li>
										</xsl:for-each>
									</ul>
								</xsl:if>
					  	</td>
						</tr>
						<!-- TODO: Scopes -->
					</xsl:if>
					<tr>
						<td><b>Notification option</b></td>
						<td>
							<xsl:call-template name="translateWorkgroupNotificationOptions">
								<xsl:with-param name="option" select="Preferences/Map/entry[@key='workgroupNotificationOption']/value/WorkgroupNotifationOption"/>
							</xsl:call-template>
						</td>
					</tr>
					<tr>
						<td><b>Members</b></td>
						<td>
							<xsl:if test="//sailpoint/Identity[not(@workgroup = 'true')]/Workgroups/Reference/@name = $workgroupName">
								<ul>
									<xsl:for-each select="//sailpoint/Identity[not(@workgroup = 'true')]/Workgroups/Reference[@name = $workgroupName]">
										<li><xsl:value-of select="../../Attributes/Map/entry[@key='displayName']/@value"/></li>
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
