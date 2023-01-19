<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:iiqdoc="http://iiqdoc.config.data">
	<xsl:output omit-xml-declaration="yes" indent="yes" />

	<xsl:template name="taskDefinitionReferenceLink">
		<xsl:param name="taskDefinitionName" />
		<xsl:choose>
			<xsl:when test="//TaskDefinition[not(@template='true') and @name=$taskDefinitionName]">
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="concat('#TaskDefinition - ', $taskDefinitionName)" />
					</xsl:attribute>
					<xsl:value-of select="$taskDefinitionName" />
				</a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$taskDefinitionName" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="processTaskDefinitions">
		<!--
			The ImportAction is a KOGIT trick with a custom merge class. Supporting this here for code review.
		-->
		<xsl:if test="document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='documentTasks']/@value='true' and ( /sailpoint/TaskDefinition[not(@template='true' or @type='GridReport' or @type='Report' or @type='LiveReport' or @type='Certification' or @type='RoleMining' or @executor='sailpoint.task.RoleMiningTask')] | /sailpoint/ImportAction[@name='execute']/TaskDefinition[not(@template='true' or @type='GridReport' or @type='Report' or @type='LiveReport' or @type='Certification' or @type='RoleMining' or @executor='sailpoint.task.RoleMiningTask')] )">
			<a name="Heading-TaskDefinitions" />
			<h1>Task Definitions</h1>
			<a name="TaskDefinition -- Summary" />
			<h2>Summary</h2>
			<table class="mapTable">
				<tr>
					<th class="rowHeader">Total number of tasks</th>
					<td>
						<xsl:value-of select="count(/sailpoint/TaskDefinition[not(@template='true' or @type='GridReport' or @type='Report' or @type='LiveReport' or @type='Certification' or @type='RoleMining' or @executor='sailpoint.task.RoleMiningTask')] | /sailpoint/ImportAction[@name='execute']/TaskDefinition[not(@template='true' or @type='GridReport' or @type='Report' or @type='LiveReport' or @type='Certification' or @type='RoleMining' or @executor='sailpoint.task.RoleMiningTask')])" />
					</td>
				</tr>
				<tr>
					<th class="rowHeader">Number of account aggregation tasks</th>
					<td>
						<xsl:value-of select="count(/sailpoint/TaskDefinition[not(@template='true') and @type='AccountAggregation'] | /sailpoint/ImportAction[@name='execute']/TaskDefinition[not(@template='true') and @type='AccountAggregation'])" />
					</td>
				</tr>
				<tr>
					<th class="rowHeader">Number of account aggregation tasks with delta</th>
					<td>
						<xsl:value-of select="count(/sailpoint/TaskDefinition[not(@template='true') and @type='AccountAggregation' and Attributes/Map/entry[@key='deltaAggregation' and @value='true'] ] | /sailpoint/ImportAction[@name='execute']/TaskDefinition[not(@template='true') and @type='AccountAggregation' and Attributes/Map/entry[@key='deltaAggregation' and @value='true'] ])" />
					</td>
				</tr>
				<tr>
					<th class="rowHeader">Number of account aggregation tasks with partitioning</th>
					<td>
						<xsl:value-of select="count(/sailpoint/TaskDefinition[not(@template='true') and @type='AccountAggregation' and Attributes/Map/entry[@key='enablePartitioning' and @value='true'] ] | /sailpoint/ImportAction[@name='execute']/TaskDefinition[not(@template='true') and @type='AccountAggregation' and Attributes/Map/entry[@key='enablePartitioning' and @value='true'] ])" />
					</td>
				</tr>
				<tr>
					<th class="rowHeader">Number of group aggregation tasks</th>
					<td>
						<xsl:value-of select="count(/sailpoint/TaskDefinition[not(@template='true') and @type='AccountGroupAggregation'] | /sailpoint/ImportAction[@name='execute']/TaskDefinition[not(@template='true') and @type='AccountGroupAggregation'])" />
					</td>
				</tr>
				<tr>
					<th class="rowHeader">Number of identity refresh tasks</th>
					<td>
						<xsl:value-of select="count(/sailpoint/TaskDefinition[not(@template='true') and @type='Identity' and Parent/Reference/@name='Identity Refresh'] | /sailpoint/ImportAction[@name='execute']/TaskDefinition[not(@template='true') and @type='Identity' and Parent/Reference/@name='Identity Refresh'])" />
					</td>
				</tr>
				<tr>
					<th class="rowHeader">Number of identity refresh tasks with delta</th>
					<td>
						<xsl:value-of select="count(/sailpoint/TaskDefinition[not(@template='true') and @type='Identity' and Parent/Reference/@name='Identity Refresh']/Attributes/Map/entry[@key='filterNeedsRefresh' and @value='true'] | /sailpoint/ImportAction[@name='execute']/TaskDefinition[not(@template='true') and @type='Identity' and Parent/Reference/@name='Identity Refresh']/Attributes/Map/entry[@key='filterNeedsRefresh' and @value='true'])" />
					</td>
				</tr>
				<tr>
					<th class="rowHeader">Number of identity refresh tasks with partitioning</th>
					<td>
						<xsl:value-of select="count(/sailpoint/TaskDefinition[not(@template='true') and @type='Identity' and Parent/Reference/@name='Identity Refresh' and Attributes/Map/entry[@key='enablePartitioning' and @value='true']] | /sailpoint/ImportAction[@name='execute']/TaskDefinition[not(@template='true') and @type='Identity' and Parent/Reference/@name='Identity Refresh' and Attributes/Map/entry[@key='enablePartitioning' and @value='true']])" />
					</td>
				</tr>
				<tr>
					<th class="rowHeader">Number of sequential task launcher tasks</th>
					<td>
						<xsl:value-of select="count(/sailpoint/TaskDefinition[not(@template='true') and @type='Identity'] | /sailpoint/ImportAction[@name='execute']/TaskDefinition[not(@template='true') and @type='Identity'])" />
					</td>
				</tr>
			</table>

			<xsl:for-each select="/sailpoint/TaskDefinition[not(@template='true' or @type='GridReport' or @type='Report' or @type='LiveReport' or @type='Certification' or @type='RoleMining' or @executor='sailpoint.task.RoleMiningTask')] | /sailpoint/ImportAction[@name='execute']/TaskDefinition[not(@template='true' or @type='GridReport' or @type='Report' or @type='LiveReport' or @type='Certification' or @type='RoleMining' or @executor='sailpoint.task.RoleMiningTask')]">
				<xsl:sort select="@name" />
				<xsl:variable name="taskDefinitionName">
					<xsl:value-of select="@name" />
				</xsl:variable>
				<a>
					<xsl:attribute name="name">
						<xsl:value-of select="concat('TaskDefinition - ', @name)" />
					</xsl:attribute>
				</a>
				<h2>
					<xsl:value-of select="@name" />
				</h2>
				<table class="taskDefinitionTable">
					<tr>
						<th class="rowHeader">Name</th>
						<td>
							<xsl:value-of select="@name" />
						</td>
					</tr>
					<tr>
						<th class="rowHeader">Type</th>
						<td>
							<xsl:value-of select="@type" />
						</td>
					</tr>
					<tr>
						<th class="rowHeader">Subtype</th>
						<td>
							<xsl:value-of select="@subType" />
						</td>
					</tr>
					<xsl:if test="Parent/Reference">
						<tr>
							<th class="rowHeader">Parent</th>
							<td>
								<xsl:value-of select="Parent/Reference/@name" />
							</td>
						</tr>
					</xsl:if>
					<tr>
						<th class="rowHeader">Result Action</th>
						<td>
							<xsl:value-of select="@resultAction" />
						</td>
					</tr>
					<xsl:if test="@concurrent='true'">
						<th class="rowHeader">Allow Concurrency</th>
						<td>
							<xsl:text>true &#9888; Be careful: this may lead to conflicts.</xsl:text>
						</td>
					</xsl:if>
					<xsl:if test="Attributes/Map/entry[@key='pluginName']/@value">
						<tr>
							<th class="rowHeader">Plugin</th>
							<td>
								<xsl:value-of select="Attributes/Map/entry[@key='pluginName']/@value" />
							</td>
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
					<xsl:if test="Description">
						<tr>
							<th class="rowHeader">Description</th>
							<td>
								<pre class="description">
									<xsl:value-of select="Description" />
								</pre>
							</td>
						</tr>
					</xsl:if>
					<xsl:if test="Attributes/Map/entry[@key='TaskSchedule.host']/@value">
						<tr>
							<th class="rowHeader">Host</th>
							<td>
								<xsl:value-of select="Attributes/Map/entry[@key='TaskSchedule.host']/@value" />
							</td>
						</tr>
					</xsl:if>
					<xsl:if test="Parent/Reference/@name = 'Sequential Task Launcher'">
						<tr>
							<th class="rowHeader">Sub-tasks</th>
							<td>
								<xsl:call-template name="splitToDocLinkList">
									<xsl:with-param name="pText" select="Attributes/Map/entry[@key='taskList']/@value" />
									<xsl:with-param name="objectType" select="'TaskDefinition'" />
								</xsl:call-template>
							</td>
						</tr>
					</xsl:if>
					<xsl:if test="Parent/Reference/@name='Identity Refresh'">
						<xsl:if test="Attributes/Map/entry[@key='filter']/@value">
							<tr>
								<th class="rowHeader">Filter string to constrain the identities refreshed</th>
								<td>
									<xsl:value-of select="Attributes/Map/entry[@key='filter']/@value" />
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="Attributes/Map/entry[@key='filterGroups']">
							<tr>
								<th class="rowHeader">List of group or population names to constrain the identities refreshed</th>
								<td>
									<xsl:value-of select="Attributes/Map/entry[@key='filterGroups']/@value | Attributes/Map/entry[@key='filterGroups']/value" />
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="Attributes/Map/entry[@key='thresholdDate']">
							<tr>
								<th class="rowHeader">Refresh identities whose last refresh date is before this date</th>
								<td>
									<xsl:value-of select="Attributes/Map/entry[@key='thresholdDate']/@value | Attributes/Map/entry[@key='thresholdDate']/value" />
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="Attributes/Map/entry[@key='excludeWindow']">
							<tr>
								<th class="rowHeader">Refresh identities whose last refresh date is at least this number of hours ago</th>
								<td>
									<xsl:value-of select="Attributes/Map/entry[@key='excludeWindow']/@value | Attributes/Map/entry[@key='excludeWindow']/value" />
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="Attributes/Map/entry[@key='includeWindow']">
							<tr>
								<th class="rowHeader">Refresh identities whose last refresh date is within this number of hours</th>
								<td>
									<xsl:value-of select="Attributes/Map/entry[@key='includeWindow']/@value | Attributes/Map/entry[@key='includeWindow']/value" />
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="Attributes/Map/entry[@key='includeWindowModified']">
							<tr>
								<th class="rowHeader">Include modified identities in the refresh date window</th>
								<td>
									<xsl:call-template name="parseTextToBooleanIcon">
										<xsl:with-param name="boolVal" select="Attributes/Map/entry[@key='includeWindowModified']/@value | Attributes/Map/entry[@key='includeWindowModified']/value/Boolean" />
									</xsl:call-template>
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="Attributes/Map/entry[@key='filterNeedsRefresh']">
							<tr>
								<th class="rowHeader">Refresh only identities marked as needing refresh during aggregation (Delta Refresh)</th>
								<td>
									<xsl:call-template name="parseTextToBooleanIcon">
										<xsl:with-param name="boolVal" select="Attributes/Map/entry[@key='filterNeedsRefresh']/@value | Attributes/Map/entry[@key='filterNeedsRefresh']/value/Boolean" />
									</xsl:call-template>
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="Attributes/Map/entry[@key='noResetNeedsRefresh']">
							<tr>
								<th class="rowHeader">Do not reset the needing refresh marker after refresh</th>
								<td>
									<xsl:call-template name="parseTextToBooleanIcon">
										<xsl:with-param name="boolVal" select="Attributes/Map/entry[@key='noResetNeedsRefresh']/@value | Attributes/Map/entry[@key='noResetNeedsRefresh']/value/Boolean" />
									</xsl:call-template>
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="Attributes/Map/entry[@key='excludeInactive']">
							<tr>
								<th class="rowHeader">Exclude identities marked inactive</th>
								<td>
									<xsl:call-template name="parseTextToBooleanIcon">
										<xsl:with-param name="boolVal" select="Attributes/Map/entry[@key='excludeInactive']/@value | Attributes/Map/entry[@key='excludeInactive']/value/Boolean" />
									</xsl:call-template>
								</td>
							</tr>
						</xsl:if>
					</xsl:if>
					<xsl:if test="Attributes/Map/entry[@key='applications']">
						<tr>
							<th class="rowHeader">Application</th>
							<td>
								<xsl:call-template name="splitToDocLinkList">
									<xsl:with-param name="pText" select="Attributes/Map/entry[@key='applications']/@value" />
									<xsl:with-param name="objectType" select="'Application'" />
								</xsl:call-template>
							</td>
						</tr>
					</xsl:if>
					<xsl:if test="Attributes/Map/entry[@key='noOptimizeReaggregation']">
						<tr>
							<th class="rowHeader">Disable optimization of unchanged accounts</th>
							<td>
								<xsl:call-template name="parseTextToBoolean">
									<xsl:with-param name="boolVal" select="Attributes/Map/entry[@key='noOptimizeReaggregation']/@value" />
								</xsl:call-template>
								<xsl:if test="@type='AccountAggregation' and Attributes/Map/entry[@key='noOptimizeReaggregation']/@value='true'">
									<b>
										<xsl:text> &#9888; This should not be used in production, except once when aggregation rules or correlation logic have been updated.</xsl:text>
									</b>
								</xsl:if>
							</td>
						</tr>
					</xsl:if>
					<xsl:if test="Attributes/Map/entry[@key='promoteManagedAttributes']">
						<tr>
							<th class="rowHeader">Promote Managed Attribute</th>
							<td>
								<xsl:call-template name="parseTextToBoolean">
									<xsl:with-param name="boolVal" select="Attributes/Map/entry[@key='promoteManagedAttributes']/@value" />
								</xsl:call-template>
								<xsl:if test="@type='AccountAggregation' and Attributes/Map/entry[@key='promoteManagedAttributes']/@value='true'">
									<b>
										<xsl:text> &#9888; This option is inherently non-performant and should be run in a separate, non-partitioned refresh task.</xsl:text>
									</b>
								</xsl:if>
							</td>
						</tr>
					</xsl:if>
					<xsl:if test="Attributes/Map/entry[@key='enablePartitioning']">
						<tr>
							<th class="rowHeader">Partitioning Enabled</th>
							<td>
								<xsl:call-template name="parseTextToBoolean">
									<xsl:with-param name="boolVal" select="Attributes/Map/entry[@key='enablePartitioning']/@value" />
								</xsl:call-template>
							</td>
						</tr>
					</xsl:if>
					<xsl:if test="Attributes/Map/entry[@key='deltaAggregation']">
						<tr>
							<th class="rowHeader">Delta Aggregation</th>
							<td>
								<xsl:call-template name="parseTextToBoolean">
									<xsl:with-param name="boolVal" select="Attributes/Map/entry[@key='deltaAggregation']/@value" />
								</xsl:call-template>
							</td>
						</tr>
					</xsl:if>
					<xsl:if test="Attributes/Map/entry[@key='logAllowedActions']/@value">
						<tr>
							<th class="rowHeader">Actions to include in the task result</th>
							<td>
								<xsl:call-template name="splitToList">
									<xsl:with-param name="pText" select="Attributes/Map/entry[@key='logAllowedActions']/@value" />
									<xsl:with-param name="delim" select="','" />
								</xsl:call-template>
								<p>&#9888; Unselecting all “Actions to include in the task result” will improve task performance.</p>
							</td>
						</tr>
					</xsl:if>
					<!-- Run Rule -->
					<xsl:if test="Parent/Reference/@name='Run Rule'">
						<xsl:if test="Attributes/Map/entry[@key='ruleName']/@value">
							<tr>
								<th class="rowHeader">Rule Name</th>
								<td>
									<xsl:call-template name="ruleReferenceLink">
										<xsl:with-param name="ruleName" select="Attributes/Map/entry[@key='ruleName']/@value" />
									</xsl:call-template>
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="Attributes/Map/entry[@key='ruleConfig']/@value">
							<tr>
								<th class="rowHeader">Rule Configuration</th>
								<td>
									<xsl:value-of select="Attributes/Map/entry[@key='ruleConfig']/@value" />
								</td>
							</tr>
						</xsl:if>
					</xsl:if>
					<!-- Perform Maintenance -->
					<xsl:if test="Parent/Reference/@name='System Maintenance'">
						<xsl:if test="Attributes/Map/entry[@key='pruneHistory']/@value">
							<tr>
								<th class="rowHeader">Prune identity snapshots</th>
								<td>
									<xsl:value-of select="Attributes/Map/entry[@key='pruneHistory']/@value" />
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="Attributes/Map/entry[@key='pruneTaskResults']/@value">
							<tr>
								<th class="rowHeader">Prune task results</th>
								<td>
									<xsl:value-of select="Attributes/Map/entry[@key='pruneTaskResults']/@value" />
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="Attributes/Map/entry[@key='pruneRequests']/@value">
							<tr>
								<th class="rowHeader">Prune requests</th>
								<td>
									<xsl:value-of select="Attributes/Map/entry[@key='pruneRequests']/@value" />
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="Attributes/Map/entry[@key='pruneProvisioningTransactons']/@value">
							<tr>
								<th class="rowHeader">Prune provisioning transactions</th>
								<td>
									<xsl:value-of select="Attributes/Map/entry[@key='pruneProvisioningTransactons']/@value" />
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="Attributes/Map/entry[@key='pruneCertifications']/@value">
							<tr>
								<th class="rowHeader">Archive and prune certifications</th>
								<td>
									<xsl:value-of select="Attributes/Map/entry[@key='pruneCertifications']/@value" />
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="Attributes/Map/entry[@key='automaticallyCloseCertifications']/@value">
							<tr>
								<th class="rowHeader">Automatically close certifications</th>
								<td>
									<xsl:value-of select="Attributes/Map/entry[@key='automaticallyCloseCertifications']/@value" />
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="Attributes/Map/entry[@key='finishCertifications']/@value">
							<tr>
								<th class="rowHeader">Finish certifications</th>
								<td>
									<xsl:value-of select="Attributes/Map/entry[@key='finishCertifications']/@value" />
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="Attributes/Map/entry[@key='finisherThreads']/@value">
							<tr>
								<th class="rowHeader">Number of finisher threads</th>
								<td>
									<xsl:value-of select="Attributes/Map/entry[@key='finisherThreads']/@value" />
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="Attributes/Map/entry[@key='phaseCertifications']/@value">
							<tr>
								<th class="rowHeader">Transition certifications phases</th>
								<td>
									<xsl:value-of select="Attributes/Map/entry[@key='phaseCertifications']/@value" />
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="Attributes/Map/entry[@key='scanRemediations']/@value">
							<tr>
								<th class="rowHeader">Scan for completed revocations</th>
								<td>
									<xsl:value-of select="Attributes/Map/entry[@key='scanRemediations']/@value" />
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="Attributes/Map/entry[@key='forwardInactiveWorkItems']/@value">
							<tr>
								<th class="rowHeader">Forward inactive user work items</th>
								<td>
									<xsl:value-of select="Attributes/Map/entry[@key='forwardInactiveWorkItems']/@value" />
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="Attributes/Map/entry[@key='denormalizeScopes']/@value">
							<tr>
								<th class="rowHeader">Denormalize scopes</th>
								<td>
									<xsl:value-of select="Attributes/Map/entry[@key='denormalizeScopes']/@value" />
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="Attributes/Map/entry[@key='pruneBatchRequests']/@value">
							<tr>
								<th class="rowHeader">Prune batch requests</th>
								<td>
									<xsl:value-of select="Attributes/Map/entry[@key='pruneBatchRequests']/@value" />
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="Attributes/Map/entry[@key='pruneSyslogEvents']/@value">
							<tr>
								<th class="rowHeader">Prune syslog events</th>
								<td>
									<xsl:value-of select="Attributes/Map/entry[@key='pruneSyslogEvents']/@value" />
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="Attributes/Map/entry[@key='processWorkflowEvents']/@value">
							<tr>
								<th class="rowHeader">Process background workflow events</th>
								<td>
									<xsl:value-of select="Attributes/Map/entry[@key='processWorkflowEvents']/@value" />
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="Attributes/Map/entry[@key='workflowThreads']/@value">
							<tr>
								<th class="rowHeader">Number of background workflow threads </th>
								<td>
									<xsl:value-of select="Attributes/Map/entry[@key='workflowThreads']/@value" />
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="Attributes/Map/entry[@key='workflowThreads']/@value">
							<tr>
								<th class="rowHeader">Workflow thread timeout (seconds) </th>
								<td>
									<xsl:value-of select="Attributes/Map/entry[@key='workflowThreadTimeoutSeconds']/@value" />
								</td>
							</tr>
						</xsl:if>
						<xsl:if test="Attributes/Map/entry[@key='pruneAttachments']/@value">
							<tr>
								<th class="rowHeader">Prune Attachments</th>
								<td>
									<xsl:value-of select="Attributes/Map/entry[@key='pruneAttachments']/@value" />
								</td>
							</tr>
						</xsl:if>
					</xsl:if>
					<!-- Task Schedules found for the task -->
					<xsl:if test="//TaskSchedule[Arguments/Map/entry[@key='executor']/@value = $taskDefinitionName]">
						<tr>
							<th class="rowHeader">Schedule(s)</th>
							<td>
								<table class="taskDefinitionTable">
									<xsl:for-each select="//TaskSchedule[Arguments/Map/entry[@key='executor']/@value = $taskDefinitionName]">
										<tr>
											<th>Name</th>
											<td>
												<xsl:value-of select="@name" />
											</td>
										</tr>
										<tr>
											<th>Launcher</th>
											<td>
												<xsl:value-of select="Arguments/Map/entry[@key='launcher']/@value" />
											</td>
										</tr>
										<tr>
											<th>Schedule</th>
											<td>
												<xsl:for-each select="CronExpressions/String">
													<xsl:call-template name="describeCronExpression">
														<xsl:with-param name="cronExpression" select="./text()" />
													</xsl:call-template>
												</xsl:for-each>
											</td>
										</tr>
									</xsl:for-each>
								</table>
							</td>
						</tr>
					</xsl:if>
				</table>

			</xsl:for-each>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>