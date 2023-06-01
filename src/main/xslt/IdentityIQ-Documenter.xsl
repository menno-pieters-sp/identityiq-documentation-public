<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:iiqdoc="http://iiqdoc.config.data">

	<xsl:output omit-xml-declaration="yes" indent="yes"/>

	<xsl:include href="IdentityIQ-Documenter-Config.xsl"/>

	<xsl:include href="IIQDoc-Stylesheet.xsl"/>
    <xsl:include href="IdentityIQ-Documenter-Localization.xsl"/>
	<xsl:include href="IIQDoc-Utilities.xsl"/>

    <xsl:include href="IIQDoc-Configuration.xsl"/>
    <xsl:include href="IIQDoc-AuditConfig.xsl"/>
	<xsl:include href="IIQDoc-ObjectConfig.xsl"/>
	<xsl:include href="IIQDoc-Application.xsl"/>
	<xsl:include href="IIQDoc-IntegrationConfig.xsl"/>
	<xsl:include href="IIQDoc-ManagedAttribute.xsl"/>
	<xsl:include href="IIQDoc-Bundle.xsl"/>
	<xsl:include href="IIQDoc-PasswordPolicy.xsl"/>
	<xsl:include href="IIQDoc-ScheduledCertifications.xsl"/>
	<xsl:include href="IIQDoc-TaskDefinition.xsl"/>
	<xsl:include href="IIQDoc-Policy.xsl"/>
	<xsl:include href="IIQDoc-LifecycleEvent.xsl"/>
	<xsl:include href="IIQDoc-Workflow.xsl"/>
	<xsl:include href="IIQDoc-Rule.xsl"/>
	<xsl:include href="IIQDoc-EmailTemplate.xsl"/>
	<xsl:include href="IIQDoc-Form.xsl"/>
	<xsl:include href="IIQDoc-Workgroup.xsl"/>
	<xsl:include href="IIQDoc-ProvisioningPlan.xsl"/>
	<xsl:include href="IIQDoc-IdentitySelector.xsl"/>
	<xsl:include href="IIQDoc-Filter.xsl"/>
	<xsl:include href="IIQDoc-Population.xsl"/>
	<xsl:include href="IIQDoc-GroupFactory.xsl"/>
    <xsl:include href="IIQDoc-QuickLink.xsl"/>

	<xsl:template name="createIndex">
		<script><![CDATA[
function toggleSection(name) {
	let olName = "submenu-" + name;
	let olElement = document.getElementById(olName);
	if (typeof(olElement) !== undefined) {
    let display = document.getElementById(olName).style.display;
		if (display === 'none') {
		  unfoldSection(name);
		} else {
	  	foldSection(name);
		}
	}
}

function foldSection(name) {
  let triangleName = "triangle-" + name;
  let olName = "submenu-" + name;
  document.getElementById(olName).style.display = 'none';
	document.getElementById(triangleName).innerHTML = '&#9654;';
}

function unfoldSection(name) {
  let triangleName = "triangle-" + name;
  let olName = "submenu-" + name;
  document.getElementById(olName).style.display = 'block';
	document.getElementById(triangleName).innerHTML = '&#9660;';
}
			]]></script>
		<div id="tableOfContents">
			<ol>

				<xsl:if test="document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='documentConfiguration']/@value='true' and (/sailpoint/Configuration[@name='SystemConfiguration'] or /sailpoint/ImportAction[@name='merge' or @name='execute']/Configuration[@name='SystemConfiguration'])">
					<li>
						<a href="#Heading-SystemConfiguration">System Configuration</a>
					</li>
				</xsl:if>

                <xsl:if test="document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='documentAuditConfig']/@value='true' and (/sailpoint/AuditConfig[@name='AuditConfig'] or /sailpoint/ImportAction[@name='merge' or @name='execute']/AuditConfig[@name='AuditConfig'])">
                    <li>
                        <a href="#Heading-AuditConfig">Audit Configuration</a>
                    </li>
                </xsl:if>
        
				<xsl:if test="(/sailpoint/ImportAction[@name='execute' or @name='merge']/ObjectConfig or /sailpoint/ObjectConfig) and document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='documentObjectConfig']/@value='true'">
					<li>
						<a href="#Heading-ObjectConfig">Object Configuration</a><xsl:text> </xsl:text><span onclick="toggleSection('ObjectConfig')" id="triangle-ObjectConfig" class="triangle-icon">&#9654;</span>
					</li>
					<ol id="submenu-ObjectConfig" style="display: none;">
						<xsl:for-each select="/sailpoint/ImportAction[@name='execute' or @name='merge']/ObjectConfig | /sailpoint/ObjectConfig">
							<xsl:sort select="@name"/>
							<li>
								<a>

									<xsl:attribute name="href">
										<xsl:value-of select="concat('#ObjectConfig - ', @name)"/>
									</xsl:attribute>

									<xsl:value-of select="@name"/>
								</a>
							</li>
						</xsl:for-each>
					</ol>
				</xsl:if>

				<xsl:if test="document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='documentApplications']/@value='true' and /sailpoint/Application or /sailpoint/ImportAction[@name='execute']/Application">
					<li>
						<a href="#Heading-Application">Applications</a><xsl:text> </xsl:text><span onclick="toggleSection('Application')" id="triangle-Application" class="triangle-icon">&#9654;</span>
					</li>
					<ol id="submenu-Application" style="display: none;">
						<li><a href="#Application-Statistics">Application Statistics</a></li>
                        <xsl:if test="document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='applicationStatisticsOnly']/@value!='true'">
    						<xsl:for-each select="/sailpoint/Application | /sailpoint/ImportAction[@name='execute']/Application">
    							<xsl:sort select="@name"/>
    							<li>
    								<a>
    									<xsl:attribute name="href">
    										<xsl:value-of select="concat('#Application - ', @name)"/>
    									</xsl:attribute>
    									<xsl:value-of select="@name"/>
    								</a>
    							</li>
    						</xsl:for-each>
                        </xsl:if>
					</ol>
				</xsl:if>

				<xsl:if test="/sailpoint/IntegrationConfig or /sailpoint/ImportAction[@name='execute']/IntegrationConfig">
					<li>
						<a href="#Heading-IntegrationConfig">IntegrationConfigs</a><xsl:text> </xsl:text><span onclick="toggleSection('IntegrationConfig')" id="triangle-IntegrationConfig" class="triangle-icon">&#9654;</span>
					</li>
					<ol id="submenu-IntegrationConfig" style="display: none;">
						<xsl:for-each select="/sailpoint/IntegrationConfig | /sailpoint/ImportAction[@name='execute']/IntegrationConfig">
							<xsl:sort select="@name"/>
							<li>
								<a>
									<xsl:attribute name="href">
										<xsl:value-of select="concat('#IntegrationConfig - ', @name)"/>
									</xsl:attribute>
									<xsl:value-of select="@name"/>
								</a>
							</li>
						</xsl:for-each>
					</ol>
				</xsl:if>

				<xsl:if test="/sailpoint/ManagedAttribute and document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='documentManagedAttributes']/@value='true'">
					<li>
						<a href="#Heading-ManagedAttribute">Entitlements</a><xsl:text> </xsl:text><span onclick="toggleSection('ManagedAttribute')" id="triangle-ManagedAttribute" class="triangle-icon">&#9654;</span>
					</li>
					<ol id="submenu-ManagedAttribute" style="display: none;">
						<xsl:for-each select="/sailpoint/ManagedAttribute/ApplicationRef/Reference[not(@name=../../following-sibling::ManagedAttribute/ApplicationRef/Reference/@name)]">
							<li>
								<a>
									<xsl:attribute name="href">
										<xsl:value-of select="concat('#ManagedAttribute-Application - ', @name)"/>
									</xsl:attribute>
									<xsl:value-of select="@name"/>
								</a>
							</li>
						</xsl:for-each>
					</ol>
				</xsl:if>

				<xsl:if test="/sailpoint/Bundle and document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='documentBundles']/@value='true'">
					<li>
						<a href="#Heading-Bundle">Roles</a><xsl:text> </xsl:text><span onclick="toggleSection('Bundle')" id="triangle-Bundle" class="triangle-icon">&#9654;</span>
					</li>
					<ol id="submenu-Bundle" style="display: none;">
						<xsl:choose>
							<xsl:when test="/sailpoint/ObjectConfig[@name='Bundle'] or /sailpoint/ImportAction[@name='merge' or @name='execute']/ObjectConfig[@name='Bundle']">
								<!-- Organize by type of role -->
								<xsl:for-each select="(/sailpoint|/sailpoint/ImportAction[@name='merge' or @name='execute'])/ObjectConfig[@name='Bundle']/Attributes/Map/entry[@key='roleTypeDefinitions']/value/List/RoleTypeDefinition">
									<xsl:sort select="@displayName"/>
									<xsl:variable name="roleType" select="@name"/>
									<xsl:variable name="roleTypeDisplayName" select="@displayName"/>
									<xsl:if test="/sailpoint/Bundle[@type=$roleType]">
										<li>
											<xsl:value-of select="$roleType" />
											<xsl:text> </xsl:text>
											<span class="triangle-icon">
												<xsl:attribute name="onclick">
													<xsl:text>toggleSection(&apos;Bundle-Type-</xsl:text><xsl:value-of select="$roleType"/><xsl:text>&apos;)</xsl:text>
												</xsl:attribute>
												<xsl:attribute name="id">
													<xsl:value-of select="concat('triangle-Bundle-Type-', $roleType)"/>
												</xsl:attribute>
											  <xsl:text>&#9654;</xsl:text>
										  </span>
											<ol style="display: none;">
												<xsl:attribute name="id">
													<xsl:value-of select="concat('submenu-Bundle-Type-', $roleType)"/>
												</xsl:attribute>
												<xsl:for-each select="/sailpoint/Bundle[@type=$roleType]">
													<xsl:sort select="@name"/>
													<li>
														<xsl:call-template name="roleReferenceLink">
															<xsl:with-param name="roleName">
																<xsl:value-of select="@name"/>
															</xsl:with-param>
														</xsl:call-template>
													</li>
												</xsl:for-each>
											</ol>
										</li>
									</xsl:if>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<!-- Just iterate over all the roles in the file -->
								<xsl:for-each select="/sailpoint/Bundle">
									<xsl:sort select="@name"/>
									<li>
										<xsl:call-template name="roleReferenceLink">
											<xsl:with-param name="roleName">
												<xsl:value-of select="@name"/>
											</xsl:with-param>
										</xsl:call-template>
									</li>
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
					</ol>
				</xsl:if>

				<!-- Workgroups -->
				<xsl:if test="/sailpoint/Identity[@workgroup='true'] and document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='documentWorkgroups']/@value='true'">
					<li>
						<a href="#Heading-Workgroups">Workgroups</a><xsl:text> </xsl:text><span onclick="toggleSection('Workgroups')" id="triangle-Workgroups" class="triangle-icon">&#9654;</span>
					</li>
					<ol id="submenu-Workgroups" style="display: none;">
						<xsl:for-each select="/sailpoint/Identity[@workgroup='true']">
							<xsl:sort select="@name"/>
							<li>
								<a>
									<xsl:attribute name="href">
										<xsl:value-of select="concat('#Workgroup - ', @name)"/>
									</xsl:attribute>
									<xsl:value-of select="@name"/>
								</a>
							</li>
						</xsl:for-each>
					</ol>
				</xsl:if>

				<!-- Populations -->
				<xsl:if test="/sailpoint/GroupDefinition[not(Factory)] and document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='documentPopulations']/@value='true'">
					<li>
						<a href="#Heading-Populations">Populations</a><xsl:text> </xsl:text><span onclick="toggleSection('Populations')" id="triangle-Populations" class="triangle-icon">&#9654;</span>
					</li>
					<ol id="submenu-Populations" style="display: none;">
						<xsl:for-each select="/sailpoint/GroupDefinition[not(Factory)]">
							<li>
								<a>
									<xsl:attribute name="href">
										<xsl:value-of select="concat('#Population - ', @name, ' - ', Owner/Reference/@name)"/>
									</xsl:attribute>
									<xsl:value-of select="@name"/>
								</a>
							</li>
						</xsl:for-each>
					</ol>
				</xsl:if>

				<!-- GroupFactories -->
				<xsl:if test="/sailpoint/GroupFactory and document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='documentGroupFactories']/@value='true'">
					<li>
						<a href="#Heading-GroupFactory">Group Factories</a><xsl:text> </xsl:text><span onclick="toggleSection('GroupFactory')" id="triangle-GroupFactory" class="triangle-icon">&#9654;</span>
					</li>
					<ol id="submenu-GroupFactory" style="display: none;">
						<xsl:for-each select="/sailpoint/GroupFactory">
							<li>
								<a>
									<xsl:attribute name="href">
										<xsl:value-of select="concat('#GroupFactory - ', @name)"/>
									</xsl:attribute>
									<xsl:value-of select="@name"/>
								</a>
							</li>
						</xsl:for-each>
					</ol>
				</xsl:if>

				<!-- Scheduled Certifications -->
				<xsl:if test="/sailpoint/TaskSchedule[Arguments/Map/entry[@key='certificationDefinitionId']]">
					<li>
						<a href="#Heading-Certifications">Certifications</a><xsl:text> </xsl:text><span onclick="toggleSection('Certifications')" id="triangle-Certifications" class="triangle-icon">&#9654;</span>
					</li>
					<ol id="submenu-Certifications" style="display: none;">
						<xsl:for-each select="/sailpoint/TaskSchedule[Arguments/Map/entry[@key='certificationDefinitionId']]">
                            <xsl:sort select="@name"/>
							<li>
								<a>
									<xsl:attribute name="href">
					          <xsl:value-of select="concat('#TaskSchedule - ', @name)" />
									</xsl:attribute>
									<xsl:value-of select="@name"/>
								</a>
							</li>
						</xsl:for-each>
					</ol>
				</xsl:if>

				<!-- Task Definition -->
				<xsl:if test="document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='documentTasks']/@value='true' and (/sailpoint/TaskDefinition[not(@template='true' or @type='GridReport' or @type='Report' or @type='LiveReport' or @type='Certification' or @type='RoleMining' or @executor='sailpoint.task.RoleMiningTask')] | /sailpoint/ImportAction[@name='execute']/TaskDefinition[not(@template='true' or @type='GridReport' or @type='Report' or @type='LiveReport' or @type='Certification' or @type='RoleMining' or @executor='sailpoint.task.RoleMiningTask')] )">
					<li>
						<a href="#Heading-TaskDefinitions">Task Definition</a><xsl:text> </xsl:text><span onclick="toggleSection('TaskDefinitions')" id="triangle-TaskDefinitions" class="triangle-icon">&#9654;</span>
					</li>
					<ol id="submenu-TaskDefinitions" style="display: none;">
                        <li>
                            <a href="#TaskDefinition -- Summary">Summary</a>
                        </li>
						<xsl:for-each select="/sailpoint/TaskDefinition[not(@template='true' or @type='GridReport' or @type='Report' or @type='LiveReport' or @type='Certification' or @type='RoleMining' or @executor='sailpoint.task.RoleMiningTask')] | /sailpoint/ImportAction[@name='execute']/TaskDefinition[not(@template='true' or @type='GridReport' or @type='Report' or @type='LiveReport' or @type='Certification' or @type='RoleMining' or @executor='sailpoint.task.RoleMiningTask')]">
							<xsl:sort select="@name"/>
							<li>
								<a>
									<xsl:attribute name="href">
										<xsl:value-of select="concat('#TaskDefinition - ', @name)"/>
									</xsl:attribute>
									<xsl:value-of select="@name"/>
								</a>
							</li>
						</xsl:for-each>
					</ol>
				</xsl:if>

				<!-- Certification Events -->
				<!-- TODO -->

				<!-- Policies -->
				<xsl:if test="/sailpoint/Policy[not(@template='true')] and document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='documentPolicies']/@value='true'">
					<li>
						<a href="#Heading-Policies">Policies</a><xsl:text> </xsl:text><span onclick="toggleSection('Policies')" id="triangle-Policies" class="triangle-icon">&#9654;</span>
					</li>
					<ol id="submenu-Policies" style="display: none;">
						<xsl:for-each select="/sailpoint/Policy[not(@template='true')]">
							<xsl:sort select="@name"/>
							<li>
								<a>
									<xsl:attribute name="href">
										<xsl:value-of select="concat('#Policy - ', @name)"/>
									</xsl:attribute>
									<xsl:value-of select="@name"/>
								</a>
							</li>
						</xsl:for-each>
					</ol>
				</xsl:if>

				<!-- Lifecycle Events -->
				<xsl:if test="document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='documentLifecycleEvents']/@value='true' and /sailpoint/IdentityTrigger[@handler='sailpoint.api.WorkflowTriggerHandler' or @handler='sailpoint.api.AsynchronousWorkflowTriggerHandler']">
					<li>
						<a href="#Heading-LifecycleEvents">Lifecycle Events</a><xsl:text> </xsl:text><span onclick="toggleSection('LifecycleEvents')" id="triangle-LifecycleEvents" class="triangle-icon">&#9654;</span>
					</li>
					<ol id="submenu-LifecycleEvents" style="display: none;">
						<xsl:for-each select="/sailpoint/IdentityTrigger[@handler='sailpoint.api.WorkflowTriggerHandler' or @handler='sailpoint.api.AsynchronousWorkflowTriggerHandler']">
                            <xsl:sort select="@name"/>
							<li>
								<a>
									<xsl:attribute name="href">
										<xsl:value-of select="concat('#LifecycleEvent - ', @name)"/>
									</xsl:attribute>
									<xsl:value-of select="@name"/>
								</a>
							</li>
						</xsl:for-each>
					</ol>
				</xsl:if>

                <!-- QuickLinks -->
                <xsl:if test="document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='documentQuickLinks']/@value='true' and /sailpoint/QuickLink">
                    <li>
                        <a href="#Heading-QuickLinks">QuickLinks</a><xsl:text> </xsl:text><span onclick="toggleSection('QuickLinks')" id="triangle-QuickLinks" class="triangle-icon">&#9654;</span>
                    </li>
                    <ol id="submenu-QuickLinks" style="display: none;">
                        <xsl:for-each select="/sailpoint/QuickLink">
                            <xsl:sort select="@name"/>
                            <li>
                                <a>
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="concat('#QuickLink - ', @name)"/>
                                    </xsl:attribute>
                                    <xsl:value-of select="@name"/>
                                </a>
                            </li>
                        </xsl:for-each>
                    </ol>
                </xsl:if>
                
				<!-- Workflows -->
				<xsl:if test="document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='documentWorkflows']/@value='true' and /sailpoint/Workflow">
					<li>
						<a href="#Heading-Workflows">Business Processes</a><xsl:text> </xsl:text><span onclick="toggleSection('Workflows')" id="triangle-Workflows" class="triangle-icon">&#9654;</span>
					</li>
					<ol id="submenu-Workflows" style="display: none;">
						<xsl:for-each select="/sailpoint/Workflow">
                            <xsl:sort select="@name"/>
							<li>
								<a>
									<xsl:attribute name="href">
										<xsl:value-of select="concat('#Workflow - ', @name)"/>
									</xsl:attribute>
									<xsl:value-of select="@name"/>
								</a>
							</li>
						</xsl:for-each>
					</ol>
				</xsl:if>

				<!-- Rules -->
				<xsl:if test="document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='documentRules']/@value='true' and /sailpoint/Rule">
					<li>
						<a href="#Heading-Rules">Rules</a><xsl:text> </xsl:text><span onclick="toggleSection('Rules')" id="triangle-Rules" class="triangle-icon">&#9654;</span>
					</li>
					<ol id="submenu-Rules" style="display: none;">
						<xsl:for-each select="/sailpoint/Rule">
                            <xsl:sort select="@name"/>
							<li>
								<a>
									<xsl:attribute name="href">
										<xsl:value-of select="concat('#Rule - ', @name)"/>
									</xsl:attribute>
									<xsl:value-of select="@name"/>
								</a>
							</li>
						</xsl:for-each>
					</ol>
				</xsl:if>

				<!-- Email Templates -->
				<xsl:if test="document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='documentEmailTemplates']/@value='true' and /sailpoint/EmailTemplate">
					<li>
						<a href="#Heading-EmailTemplate">Email Templates</a><xsl:text> </xsl:text><span onclick="toggleSection('EmailTemplate')" id="triangle-EmailTemplate" class="triangle-icon">&#9654;</span>
					</li>
					<ol id="submenu-EmailTemplate" style="display: none;">
						<xsl:for-each select="/sailpoint/EmailTemplate">
                            <xsl:sort select="@name"/>
							<li>
								<a>
									<xsl:attribute name="href">
										<xsl:value-of select="concat('#EmailTemplate - ', @name)"/>
									</xsl:attribute>
									<xsl:value-of select="@name"/>
								</a>
							</li>
						</xsl:for-each>
					</ol>
				</xsl:if>

				<!-- Forms -->
				<xsl:if test="document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='documentForms']/@value='true' and /sailpoint/Form">
					<li>
						<a href="#Heading-Forms">Forms</a><xsl:text> </xsl:text><span onclick="toggleSection('Forms')" id="triangle-Forms" class="triangle-icon">&#9654;</span>
					</li>
					<ol id="submenu-Forms" style="display: none;">
						<xsl:for-each select="/sailpoint/Form">
                            <xsl:sort select="@name"/>
							<li>
								<a>
									<xsl:attribute name="href">
										<xsl:value-of select="concat('#Form - ', @name)"/>
									</xsl:attribute>
									<xsl:value-of select="@name"/>
								</a>
							</li>
						</xsl:for-each>
					</ol>
				</xsl:if>

			</ol>
		</div>
	</xsl:template>

	<xsl:template match="/">
		<xsl:text disable-output-escaping="yes"><![CDATA[<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">]]></xsl:text>
		<html>
			<head>
				<title>SailPoint Object Documentation</title>
				<!-- link rel="stylesheet" href="sailpoint-doc.css"/ -->
				<xsl:call-template name="insertCssStylesheet"/>
			</head>
			<body>
				<div id="mainBody">
					<xsl:call-template name="createIndex"/>
					<div id="mainDocument" >
						<xsl:if test="document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='documentConfiguration']/@value='true'">
							<xsl:call-template name="processSystemConfiguration"/>
						</xsl:if>
                        <xsl:if test="document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='documentAuditConfig']/@value='true'">
                            <xsl:call-template name="processAuditConfig"/>
                        </xsl:if>
						<xsl:if test="document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='documentObjectConfig']/@value='true'">
							<xsl:call-template name="processObjectConfigs"/>
						</xsl:if>
						<xsl:call-template name="processApplications"/>
						<xsl:call-template name="processIntegrationConfigs"/>
						<xsl:call-template name="processManagedAttributes"/>
						<xsl:call-template name="processBundles"/>
						<xsl:call-template name="processWorkgroups"/>
						<xsl:call-template name="processPopulations"/>
						<xsl:call-template name="processGroupFactories"/>
						<xsl:call-template name="processScheduledCertifications"/>
                        <xsl:if test="document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='documentTasks']/@value='true'" >
    						<xsl:call-template name="processTaskDefinitions"/>
                        </xsl:if>
						<!-- TODO: Certification Event -->
						<xsl:call-template name="processPolicies"/>
						<xsl:if test="document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='documentLifecycleEvents']/@value='true'">
							<xsl:call-template name="processLifecycleEvents"/>
						</xsl:if>
                        <xsl:if test="document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='documentQuickLinks']/@value='true'">
                            <xsl:call-template name="processQuickLinks"/>
                        </xsl:if>
						<xsl:if test="document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='documentWorkflows']/@value='true'">
							<xsl:call-template name="processWorkflows"/>
						</xsl:if>
						<xsl:if test="document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='documentRules']/@value='true'">
							<xsl:call-template name="processRules"/>
						</xsl:if>
						<xsl:if test="document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='documentEmailTemplates']/@value='true'">
							<xsl:call-template name="processEmailTemplates"/>
						</xsl:if>
						<xsl:if test="document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='documentForms']/@value='true'">
							<xsl:call-template name="processForms"/>
						</xsl:if>

						<hr/>
						<h1>Credits</h1>
						<ul>
							<li><div>Icons made by <a href="https://www.flaticon.com/authors/roundicons" title="Roundicons">Roundicons</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a> is licensed by <a href="http://creativecommons.org/licenses/by/3.0/" 			    title="Creative Commons BY 3.0" target="_blank">CC 3.0 BY</a></div></li>
							<li><div>Library <a href="http://cron-parser.com/" title="Cron-Utils">Cron-Utils</a> from <a href="http://cron-parser.com/" title="Cron-Utils">cron-parser.com</a> is licensed by <a href="https://github.com/jmrozanec/cron-utils/blob/master/LICENSE" title="Apache License 2.0" target="_blank">Apache License 2.0</a></div></li>
						</ul>
					</div>
				</div>
			</body>
		</html>
	</xsl:template>

</xsl:stylesheet>
