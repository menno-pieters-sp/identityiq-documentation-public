<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:java="http://xml.apache.org/xalan/java"
  xmlns:saxon="http://saxon.sf.net/"
	xmlns:iiqdoc="http://iiqdoc.config.data">
	<xsl:output omit-xml-declaration="yes" indent="yes" />

	<xsl:template name="getManagedAttributeDisplayName">
		<xsl:param name="application"/>
		<xsl:param name="attribute"/>
		<xsl:param name="value"/>
		<xsl:choose>
			<xsl:when test="//ManagedAttribute[ApplicationRef/Reference[@name=$application] and @value=$value and @attribute=$attribute]/@displayName">
				<xsl:value-of select="//ManagedAttribute[ApplicationRef/Reference[@name=$application] and @value=$value and @attribute=$attribute]/@displayName"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$value"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="excludeManagedAttributeExtendedAttribute">
		<xsl:param name="name" />
		<xsl:variable name="matches">
			<xsl:for-each select="document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='hideManagedAttributeExtendedAttribute']/value/List/String">
				<xsl:if test="text() = $name">
					<xsl:text>*</xsl:text>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:if test="not(normalize-space($matches) = '')">
			<xsl:text>true</xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template name="processManagedAttributes">
		<xsl:if test="/sailpoint/ManagedAttribute and document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='documentManagedAttributes']/@value='true'">
			<a name="Heading-ManagedAttribute"/>
			<h1>Entitlements</h1>

			<xsl:for-each select="/sailpoint/ManagedAttribute/ApplicationRef/Reference[not(@name=../../following-sibling::ManagedAttribute/ApplicationRef/Reference/@name)]">
				<xsl:variable name="applicationName" select="@name"/>
				<a>
					<xsl:attribute name="name">
						<xsl:value-of select="concat('ManagedAttribute-Application - ', @name)"/>
					</xsl:attribute>
				</a>
				<h2><xsl:value-of select="@name"/></h2>
				<table class="managedAttributeConfig">
					<tr>
						<th>Attribute</th>
						<th>Value</th>
						<th>Display Value</th>
						<th>Description</th>
						<xsl:if test="document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='showManagedAttributeType']/@value='true'">
							<th>Type</th>
						</xsl:if>
						<th>Owner</th>
						<th>Requestable</th>
						<xsl:if test="//ObjectConfig[@name='ManagedAttribute']/ObjectAttribute">
							<xsl:for-each select="//ObjectConfig[@name='ManagedAttribute']/ObjectAttribute">
								<xsl:variable name="excludeAttr">
									<xsl:call-template name="excludeManagedAttributeExtendedAttribute">
										<xsl:with-param name="name" select="@name" />
									</xsl:call-template>
								</xsl:variable>

								<xsl:if test="not(normalize-space($excludeAttr) = 'true')">
									<xsl:variable name="displayName">
										<xsl:choose>
											<xsl:when test="@displayName">
												<xsl:value-of select="@displayName"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="@name"/>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:variable>
							    <th><xsl:value-of select="$displayName" /></th>
								</xsl:if>
							</xsl:for-each>
						</xsl:if>
					</tr>

					<xsl:for-each select="/sailpoint/ManagedAttribute[ApplicationRef/Reference/@name = $applicationName]">
						<xsl:variable name="managedAttributeId" select="@id" />
						<tr>
							<td>
								<xsl:value-of select="@attribute"/>
							</td>
							<td>
								<xsl:value-of select="@value"/>
							</td>
							<td>
								<xsl:value-of select="@displayName"/>
							</td>
							<td>
								<xsl:if test="Attributes/Map/entry[@key='sysDescriptions']/value/Map/entry">
									<xsl:call-template name="stripHtml">
										<xsl:with-param name="sourceText">
											<xsl:choose>
												<xsl:when test="Attributes/Map/entry[@key='sysDescriptions']/value/Map/entry[@key='en_US']">
													<xsl:value-of select="Attributes/Map/entry[@key='sysDescriptions']/value/Map/entry[@key='en_US']/@value | Attributes/Map/entry[@key='sysDescriptions']/value/Map/entry[@key='en_US']/value/node()" />
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="Attributes/Map/entry[@key='sysDescriptions']/value/Map/entry[1]/@value | Attributes/Map/entry[@key='sysDescriptions']/value/Map/entry[1]/value/node()" />
												</xsl:otherwise>
											</xsl:choose>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
							</td>
						  <xsl:if test="document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='showManagedAttributeType']/@value='true'">
								<td>
									<xsl:value-of select="@type"/>
								</td>
							</xsl:if>
							<td>
								<xsl:if test="Owner/Reference/@name">
									<xsl:call-template name="workgroupOrIdentityLink">
										<xsl:with-param name="identityName" select="Owner/Reference/@name"/>
									</xsl:call-template>
								</xsl:if>
							</td>
							<td>
								<xsl:choose>
									<xsl:when test="@requestable = 'true'">
										<xsl:text>Yes</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>No</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</td>
							<xsl:if test="//ObjectConfig[@name='ManagedAttribute']/ObjectAttribute">
								<xsl:for-each select="//ObjectConfig[@name='ManagedAttribute']/ObjectAttribute">
									<xsl:variable name="excludeAttr">
										<xsl:call-template name="excludeManagedAttributeExtendedAttribute">
											<xsl:with-param name="name" select="@name" />
										</xsl:call-template>
									</xsl:variable>

									<xsl:if test="not(normalize-space($excludeAttr) = 'true')">
										<xsl:variable name="extendedAttributeName" select="@name" />
										<xsl:variable name="extendedAttributeType" select="@type" />
										<xsl:variable name="extendedAttributeValue" select="/sailpoint/ManagedAttribute[@id=$managedAttributeId]/Attributes/Map/entry[@key=$extendedAttributeName]/value/node() | /sailpoint/ManagedAttribute[@id=$managedAttributeId]/Attributes/Map/entry[@key=$extendedAttributeName]/@value" />
										<td>
											<xsl:choose>
												<xsl:when test="$extendedAttributeType = 'Identity' or $extendedAttributeType = 'sailpoint.object.Identity'">
													<xsl:call-template name="workgroupOrIdentityLinkById">
														<xsl:with-param name="identityId" select="$extendedAttributeValue" />
													</xsl:call-template>
												</xsl:when>
												<xsl:when test="$extendedAttributeType = 'boolean'">
													<xsl:variable name="boolVal" select="/sailpoint/ManagedAttribute[@id=$managedAttributeId]/Attributes/Map/entry[@key=$extendedAttributeName]/value | /sailpoint/ManagedAttribute[@id=$managedAttributeId]/Attributes/Map/entry[@key=$extendedAttributeName]/@value" />
													<xsl:call-template name="parseTextToBoolean">
														<xsl:with-param name="boolVal" select="$boolVal" />
													</xsl:call-template>
												</xsl:when>
												<xsl:otherwise>
													<xsl:value-of select="$extendedAttributeValue"/>
												</xsl:otherwise>
											</xsl:choose>
								    </td>
									</xsl:if>
								</xsl:for-each>
							</xsl:if>
						</tr>
					</xsl:for-each>
				</table>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
