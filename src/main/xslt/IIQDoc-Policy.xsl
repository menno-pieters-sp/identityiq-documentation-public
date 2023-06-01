<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:iiqdoc="http://iiqdoc.config.data">
	<xsl:output omit-xml-declaration="yes" indent="yes" />

	<xsl:template name="policyReferenceLink">
		<xsl:param name="policyName"/>
		<xsl:choose>
			<xsl:when test="//Policy[not(@template='true') and @name=$policyName] and document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='documentPolicies']/@value='true'">
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="concat('#Policy - ', @policyName)"/>
					</xsl:attribute>
					<xsl:value-of select="policyName"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$policyName"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="processGenericConstraint" match="//GenericConstraint">
		<table class="policyRuleTable">
			<tr>
				<th class="rowHeader">Name</th>
				<td><xsl:value-of select="@name"/></td>
			</tr>
			<xsl:if test="Owner/Reference">
				<tr>
					<th class="rowHeader">Owner</th>
					<td>
						<xsl:call-template name="workgroupOrIdentityLink">
							<xsl:with-param name="identityName" select="Owner/Reference/@name"/>
						</xsl:call-template>
					</td>
				</tr>
			</xsl:if>
			<tr>
				<th class="rowHeader">Violation Owner</th>
				<td>
					<xsl:choose>
						<xsl:when test="@violationOwnerType='None'">
							<xsl:text>None</xsl:text>
						</xsl:when>
						<xsl:when test="@violationOwnerType='Manager'">
							<xsl:text>Manager</xsl:text>
						</xsl:when>
						<xsl:when test="@violationOwnerType='Identity'">
							<xsl:text>Identity: </xsl:text>
							<xsl:call-template name="workgroupOrIdentityLink">
								<xsl:with-param name="identityName" select="ViolationOwner/Reference/@name" />
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="@violationOwnerType='Rule'">
							<xsl:text>Rule: </xsl:text>
							<xsl:call-template name="ruleReferenceLink">
								<xsl:with-param name="ruleName" select="ViolationOwnerRule/Reference/@name" />
							</xsl:call-template>
						</xsl:when>
					</xsl:choose>
				</td>
			</tr>
			<xsl:if test="Description">
				<tr>
					<th class="rowHeader">Description</th>
					<td><xsl:value-of select="Description/text()"/></td>
				</tr>
			</xsl:if>
			<xsl:if test="CompensatingControl">
				<tr>
					<th class="rowHeader">Compensating Control</th>
					<td><xsl:value-of select="CompensatingControl/text()"/></td>
				</tr>
			</xsl:if>
			<xsl:if test="RemediationAdvice">
				<tr>
					<th class="rowHeader">Remediation Advice</th>
					<td><xsl:value-of select="RemediationAdvice/text()"/></td>
				</tr>
			</xsl:if>
			<xsl:if test="IdentitySelector">
				<th class="rowHeader">Criteria</th>
				<td>
					<xsl:for-each select="IdentitySelector">
						<xsl:call-template name="processSingleIdentitySelector" />
					</xsl:for-each>
				</td>
			</xsl:if>

		</table>
		<br/>
	</xsl:template>

	<xsl:template name="processActivityConstraint" match="ActivityConstraint">
		<table class="policyRuleTable">
			<tr>
				<th class="rowHeader">Name</th>
				<td><xsl:value-of select="@name"/></td>
			</tr>
			<xsl:if test="Owner/Reference">
				<tr>
					<th class="rowHeader">Owner</th>
					<td>
						<xsl:call-template name="workgroupOrIdentityLink">
							<xsl:with-param name="identityName" select="Owner/Reference/@name"/>
						</xsl:call-template>
					</td>
				</tr>
			</xsl:if>
			<tr>
				<th class="rowHeader">Violation Owner</th>
				<td>
					<xsl:choose>
						<xsl:when test="@violationOwnerType='None'">
							<xsl:text>None</xsl:text>
						</xsl:when>
						<xsl:when test="@violationOwnerType='Manager'">
							<xsl:text>Manager</xsl:text>
						</xsl:when>
						<xsl:when test="@violationOwnerType='Identity'">
							<xsl:text>Identity: </xsl:text>
							<xsl:call-template name="workgroupOrIdentityLink">
								<xsl:with-param name="identityName" select="ViolationOwner/Reference/@name" />
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="@violationOwnerType='Rule'">
							<xsl:text>Rule: </xsl:text>
							<xsl:call-template name="ruleReferenceLink">
								<xsl:with-param name="ruleName" select="ViolationOwnerRule/Reference/@name" />
							</xsl:call-template>
						</xsl:when>
					</xsl:choose>
				</td>
			</tr>
			<xsl:if test="Description">
				<tr>
					<th class="rowHeader">Description</th>
					<td><xsl:value-of select="Description/text()"/></td>
				</tr>
			</xsl:if>
			<xsl:if test="CompensatingControl">
				<tr>
					<th class="rowHeader">Compensating Control</th>
					<td><xsl:value-of select="CompensatingControl/text()"/></td>
				</tr>
			</xsl:if>
			<xsl:if test="RemediationAdvice">
				<tr>
					<th class="rowHeader">Remediation Advice</th>
					<td><xsl:value-of select="RemediationAdvice/text()"/></td>
				</tr>
			</xsl:if>

			<!-- TODO -->
	  </table>
		<br/>
	</xsl:template>

	<xsl:template name="processSODConstraint" match="//SODConstraint">
		<table class="policyRuleTable">
			<tr>
				<th class="rowHeader">Name</th>
				<td><xsl:value-of select="@name"/></td>
			</tr>
			<xsl:if test="Owner/Reference">
				<tr>
					<th class="rowHeader">Owner</th>
					<td>
						<xsl:call-template name="workgroupOrIdentityLink">
							<xsl:with-param name="identityName" select="Owner/Reference/@name"/>
						</xsl:call-template>
					</td>
				</tr>
			</xsl:if>
			<tr>
				<th class="rowHeader">Violation Owner</th>
				<td>
					<xsl:choose>
						<xsl:when test="@violationOwnerType='None'">
							<xsl:text>None</xsl:text>
						</xsl:when>
						<xsl:when test="@violationOwnerType='Manager'">
							<xsl:text>Manager</xsl:text>
						</xsl:when>
						<xsl:when test="@violationOwnerType='Identity'">
							<xsl:text>Identity: </xsl:text>
							<xsl:call-template name="workgroupOrIdentityLink">
								<xsl:with-param name="identityName" select="ViolationOwner/Reference/@name" />
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="@violationOwnerType='Rule'">
							<xsl:text>Rule: </xsl:text>
							<xsl:call-template name="ruleReferenceLink">
								<xsl:with-param name="ruleName" select="ViolationOwnerRule/Reference/@name" />
							</xsl:call-template>
						</xsl:when>
					</xsl:choose>
				</td>
			</tr>
			<xsl:if test="Description">
				<tr>
					<th class="rowHeader">Description</th>
					<td><xsl:value-of select="Description/text()"/></td>
				</tr>
			</xsl:if>
			<xsl:if test="CompensatingControl">
				<tr>
					<th class="rowHeader">Compensating Control</th>
					<td><xsl:value-of select="CompensatingControl/text()"/></td>
				</tr>
			</xsl:if>
			<xsl:if test="RemediationAdvice">
				<tr>
					<th class="rowHeader">Remediation Advice</th>
					<td><xsl:value-of select="RemediationAdvice/text()"/></td>
				</tr>
			</xsl:if>
			<tr>
				<td colspan="2">
					<table border="0" cols="2">
						<tr>
							<th width="50%">Any of these roles...</th>
							<th width="50%">...conflict with any of these roles</th>
						</tr>
						<tr>
							<td>
								<ul>
									<xsl:for-each select="LeftBundles/Reference">
										<li>
											<xsl:call-template name="roleReferenceLink">
												<xsl:with-param name="roleName" select="@name" />
											</xsl:call-template>
										</li>
									</xsl:for-each>
								</ul>
							</td>
							<td>
								<ul>
									<xsl:for-each select="RightBundles/Reference">
										<li>
											<xsl:call-template name="roleReferenceLink">
												<xsl:with-param name="roleName" select="@name" />
											</xsl:call-template>
										</li>
									</xsl:for-each>
								</ul>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<br/>
	</xsl:template>

	<xsl:template name="processPolicies">
		<xsl:if test="/sailpoint/Policy[not(@template='true')] and document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='documentPolicies']/@value='true'">
			<a name="Heading-Policies"/>
			<h1>Policies</h1>

			<xsl:for-each select="/sailpoint/Policy[not(@template='true')]">
				<xsl:sort select="@name"/>
				<xsl:variable name="policyName"><xsl:value-of select="@name"/></xsl:variable>
				<a>
					<xsl:attribute name="name">
						<xsl:value-of select="concat('Policy - ', @name)"/>
					</xsl:attribute>
				</a>
				<h2><xsl:value-of select="@name"/></h2>
				<table class="policyTable">
					<tr>
						<th class="rowHeader">Type</th>
						<td><xsl:value-of select="@type"/></td>
					</tr>
					<xsl:if test="Attributes/Map/entry[@key='pluginName']/@value">
						<tr>
							<th class="rowHeader">Plugin</th>
							<td><xsl:value-of select="Attributes/Map/entry[@key='pluginName']/@value"/></td>
						</tr>
					</xsl:if>
					<tr>
						<th class="rowHeader">Owner</th>
						<td>
							<xsl:call-template name="workgroupOrIdentityLink">
								<xsl:with-param name="identityName" select="Owner/Reference/@name" />
							</xsl:call-template>
						</td>
					</tr>
					<tr>
						<th class="rowHeader">Violation Owner</th>
						<td>
							<xsl:choose>
								<xsl:when test="@violationOwnerType='None'">
									<xsl:text>None</xsl:text>
								</xsl:when>
								<xsl:when test="@violationOwnerType='Manager'">
									<xsl:text>Manager</xsl:text>
								</xsl:when>
								<xsl:when test="@violationOwnerType='Identity'">
									<xsl:text>Identity: </xsl:text>
									<xsl:call-template name="workgroupOrIdentityLink">
										<xsl:with-param name="identityName" select="ViolationOwner/Reference/@name" />
									</xsl:call-template>
								</xsl:when>
								<xsl:when test="@violationOwnerType='Rule'">
									<xsl:text>Rule: </xsl:text>
									<xsl:call-template name="ruleReferenceLink">
										<xsl:with-param name="ruleName" select="ViolationOwnerRule/Reference/@name" />
									</xsl:call-template>
								</xsl:when>
							</xsl:choose>
						</td>
					</tr>
					<xsl:if test="Attributes/Map/entry[@key='sysDescriptions']/value/Map/entry[@key='en_US']">
						<tr>
							<th class="rowHeader">Description</th>
							<td>
								<pre class="description">
									<xsl:choose>
										<xsl:when test="Attributes/Map/entry[@key='sysDescriptions']/value/Map/entry[@key='en_US']/@value">
									    <xsl:value-of select="Attributes/Map/entry[@key='sysDescriptions']/value/Map/entry[@key='en_US']/@value"/>
										</xsl:when>
										<xsl:otherwise>
									    <xsl:value-of select="Attributes/Map/entry[@key='sysDescriptions']/value/Map/entry[@key='en_US']/value/String/text()"/>
										</xsl:otherwise>
									</xsl:choose>
							  </pre>
							</td>
						</tr>
				  </xsl:if>

					<xsl:if test="ViolationOwnerRule">
						<tr>
							<th class="rowHeader">Violation Formatting Rule</th>
							<td>
								<xsl:call-template name="ruleReferenceLink">
									<xsl:with-param name="ruleName" select="ViolationOwnerRule/Reference/@name"/>
								</xsl:call-template>
							</td>
						</tr>
					</xsl:if>

					<xsl:if test="Attributes/Map/entry[@key='violationRule']/@value">
						<tr>
							<th class="rowHeader">Violation formatting rule</th>
							<td>
								<xsl:call-template name="ruleReferenceLink">
									<xsl:with-param name="ruleName" select="Attributes/Map/entry[@key='violationRule']/@value"/>
								</xsl:call-template>
							</td>
						</tr>
					</xsl:if>

					<xsl:if test="Attributes/Map/entry[@key='violationWorkflow']/@value">
						<tr>
							<th class="rowHeader">Violation business process</th>
							<td>
								<xsl:call-template name="workflowReferenceLink">
									<xsl:with-param name="workflowName" select="Attributes/Map/entry[@key='violationWorkflow']/@value"/>
								</xsl:call-template>
							</td>
						</tr>
					</xsl:if>

					<tr>
						<th class="rowHeader">State</th>
						<td><xsl:value-of select="@state"/></td>
					</tr>

					<tr>
						<th class="rowHeader">Send Alerts</th>
						<td>
							<xsl:choose>
								<xsl:when test="PolicyAlert[not(@disabled='true')]">
									<table>
										<tr>
											<th class="rowHeader"><xsl:text>Escalation</xsl:text></th>
											<td>
												<xsl:variable name="escalationStyle" select="PolicyAlert/@escalationStyle"/>
												<xsl:choose>
													<xsl:when test="$escalationStyle = 'none'">
														<xsl:text>None</xsl:text>
													</xsl:when>
													<xsl:when test="$escalationStyle = 'reminder'">
														<xsl:text>Send Reminders</xsl:text>
													</xsl:when>
													<xsl:when test="$escalationStyle = 'escalation'">
														<xsl:text>Escalation Only</xsl:text>
													</xsl:when>
													<xsl:when test="$escalationStyle = 'both'">
														<xsl:text>Reminders then Escalation</xsl:text>
													</xsl:when>
												</xsl:choose>
											</td>
										</tr>
										<xsl:if test="PolicyAlert/@hoursTillEscalation">
										  <tr>
												<th class="rowHeader"><xsl:text>Days Before First Reminder</xsl:text></th>
												<td><xsl:value-of select="PolicyAlert/@hoursTillEscalation div 24"/></td>
										  </tr>
										</xsl:if>
										<xsl:if test="PolicyAlert/@hoursBetweenReminders">
										  <tr>
												<th class="rowHeader"><xsl:text>Reminder Frequency</xsl:text></th>
												<td><xsl:value-of select="PolicyAlert/@hoursBetweenReminders div 24"/></td>
										  </tr>
										</xsl:if>
										<xsl:if test="PolicyAlert/ReminderEmailTemplateRef">
										  <tr>
												<th class="rowHeader"><xsl:text>Reminder Email Template</xsl:text></th>
												<td>
													<xsl:call-template name="emailTemplateReferenceLink">
														<xsl:with-param name="emailTemplateName" select="PolicyAlert/ReminderEmailTemplateRef/Reference/@name"/>
													</xsl:call-template>
												</td>
										  </tr>
										</xsl:if>
										<xsl:if test="PolicyAlert/@maxReminders">
										  <tr>
												<th class="rowHeader"><xsl:text>Reminders Before Escalation</xsl:text></th>
												<td><xsl:value-of select="PolicyAlert/@maxReminders"/></td>
										  </tr>
										</xsl:if>
										<xsl:if test="PolicyAlert/EscalationRuleRef">
										  <tr>
												<th class="rowHeader"><xsl:text>Escalation Owner Rule</xsl:text></th>
												<td>
													<xsl:call-template name="ruleReferenceLink">
														<xsl:with-param name="ruleName" select="PolicyAlert/EscalationRuleRef/Reference/@name"/>
													</xsl:call-template>
												</td>
										  </tr>
										</xsl:if>
										<xsl:if test="PolicyAlert/EscalationEmailTemplateRef">
										  <tr>
												<th class="rowHeader"><xsl:text>Escalation Email</xsl:text></th>
												<td>
													<xsl:call-template name="emailTemplateReferenceLink">
														<xsl:with-param name="emailTemplateName" select="PolicyAlert/EscalationEmailTemplateRef/Reference/@name"/>
													</xsl:call-template>
											  </td>
										  </tr>
										</xsl:if>
										<xsl:if test="PolicyAlert/Owners/Reference">
										  <tr>
												<th class="rowHeader"><xsl:text>Observers</xsl:text></th>
												<td>
													<ul>
														<xsl:for-each select="PolicyAlert/Owners/Reference">
															<li>
																<xsl:call-template name="workgroupOrIdentityLink">
																	<xsl:with-param name="identityName" select="@name"/>
																</xsl:call-template>
															</li>
														</xsl:for-each>
													</ul>
												</td>
										  </tr>
										</xsl:if>
									</table>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>Disabled</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</td>
					</tr>
				</table>

				<h3>Policy Rules</h3>
				<xsl:if test="SODConstraints/SODConstraint">
					<xsl:for-each select="SODConstraints/SODConstraint">
						<xsl:call-template name="processSODConstraint"/>
					</xsl:for-each>
				</xsl:if>
				<xsl:if test="ActivityConstraints/ActivityConstraint">
					<xsl:for-each select="ActivityConstraints/ActivityConstraint">
						<xsl:call-template name="processActivityConstraint"/>
					</xsl:for-each>
				</xsl:if>
				<xsl:if test="GenericConstraints/GenericConstraint">
					<xsl:for-each select="GenericConstraints/GenericConstraint">
						<xsl:call-template name="processGenericConstraint"/>
					</xsl:for-each>
				</xsl:if>
				<xsl:if test="@type = 'Risk'">
					<!-- TODO: Risk policy -->
				</xsl:if>

			</xsl:for-each>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
