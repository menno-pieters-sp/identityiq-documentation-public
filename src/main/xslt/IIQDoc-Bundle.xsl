<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:iiqdoc="http://iiqdoc.config.data">
	<xsl:output omit-xml-declaration="yes" indent="yes" />

	<xsl:template name="getRoleDisplayName">
		<xsl:param name="name"/>
		<xsl:choose>
			<xsl:when test="//Bundle[@name=$name]/@displayName">
				<xsl:value-of select="//Bundle[@name=$name]/@displayName"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$name"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="roleReferenceLink">
		<xsl:param name="roleName"/>
		<xsl:choose>
			<xsl:when test="//Bundle[@name=$roleName]">
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="concat('#Bundle - ', $roleName)"/>
					</xsl:attribute>
					<xsl:choose>
						<xsl:when test="//Bundle[@name=$roleName]/@displayName">
						  <xsl:value-of select="//Bundle[@name=$roleName]/@displayName"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$roleName"/>
						</xsl:otherwise>
					</xsl:choose>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$roleName"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="documentSingleBundle" match="//Bundle">
		<xsl:comment>Role</xsl:comment>
		<xsl:variable name="roleName" select="@name"/>
		<xsl:variable name="roleDisplayName">
			<xsl:choose>
				<xsl:when test="normalize-space(@displayName)=''">
					<xsl:value-of select="@name"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@displayName"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<a>
			<xsl:attribute name="name">
				<xsl:value-of select="concat('Bundle - ', @name)" />
			</xsl:attribute>
		</a>
		<h3>Role: <xsl:value-of select="$roleDisplayName"/></h3>
		<table class="bundleDetails">
			<tr>
				<td><b>Name:</b></td>
				<td><xsl:value-of select="@name"/></td>
			</tr>
			<tr>
				<td><b>Display Name:</b></td>
				<td><xsl:value-of select="@displayName"/></td>
			</tr>
			<tr>
				<td><b>Type:</b></td>
				<td><xsl:value-of select="@type"/></td>
			</tr>
			<tr>
				<td><b>Owner:</b></td>
				<td>
					<xsl:call-template name="workgroupOrIdentityLink">
						<xsl:with-param name="identityName" select="Owner/Reference/@name"/>
					</xsl:call-template>
				</td>
			</tr>
			<tr>
				<td><b>Description:</b></td>
				<td>
					<xsl:choose>
						<xsl:when test="Attributes/Map/entry[@key='sysDescriptions']/value/Map/entry[@key='en_US']/@value | Attributes/Map/entry[@key='sysDescriptions']/value/Map/entry[@key='en_US']/value">
							<xsl:value-of select="Attributes/Map/entry[@key='sysDescriptions']/value/Map/entry[@key='en_US']/@value | Attributes/Map/entry[@key='sysDescriptions']/value/Map/entry[@key='en_US']/value" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="Attributes/Map/entry[@key='sysDescriptions']/value/Map/entry[1]/@value | Attributes/Map/entry[@key='sysDescriptions']/value/Map/entry[1]/value" />
						</xsl:otherwise>
					</xsl:choose>
				</td>
			</tr>
			<xsl:if test="document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='includeBundleDetails']/@value='true'">
				<tr>
					<td><b>Enable Activity Monitoring:</b></td>
					<td>
						<xsl:if test="ActivityConfig/@allEnabled = 'true'">
							<xsl:text>Yes</xsl:text>
				  	</xsl:if>
					</td>
				</tr>
				<tr>
					<td><b>Provision both profiles and policies:</b></td>
					<td>
						<xsl:if test="Attributes/Map/entry[@key='mergeTemplates']/@value = 'true' or Attributes/Map/entry[@key='mergeTemplates']/value/Boolean/text() = 'true'">
							<xsl:text>Yes</xsl:text>
				  	</xsl:if>
					</td>
				</tr>
				<tr>
					<td><b>Allow Multiple Assignments:</b></td>
					<td>
						<xsl:if test="Attributes/Map/entry[@key='allowMultipleAssignments']/@value = 'true' or Attributes/Map/entry[@key='allowMultipleAssignments']/value/Boolean/text() = 'true'">
							<xsl:text>Yes</xsl:text>
				  	</xsl:if>
					</td>
				</tr>
				<tr>
					<td><b>Allow Multiple Application Accounts:</b></td>
					<td>
						<xsl:if test="Attributes/Map/entry[@key='allowDuplicateAccounts']/@value = 'true' or Attributes/Map/entry[@key='allowDuplicateAccounts']/value/Boolean/text() = 'true'">
							<xsl:text>Yes</xsl:text>
				  	</xsl:if>
					</td>
				</tr>
			</xsl:if>
			<tr>
				<td><b>Disabled:</b></td>
				<td>
					<xsl:if test="@disabled = 'true'">
						<xsl:text>Yes</xsl:text>
			  	</xsl:if>
				</td>
			</tr>
			<xsl:if test="@pendingDelete = 'true'">
				<tr>
					<td><b>Pending Delete:</b></td>
					<td>Yes</td>
				</tr>
			</xsl:if>
		</table>

		<!-- Bundle Extended Attributes -->
		<xsl:if test="//ObjectConfig[@name='Bundle']/ObjectAttribute">
			<h4>Extended Attributes</h4>
			<table class="bundleExtendedAttributes">
				<tr>
					<xsl:if test="document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='showExtendedAttributeCategory']/@value='true'">
						<th>Category</th>
					</xsl:if>
					<th>Name</th>
					<th>Value</th>
				</tr>
				<xsl:for-each select="//ObjectConfig[@name='Bundle']/ObjectAttribute">
					<xsl:variable name="extendedAttributeName" select="normalize-space(@name)"/>
					<xsl:variable name="extendedAttributeDisplayName">
						<xsl:choose>
							<xsl:when test="@displayName">
								<xsl:value-of select="@displayName"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="@name"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="extendedAttributeType" select="@type" />
					<xsl:variable name="extendedAttributeValue" select="/sailpoint/Bundle[@name=$roleName]/Attributes/Map/entry[@key=$extendedAttributeName]/value/node() | /sailpoint/Bundle[@name=$roleName]/Attributes/Map/entry[@key=$extendedAttributeName]/@value"/>
					<tr>
						<xsl:if test="document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='showExtendedAttributeCategory']/@value='true'">
							<td><xsl:value-of select="@categoryName"/></td>
						</xsl:if>
						<td><xsl:value-of select="$extendedAttributeDisplayName"/></td>
						<td>
							<xsl:choose>
								<xsl:when test="$extendedAttributeType = 'Identity' or $extendedAttributeType = 'sailpoint.object.Identity'">
									<xsl:call-template name="workgroupOrIdentityLinkById">
										<xsl:with-param name="identityId" select="$extendedAttributeValue" />
									</xsl:call-template>
								</xsl:when>
								<xsl:when test="$extendedAttributeType = 'boolean'">
									<xsl:variable name="boolVal" select="/sailpoint/Bundle[@name=$roleName]/Attributes/Map/entry[@key=$extendedAttributeName]/value | /sailpoint/Bundle[@name=$roleName]/Attributes/Map/entry[@key=$extendedAttributeName]/@value" />
									<xsl:call-template name="parseTextToBoolean">
										<xsl:with-param name="boolVal" select="$boolVal" />
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$extendedAttributeValue"/>
								</xsl:otherwise>
							</xsl:choose>
						</td>
					</tr>
				</xsl:for-each>
			</table>
		</xsl:if>

		<!-- Assignment Logic -->
		<xsl:if test="Selector/IdentitySelector">
			<h4>Assignment Rule</h4>
			<xsl:for-each select="Selector/IdentitySelector">
				<xsl:call-template name="processSingleIdentitySelector"/>
			</xsl:for-each>
		</xsl:if>

		<!-- Inherited Roles -->
		<xsl:if test="Inheritance/Reference">
			<h4>Inherited Roles (Role Hierarchy)</h4>
			<ul>
				<xsl:for-each select="Inheritance/Reference">
					<li>
						<xsl:call-template name="roleReferenceLink">
							<xsl:with-param name="roleName">
								<xsl:value-of select="@name"/>
							</xsl:with-param>
						</xsl:call-template>
					</li>
				</xsl:for-each>
			</ul>
		</xsl:if>

		<!-- Required Roles -->
		<xsl:if test="Requirements/Reference">
			<h4>Required Roles</h4>
			<ul>
				<xsl:for-each select="Requirements/Reference">
					<li>
						<xsl:call-template name="roleReferenceLink">
							<xsl:with-param name="roleName">
								<xsl:value-of select="@name"/>
							</xsl:with-param>
						</xsl:call-template>
					</li>
				</xsl:for-each>
			</ul>
		</xsl:if>

		<!-- Permitted Roles -->
		<xsl:if test="Permits/Reference">
			<h4>Permitted Roles</h4>
			<ul>
				<xsl:for-each select="Permits/Reference">
					<li>
						<xsl:call-template name="roleReferenceLink">
							<xsl:with-param name="roleName">
								<xsl:value-of select="@name"/>
							</xsl:with-param>
						</xsl:call-template>
					</li>
				</xsl:for-each>
			</ul>
		</xsl:if>

		<!-- ProvisioningPlan -->
		<xsl:if test="ProvisioningPlan">
			<h4>Provisioning Plan</h4>
			<xsl:for-each select="ProvisioningPlan">
				<xsl:call-template name="processProvisioningPlan"/>
			</xsl:for-each>
		</xsl:if>

		<!-- Profiles -->
		<xsl:if test="Profiles/Profile">
			<h4>Entitlement Profiles (Entitlements included in the role)</h4>
			<xsl:for-each select="Profiles/Profile">
				<xsl:variable name="applicationName" select="ApplicationRef/Reference/@name" />
				<table class="entitlementProfileTable">
					<tr>
						<th>Application</th>
						<td>
							<xsl:call-template name="applicationReferenceLink">
								<xsl:with-param name="applicationName">
									<xsl:value-of select="$applicationName"/>
								</xsl:with-param>
							</xsl:call-template>
						</td>
					</tr>
					<tr>
						<th>Constraints</th>
						<td>
							<xsl:for-each select="Constraints/node()">
								<xsl:if test="name(.) = 'CompositeFilter'">
									<xsl:call-template name="processCompositeFilter">
									</xsl:call-template>
								</xsl:if>
								<xsl:if test="name(.) = 'Filter'">
									<xsl:call-template name="processFilter">
										<xsl:with-param name="lookupManagedAttributeDescription" select="'true'"/>
										<xsl:with-param name="managedAttributeApplication" select="$applicationName"/>
									</xsl:call-template>
								</xsl:if>
							</xsl:for-each>
						</td>
					</tr>
				</table>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>

	<xsl:template name="processBundles">
		<xsl:if test="/sailpoint/Bundle and document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='documentBundles']/@value='true'">
			<a name="Heading-Bundle"/>
			<h1>Roles</h1>

			<xsl:choose>
				<xsl:when test="/sailpoint/ObjectConfig[@name='Bundle'] or /sailpoint/ImportAction[@name='merge' or @name='execute']/ObjectConfig[@name='Bundle']">
					<!-- Organize by type of role -->
					<xsl:for-each select="(/sailpoint|/sailpoint/ImportAction[@name='merge' or @name='execute'])/ObjectConfig[@name='Bundle']/Attributes/Map/entry[@key='roleTypeDefinitions']/value/List/RoleTypeDefinition">
						<xsl:sort select="@displayName"/>
						<xsl:variable name="roleType" select="@name"/>
						<xsl:variable name="roleTypeDisplayName" select="@displayName"/>
						<xsl:if test="/sailpoint/Bundle[@type=$roleType]">
							<h2><xsl:value-of select="$roleTypeDisplayName"/></h2>
							<xsl:for-each select="/sailpoint/Bundle[@type=$roleType]">
								<xsl:sort select="@name"/>
								<xsl:call-template name="documentSingleBundle" />
							</xsl:for-each>
						</xsl:if>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<!-- Just iterate over all the roles in the file -->
					<xsl:for-each select="/sailpoint/Bundle">
						<xsl:call-template name="documentSingleBundle"/>
					</xsl:for-each>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
