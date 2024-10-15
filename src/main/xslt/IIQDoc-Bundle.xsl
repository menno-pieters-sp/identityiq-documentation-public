<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:iiqdoc="http://iiqdoc.config.data">
	<xsl:output omit-xml-declaration="yes" indent="yes" />

	<xsl:key name="entitlement" match="/sailpoint/Bundle/Profiles/Profile/Constraints/Filter[@operation='CONTAINS_ALL']/Value/List/String" use="concat(../../../../../ApplicationRef/Reference/@name,'|',../../../@property,'|',text())" />
	<xsl:key name="assignmentRules" match="/sailpoint/Bundle[not(@disabled='true')]/Selector/IdentitySelector/RuleRef/Reference" use="@name" />
	<xsl:key name="assignmentPopulations" match="/sailpoint/Bundle[not(@disabled='true')]/Selector/IdentitySelector/PopulationRef/Reference" use="@name" />

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
			<xsl:when test="//Bundle[@name=$roleName] and document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='documentBundles']/@value='true' and not(document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='bundleStatisticsOnly']/@value='true')">
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
		
		<xsl:if test="document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='includeBundleDetails']/@value='true'">
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
		
		<xsl:if test="document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='includeBundleDetails']/@value='true'">
			<!-- Required by other roles -->
			<xsl:if test="//Bundle[Requirements/Reference[@name=$roleName]]">
				<h4>Required by Roles</h4>
				<xsl:for-each select="//Bundle[Requirements/Reference[@name=$roleName]]">
					<li>
						<xsl:call-template name="roleReferenceLink">
							<xsl:with-param name="roleName">
								<xsl:value-of select="@name"/>
							</xsl:with-param>
						</xsl:call-template>
					</li>
				</xsl:for-each>
			</xsl:if>
			
			<!-- Permitted by other roles -->
			<xsl:if test="//Bundle[Permits/Reference[@name=$roleName]]">
				<h4>Permitted by Roles</h4>
				<xsl:for-each select="//Bundle[Permits/Reference[@name=$roleName]]">
					<li>
						<xsl:call-template name="roleReferenceLink">
							<xsl:with-param name="roleName">
								<xsl:value-of select="@name"/>
							</xsl:with-param>
						</xsl:call-template>
					</li>
				</xsl:for-each>
			</xsl:if>
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

	<xsl:template name="processBundleStatistics">
		<a name="Bundle - Statistics"/>
		<h2>Role Statistics</h2>
		<table class="mapTable">
                <tr>
                    <th class="rowHeader">Total Number of Roles</th>
                    <td class="mapTable">
                        <xsl:value-of select="count(/sailpoint/Bundle)"/>
						<xsl:text> (disabled: </xsl:text>
						<xsl:value-of select="count(/sailpoint/Bundle[@disabled='true'])"/>
						<xsl:text>)</xsl:text>
                    </td>
                </tr>
                <tr>
                    <th colspan="2" class="rowHeader">Count per Role Type</th>
                </tr>
				<xsl:for-each select="(/sailpoint|/sailpoint/ImportAction[@name='merge' or @name='execute'])/ObjectConfig[@name='Bundle']/Attributes/Map/entry[@key='roleTypeDefinitions']/value/List/RoleTypeDefinition">
					<xsl:sort select="@displayName"/>
					<xsl:variable name="roleType" select="@name"/>
					<xsl:variable name="roleTypeDisplayName" select="@displayName"/>
					<tr>
                    	<th class="rowHeader"><xsl:value-of select="$roleType"/></th>
                    	<td class="mapTable">
							<xsl:value-of select="count(/sailpoint/Bundle[@type=$roleType])"/>
							<xsl:text> (disabled: </xsl:text>
							<xsl:value-of select="count(/sailpoint/Bundle[@type=$roleType and @disabled='true'])"/>
							<xsl:text>)</xsl:text>
						</td>
      		        </tr>
				</xsl:for-each>
                <tr>
                    <th colspan="2" class="rowHeader">Other</th>
                </tr>
                <tr>
                    <th class="rowHeader">Roles Pending Deletion</th>
                    <td class="mapTable">
						<xsl:value-of select="count(/sailpoint/Bundle[@pendingDelete='true'])"/>
					</td>
                </tr>
                <tr>
                    <th class="rowHeader">Enabled Roles with a Single Entitlement</th>
                    <td class="mapTable">
						<ul>
							<xsl:for-each select="(/sailpoint|/sailpoint/ImportAction[@name='merge' or @name='execute'])/ObjectConfig[@name='Bundle']/Attributes/Map/entry[@key='roleTypeDefinitions']/value/List/RoleTypeDefinition">
								<xsl:variable name="roleType" select="@name"/>
								<xsl:variable name="roleTypeDisplayName" select="@displayName"/>
								<xsl:variable name="roleCount" select="count(/sailpoint/Bundle[not(@disabled='true') and @type=$roleType and count(Profiles/Profile/Constraints/Filter[@operation='CONTAINS_ALL']/Value/List/String)=1])"/>
								<xsl:if test="$roleCount > 0">
									<li>
										<xsl:value-of select="$roleTypeDisplayName"/>
										<xsl:text>: </xsl:text>
										<xsl:value-of select="$roleCount"/>
									</li>
								</xsl:if>
							</xsl:for-each>
						</ul>
					</td>
                </tr>
                <tr>
                    <th class="rowHeader">Enabled Assignable Roles with Direct Entitlements</th>
                    <td class="mapTable">
						<ul>
							<xsl:for-each select="(/sailpoint|/sailpoint/ImportAction[@name='merge' or @name='execute'])/ObjectConfig[@name='Bundle']/Attributes/Map/entry[@key='roleTypeDefinitions']/value/List/RoleTypeDefinition[not(@noAutoAssignment='true' or @noManualAssignment='true')]">
								<xsl:variable name="roleType" select="@name"/>
								<xsl:variable name="roleTypeDisplayName" select="@displayName"/>
								<xsl:variable name="roleCount" select="count(/sailpoint/Bundle[not(@disabled='true') and @type=$roleType and Profiles/Profile/Constraints/Filter])"/>
								<xsl:if test="$roleCount > 0">
									<li>
										<xsl:value-of select="$roleTypeDisplayName"/>
										<xsl:text>: </xsl:text>
										<xsl:value-of select="$roleCount"/>
									</li>
								</xsl:if>
							</xsl:for-each>
						</ul>
					</td>
                </tr>
                <tr>
                    <th class="rowHeader">Enabled Assignable Roles without Permitted or Required Roles, Provisioning Policy or Entitlements</th>
                    <td class="mapTable">
						<ul>
							<xsl:for-each select="(/sailpoint|/sailpoint/ImportAction[@name='merge' or @name='execute'])/ObjectConfig[@name='Bundle']/Attributes/Map/entry[@key='roleTypeDefinitions']/value/List/RoleTypeDefinition[not(@noAutoAssignment='true' or @noManualAssignment='true')]">
								<xsl:variable name="roleType" select="@name"/>
								<xsl:variable name="roleTypeDisplayName" select="@displayName"/>
								<xsl:variable name="roleCount" select="count(/sailpoint/Bundle[not(@disabled='true') and @type=$roleType and not(Profiles/Profile/Constraints/Filter) and not(Permits/Reference) and not(Requirements/Reference) and not(ProvisioningPlan/AccountRequest[@application='IIQ']/AttributeRequest) and not(ProvisioningForms/Form/Section/Field)])"/>
								<xsl:if test="$roleCount > 0">
									<li>
										<xsl:value-of select="$roleTypeDisplayName"/>
										<xsl:text>: </xsl:text>
										<xsl:value-of select="$roleCount"/>
									</li>
								</xsl:if>
							</xsl:for-each>
						</ul>
					</td>
                </tr>
                <tr>
                    <th class="rowHeader">Enabled Roles with Required Roles</th>
                    <td class="mapTable">
						<xsl:value-of select="count(/sailpoint/Bundle[not(@disabled='true') and Requirements/Reference])"/>
					</td>
                </tr>
                <tr>
                    <th class="rowHeader">Enabled Roles with Permitted Roles</th>
                    <td class="mapTable">
						<xsl:value-of select="count(/sailpoint/Bundle[not(@disabled='true') and Permits/Reference])"/>
					</td>
                </tr>
                <tr>
                    <th class="rowHeader">Disabled Roles with Required Roles</th>
                    <td class="mapTable">
						<xsl:value-of select="count(/sailpoint/Bundle[@disabled='true' and Requirements/Reference])"/>
					</td>
                </tr>
                <tr>
                    <th class="rowHeader">Disabled Roles with Permitted Roles</th>
                    <td class="mapTable">
						<xsl:value-of select="count(/sailpoint/Bundle[@disabled='true' and Permits/Reference])"/>
					</td>
                </tr>
				<tr>
					<th class="rowHeader" colspan="2">Assignment Logic</th>
				</tr>
				<tr>
					<th class="rowHeader">Total enabled roles with assignment logic</th>
                    <td class="mapTable">
						<xsl:value-of select="count(/sailpoint/Bundle[not(@disabled='true') and Selector/IdentitySelector])"/>
					</td>
				</tr>
				<tr>
					<th class="rowHeader">Roles with a Rule for assignment</th>
                    <td class="mapTable">
						<xsl:variable name="roleCount" select="count(/sailpoint/Bundle[not(@disabled='true') and Selector/IdentitySelector/RuleRef/Reference])"/>
						<xsl:value-of select="$roleCount"/>
						<xsl:if test="$roleCount > 0">
							<p><xsl:text>Rules:</xsl:text></p>
							<ol>
								<xsl:for-each select="/sailpoint/Bundle[not(@disabled='true')]/Selector/IdentitySelector/RuleRef/Reference[generate-id() = generate-id(key('assignmentRules', @name)[1])]">
									<xsl:sort select="@name"/>
									<li>
										<xsl:call-template name="ruleReferenceLink">
											<xsl:with-param name="ruleName" select="@name"/>
										</xsl:call-template>
									</li>
								</xsl:for-each>
							</ol>
						</xsl:if>
					</td>
				</tr>
				<tr>
					<th class="rowHeader">Enabled roles using a Script for assignment</th>
                    <td class="mapTable">
						<xsl:value-of select="count(/sailpoint/Bundle[not(@disabled='true') and Selector/IdentitySelector/Script/Source])"/>
					</td>
				</tr>
				<tr>
					<th class="rowHeader">Enabled roles using a Match List for assignment</th>
                    <td class="mapTable">
						<xsl:value-of select="count(/sailpoint/Bundle[not(@disabled='true') and Selector/IdentitySelector/MatchExpression/MatchTerm])"/>
					</td>
				</tr>
				<tr>
					<th class="rowHeader">Enabled roles using a Population for assignment</th>
                    <td class="mapTable">
						<xsl:variable name="roleCount" select="count(/sailpoint/Bundle[not(@disabled='true') and Selector/IdentitySelector/PopulationRef/Reference])"/>
						<xsl:value-of select="$roleCount"/>
						<xsl:if test="$roleCount > 0">
							<p><xsl:text>Populations:</xsl:text></p>
							<ol>
								<xsl:for-each select="/sailpoint/Bundle[not(@disabled='true')]/Selector/IdentitySelector/PopulationRef/Reference[generate-id() = generate-id(key('assignmentPopulations', @name)[1])]">
									<xsl:sort select="@name"/>
									<li>
										<xsl:call-template name="populationReferenceLink">
											<xsl:with-param name="populationName" select="@name"/>
											<xsl:with-param name="populationId" select="@id"/>
										</xsl:call-template>
									</li>
								</xsl:for-each>
							</ol>
						</xsl:if>

					</td>
				</tr>
				<tr>
					<th class="rowHeader">Enabled roles using a Filter for assignment</th>
                    <td class="mapTable">
						<xsl:value-of select="count(/sailpoint/Bundle[not(@disabled='true') and Selector/IdentitySelector/CompoundFilter])"/>
					</td>
				</tr>
		</table>
	</xsl:template>

	<xsl:template name="performBundleAnalysis">
		<a name="Bundle - Role Model Analysis"/>
		<h2>Role Model Analysis</h2>
		<xsl:choose>
			<xsl:when test="(/sailpoint|/sailpoint/ImportAction[@name='merge' or @name='execute'])/ObjectConfig[@name='Bundle']/Attributes/Map/entry[@key='roleTypeDefinitions']/value/List/RoleTypeDefinition">
				<!-- Detectable Roles without Entitlements -->
				<a name="Bundle - Role Model Analysis - Detectable Roles without Entitlements or Provisioning Policies"/><h3>Detectable Roles without Entitlements or Provisioning Policies</h3>
				<xsl:for-each select="(/sailpoint|/sailpoint/ImportAction[@name='merge' or @name='execute'])/ObjectConfig[@name='Bundle']/Attributes/Map/entry[@key='roleTypeDefinitions']/value/List/RoleTypeDefinition[not(@noDetection='true' or @noDetectionUnlessAssigned='true')]">
					<xsl:sort select="@displayName"/>
					<xsl:variable name="roleType" select="@name"/>
					<xsl:variable name="roleTypeDisplayName" select="@displayName"/>
					<xsl:variable name="roleCount" select="count(/sailpoint/Bundle[@type=$roleType and count(Profiles/Profile/Constraints/Filter[@operation='CONTAINS_ALL']/Value/List/String)=0 and count(ProvisioningForms/Form)=0])"/>
					<xsl:if test="$roleCount > 0">
						<h4><xsl:value-of select="$roleTypeDisplayName"/></h4>
							<ol>
								<xsl:for-each select="/sailpoint/Bundle[not(@disabled='true') and @type=$roleType and count(Profiles/Profile/Constraints/Filter[@operation='CONTAINS_ALL']/Value/List/String)=0 and count(ProvisioningForms/Form)=0]">
									<xsl:sort select="@displayName"/>
									<li>
										<xsl:call-template name="roleReferenceLink">
											<xsl:with-param name="roleName" select="@name"/>
										</xsl:call-template>
									</li>
								</xsl:for-each>
							</ol>
					</xsl:if>
				</xsl:for-each>
				<!-- Detectable Roles with a Single Entitlement, but not 1-1-1. -->
				<a name="Bundle - Role Model Analysis - Detectable Roles with a Single Entitlement"/><h3>Detectable Roles with a Single Entitlement (not 1-1-1)</h3>
				<p>
					<xsl:text>Detectable roles that have only a single entitlement are considered inefficient and could lead to role explosion. This sections lists the roles that have a single entitlement but are not the only detectable role in a business role.</xsl:text>
				</p>
				<xsl:for-each select="(/sailpoint|/sailpoint/ImportAction[@name='merge' or @name='execute'])/ObjectConfig[@name='Bundle']/Attributes/Map/entry[@key='roleTypeDefinitions']/value/List/RoleTypeDefinition[not(@noDetection='true' or @noDetectionUnlessAssigned='true')]">
					<xsl:sort select="@displayName"/>
					<xsl:variable name="roleType" select="@name"/>
					<xsl:variable name="roleTypeDisplayName" select="@displayName"/>
					<xsl:variable name="roleCount" select="count(/sailpoint/Bundle[not(@disabled='true') and @type=$roleType and count(Profiles/Profile/Constraints/Filter[@operation='CONTAINS_ALL']/Value/List/String)=1])"/>
					<xsl:variable name="hybridRole">
						<xsl:choose>
							<xsl:when test="not(@noAutoAssignment='true' and @noManualAssignment='true')">
								<xsl:value-of select="'true'"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="'false'"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:if test="$roleCount > 0">
						<h4><xsl:value-of select="$roleTypeDisplayName"/></h4>
						<ol>
							<xsl:for-each select="/sailpoint/Bundle[not(@disabled='true') and @type=$roleType and count(Profiles/Profile/Constraints/Filter[@operation='CONTAINS_ALL']/Value/List/String)=1]">
								<xsl:sort select="@displayName"/>
								<xsl:variable name="roleName" select="@name"/>
								<xsl:variable name="roleRequiredCount" select="count(/sailpoint/Bundle[Requirements/Reference[@name=$roleName]])"/>
								<xsl:variable name="rolePermittedCount" select="count(/sailpoint/Bundle[Permits/Reference[@name=$roleName]])"/>
								<xsl:variable name="roleInheritedCount" select="count(/sailpoint/Bundle[@type=$roleType and Inheritance/Reference[@name=$roleName]])"/>
								<xsl:variable name="reqAndPermCount" select="count(/sailpoint/Bundle[Permits/Reference[@name=$roleName]]/Permits/Reference) + count(/sailpoint/Bundle[Requirements/Reference[@name=$roleName]]/Requirements/Reference) "/>
								<xsl:if test="$reqAndPermCount != 1">
									<li>
										<xsl:call-template name="roleReferenceLink">
											<xsl:with-param name="roleName" select="$roleName"/>
										</xsl:call-template>
										<xsl:if test="$hybridRole='true'">
											<xsl:text> (hybrid)</xsl:text>
										</xsl:if>
										<ul>
											<xsl:if test="$hybridRole='false'">
												<li>
													<xsl:text>Required by Roles: </xsl:text>
													<xsl:value-of select="$roleRequiredCount"/>
												</li>
												<li>
													<xsl:text>Permitted by Roles: </xsl:text>
													<xsl:value-of select="$rolePermittedCount"/>
												</li>
												<li>
													<xsl:text>Total Required and Permitted by Roles: </xsl:text>
													<xsl:value-of select="$roleRequiredCount + $rolePermittedCount"/>
													<xsl:choose>
														<xsl:when test="$roleRequiredCount + $rolePermittedCount = 0">
															<xsl:text>&#10060;</xsl:text>
														</xsl:when>
													</xsl:choose>
												</li>
											</xsl:if>
											<li>
												<xsl:value-of select="concat('Inherited by Roles (', $roleTypeDisplayName, '): ', $roleInheritedCount)"/>
											</li>
										</ul>
									</li>
								</xsl:if>
							</xsl:for-each>
						</ol>
					</xsl:if>
				</xsl:for-each>
				<!-- Detectable Roles with a Single Entitlement in a 1-1-1 hierarchy. -->
				<a name="Bundle - Role Model Analysis - Detectable Roles with a Single Entitlement in a 1-1-1 Hierarchy"/><h3>Detectable Roles with a Single Entitlement in a 1-1-1 Hierarchy</h3>
				<p>
					<xsl:text>Detectable roles that have only a single entitlement are considered inefficient and could lead to role explosion. This sections lists the roles that have a single entitlement and are the only detectable role in a business role.</xsl:text>
				</p>
				<xsl:for-each select="(/sailpoint|/sailpoint/ImportAction[@name='merge' or @name='execute'])/ObjectConfig[@name='Bundle']/Attributes/Map/entry[@key='roleTypeDefinitions']/value/List/RoleTypeDefinition[not(@noDetection='true' or @noDetectionUnlessAssigned='true')]">
					<xsl:sort select="@displayName"/>
					<xsl:variable name="roleType" select="@name"/>
					<xsl:variable name="roleTypeDisplayName" select="@displayName"/>
					<xsl:variable name="roleCount" select="count(/sailpoint/Bundle[not(@disabled='true') and @type=$roleType and count(Profiles/Profile/Constraints/Filter[@operation='CONTAINS_ALL']/Value/List/String)=1])"/>
					<xsl:variable name="hybridRole">
						<xsl:choose>
							<xsl:when test="not(@noAutoAssignment='true' and @noManualAssignment='true')">
								<xsl:value-of select="'true'"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="'false'"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>
					<xsl:if test="$roleCount > 0">
						<h4><xsl:value-of select="$roleTypeDisplayName"/></h4>
						<ol>
							<xsl:for-each select="/sailpoint/Bundle[not(@disabled='true') and @type=$roleType and count(Profiles/Profile/Constraints/Filter[@operation='CONTAINS_ALL']/Value/List/String)=1]">
								<xsl:sort select="@displayName"/>
								<xsl:variable name="roleName" select="@name"/>
								<xsl:variable name="roleInheritedCount" select="count(/sailpoint/Bundle[@type=$roleType and Inheritance/Reference[@name=$roleName]])"/>
								<xsl:variable name="reqAndPermCount" select="count(/sailpoint/Bundle[Permits/Reference[@name=$roleName]]/Permits/Reference) + count(/sailpoint/Bundle[Requirements/Reference[@name=$roleName]]/Requirements/Reference) "/>
								<xsl:if test="$reqAndPermCount = 1">
									<li>
										<xsl:call-template name="roleReferenceLink">
											<xsl:with-param name="roleName" select="$roleName"/>
										</xsl:call-template>
										<xsl:if test="$hybridRole='true'">
											<xsl:text> (hybrid)</xsl:text>
										</xsl:if>
										<xsl:if test="$roleInheritedCount > 0"> 
											<xsl:value-of select="concat('. Inherited by Roles (', $roleTypeDisplayName, '): ', $roleInheritedCount)"/>
											<ul>
												<xsl:for-each select="/sailpoint/Bundle[@type=$roleType and Inheritance/Reference[@name=$roleName]]">
													<li>
														<xsl:call-template name="roleReferenceLink">
															<xsl:with-param name="roleName" select="@name"/>	
														</xsl:call-template>
													</li>
												</xsl:for-each>
											</ul>
										</xsl:if>
									</li>
								</xsl:if>
							</xsl:for-each>
						</ol>
					</xsl:if>
				</xsl:for-each>
				<!-- Assignable roles without permitted or required roles -->
				<a name="Bundle - Role Model Analysis - Assignable Roles without permitted or required roles"/><h3>Assignable Roles without permitted or required roles</h3>
				<xsl:for-each select="(/sailpoint|/sailpoint/ImportAction[@name='merge' or @name='execute'])/ObjectConfig[@name='Bundle']/Attributes/Map/entry[@key='roleTypeDefinitions']/value/List/RoleTypeDefinition[@noDetection='true' and not(@noAssignmentSelector='true') and @noIIQ='true']">
					<xsl:sort select="@displayName"/>
					<xsl:variable name="roleType" select="@name"/>
					<xsl:variable name="roleTypeDisplayName" select="@displayName"/>
					<xsl:variable name="roleCount" select="count(/sailpoint/Bundle[not(@disabled='true') and @type=$roleType and count((Permits|Requirements)/Reference)=0])"/>
					<p>Roles listed here are assignable, but do not seem to represent any access. These roles need to be reviewed. If they serve no purpose they should be disabled and/or removed.</p>
					<xsl:if test="$roleCount > 0">
						<h4><xsl:value-of select="$roleTypeDisplayName"/></h4>
						<ol>
							<xsl:for-each select="/sailpoint/Bundle[@type=$roleType and count((Permits|Requirements)/Reference)=0]">
								<xsl:sort select="@displayName"/>
								<xsl:variable name="roleName" select="@name"/>
								<li>
									<xsl:call-template name="roleReferenceLink">
										<xsl:with-param name="roleName" select="$roleName"/>
									</xsl:call-template>
								</li>
							</xsl:for-each>
						</ol>
					</xsl:if>
				</xsl:for-each>
				<!-- Detectable roles that are not permitted or required -->
				<a name="Bundle - Role Model Analysis - Detectable roles that are not permitted, required or inherited"/><h3>Detectable roles that are not permitted, required or inherited</h3>
				<p>Any roles listed here are not used in assignable roles. They may be detected, but if they do not serve any purpose, these roles should be cleaned up.</p>
				<xsl:for-each select="(/sailpoint|/sailpoint/ImportAction[@name='merge' or @name='execute'])/ObjectConfig[@name='Bundle']/Attributes/Map/entry[@key='roleTypeDefinitions']/value/List/RoleTypeDefinition[not(@noDetection='true' or @noDetectionUnlessAssigned='true') and @noAssignmentSelector='true']">
					<xsl:sort select="@displayName"/>
					<xsl:variable name="roleType" select="@name"/>
					<xsl:variable name="roleTypeDisplayName" select="@displayName"/>
					<ol>
						<xsl:for-each select="/sailpoint/Bundle[not(@disabled='true') and @type=$roleType]">
							<xsl:sort select="@displayName"/>
							<xsl:variable name="roleName" select="@name"/>
							<xsl:variable name="roleRequiredCount" select="count(/sailpoint/Bundle[Requirements/Reference[@name=$roleName]])"/>
							<xsl:variable name="rolePermittedCount" select="count(/sailpoint/Bundle[Permits/Reference[@name=$roleName]])"/>
							<xsl:variable name="roleInheritedCount" select="count(/sailpoint/Bundle[@type=$roleType and Inheritance/Reference[@name=$roleName]])"/>
							<xsl:if test="($roleRequiredCount + $rolePermittedCount + $roleInheritedCount) = 0">
								<li>
									<xsl:value-of select="concat($roleTypeDisplayName, ': ')"/>
									<xsl:call-template name="roleReferenceLink">
										<xsl:with-param name="roleName" select="$roleName"/>
									</xsl:call-template>
								</li>
							</xsl:if>
						</xsl:for-each>
					</ol>
				</xsl:for-each>
				<!-- Entitlements used in multiple roles -->
				<!-- TODO -->
			</xsl:when>
			<xsl:otherwise>
				<p>
					<b>
						<xsl:text>No role type definitions (ObjectConfig) found.</xsl:text>
					</b>
				</p>
			</xsl:otherwise>
		</xsl:choose>	
	</xsl:template>

	<xsl:template name="processBundles">
		<xsl:if test="/sailpoint/Bundle and document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='documentBundles']/@value='true'">
			<a name="Heading-Bundle"/>
			<h1>Roles</h1>
			<!-- Statistics -->
			<xsl:call-template name="processBundleStatistics"/>
			<!-- Role model analysis -->
			<xsl:if test="document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='bundleModelAnalysis']/@value='true'">
				<xsl:call-template name="performBundleAnalysis"/>
			</xsl:if>
			<!-- Role definitions -->
			<xsl:if test="not(document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='bundleStatisticsOnly']/@value='true')">
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
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
