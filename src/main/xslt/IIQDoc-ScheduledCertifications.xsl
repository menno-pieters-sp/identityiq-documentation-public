<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:iiqdoc="http://iiqdoc.config.data">
	<xsl:output omit-xml-declaration="yes" indent="yes" method="html" />

	<xsl:template name="processSingleCertificationDefinition" match="//CertificationDefinition">
		<xsl:param name="taskScheduleId" />
		<xsl:variable name="certificationType" select="Attributes/Map/entry[@key='certificationType']/value/CertificationType|Attributes/Map/entry[@key='certificationType']/@value"/>
		<h3>Basic</h3>
		<h4>Certification Properties</h4>
		<table>
			<tr>
				<th class="rowHeader">Certification Type</th>
				<td><xsl:value-of select="$certificationType"/></td>
			</tr>
			<tr>
				<th class="rowHeader">Certification Name</th>
				<td><xsl:value-of select="@name"/></td>
			</tr>
			<tr>
				<th class="rowHeader">Certification Owner</th>
				<td>
					<xsl:call-template name="workgroupOrIdentityLink">
						<xsl:with-param name="identityName" select="Attributes/Map/entry[@key='certOwner']/@value"/>
					</xsl:call-template>
				</td>
			</tr>
		</table>

		<h4>What to Certify</h4>
		<table>
			<xsl:choose>
			  <!-- AccountGroupMembership / AccountGroupPermissions -->
				<xsl:when test="$certificationType = 'AccountGroupMembership' or $certificationType = 'AccountGroupPermissions'">
					<tr>
						<th class="rowHeader">Applications</th>
						<td>
							<xsl:choose>
								<xsl:when test="Attributes/Map/entry[@key='icertificationGlobal']/@value = 'true'">
									<i>All Applications</i>
								</xsl:when>
								<xsl:when test="Attributes/Map/entry[@key='certifiedApplicationIds']/@value">
									<ul>
										<xsl:call-template name="splitToList">
											<xsl:with-param name="pText" select="Attributes/Map/entry[@key='certifiedApplicationIds']/@value" />
											<xsl:with-param name="delim" select="','" />
										</xsl:call-template>
									</ul>
								</xsl:when>
							</xsl:choose>
						</td>
					</tr>
					<xsl:if test="Attributes/Map/entry[@key='applicationGroups']/value/List/ApplicationGroup">
						<tr>
							<th class="rowHeader">Certify By Object Type</th>
							<td>
								<ul>
						    	<xsl:for-each select="Attributes/Map/entry[@key='applicationGroups']/value/List/ApplicationGroup">
										<li>
											<b>
												<xsl:value-of select="@applicationName"/>
												<xsl:text>: </xsl:text>
											</b>
											<xsl:value-of select="@schemaObjectType"/>
										</li>
									</xsl:for-each>
								</ul>
							</td>
					  </tr>
					</xsl:if>
				</xsl:when>
			  <!-- ApplicationOwner / DataOwner (Entitlement Owner) -->
				<xsl:when test="$certificationType = 'ApplicationOwner' or $certificationType = 'DataOwner'">
					<tr>
						<th class="rowHeader">Applications</th>
						<td>
							<xsl:choose>
								<xsl:when test="Attributes/Map/entry[@key='icertificationGlobal']/@value = 'true'">
									<i>All Applications</i>
								</xsl:when>
								<xsl:when test="Attributes/Map/entry[@key='certifiedApplicationIds']/@value">
									<ul>
										<xsl:call-template name="splitToList">
											<xsl:with-param name="pText" select="Attributes/Map/entry[@key='certifiedApplicationIds']/@value" />
											<xsl:with-param name="delim" select="','" />
										</xsl:call-template>
									</ul>
								</xsl:when>
							</xsl:choose>
						</td>
					</tr>
				</xsl:when>
			  <!-- BusinessRoleComposition / BusinessRoleMembership -->
				<xsl:when test="$certificationType = 'BusinessRoleComposition' or $certificationType = 'BusinessRoleMembership'">
					<tr>
						<th class="rowHeader">Selected Roles</th>
						<xsl:choose>
							<xsl:when test="Attributes/Map/entry[@key='certificationGlobal']/@value='true'">
								<b>All Roles</b>
							</xsl:when>
							<xsl:when test="Attributes/Map/entry[@key='roleTypes']">
								<td>
									<b>Role Types: </b><br/>
									<xsl:value-of select="Attributes/Map/entry[@key='roleTypes']/@value"/>
								</td>
							</xsl:when>
							<xsl:when test="Attributes/Map/entry[@key='businessRoles']">
								<td>
									<b>Manually Selected Roles: </b><br/>
									<xsl:value-of select="Attributes/Map/entry[@key='businessRoles']/@value"/>
								</td>
							</xsl:when>
						</xsl:choose>
					</tr>
				</xsl:when>
			  <!-- Flexible - obsolete -->
			  <!-- Focused (Targeted) -->
				<xsl:when test="$certificationType = 'Focused'">
					<!-- entitySelectionType - Population: entityPopulation -->
					<xsl:if test="Attributes/Map/entry[@key='entityPopulation']/@value">
						<tr>
							<th class="rowHeader">Population</th>
							<td>
								<xsl:call-template name="populationReferenceLink">
									<xsl:with-param name="populationName" select="Attributes/Map/entry[@key='entityPopulation']/@value" />
								</xsl:call-template>
							</td>
						</tr>
					</xsl:if>
					<!-- entitySelectionType - Filter: entitlementFilter, entitlementFilterValues, entityFilter, entityFilterValues -->
					<xsl:if test="Attributes/Map/entry[@key='entityFilter']/value">
						<tr>
							<th class="rowHeader">Filter</th>
							<td>
								<xsl:for-each select="Attributes/Map/entry[@key='entityFilter']/value">
									<xsl:choose>
										<xsl:when test="CompositeFilter">
											<xsl:for-each select="CompositeFilter">
												<xsl:call-template name="processCompositeFilter"/>
											</xsl:for-each>
										</xsl:when>
										<xsl:when test="Filter">
											<xsl:for-each select="Filter">
												<xsl:call-template name="processFilter"/>
											</xsl:for-each>
										</xsl:when>
									</xsl:choose>
								</xsl:for-each>
							</td>
						</tr>
					</xsl:if>
					<!-- entitySelectionType - entityRule -->
					<xsl:if test="Attributes/Map/entry[@key='entityRule']/@value">
						<tr>
							<th class="rowHeader">Rule</th>
							<td>
								<xsl:call-template name="ruleReferenceLink">
									<xsl:with-param name="ruleName" select="Attributes/Map/entry[@key='entityRule']/@value" />
								</xsl:call-template>
							</td>
						</tr>
					</xsl:if>
					<tr>
						<th class="rowHeader">Exclude Inactive</th>
						<td><xsl:value-of select="Attributes/Map/entry[@key='excludeInactive']/@value"/></td>
					</tr>
				</xsl:when>
			  <!-- Group (Advanced) -->
				<xsl:when test="$certificationType = 'Group'">
					<tr>
						<th class="rowHeader">Populations to Certify</th>
						<td>
							<xsl:if test="Attributes/Map/entry[@key='iPOPCertifierMap']/value/Map/entry">
								<table>
									<tr>
										<th>Population</th>
										<th>Certifiers</th>
									</tr>
									<xsl:for-each select="Attributes/Map/entry[@key='iPOPCertifierMap']/value/Map/entry">
										<tr>
											<td>
												<xsl:call-template name="populationReferenceLink">
													<xsl:with-param name="populationId" select="@key"/>
												</xsl:call-template>
											</td>
											<td>
												<ul>
													<xsl:for-each select="value/List/String">
														<li>
															<xsl:call-template name="workgroupOrIdentityLinkById">
														    <xsl:with-param name="identityId" select="node()"/>
															</xsl:call-template>
														</li>
													</xsl:for-each>
												</ul>
											</td>
										</tr>
									</xsl:for-each>
								</table>
							</xsl:if>
						</td>
					</tr>
					<tr>
						<th class="rowHeader">Group Factories to Certify</th>
						<td>
							<xsl:if test="Attributes/Map/entry[@key='factoryCertifierMap']/value/Map/entry">
								<table>
									<tr>
										<th>Group Factory</th>
										<th>Certifier Rule</th>
									</tr>
									<xsl:for-each select="Attributes/Map/entry[@key='factoryCertifierMap']/value/Map/entry">
										<tr>
											<td>
												<xsl:call-template name="groupFactoryReferenceLink">
													<xsl:with-param name="groupFactoryId" select="@key"/>
												</xsl:call-template>
											</td>
											<td>
												<xsl:call-template name="ruleReferenceLink">
													<xsl:with-param name="ruleName" select="@value"/>
												</xsl:call-template>
											</td>
										</tr>
									</xsl:for-each>
								</table>
							</xsl:if>
						</td>
					</tr>
				</xsl:when>
			  <!-- Identity -->
				<xsl:when test="$certificationType = 'Identity'">
					<tr>
						<th class="rowHeader">Certifiers</th>
						<td>
							<xsl:choose>
								<xsl:when test="Attributes/Map/entry[@key='certifierType']/@value = 'Manager'">
									<b>Assign to Manager(s)</b><br/>
									Default: <xsl:call-template name="workgroupOrIdentityLink">
										<xsl:with-param name="identityName" select="Attributes/Map/entry[@key='certifier']/@value"/>
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
								</xsl:otherwise>
							</xsl:choose>
						</td>
					</tr>
				</xsl:when>
			  <!-- Manager -->
				<xsl:when test="$certificationType = 'Manager'">
					<tr>
						<th class="rowHeader">Recipient</th>
						<td>
							<xsl:choose>
								<xsl:when test="Attributes/Map/entry[@key='certificationGlobal']/@value='true'">
									<b>All Managers</b>
								</xsl:when>
								<xsl:otherwise>
									<xsl:call-template name="workgroupOrIdentityLink">
										<xsl:with-param name="identityName" select="Attributes/Map/entry[@key='certifier']/@value"/>
									</xsl:call-template>
								</xsl:otherwise>
							</xsl:choose>
						</td>
					</tr>
				</xsl:when>
				<xsl:otherwise>
				</xsl:otherwise>
			</xsl:choose>
		</table>

		<xsl:if test="$taskScheduleId">
			<h4>When to Certify</h4>
			<table>
				<tr>
					<th class="rowHeader">Schedule</th>
					<td>
						<xsl:if test="/sailpoint/TaskSchedule[@id=$taskScheduleId]/CronExpressions/String">
							<xsl:for-each select="/sailpoint/TaskSchedule[@id=$taskScheduleId]/CronExpressions/String">
						  	<xsl:call-template name="describeCronExpression">
						  		<xsl:with-param name="cronExpression">
										<xsl:value-of select="text()"/>
										<br/>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:for-each>
						</xsl:if>
					</td>
				</tr>
				<tr>
					<th class="rowHeader">Next execution</th>
					<td>
						<xsl:if test="/sailpoint/TaskSchedule[@id=$taskScheduleId]/@nextExecution">
							<xsl:call-template name="timeStampToDate">
								<xsl:with-param name="timestamp" select="/sailpoint/TaskSchedule[@id=$taskScheduleId]/@nextExecution"/>
								<xsl:with-param name="format" select="document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='defaultDateTimeLong']/@value" />
							</xsl:call-template>
						</xsl:if>
					</td>
				</tr>
			</table>
		</xsl:if>

		<!-- includeCertificationDetails -->

		<h4>Certification Contents</h4>

		<table>
			<!-- TODO: depending on type -->

			<tr>
				<th class="rowHeader">Tags</th>
				<td>
					<xsl:if test="Tags/Reference">
						<ul>
							<xsl:for-each select="Tags/Reference">
								<li>
									<xsl:value-of select="@name"/>
								</li>
							</xsl:for-each>
						</ul>
					</xsl:if>
				</td>
			</tr>
		</table>

		<xsl:if test="document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='defaultDateTimeLong']/@value = 'true'">
			<!-- TODO -->
			<h3>Lifecycle</h3>
			<!-- TODO -->
			<h3>Notifications</h3>
			<!-- TODO -->
			<h3>Behavior</h3>
			<!-- TODO -->
			<h3>Advanced</h3>
			<!-- TODO -->
		</xsl:if>
	</xsl:template>

	<xsl:template name="processScheduledCertifications">
		<xsl:if test="/sailpoint/TaskSchedule[Arguments/Map/entry[@key='certificationDefinitionId']]">
			<a name="Heading-Certifications"/>
			<h1>Certifications</h1>
			<xsl:for-each select="/sailpoint/TaskSchedule[Arguments/Map/entry[@key='certificationDefinitionId']]">
                <xsl:sort select="@name"/>
				<xsl:variable name="taskScheduleId" select="@id"/>
				<xsl:variable name="certificationDefinitionId">
					<xsl:value-of select="Arguments/Map/entry[@key='certificationDefinitionId']/@value"/>
				</xsl:variable>
				<a>
					<xsl:attribute name="name">
	          <xsl:value-of select="concat('TaskSchedule - ', @name)" />
					</xsl:attribute>
				</a>
				<h2><xsl:value-of select="@name"/></h2>
				<xsl:if test="//CertificationDefinition[@id=$certificationDefinitionId or @name=$certificationDefinitionId]">
					<xsl:for-each select="//CertificationDefinition[@id=$certificationDefinitionId or @name=$certificationDefinitionId]">
						<xsl:call-template name="processSingleCertificationDefinition">
							<xsl:with-param name="taskScheduleId" select="$taskScheduleId"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
