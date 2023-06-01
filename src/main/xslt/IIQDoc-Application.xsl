<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:iiqdoc="http://iiqdoc.config.data">
    <xsl:output omit-xml-declaration="yes" indent="yes" />
    <xsl:template name="applicationReferenceLink">
        <xsl:param name="applicationName" />
        <xsl:choose>
            <xsl:when test="//Application[@name=$applicationName]">
                <a>
                    <xsl:attribute name="href">
						<xsl:value-of select="concat('#Application - ', $applicationName)" />
					</xsl:attribute>
                    <xsl:value-of select="$applicationName" />
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$applicationName" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="processApplications">
        <xsl:if test="document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='documentApplications']/@value='true' and /sailpoint/Application or /sailpoint/ImportAction[@name='execute']/Application">
            <a name="Heading-Application" />
            <h1>Applications</h1>
            <p>This section provides statistics on the application definitions that have been provided and an overview of the configurations for each of the definitions</p>
            <a name="Application-Statistics" />
            <h2>Application Statistics</h2>
            <p>The table below provides statistics on the application definitions below</p>
            <table class="mapTable">
                <tr>
                    <th class="rowHeader">Number of Applications</th>
                    <td class="mapTable">
                        <xsl:value-of select="count(/sailpoint/Application | /sailpoint/ImportAction[@name='execute']/Application)" />
                    </td>
                </tr>
                <xsl:variable name="numAuthoritativeApps" select="count(/sailpoint/Application[@authoritative='true'] | /sailpoint/ImportAction[@name='execute']/Application[@authoritative='true'])" />
                <tr>
                    <th class="rowHeader">Number of Authoritative Applications</th>
                    <td class="mapTable">
                        <xsl:value-of select="$numAuthoritativeApps" />
                    </td>
                </tr>
                <xsl:if test="$numAuthoritativeApps &gt; 0">
                    <tr>
                        <th class="rowHeader">Authoritative Applications</th>
                        <td class="mapTable">
                            <ul>
                                <xsl:for-each select="/sailpoint/Application[@authoritative='true'] | /sailpoint/ImportAction[@name='execute']/Application[@authoritative='true']">
                                    <xsl:sort select="@name" />
                                    <li>
                                        <xsl:call-template name="applicationReferenceLink">
                                            <xsl:with-param name="applicationName" select="@name" />
                                        </xsl:call-template>
                                    </li>
                                </xsl:for-each>
                            </ul>
                        </td>
                    </tr>
                </xsl:if>
                <tr>
                    <th class="rowHeader">Number of Applications Configured for Provisioning</th>
                    <td class="mapTable">
                        <xsl:value-of select="count(/sailpoint/Application[contains(@featuresString, 'PROVISIONING')] | /sailpoint/ImportAction[@name='execute']/Application[contains(@featuresString, 'PROVISIONING')])" />
                    </td>
                </tr>
                <xsl:if test="count(/sailpoint/Application[not(contains(@featuresString, 'PROVISIONING'))] | /sailpoint/ImportAction[@name='execute']/Application[not(contains(@featuresString, 'PROVISIONING'))]) &gt; 0">
                    <tr>
                        <th class="rowHeader">Applications not Configured for Provisioning</th>
                        <td class="mapTable">
                            <ul>
                                <xsl:for-each select="/sailpoint/Application[not(contains(@featuresString, 'PROVISIONING'))] | /sailpoint/ImportAction[@name='execute']/Application[not(contains(@featuresString, 'PROVISIONING'))]">
                                    <xsl:sort select="@name" />
                                    <li>
                                        <xsl:call-template name="applicationReferenceLink">
                                            <xsl:with-param name="applicationName" select="@name" />
                                        </xsl:call-template>
                                        <xsl:if test="ProvisioningForms/Form[@objectType = 'account' and @type='Create']">
                                            <xsl:text> (Has Account Create Policy)</xsl:text>
                                        </xsl:if>
                                    </li>
                                </xsl:for-each>
                            </ul>
                        </td>
                    </tr>
                </xsl:if>
                <xsl:for-each select="(/sailpoint/Application | /sailpoint/ImportAction[@name='execute']/Application)[not(following-sibling::*/@type = @type)]">
                    <xsl:sort select="@type" />
                    <xsl:variable name="typeName">
                        <xsl:value-of select="@type" />
                    </xsl:variable>
                    <xsl:if test="not(@type=following::*/@type)">
                        <tr>
                            <th class="rowHeader">
                                <xsl:value-of select="$typeName" />
                            </th>
                            <td class="mapTable">
                                <xsl:value-of select="count(/sailpoint/Application[@type = $typeName] | /sailpoint/ImportAction[@name='execute']/Application[@type = $typeName])" />
                            </td>
                        </tr>
                    </xsl:if>
                </xsl:for-each>
            </table>
                        
			<!-- Application definitions -->
            <xsl:if test="document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='applicationStatisticsOnly']/@value!='true'">
                <xsl:for-each select="/sailpoint/Application | /sailpoint/ImportAction[@name='execute']/Application">
                    <xsl:sort select="@name" />
                    <xsl:variable name="applicationName">
                        <xsl:value-of select="@name" />
                    </xsl:variable>
                    <a>
                        <xsl:attribute name="name">
						<xsl:value-of select="concat('Application - ', @name)" />
					</xsl:attribute>
                    </a>
                    <h2>
                        Application -
                        <xsl:value-of select="@name" />
                    </h2>
                    <table class="headerTable">
                        <tr>
                            <td class="property">Name</td>
                            <td class="value">
                                <xsl:value-of select="@name" />
                            </td>
                        </tr>
                        <tr>
                            <td class="property">Type</td>
                            <td class="value">
                                <xsl:value-of select="@type" />
                            </td>
                        </tr>
                        <tr>
                            <td class="property">Connector</td>
                            <td class="value">
                                <xsl:value-of select="@connector" />
                            </td>
                        </tr>
                        <xsl:if test="@connector = 'sailpoint.pse.connector.MultiConnectorAdapter'">
                            <tr>
                                <td class="property">Multi-Connector Adapter - Real Connector</td>
                                <td class="value">
                                    <xsl:value-of select="Attributes/Map/entry[@key='multiApplicationRealConnector']/@value|Attributes/Map/entry[@key='multiApplicationRealConnector']/value" />
                                </td>
                            </tr>
                        </xsl:if>
                        <xsl:if test="@connector = 'sailpoint.services.standard.connector.LogiPlexConnector'">
                            <tr>
                                <td class="property">LogiPlex - Real Connector</td>
                                <td class="value">
                                    <xsl:value-of select="Attributes/Map/entry[@key='logiPlexMasterConnector']/@value|Attributes/Map/entry[@key='logiPlexMasterConnector']/value" />
                                </td>
                            </tr>
                        </xsl:if>
                        <tr>
                            <td class="property">Owner</td>
                            <td class="value">
                                <xsl:call-template name="workgroupOrIdentityLink">
                                    <xsl:with-param name="identityName" select="Owner/Reference/@name" />
                                </xsl:call-template>
                            </td>
                        </tr>
                        <xsl:if test="document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='includeApplicationDetails']/@value='true'">
                            <tr>
                                <td class="property">Remediators</td>
                                <td class="value">
                                    <xsl:call-template name="workgroupOrIdentityLink">
                                        <xsl:with-param name="identityName" select="Remediators/Reference/@name" />
                                    </xsl:call-template>
                                </td>
                            </tr>
                            <tr>
                                <td class="property">Proxy Application</td>
                                <td class="value">
                                    <xsl:call-template name="applicationReferenceLink">
                                        <xsl:with-param name="applicationName">
                                            <xsl:value-of select="ProxyApplication/Reference/@name" />
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </td>
                            </tr>
                            <tr>
                                <td class="property">Profile Class</td>
                                <td class="value">
                                    <xsl:value-of select="@profileClass" />
                                </td>
                            </tr>
                        </xsl:if>
                        <tr>
                            <td class="property">Description</td>
                            <td class="value">
                                <xsl:call-template name="stripHtml">
                                    <xsl:with-param name="sourceText">
                                        <xsl:value-of select="Attributes/Map/entry[@key='sysDescriptions']/value/Map/entry[1]/@value | Attributes/Map/entry[@key='sysDescriptions']/value/Map/entry[1]/value" />
                                    </xsl:with-param>
                                </xsl:call-template>
                            </td>
                        </tr>
                        <tr>
                            <td class="property">Authoritative Application</td>
                            <td class="value">
                                <xsl:if test="@authoritative = 'true'">
                                    <xsl:text>Yes</xsl:text>
                                </xsl:if>
                            </td>
                        </tr>
                        <xsl:if test="document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='includeApplicationDetails']/@value='true'">
                            <tr>
                                <td class="property">Case Insensitive</td>
                                <td class="value">
                                    <xsl:if test="@caseInsensitive = 'true'">
                                        <xsl:text>Yes</xsl:text>
                                    </xsl:if>
                                </td>
                            </tr>
                        </xsl:if>
                        <tr>
                            <td class="property">Native Change Detection</td>
                            <td class="value">
                                <xsl:if test="Attributes/Map/entry[@key='nativeChangeDetectionEnabled']/@value = 'true' or Attributes/Map/entry[@key='nativeChangeDetectionEnabled']/value/Boolean = 'true'">
                                    Yes
                                    <table style="border-style: none; border-width: 0px;">
                                        <tr>
                                            <td>
                                                <b>Operations:</b>
                                            </td>
                                            <td>
                                                <ul>
                                                    <xsl:for-each select="Attributes/Map/entry[@key='nativeChangeDetectionOperations']/value/List/String">
                                                        <li>
                                                            <xsl:value-of select="." />
                                                        </li>
                                                    </xsl:for-each>
                                                </ul>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <b>Scope:</b>
                                            </td>
                                            <td>
                                                <xsl:choose>
                                                    <xsl:when test="Attributes/Map/entry[@key='nativeChangeDetectionAttributeScope']/@value = 'entitlements'">
                                                        <b>entitlements</b>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <b>attributes:</b>
                                                        <ul>
                                                            <xsl:for-each select="Attributes/Map/entry[@key='nativeChangeDetectionAttributes']/value/List/String">
                                                                <li>
                                                                    <xsl:value-of select="." />
                                                                </li>
                                                            </xsl:for-each>
                                                        </ul>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </td>
                                        </tr>
                                    </table>
                                </xsl:if>
                            </td>
                        </tr>
                    </table>

				<!-- Application Extended Attributes -->
                    <xsl:if test="//ObjectConfig[@name='Application']/ObjectAttribute">
                        <h3>Extended Attributes</h3>
                        <table class="applicationExtendedAttributes">
                            <tr>
                                <xsl:if test="document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='showExtendedAttributeCategory']/@value='true'">
                                    <th>Category</th>
                                </xsl:if>
                                <th>Name</th>
                                <th>Value</th>
                            </tr>
                            <xsl:for-each select="//ObjectConfig[@name='Application']/ObjectAttribute">
                                <xsl:variable name="extendedAttributeName" select="@name" />
                                <xsl:variable name="extendedAttributeDisplayName">
                                    <xsl:choose>
                                        <xsl:when test="@displayName">
                                            <xsl:value-of select="@displayName" />
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="@name" />
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <tr>
                                    <xsl:if test="document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='showExtendedAttributeCategory']/@value='true'">
                                        <td>
                                            <xsl:value-of select="@categoryName" />
                                        </td>
                                    </xsl:if>
                                    <td>
                                        <xsl:value-of select="$extendedAttributeDisplayName" />
                                    </td>
                                    <xsl:variable name="extendedAttributeType" select="@type" />
                                    <xsl:variable name="extendedAttributeValue" select="/sailpoint/Application[@name=$applicationName]/Attributes/Map/entry[@key=$extendedAttributeName]/value/node() | /sailpoint/Application[@name=$applicationName]/Attributes/Map/entry[@key=$extendedAttributeName]/@value" />
                                    <td>
                                        <xsl:choose>
                                            <xsl:when test="$extendedAttributeType = 'Identity' or $extendedAttributeType = 'sailpoint.object.Identity'">
                                                <xsl:call-template name="workgroupOrIdentityLinkById">
                                                    <xsl:with-param name="identityId" select="$extendedAttributeValue" />
                                                </xsl:call-template>
                                            </xsl:when>
                                            <xsl:when test="$extendedAttributeType = 'boolean'">
                                                <xsl:variable name="boolVal" select="/sailpoint/Application[@name=$applicationName]/Attributes/Map/entry[@key=$extendedAttributeName]/value | /sailpoint/Application[@name=$applicationName]/Attributes/Map/entry[@key=$extendedAttributeName]/@value" />
                                                <xsl:call-template name="parseTextToBoolean">
                                                    <xsl:with-param name="boolVal" select="$boolVal" />
                                                </xsl:call-template>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="$extendedAttributeValue" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </table>
                    </xsl:if>

				<!-- Configuration -->
                    <xsl:if test="document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='includeApplicationDetails']/@value='true'">
                        <h3>Features</h3>
                        <ul>
                            <xsl:call-template name="splitToList">
                                <xsl:with-param name="pText" select="@featuresString" />
                                <xsl:with-param name="delim" select="','" />
                            </xsl:call-template>
                        </ul>
                        <xsl:if test="//IntegrationConfig[ManagedResources/ManagedResource/ApplicationRef/Reference[@class='sailpoint.object.Application' and @name=$applicationName]]">
                            <h3>Integration</h3>
                            <p>The following integration is configured to handle provisioning for this application:</p>
                            <xsl:if test="count(//IntegrationConfig[ManagedResources/ManagedResource/ApplicationRef/Reference[@class='sailpoint.object.Application' and @name=$applicationName]]) &gt; 1">
                                <p style="color: red">&#9888; Multiple integration configs configured: ambiguous configuration!</p>
                            </xsl:if>
                            <ul>
                                <xsl:for-each select="//IntegrationConfig[ManagedResources/ManagedResource/ApplicationRef/Reference[@class='sailpoint.object.Application' and @name=$applicationName]]">
                                    <li>
                                        <xsl:call-template name="integrationConfigReferenceLink">
                                            <xsl:with-param name="integrationConfigName">
                                                <xsl:value-of select="@name" />
                                            </xsl:with-param>
                                        </xsl:call-template>
                                    </li>
                                </xsl:for-each>
                            </ul>
                        </xsl:if>
                    </xsl:if>

				<!-- Application Specific settings -->
                    <xsl:choose>
                        <xsl:when test="@type='DelimitedFile' and document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='includeApplicationConfigurationDetails.DelimitedFile']/@value='true'">
                            <h4>Settings</h4>
                            <xsl:variable name="attributes" select="Attributes/Map" />
                            <xsl:variable name="objectTypes" select="Schemas/Schema/@objectType" />
                            <table class="configuration">
                                <xsl:for-each select="$objectTypes">
                                    <xsl:variable name="objectType" select="." />
                                    <xsl:variable name="type">
                                        <xsl:choose>
                                            <xsl:when test="$objectType = 'account'" />
                                            <xsl:otherwise>
                                                <xsl:value-of select="concat($objectType, '.')" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    <tr>
                                        <th colspan="2">
                                            <xsl:value-of select="$objectType" />
                                        </th>
                                    </tr>
                                    <xsl:variable name="fileTransport" select="normalize-space(concat($attributes/entry[@key=concat($type,'filetransport')]/@value, $attributes/entry[@key=concat($type,'filetransport')]/value/String))" />
                                    <xsl:variable name="fileLocation" select="normalize-space(concat($attributes/entry[@key=concat($type,'file')]/@value, $attributes/entry[@key=concat($type,'file')]/value/String))" />
                                    <xsl:if test="not($fileTransport = 'local')">
                                        <tr>
                                            <td class="property">File Transport</td>
                                            <td class="value">
                                                <tt>
                                                    <xsl:value-of select="$fileTransport" />
                                                </tt>
                                            </td>
                                        </tr>
                                    </xsl:if>
                                    <tr>
                                        <td class="property">File Location</td>
                                        <td class="value">
                                            <tt>
                                                <xsl:value-of select="$fileLocation" />
                                            </tt>
                                        </td>
                                    </tr>
                                </xsl:for-each>
                            </table>
						<!-- TODO -->
                        </xsl:when>
                        <xsl:when test="@type='Active Directory - Direct' and document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='includeApplicationConfigurationDetails.ActiveDirectory']/@value='true'">
						<!-- TODO -->
                        </xsl:when>
                        <xsl:when test="@type='JDBC' and document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='includeApplicationConfigurationDetails.JDBC']/@value='true'">
                            <h4>Settings</h4>
                            <xsl:variable name="attributes" select="Attributes/Map" />
                            <xsl:variable name="objectTypes" select="Schemas/Schema/@objectType" />
                            <table class="configuration">
                                <xsl:for-each select="$objectTypes">
                                    <xsl:variable name="objectType" select="." />
                                    <xsl:variable name="type">
                                        <xsl:choose>
                                            <xsl:when test="$objectType = 'account'" />
                                            <xsl:otherwise>
                                                <xsl:value-of select="concat($objectType, '.')" />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    <tr>
                                        <th colspan="2">
                                            <xsl:value-of select="$objectType" />
                                        </th>
                                    </tr>
                                    <tr>
                                        <td class="property">JDBC URL</td>
                                        <td class="value">
                                            <tt>
                                                <xsl:value-of select="concat($attributes/entry[@key=concat($type,'url')]/@value, $attributes/entry[@key=concat($type,'url')]/value/String)" />
                                            </tt>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="property">JDBC Driver Class</td>
                                        <td class="value">
                                            <tt>
                                                <xsl:value-of select="$attributes/entry[@key=concat($type,'driverClass')]/@value" />
                                            </tt>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="property">User</td>
                                        <td class="value">
                                            <tt>
                                                <xsl:value-of select="$attributes/entry[@key=concat($type,'user')]/@value" />
                                            </tt>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="property">Password</td>
                                        <td class="value">
                                            <tt>
                                                <xsl:if test="string-length($attributes/entry[@key=concat($type,'password')]/@value) &gt; 0">
                                                    ********
                                                </xsl:if>
                                            </tt>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="property">SQL</td>
                                        <td class="value">
                                            <pre>
                                                <xsl:value-of select="concat($attributes/entry[@key='SQL']/@value, $attributes/entry[@key='SQL']/value/String)" />
                                            </pre>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="property">Get Object SQL</td>
                                        <td class="value">
                                            <pre>
                                                <xsl:value-of select="concat($attributes/entry[@key=concat($type,'getObjectSQL')]/@value, $attributes/entry[@key=concat($type,'getObjectSQL')]/value/String)" />
                                            </pre>
                                        </td>
                                    </tr>
                                    <xsl:variable name="delta" select="concat($attributes/entry[@key=concat($type,'aggregationMode')]/@value, $attributes/entry[@key=concat($type,'aggregationMode')]/value/Boolean)" />
                                    <tr>
                                        <th colspan="2">
                                            Delta: [
                                            <xsl:value-of select="$delta" />
                                            ]
                                        </th>
                                    </tr>
                                    <xsl:if test="$delta = 'true'">
                                        <tr>
                                            <td class="property">Delta Table</td>
                                            <td class="value">
                                                <tt>
                                                    <xsl:value-of select="$attributes/entry[@key=concat($type,'deltaTable')]/@value" />
                                                </tt>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="property">Get Object SQL</td>
                                            <td class="value">
                                                <pre>
                                                    <xsl:value-of select="concat($attributes/entry[@key=concat($type,'getDeltaSQL')]/@value, $attributes/entry[@key=concat($type,'getDeltaSQL')]/value/String)" />
                                                </pre>
                                            </td>
                                        </tr>
                                    </xsl:if>
                                </xsl:for-each>
                            </table>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:if test="document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='includeApplicationDetails']/@value='true'">
					<!-- Rules -->
                        <h3>Rules</h3>
                        <table class="rulesTable">
                            <tr>
                                <th colspan="2">Aggregation Rules</th>
                            </tr>
                            <tr>
                                <td class="property">Correlation Rule</td>
                                <td class="value">
                                    <xsl:call-template name="ruleReferenceLink">
                                        <xsl:with-param name="ruleName" select="CorrelationRule/Reference/@name" />
                                    </xsl:call-template>
                                </td>
                            </tr>
                            <tr>
                                <td class="property">Creation Rule</td>
                                <td class="value">
                                    <xsl:call-template name="ruleReferenceLink">
                                        <xsl:with-param name="ruleName" select="CreationRule/Reference/@name" />
                                    </xsl:call-template>
                                </td>
                            </tr>
                            <tr>
                                <td class="property">Manager Correlation Rule</td>
                                <td class="value">
                                    <xsl:call-template name="ruleReferenceLink">
                                        <xsl:with-param name="ruleName" select="ManagerCorrelationRule/Reference/@name" />
                                    </xsl:call-template>
                                </td>
                            </tr>
                            <tr>
                                <td class="property">Customization Rule</td>
                                <td class="value">
                                    <xsl:call-template name="ruleReferenceLink">
                                        <xsl:with-param name="ruleName" select="CustomizationRule/Reference/@name" />
                                    </xsl:call-template>
                                </td>
                            </tr>
                            <tr>
                                <td class="property">Managed Entitlement Customization Rule</td>
                                <td class="value">
                                    <xsl:call-template name="ruleReferenceLink">
                                        <xsl:with-param name="ruleName" select="ManagedAttributeCustomizationRule/Reference/@name" />
                                    </xsl:call-template>
                                </td>
                            </tr>
                            <tr>
                                <th colspan="2">Provisioning Rules</th>
                            </tr>
                            <tr>
                                <td class="property">Before Provisioning Rule</td>
                                <td class="value">
                                    <xsl:call-template name="ruleReferenceLink">
                                        <xsl:with-param name="ruleName" select="Attributes/Map/entry[@key='beforeProvisioningRule']/@value" />
                                    </xsl:call-template>
                                </td>
                            </tr>
                            <tr>
                                <td class="property">After Provisioning Rule</td>
                                <td class="value">
                                    <xsl:call-template name="ruleReferenceLink">
                                        <xsl:with-param name="ruleName" select="Attributes/Map/entry[@key='afterProvisioningRule']/@value" />
                                    </xsl:call-template>
                                </td>
                            </tr>
                            <xsl:if test="count(Attributes/Map/entry[@key='nativeRules']/value/List/String) &gt; 0">
                                <tr>
                                    <th colspan="2">Native Rules</th>
                                </tr>
                                <td class="value" colspan="2">
                                    <ul>
                                        <xsl:for-each select="Attributes/Map/entry[@key='nativeRules']/value/List/String">
                                            <li>
                                                <xsl:call-template name="ruleReferenceLink">
                                                    <xsl:with-param name="ruleName" select="node()" />
                                                </xsl:call-template>
                                            </li>
                                        </xsl:for-each>
                                    </ul>
                                </td>
                            </xsl:if>
						<!-- Connector Rules -->
                            <xsl:choose>
                                <xsl:when test="@type='DelimitedFile'">
                                    <tr>
                                        <th colspan="2">Connector Rules</th>
                                    </tr>
                                    <tr>
                                        <td class="property">Build Map Rule</td>
                                        <td class="value">
                                            <xsl:call-template name="ruleReferenceLink">
                                                <xsl:with-param name="ruleName" select="Attributes/Map/entry[@key='buildMapRule']/value" />
                                            </xsl:call-template>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="property">PreIterate Rule</td>
                                        <td class="value">
                                            <xsl:call-template name="ruleReferenceLink">
                                                <xsl:with-param name="ruleName" select="Attributes/Map/entry[@key='preIterateRule']/value" />
                                            </xsl:call-template>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="property">PostIterate Rule</td>
                                        <td class="value">
                                            <xsl:call-template name="ruleReferenceLink">
                                                <xsl:with-param name="ruleName" select="Attributes/Map/entry[@key='postIterateRule']/value" />
                                            </xsl:call-template>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="property">Map to ResourceObject Rule</td>
                                        <td class="value">
                                            <xsl:call-template name="ruleReferenceLink">
                                                <xsl:with-param name="ruleName" select="Attributes/Map/entry[@key='mapToResourceObjectRule']/value" />
                                            </xsl:call-template>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="property">MergeMaps Rule</td>
                                        <td class="value">
                                            <xsl:call-template name="ruleReferenceLink">
                                                <xsl:with-param name="ruleName" select="Attributes/Map/entry[@key='mergeMapsRule']/value" />
                                            </xsl:call-template>
                                        </td>
                                    </tr>
                                </xsl:when>
                                <xsl:when test="@type='JDBC'">
                                    <tr>
                                        <th colspan="2">Connector Rules</th>
                                    </tr>
                                    <tr>
                                        <td class="property">Build Map Rule</td>
                                        <td class="value">
                                            <xsl:call-template name="ruleReferenceLink">
                                                <xsl:with-param name="ruleName" select="Attributes/Map/entry[@key='buildMapRule']/value" />
                                            </xsl:call-template>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="property">Map to ResourceObject Rule</td>
                                        <td class="value">
                                            <xsl:call-template name="ruleReferenceLink">
                                                <xsl:with-param name="ruleName" select="Attributes/Map/entry[@key='mapToResourceObjectRule']/value" />
                                            </xsl:call-template>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="property">MergeMaps Rule</td>
                                        <td class="value">
                                            <xsl:call-template name="ruleReferenceLink">
                                                <xsl:with-param name="ruleName" select="Attributes/Map/entry[@key='mergeMapsRule']/value" />
                                            </xsl:call-template>
                                        </td>
                                    </tr>
                                    <xsl:choose>
                                        <xsl:when test="Attributes/Map/entry[@key='provisionRule']/value = 'operationRule'">
                                            <tr>
                                                <td class="property">JDBC Create Provisioning Rule</td>
                                                <td class="value">
                                                    <xsl:call-template name="ruleReferenceLink">
                                                        <xsl:with-param name="ruleName" select="Attributes/Map/entry[@key='jdbcCreateProvisioningRule']/value" />
                                                    </xsl:call-template>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="property">JDBC Delete Provisioning Rule</td>
                                                <td class="value">
                                                    <xsl:call-template name="ruleReferenceLink">
                                                        <xsl:with-param name="ruleName" select="Attributes/Map/entry[@key='jdbcDeleteProvisioningRule']/value" />
                                                    </xsl:call-template>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="property">JDBC Modify Provisioning Rule</td>
                                                <td class="value">
                                                    <xsl:call-template name="ruleReferenceLink">
                                                        <xsl:with-param name="ruleName" select="Attributes/Map/entry[@key='jdbcModifyProvisioningRule']/value" />
                                                    </xsl:call-template>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="property">JDBC Enable Provisioning Rule</td>
                                                <td class="value">
                                                    <xsl:call-template name="ruleReferenceLink">
                                                        <xsl:with-param name="ruleName" select="Attributes/Map/entry[@key='jdbcEnableProvisioningRule']/value" />
                                                    </xsl:call-template>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="property">JDBC Disable Provisioning Rule</td>
                                                <td class="value">
                                                    <xsl:call-template name="ruleReferenceLink">
                                                        <xsl:with-param name="ruleName" select="Attributes/Map/entry[@key='jdbcDisableProvisioningRule']/value" />
                                                    </xsl:call-template>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="property">JDBC Unlock Provisioning Rule</td>
                                                <td class="value">
                                                    <xsl:call-template name="ruleReferenceLink">
                                                        <xsl:with-param name="ruleName" select="Attributes/Map/entry[@key='jdbcUnlockProvisioningRule']/value" />
                                                    </xsl:call-template>
                                                </td>
                                            </tr>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <tr>
                                                <td class="property">JDBC Provisioning Rule</td>
                                                <td class="value">
                                                    <xsl:call-template name="ruleReferenceLink">
                                                        <xsl:with-param name="ruleName" select="Attributes/Map/entry[@key='jdbcProvisionRule']/value" />
                                                    </xsl:call-template>
                                                </td>
                                            </tr>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:when test="@connector = 'sailpoint.pse.connector.MultiConnectorAdapter'">
                                    <tr>
                                        <th colspan="2">Multi-Connector Adapter Rules</th>
                                    </tr>
                                    <tr>
                                        <td class="property">Multi Configuration Rule</td>
                                        <td class="value">
                                            <xsl:call-template name="ruleReferenceLink">
                                                <xsl:with-param name="ruleName" select="Attributes/Map/entry[@key='multiConfigurationRule']/value" />
                                            </xsl:call-template>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="property">Multi Credential Rule</td>
                                        <td class="value">
                                            <xsl:call-template name="ruleReferenceLink">
                                                <xsl:with-param name="ruleName" select="Attributes/Map/entry[@key='multiCredentialRule']/value" />
                                            </xsl:call-template>
                                        </td>
                                    </tr>
                                </xsl:when>
                            </xsl:choose>
                        </table>
                    </xsl:if>

				<!-- Correlation -->
                    <xsl:if test="count(AccountCorrelationConfig/Reference) &gt; 0 or string-length(Attributes/Map/entry[@key='managerCorrelationFilter']/value/Filter/@property) &gt; 0">
                        <h3>Correlation</h3>
                        <xsl:if test="count(AccountCorrelationConfig/Reference) &gt; 0">
                            <h4>Identity Correlation</h4>
                            <xsl:choose>
                                <xsl:when test="count(//CorrelationConfig) &gt; 0">
                                    <table>
                                        <tr>
                                            <th>Identity Attribute</th>
                                            <th>Account Attribute</th>
                                        </tr>
                                        <xsl:for-each select="AccountCorrelationConfig/Reference">
                                            <xsl:variable name="cconfig" select="@name" />
                                            <xsl:for-each select="//CorrelationConfig">
                                                <xsl:if test="@name = $cconfig">
                                                    <xsl:for-each select="AttributeAssignments/Filter[@operation='EQ']">
                                                        <tr>
                                                            <td>
                                                                <xsl:value-of select="@property" />
                                                            </td>
                                                            <td>
                                                                <xsl:value-of select="@value" />
                                                            </td>
                                                        </tr>
                                                    </xsl:for-each>
                                                </xsl:if>
                                            </xsl:for-each>
                                        </xsl:for-each>
                                    </table>
                                </xsl:when>
                                <xsl:otherwise>
                                    <ul>
                                        <xsl:for-each select="AccountCorrelationConfig/Reference">
                                            <li>
                                                <xsl:value-of select="AccountCorrelationConfig/Reference/@name" />
                                            </li>
                                        </xsl:for-each>
                                    </ul>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:if>
                        <xsl:if test="string-length(Attributes/Map/entry[@key='managerCorrelationFilter']/value/Filter/@property) &gt; 0">
                            <h4>Manager Correlation</h4>
                            <table>
                                <tr>
                                    <th>Manager Identity Attribute</th>
                                    <th>Account Attribute</th>
                                </tr>
                                <tr>
                                    <td>
                                        <xsl:value-of select="Attributes/Map/entry[@key='managerCorrelationFilter']/value/Filter/@property" />
                                    </td>
                                    <td>
                                        <xsl:value-of select="Attributes/Map/entry[@key='managerCorrelationFilter']/value/Filter/@value" />
                                    </td>
                                </tr>
                            </table>
                        </xsl:if>
                    </xsl:if>
                    <xsl:if test="document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='includeApplicationDetails']/@value='true'">
					<!-- Schemas -->
                        <h3>Schemas</h3>
                        <xsl:for-each select="Schemas/Schema">
                            <h4>
                                <xsl:value-of select="@objectType" />
                            </h4>
                            <table class="schemaHeader">
                                <tr>
                                    <th>Native Object Type</th>
                                    <td>
                                        <xsl:value-of select="@nativeObjectType" />
                                    </td>
                                    <th>Display Attribute</th>
                                    <td>
                                        <xsl:value-of select="@displayAttribute" />
                                    </td>
                                </tr>
                                <tr>
                                    <th>Identity Attribute</th>
                                    <td>
                                        <xsl:value-of select="@identityAttribute" />
                                    </td>
                                    <th>Instance Attribute</th>
                                    <td>
                                        <xsl:value-of select="@instanceAttribute" />
                                    </td>
                                </tr>
                                <xsl:if test="not(@objectType = 'account')">
                                    <tr>
                                        <th>Description Attribute</th>
                                        <td>
                                            <xsl:value-of select="@descriptionAttribute" />
                                        </td>
                                        <th>Group Membership Attribute</th>
                                        <td>
                                            <xsl:value-of select="Attributes/Map/entry[@key='groupMemberAttribute']/@value" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>Group Hierarchy Attribute</th>
                                        <td>
                                            <xsl:value-of select="@hierarchyAttribute" />
                                        </td>
                                        <th>Child Hierarchy</th>
                                        <td>
                                            <xsl:call-template name="parseTextToBoolean">
                                                <xsl:with-param name="boolVal" select="@childHierarchy" />
                                            </xsl:call-template>
                                        </td>
                                    </tr>
                                </xsl:if>
                            </table>
                            <table class="schemaAttributes">
                                <tr>
                                    <th>Attribute</th>
                                    <th>Description</th>
                                    <th>Type</th>
                                    <th>Multi</th>
                                    <th>Entitlement</th>
                                    <th>Managed</th>
                                    <th>Correlation Key</th>
                                    <th>Remediation</th>
                                </tr>
                                <xsl:for-each select="AttributeDefinition">
                                    <tr>
                                        <td>
                                            <xsl:value-of select="@name" />
                                        </td>
                                        <td>
                                            <xsl:value-of select="Description" />
                                        </td>
                                        <td>
                                            <xsl:value-of select="@type" />
                                        </td>
                                        <td>
                                            <xsl:if test="@multi = 'true'">
                                                Yes
                                            </xsl:if>
                                        </td>
                                        <td>
                                            <xsl:if test="@entitlement = 'true'">
                                                Yes
                                            </xsl:if>
                                        </td>
                                        <td>
                                            <xsl:if test="@managed = 'true'">
                                                Yes
                                            </xsl:if>
                                        </td>
                                        <td>
                                            <xsl:if test="@correlationKey = 'true'">
                                                Yes
                                            </xsl:if>
                                        </td>
                                        <td>
                                            <xsl:value-of select="@remediationModificationType" />
                                        </td>
                                    </tr>
                                </xsl:for-each>
                            </table>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:if test="document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='includeApplicationDetails']/@value='true'">
					<!-- Provisioning Policies - Old Style -->
                        <xsl:if test="count(Templates/Template) &gt; 0">
                            <h3>Provisioning Policies</h3>
                            <xsl:if test="string-length(Dependencies/Reference/@name) &gt; 0">
                                <h4>Dependencies</h4>
                                <ul>
                                    <xsl:for-each select="Dependencies/Reference">
                                        <li>
                                            <xsl:value-of select="@name" />
                                        </li>
                                    </xsl:for-each>
                                </ul>
                            </xsl:if>
                            <xsl:for-each select="Templates/Template">
                                <h4>
                                    <xsl:value-of select="@schemaObjectType" />
                                    -
                                    <xsl:value-of select="@name" />
                                    -
                                    <xsl:value-of select="@usage" />
                                </h4>
                                <table class="templateAttributes">
                                    <tr>
                                        <th>Attribute</th>
                                        <th>Type</th>
                                        <th>Multi</th>
                                        <th>Required</th>
                                        <th>Review Required</th>
                                        <th>Authoritative</th>
                                        <th>Display Only</th>
                                        <th>Value</th>
                                    </tr>
                                    <xsl:for-each select="Field">
                                        <tr>
                                            <td>
                                                <xsl:value-of select="@name" />
                                            </td>
                                            <td>
                                                <xsl:value-of select="@type" />
                                            </td>
                                            <td>
                                                <xsl:if test="@multi = 'true'">
                                                    Yes
                                                </xsl:if>
                                            </td>
                                            <td>
                                                <xsl:if test="@required = 'true'">
                                                    Yes
                                                </xsl:if>
                                            </td>
                                            <td>
                                                <xsl:if test="@reviewRequired = 'true'">
                                                    Yes
                                                </xsl:if>
                                            </td>
                                            <td>
                                                <xsl:if test="@authoritative = 'true'">
                                                    Yes
                                                </xsl:if>
                                            </td>
                                            <td>
                                                <xsl:if test="@displayOnly = 'true'">
                                                    Yes
                                                </xsl:if>
                                            </td>
                                            <td>
                                                <xsl:choose>
                                                    <xsl:when test="string-length(@value) &gt; 0">
                                                        <xsl:value-of select="@value" />
                                                    </xsl:when>
                                                    <xsl:when test="string-length(value) &gt; 0">
                                                        <xsl:value-of select="value" />
                                                    </xsl:when>
                                                    <xsl:when test="string-length(Script/Source) &gt; 0">
                                                        <b>Script:</b>
                                                        <br />
                                                        <tt>
                                                            <xsl:value-of select="Script/Source" />
                                                        </tt>
                                                    </xsl:when>
                                                    <xsl:when test="string-length(RuleRef/Reference/@name) &gt; 0">
                                                        <b>Rule:</b>
                                                        <xsl:call-template name="ruleReferenceLink">
                                                            <xsl:with-param name="ruleName" select="RuleRef/Reference/@name" />
                                                        </xsl:call-template>
                                                    </xsl:when>
                                                    <xsl:when test="string-length(AppDependency/@applicationName) &gt; 0">
                                                        <b>Dependency:</b>
                                                        <br />
                                                        Application:
                                                        <xsl:value-of select="AppDependency/@applicationName" />
                                                        <br />
                                                        Attribute:
                                                        <xsl:value-of select="AppDependency/@schemaAttributeName" />
                                                    </xsl:when>
                                                </xsl:choose>
                                            </td>
                                        </tr>
                                    </xsl:for-each>
                                </table>
                            </xsl:for-each>
                        </xsl:if>

					<!-- Provisioning Policies - New Style -->
                        <xsl:if test="ProvisioningForms/Form">
                            <h3>Provisioning Policies</h3>
                            <xsl:for-each select="Schemas/Schema">
                                <xsl:variable name="objectType" select="@objectType" />
                                <xsl:if test="../../ProvisioningForms/Form[@objectType=$objectType]">
                                    <h4>
                                        <xsl:value-of select="$objectType" />
                                    </h4>
                                    <xsl:for-each select="../../ProvisioningForms/Form[@objectType=$objectType]">
                                        <xsl:call-template name="processSingleForm" />
                                    </xsl:for-each>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:if>
                    </xsl:if>
                    <xsl:if test="ProvisioningConfig/@* | ProvisioningConfig/node()">
                        <h3>Provisioning Configuration</h3>
                        <table class="rulesTable">
                            <xsl:if test="ProvisioningConfig/@deleteToDisable">
                                <tr>
                                    <td class="property">Delete to disable</td>
                                    <td class="value">
                                        <xsl:value-of select="ProvisioningConfig/@deleteToDisable" />
                                    </td>
                                </tr>
                            </xsl:if>
                            <xsl:if test="ProvisioningConfig/@metaUser">
                                <tr>
                                    <td class="property">Meta User</td>
                                    <td class="value">
                                        <xsl:value-of select="ProvisioningConfig/@metaUser" />
                                    </td>
                                </tr>
                            </xsl:if>
                            <xsl:if test="ProvisioningConfig/@noPermissions">
                                <tr>
                                    <td class="property">No Permissions</td>
                                    <td class="value">
                                        <xsl:value-of select="ProvisioningConfig/@noPermissions" />
                                    </td>
                                </tr>
                            </xsl:if>
                            <xsl:if test="ProvisioningConfig/@noProvisioningRequests">
                                <tr>
                                    <td class="property">No Provisioning Requests</td>
                                    <td class="value">
                                        <xsl:value-of select="ProvisioningConfig/@noProvisioningRequests" />
                                    </td>
                                </tr>
                            </xsl:if>
                            <xsl:if test="ProvisioningConfig/@optimisticProvisionings">
                                <tr>
                                    <td class="property">Optimistic Provisioning</td>
                                    <td class="value">
                                        <xsl:value-of select="ProvisioningConfig/@optimisticProvisionings" />
                                    </td>
                                </tr>
                            </xsl:if>
                            <xsl:if test="ProvisioningConfig/@provisioningRequestExpiration">
                                <tr>
                                    <td class="property">Provisioning Expiration (days)</td>
                                    <td class="value">
                                        <xsl:value-of select="ProvisioningConfig/@provisioningRequestExpiration" />
                                    </td>
                                </tr>
                            </xsl:if>
                            <xsl:if test="ProvisioningConfig/@universalManager">
                                <tr>
                                    <td class="property">Universal Manager</td>
                                    <td class="value">
                                        <xsl:value-of select="ProvisioningConfig/@universalManager" />
                                    </td>
                                </tr>
                            </xsl:if>
                            <xsl:if test="ProvisioningConfig/ClusterScript">
                                <tr>
                                    <td class="property">Cluster Script</td>
                                    <td class="value">
                                        <xsl:if test="ProvisioningConfig/ClusterScript/Includes/Reference">
                                            <p>Includes:</p>
                                            <ul>
                                                <xsl:for-each select="ProvisioningConfig/ClusterScript/Includes/Reference">
                                                    <li>
                                                        <xsl:call-template name="ruleReferenceLink">
                                                            <xsl:with-param name="ruleName" select="@name" />
                                                        </xsl:call-template>
                                                    </li>
                                                </xsl:for-each>
                                            </ul>
                                        </xsl:if>
                                        <pre>
                                            <xsl:value-of select="ProvisioningConfig/ClusterScript/Source/text()" />
                                        </pre>
                                    </td>
                                </tr>
                            </xsl:if>
                            <xsl:if test="ProvisioningConfig/ManagedResource/ApplicationRef/Reference">
                                <tr>
                                    <td class="property">Plan Initializer Rule</td>
                                    <td class="value">
                                        <ul>
                                            <xsl:for-each select="ProvisioningConfig/ManagedResource/ApplicationRef/Reference">
                                                <li>
                                                    <xsl:call-template name="applicationReferenceLink">
                                                        <xsl:with-param name="applicationName" select="@name" />
                                                    </xsl:call-template>
                                                </li>
                                            </xsl:for-each>
                                        </ul>
                                    </td>
                                </tr>
                            </xsl:if>
                            <xsl:if test="ProvisioningConfig/PlanInitializer">
                                <tr>
                                    <td class="property">Plan Initializer Rule</td>
                                    <td class="value">
                                        <xsl:call-template name="ruleReferenceLink">
                                            <xsl:with-param name="ruleName" select="ProvisioningConfig/PlanInitializer/Reference/@name" />
                                        </xsl:call-template>
                                    </td>
                                </tr>
                            </xsl:if>
                            <xsl:if test="ProvisioningConfig/PlanInitializerScript">
                                <tr>
                                    <td class="property">Plan Initializer Script</td>
                                    <td class="value">
                                        <xsl:if test="ProvisioningConfig/PlanInitializerScript/Includes/Reference">
                                            <p>Includes:</p>
                                            <ul>
                                                <xsl:for-each select="ProvisioningConfig/PlanInitializerScript/Includes/Reference">
                                                    <li>
                                                        <xsl:call-template name="ruleReferenceLink">
                                                            <xsl:with-param name="ruleName" select="@name" />
                                                        </xsl:call-template>
                                                    </li>
                                                </xsl:for-each>
                                            </ul>
                                        </xsl:if>
                                        <pre>
                                            <xsl:value-of select="ProvisioningConfig/PlanInitializerScript/Source/text()" />
                                        </pre>
                                    </td>
                                </tr>
                            </xsl:if>
                        </table>
                    </xsl:if>
                    <xsl:if test="document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='includeApplicationDetails']/@value='true'">
					<!-- Password Policies -->
                        <xsl:if test="count(PasswordPolicies/PasswordPolicyHolder) &gt; 0">
                            <xsl:call-template name="processApplicationPasswordPolicies">
                                <xsl:with-param name="policies" select="PasswordPolicies" />
                            </xsl:call-template>
                        </xsl:if>
                    </xsl:if>
                </xsl:for-each>
            </xsl:if>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>