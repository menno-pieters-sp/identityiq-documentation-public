<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:iiqdoc="http://iiqdoc.config.data">
	<xsl:output omit-xml-declaration="yes" indent="yes" method="html" />

	<xsl:template name="populationReferenceLink">
		<xsl:param name="populationName"/>
		<xsl:param name="populationId"/>
		<xsl:choose>
			<xsl:when test="//GroupDefinition[@id=$populationId] and document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='documentPopulations']/@value='true'">
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="concat('#Population - ', $populationId)"/>
					</xsl:attribute>
					<xsl:value-of select="//GroupDefinition[@id=$populationId]/@name"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$populationName"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="processPopulations">
		<xsl:if test="//GroupDefinition[not(Factory)] and document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='documentPopulations']/@value='true'">
			<a name="Heading-Populations"/>
			<h1>Populations</h1>
			<xsl:for-each select="//GroupDefinition[not(Factory)]">
				<xsl:variable name="populationName" select="@name"/>
				<a>
					<xsl:attribute name="name">
						<xsl:value-of select="concat('Population - ', @id)" />
					</xsl:attribute>
				</a>
				<a>
					<xsl:attribute name="name">
						<xsl:value-of select="concat('Population - ', @name, ' - ', Owner/Reference/@name)" />
					</xsl:attribute>
				</a>
				<h2>
					<xsl:value-of select="@name" />
				</h2>
				<table class="populationTable">
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
						<th>Private</th>
						<td><xsl:value-of select="@private"/></td>
					</tr>
					<tr>
						<th>Disabled</th>
						<td><xsl:value-of select="@disabled"/></td>
					</tr>
					<tr>
						<th>Group Filter</th>
						<td>
							<xsl:for-each select="GroupFilter/CompositeFilter|GroupFilter/Filter">
								<xsl:if test="name(.) = 'CompositeFilter'">
									<xsl:call-template name="processCompositeFilter"/>
								</xsl:if>
								<xsl:if test="name(.) = 'Filter'">
									<xsl:call-template name="processFilter"/>
								</xsl:if>
							</xsl:for-each>
						</td>
					</tr>
					<tr>
						<th>Detected Usage</th>
						<td>
							<ul>
								<!-- Bundle - Selector - IdentitySelector - PopulationRef - Reference - @name (Roles) -->
								<xsl:for-each select="//Bundle[Selector/IdentitySelector/PopulationRef/Reference[@name=$populationName]]">
									<li>
										<xsl:text>Role: </xsl:text>
										<xsl:call-template name="roleReferenceLink">
											<xsl:with-param name="roleName" select="@name"/>
										</xsl:call-template>
									</li>
								</xsl:for-each>
								<!-- DynamicScope - Selector - IdentitySelector - PopulationRef - Reference - @name (QuickLink Population)-->
								<xsl:for-each select="//DynamicScope[Selector/IdentitySelector/PopulationRef/Reference[@name=$populationName]]">
									<li>
										<xsl:text>QuickLink Population: </xsl:text>
										<xsl:value-of select="@name"/>
									</li>
								</xsl:for-each>
								<!-- IdentityTrigger - Selector - IdentitySelector - PopulationRef - Reference - @name (Certification Event: handler="sailpoint.api.CertificationTriggerHandler")-->
								<xsl:for-each select="//IdentityTrigger[@handler='sailpoint.api.CertificationTriggerHandler' and Selector/IdentitySelector/PopulationRef/Reference[@name=$populationName]]">
									<li>
										<xsl:text>Certification Event: </xsl:text>
										<xsl:value-of select="concat(@name, ' (', @type, ')')"/>
									</li>
								</xsl:for-each>
								<!-- IdentityTrigger - Selector - IdentitySelector - PopulationRef - Reference - @name (Lifecycle Event: handler="sailpoint.api.WorkflowTriggerHandler") -->
								<xsl:for-each select="//IdentityTrigger[@handler='sailpoint.api.WorkflowTriggerHandler' and Selector/IdentitySelector/PopulationRef/Reference[@name=$populationName]]">
									<li>
										<xsl:text>Lifecycle Event: </xsl:text>
										<xsl:value-of select="concat(@name, ' (', @type, ')')"/>
									</li>
								</xsl:for-each>
								<!-- Application - PasswordPolicies - PasswordPolicyHolder - Selector - IdentitySelector - PopulationRef - Reference - @name (Application password policies) -->
								<xsl:for-each select="//Application/PasswordPolicies/PasswordPolicyHolder[Selector/IdentitySelector/PopulationRef/Reference[@name=$populationName]]">
									<li>
										<xsl:variable name="applicationName" select="../../@name"/>
										<xsl:variable name="policyName" select="PolicyRef/Reference/@name"/>
										<xsl:text>Password Policy: </xsl:text>
										<xsl:value-of select="$policyName" />
										<xsl:text> on application </xsl:text>
										<xsl:call-template name="applicationReferenceLink">
											<xsl:with-param name="applicationName" select="$applicationName"/>
										</xsl:call-template>
									</li>
								</xsl:for-each>
								<!-- Widget - Selector - IdentitySelector - PopulationRef - Reference - @name (Dashboard Widget) -->
								<xsl:for-each select="//Widget[Selector/IdentitySelector/PopulationRef/Reference[@name=$populationName]]">
									<li>
										<xsl:text>Widget: </xsl:text>
										<xsl:value-of select="@name"/>
									</li>
								</xsl:for-each>
							</ul>
						</td>
					</tr>
				</table>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
