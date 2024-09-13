<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:iiqdoc="http://iiqdoc.config.data" xmlns:exslt="http://exslt.org/common" exclude-result-prefixes="exslt">
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

    <xsl:template name="taskPopulationOrGroupLink">
        <xsl:param name="groupName"/>
        <xsl:choose>
            <xsl:when test="//GroupDefinition[not(Factory) and @name=normalize-space($groupName)]/@name">
                <!-- Population -->
                <xsl:text>Population: </xsl:text>
                <xsl:call-template name="populationReferenceLink">
                   <xsl:with-param name="populationName" select="$groupName"/> 
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="//GroupDefinition[Factory/Reference[@class='sailpoint.object.GroupFactory'] and @name=normalize-space($groupName)]/@name">
                <!-- Factory Group -->
                <xsl:text>Group Factory: </xsl:text>
                <xsl:variable name="factoryName" select="//GroupDefinition[Factory/Reference[@class='sailpoint.object.GroupFactory'] and @name=normalize-space($groupName)]/Factory/Reference/@name"/>
                <xsl:call-template name="groupFactoryReferenceLink">
                    <xsl:with-param name="groupFactoryName" select="$factoryName"/>
                </xsl:call-template>
                <xsl:text>; Group: </xsl:text>
                <xsl:value-of select="$groupName"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat('[',normalize-space($groupName),']')"/>
            </xsl:otherwise>
        </xsl:choose> 
    </xsl:template>

    <xsl:template name="taskPopulationOrGroupLinks">
       <xsl:param name="delimitedGroupNames"/>
       <xsl:param name="delimiter" select="','"/>
       <xsl:variable name="groupName" select="normalize-space(substring-before(concat($delimitedGroupNames, $delimiter), $delimiter))" />
        <xsl:if test="$groupName">
            <li>
                <xsl:call-template name="taskPopulationOrGroupLink">
                    <xsl:with-param name="groupName" select="$groupName"/>
                </xsl:call-template>
            </li>
        </xsl:if>
        <xsl:if test="contains($delimitedGroupNames, $delimiter)">
            <!-- recursive call -->
            <xsl:call-template name="taskPopulationOrGroupLinks">
                <xsl:with-param name="delimitedGroupNames" select="substring-after($delimitedGroupNames, $delimiter)"/>
                <xsl:with-param name="delimiter" select="$delimiter"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="processTaskDefinitions">
		<!--
			The ImportAction is a KOGIT trick with a custom merge class. Supporting this here for code review.
		-->
        <xsl:if
            test="document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='documentTasks']/@value='true' and ( /sailpoint/TaskDefinition[not(@template='true' or @type='GridReport' or @type='Report' or @type='LiveReport' or @type='Certification' or @type='RoleMining' or @executor='sailpoint.task.RoleMiningTask')] | /sailpoint/ImportAction[@name='execute']/TaskDefinition[not(@template='true' or @type='GridReport' or @type='Report' or @type='LiveReport' or @type='Certification' or @type='RoleMining' or @executor='sailpoint.task.RoleMiningTask')] )">
            <a name="Heading-TaskDefinitions" />
            <h1>Task Definitions</h1>
            <a name="TaskDefinition -- Summary" />
            <h2>Summary</h2>
            <table class="mapTable">
                <tr>
                    <th class="rowHeader">Total number of tasks</th>
                    <td>
                        <xsl:value-of
                            select="count(/sailpoint/TaskDefinition[not(@template='true' or @type='GridReport' or @type='Report' or @type='LiveReport' or @type='Certification' or @type='RoleMining' or @executor='sailpoint.task.RoleMiningTask')] | /sailpoint/ImportAction[@name='execute']/TaskDefinition[not(@template='true' or @type='GridReport' or @type='Report' or @type='LiveReport' or @type='Certification' or @type='RoleMining' or @executor='sailpoint.task.RoleMiningTask')])" />
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
                        <xsl:value-of select="count(/sailpoint/TaskDefinition[not(@template='true') and Parent/Reference/@name='Sequential Task Launcher'] | /sailpoint/ImportAction[@name='execute']/TaskDefinition[not(@template='true') and Parent/Reference/@name='Sequential Task Launcher'])" />
                    </td>
                </tr>
                <tr>
                    <th class="rowHeader">Sequential task launcher tasks</th>
                    <td>
                        <xsl:if test="count(/sailpoint/TaskDefinition[not(@template='true') and Parent/Reference/@name='Sequential Task Launcher'] | /sailpoint/ImportAction[@name='execute']/TaskDefinition[not(@template='true') and Parent/Reference/@name='Sequential Task Launcher']) &gt; 0">
                            <ul>
                                <xsl:for-each select="/sailpoint/TaskDefinition[not(@template='true') and Parent/Reference/@name='Sequential Task Launcher'] | /sailpoint/ImportAction[@name='execute']/TaskDefinition[not(@template='true') and Parent/Reference/@name='Sequential Task Launcher']">
                                    <li>
                                        <xsl:call-template name="taskDefinitionReferenceLink">
                                            <xsl:with-param name="taskDefinitionName">
                                                <xsl:value-of select="@name" />
                                            </xsl:with-param>
                                        </xsl:call-template>
                                    </li>
                                </xsl:for-each>
                            </ul>
                        </xsl:if>
                    </td>
                </tr>
            </table>
            <xsl:if test="/sailpoint/TaskSchedule[CronExpressions]">
                <a name="TaskDefinition -- SummaryTaskSchedules" />
                <h2>Task Schedules</h2>
                <table class="mapTable">
                    <tr>
                        <th>Schedule Name</th>
                        <th>Task Name</th>
                        <th>Schedule</th>
                        <th>Average Runtime</th>
                    </tr>
                    <xsl:for-each select="/sailpoint/TaskSchedule[CronExpressions]">
                        <xsl:variable name="executorName" select="Arguments/Map/entry[@key='executor']/@value" />
                        <tr>
                            <td>
                                <xsl:value-of select="@name" />
                            </td>
                            <td>
                                <xsl:call-template name="taskDefinitionReferenceLink">
                                    <xsl:with-param name="taskDefinitionName">
                                        <xsl:value-of select="$executorName" />
                                    </xsl:with-param>
                                </xsl:call-template>
                            </td>
                            <td>
                                <xsl:for-each select="CronExpressions/String">
                                    <xsl:call-template name="describeCronExpression">
                                        <xsl:with-param name="cronExpression" select="./text()" />
                                    </xsl:call-template>
                                </xsl:for-each>
                            </td>
                            <td>
                                <xsl:if test="//TaskDefinition[@name=$executorName]/Attributes/Map/entry[@key='TaskDefinition.runLengthAverage']">
                                    <xsl:call-template name="formatDurationSeconds">
                                        <xsl:with-param name="s">
                                            <xsl:value-of select="//TaskDefinition[@name=$executorName]/Attributes/Map/entry[@key='TaskDefinition.runLengthAverage']/@value" />
                                        </xsl:with-param>
                                    </xsl:call-template>
                                </xsl:if>
                            </td>
                        </tr>
                    </xsl:for-each>
                </table>
            </xsl:if>
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
                    <xsl:if test="Attributes/Map/entry[@key='TaskDefinition.runLengthAverage']">
                        <tr>
                            <th class="rowHeader">Average Duration</th>
                            <td>
                                <xsl:call-template name="formatDurationSeconds">
                                    <xsl:with-param name="s">
                                        <xsl:value-of select="Attributes/Map/entry[@key='TaskDefinition.runLengthAverage']/@value" />
                                    </xsl:with-param>
                                </xsl:call-template>
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
                        <tr>
                            <th class="rowHeader">Filter string to constrain the identities refreshed</th>
                            <td>
                                <xsl:if test="Attributes/Map/entry[@key='filter']/@value">
                                    <xsl:value-of select="Attributes/Map/entry[@key='filter']/@value" />
                                </xsl:if>
                            </td>
                        </tr>
                        <tr>
                            <th class="rowHeader">List of group or population names to constrain the identities refreshed</th>
                            <td>
                                <xsl:if test="Attributes/Map/entry[@key='filterGroups']">
                                    <xsl:if test="Attributes/Map/entry[@key='filterGroups']/@value">
                                        <!-- split delimited string, link to population or group definition -->
                                        <ul>
                                            <xsl:call-template name="taskPopulationOrGroupLinks">
                                                <xsl:with-param name="delimitedGroupNames" select="Attributes/Map/entry[@key='filterGroups']/@value"/> 
                                                <xsl:with-param name="delimiter" select="','"/>
                                            </xsl:call-template>
                                        </ul>
                                    </xsl:if>
                                    <xsl:if test="Attributes/Map/entry[@key='filterGroups']/value/List/String">
                                        <ul>
                                            <xsl:for-each select="Attributes/Map/entry[@key='filterGroups']/value/List/String/text()">
                                                <li>
                                                    <xsl:variable name="groupName" select="normalize-space(.)"/>
                                                    <xsl:call-template name="taskPopulationOrGroupLink">
                                                        <xsl:with-param name="groupName" select="'Active Employees'"/>
                                                    </xsl:call-template>    
                                                </li>
                                            </xsl:for-each>
                                        </ul>
                                    </xsl:if>
                                    <!--
                                        <xsl:value-of select="Attributes/Map/entry[@key='filterGroups']/@value | Attributes/Map/entry[@key='filterGroups']/value/List/String" />
                                    -->
                                </xsl:if>
                            </td>
                        </tr>
                        <tr>
                            <th class="rowHeader">Refresh identities whose last refresh date is before this date</th>
                            <td>
                                <xsl:if test="Attributes/Map/entry[@key='thresholdDate']">
                                    <xsl:value-of select="Attributes/Map/entry[@key='thresholdDate']/@value | Attributes/Map/entry[@key='thresholdDate']/value" />
                                </xsl:if>
                            </td>
                        </tr>
                        <tr>
                            <th class="rowHeader">Refresh identities whose last refresh date is at least this number of hours ago</th>
                            <td>
                                <xsl:if test="Attributes/Map/entry[@key='excludeWindow']">
                                    <xsl:value-of select="Attributes/Map/entry[@key='excludeWindow']/@value | Attributes/Map/entry[@key='excludeWindow']/value" />
                                </xsl:if>
                            </td>
                        </tr>
                        <tr>
                            <th class="rowHeader">Refresh identities whose last refresh date is within this number of hours</th>
                            <td>
                                <xsl:if test="Attributes/Map/entry[@key='includeWindow']">
                                    <xsl:value-of select="Attributes/Map/entry[@key='includeWindow']/@value | Attributes/Map/entry[@key='includeWindow']/value" />
                                </xsl:if>
                            </td>
                        </tr>
                        <tr>
                            <th class="rowHeader">Include modified identities in the refresh date window</th>
                            <td>
                                <xsl:if test="Attributes/Map/entry[@key='includeWindowModified']">
                                    <xsl:call-template name="parseTextToBooleanIcon">
                                        <xsl:with-param name="boolVal" select="Attributes/Map/entry[@key='includeWindowModified']/@value | Attributes/Map/entry[@key='includeWindowModified']/value/Boolean" />
                                    </xsl:call-template>
                                </xsl:if>
                            </td>
                        </tr>
                        <tr>
                            <th class="rowHeader">Refresh only identities marked as needing refresh during aggregation (Delta Refresh)</th>
                            <td>
                                <xsl:if test="Attributes/Map/entry[@key='filterNeedsRefresh']">
                                    <xsl:call-template name="parseTextToBooleanIcon">
                                        <xsl:with-param name="boolVal" select="Attributes/Map/entry[@key='filterNeedsRefresh']/@value | Attributes/Map/entry[@key='filterNeedsRefresh']/value/Boolean" />
                                    </xsl:call-template>
                                </xsl:if>
                            </td>
                        </tr>
                        <tr>
                            <th class="rowHeader">Do not reset the needing refresh marker after refresh</th>
                            <td>
                                <xsl:if test="Attributes/Map/entry[@key='noResetNeedsRefresh']">
                                    <xsl:call-template name="parseTextToBooleanIcon">
                                        <xsl:with-param name="boolVal" select="Attributes/Map/entry[@key='noResetNeedsRefresh']/@value | Attributes/Map/entry[@key='noResetNeedsRefresh']/value/Boolean" />
                                    </xsl:call-template>
                                </xsl:if>
                            </td>
                        </tr>
                        <tr>
                            <th class="rowHeader">Exclude identities marked inactive</th>
                            <td>
                                <xsl:if test="Attributes/Map/entry[@key='excludeInactive']">
                                    <xsl:call-template name="parseTextToBooleanIcon">
                                        <xsl:with-param name="boolVal" select="Attributes/Map/entry[@key='excludeInactive']/@value | Attributes/Map/entry[@key='excludeInactive']/value/Boolean" />
                                    </xsl:call-template>
                                </xsl:if>
                            </td>
                        </tr>
                        <!-- Refresh identity attributes -->
                        <tr>
                            <th class="rowHeader">Refresh identity attributes</th>
                            <td>
                                <xsl:if test="Attributes/Map/entry[@key='promoteAttributes']">
                                    <xsl:call-template name="parseTextToBooleanIcon">
                                        <xsl:with-param name="boolVal" select="Attributes/Map/entry[@key='promoteAttributes']/@value | Attributes/Map/entry[@key='promoteAttributes']/value/Boolean" />
                                    </xsl:call-template>
                                </xsl:if>
                            </td>
                        </tr>
                        <!-- Refresh Identity Entitlements for all links -->
                        <tr>
                            <th class="rowHeader">Refresh Identity Entitlements for all links</th>
                            <td>
                                <xsl:if test="Attributes/Map/entry[@key='refreshIdentityEntitlements']">
                                    <xsl:call-template name="parseTextToBooleanIcon">
                                        <xsl:with-param name="boolVal" select="Attributes/Map/entry[@key='refreshIdentityEntitlements']/@value | Attributes/Map/entry[@key='refreshIdentityEntitlements']/value/Boolean" />
                                    </xsl:call-template>
                                </xsl:if>
                            </td>
                        </tr>
                        <!-- Refresh manager status -->
                        <tr>
                            <th class="rowHeader">Refresh manager status</th>
                            <td>
                                <xsl:if test="Attributes/Map/entry[@key='refreshManagerStatus']">
                                    <xsl:call-template name="parseTextToBooleanIcon">
                                        <xsl:with-param name="boolVal" select="Attributes/Map/entry[@key='refreshManagerStatus']/@value | Attributes/Map/entry[@key='refreshManagerStatus']/value/Boolean" />
                                    </xsl:call-template>
                                </xsl:if>
                            </td>
                        </tr>
                        <!-- Refresh assigned, detected roles and promote additional entitlements -->
                        <tr>
                            <th class="rowHeader">Refresh assigned, detected roles and promote additional entitlements</th>
                            <td>
                                <xsl:if test="Attributes/Map/entry[@key='correlateEntitlements']">
                                    <xsl:call-template name="parseTextToBooleanIcon">
                                        <xsl:with-param name="boolVal" select="Attributes/Map/entry[@key='correlateEntitlements']/@value | Attributes/Map/entry[@key='correlateEntitlements']/value/Boolean" />
                                    </xsl:call-template>
                                </xsl:if>
                            </td>
                        </tr>
                        <!-- Provision assignments -->
                        <tr>
                            <th class="rowHeader">Provision assignments</th>
                            <td>
                                <xsl:if test="Attributes/Map/entry[@key='provision']">
                                    <xsl:call-template name="parseTextToBooleanIcon">
                                        <xsl:with-param name="boolVal" select="Attributes/Map/entry[@key='provision']/@value | Attributes/Map/entry[@key='provision']/value/Boolean" />
                                    </xsl:call-template>
                                </xsl:if>
                            </td>
                        </tr>
                        <!-- Disable deprovisioning of deassigned roles -->
                        <tr>
                            <th class="rowHeader">Disable deprovisioning of deassigned roles</th>
                            <td>
                                <xsl:if test="Attributes/Map/entry[@key='noRoleDeprovisioning']">
                                    <xsl:call-template name="parseTextToBooleanIcon">
                                        <xsl:with-param name="boolVal" select="Attributes/Map/entry[@key='noRoleDeprovisioning']/@value | Attributes/Map/entry[@key='noRoleDeprovisioning']/value/Boolean" />
                                    </xsl:call-template>
                                </xsl:if>
                            </td>
                        </tr>
                        <!-- Refresh role metadata for each identity -->
                        <tr>
                            <th class="rowHeader">Refresh role metadata for each identity</th>
                            <td>
                                <xsl:if test="Attributes/Map/entry[@key='refreshRoleMetadata']">
                                    <xsl:call-template name="parseTextToBooleanIcon">
                                        <xsl:with-param name="boolVal" select="Attributes/Map/entry[@key='refreshRoleMetadata']/@value | Attributes/Map/entry[@key='refreshRoleMetadata']/value/Boolean" />
                                    </xsl:call-template>
                                </xsl:if>
                            </td>
                        </tr>
                        <!-- Enable manual account selection -->
                        <tr>
                            <th class="rowHeader">Enable manual account selection</th>
                            <td>
                                <xsl:if test="Attributes/Map/entry[@key='enableManualAccountSelection']">
                                    <xsl:call-template name="parseTextToBooleanIcon">
                                        <xsl:with-param name="boolVal" select="Attributes/Map/entry[@key='enableManualAccountSelection']/@value | Attributes/Map/entry[@key='enableManualAccountSelection']/value/Boolean" />
                                    </xsl:call-template>
                                </xsl:if>
                            </td>
                        </tr>
                        <!-- Synchronize attributes -->
                        <tr>
                            <th class="rowHeader">Synchronize attributes</th>
                            <td>
                                <xsl:if test="Attributes/Map/entry[@key='synchronizeAttributes']">
                                    <xsl:call-template name="parseTextToBooleanIcon">
                                        <xsl:with-param name="boolVal" select="Attributes/Map/entry[@key='synchronizeAttributes']/@value | Attributes/Map/entry[@key='synchronizeAttributes']/value/Boolean" />
                                    </xsl:call-template>
                                </xsl:if>
                            </td>
                        </tr>
                        <!-- Refresh the identity risk scorecards -->
                        <tr>
                            <th class="rowHeader">Refresh the identity risk scorecards</th>
                            <td>
                                <xsl:if test="Attributes/Map/entry[@key='refreshScorecard']">
                                    <xsl:call-template name="parseTextToBooleanIcon">
                                        <xsl:with-param name="boolVal" select="Attributes/Map/entry[@key='refreshScorecard']/@value | Attributes/Map/entry[@key='refreshScorecard']/value/Boolean" />
                                    </xsl:call-template>
                                </xsl:if>
                            </td>
                        </tr>
                        <!-- Maintain identity histories -->
                        <tr>
                            <th class="rowHeader">Maintain identity histories</th>
                            <td>
                                <xsl:if test="Attributes/Map/entry[@key='checkHistory']">
                                    <xsl:call-template name="parseTextToBooleanIcon">
                                        <xsl:with-param name="boolVal" select="Attributes/Map/entry[@key='checkHistory']/@value | Attributes/Map/entry[@key='checkHistory']/value/Boolean" />
                                    </xsl:call-template>
                                </xsl:if>
                            </td>
                        </tr>
                        <!-- Refresh the group scorecards -->
                        <tr>
                            <th class="rowHeader">Refresh the group scorecards</th>
                            <td>
                                <xsl:if test="Attributes/Map/entry[@key='refreshGroups']">
                                    <xsl:call-template name="parseTextToBooleanIcon">
                                        <xsl:with-param name="boolVal" select="Attributes/Map/entry[@key='refreshGroups']/@value | Attributes/Map/entry[@key='refreshGroups']/value/Boolean" />
                                    </xsl:call-template>
                                </xsl:if>
                            </td>
                        </tr>
                        <!-- Clean up groups definitions that are no longer referenced -->
                        <tr>
                            <th class="rowHeader">Clean up groups definitions that are no longer referenced</th>
                            <td>
                                <xsl:if test="Attributes/Map/entry[@key='deleteDormantGroups']">
                                    <xsl:call-template name="parseTextToBooleanIcon">
                                        <xsl:with-param name="boolVal" select="Attributes/Map/entry[@key='deleteDormantGroups']/@value | Attributes/Map/entry[@key='deleteDormantGroups']/value/Boolean" />
                                    </xsl:call-template>
                                </xsl:if>
                            </td>
                        </tr>
                        <!-- Check active policies -->
                        <tr>
                            <th class="rowHeader">Check active policies</th>
                            <td>
                                <xsl:if test="Attributes/Map/entry[@key='checkPolicies']">
                                    <xsl:call-template name="parseTextToBooleanIcon">
                                        <xsl:with-param name="boolVal" select="Attributes/Map/entry[@key='checkPolicies']/@value | Attributes/Map/entry[@key='checkPolicies']/value/Boolean" />
                                    </xsl:call-template>
                                </xsl:if>
                            </td>
                        </tr>
                        <!-- Keep previous violations -->
                        <tr>
                            <th class="rowHeader">Keep previous violations</th>
                            <td>
                                <xsl:if test="Attributes/Map/entry[@key='keepInactiveViolations']">
                                    <xsl:call-template name="parseTextToBooleanIcon">
                                        <xsl:with-param name="boolVal" select="Attributes/Map/entry[@key='keepInactiveViolations']/@value | Attributes/Map/entry[@key='keepInactiveViolations']/value/Boolean" />
                                    </xsl:call-template>
                                </xsl:if>
                            </td>
                        </tr>
                        <!-- A comma separated list of specific policy names. When set, this overrides the default policies. -->
                        <tr>
                            <th class="rowHeader">A comma separated list of specific policy names. When set, this overrides the default policies</th>
                            <td>
                                <xsl:if test="Attributes/Map/entry[@key='policies']/@value">
                                    <xsl:value-of select="Attributes/Map/entry[@key='policies']/@value" />
                                </xsl:if>
                            </td>
                        </tr>
                        <!-- Refresh assigned scope -->
                        <tr>
                            <th class="rowHeader">Refresh assigned scope</th>
                            <td>
                                <xsl:if test="Attributes/Map/entry[@key='correlateScope']">
                                    <xsl:call-template name="parseTextToBooleanIcon">
                                        <xsl:with-param name="boolVal" select="Attributes/Map/entry[@key='correlateScope']/@value | Attributes/Map/entry[@key='correlateScope']/value/Boolean" />
                                    </xsl:call-template>
                                </xsl:if>
                            </td>
                        </tr>
                        <!-- Disable auto creation of scopes -->
                        <tr>
                            <th class="rowHeader">Disable auto creation of scopes</th>
                            <td>
                                <xsl:if test="Attributes/Map/entry[@key='noAutoCreateScopes']">
                                    <xsl:call-template name="parseTextToBooleanIcon">
                                        <xsl:with-param name="boolVal" select="Attributes/Map/entry[@key='noAutoCreateScopes']/@value | Attributes/Map/entry[@key='noAutoCreateScopes']/value/Boolean" />
                                    </xsl:call-template>
                                </xsl:if>
                            </td>
                        </tr>
                        <!-- Mark dormant scopes after refresh -->
                        <tr>
                            <th class="rowHeader">Mark dormant scopes after refresh</th>
                            <td>
                                <xsl:if test="Attributes/Map/entry[@key='markDormantScopes']">
                                    <xsl:call-template name="parseTextToBooleanIcon">
                                        <xsl:with-param name="boolVal" select="Attributes/Map/entry[@key='markDormantScopes']/@value | Attributes/Map/entry[@key='markDormantScopes']/value/Boolean" />
                                    </xsl:call-template>
                                </xsl:if>
                            </td>
                        </tr>
                        <!-- Process events -->
                        <tr>
                            <th class="rowHeader">Process events</th>
                            <td>
                                <xsl:if test="Attributes/Map/entry[@key='processTriggers']">
                                    <xsl:call-template name="parseTextToBooleanIcon">
                                        <xsl:with-param name="boolVal" select="Attributes/Map/entry[@key='processTriggers']/@value | Attributes/Map/entry[@key='processTriggers']/value/Boolean" />
                                    </xsl:call-template>
                                </xsl:if>
                            </td>
                        </tr>
                        <!-- Disable Identity Processing Threshold -->
                        <tr>
                            <th class="rowHeader">Disable Identity Processing Threshold</th>
                            <td>
                                <xsl:if test="Attributes/Map/entry[@key='disableIdentityProcessingThreshold']">
                                    <xsl:call-template name="parseTextToBooleanIcon">
                                        <xsl:with-param name="boolVal" select="Attributes/Map/entry[@key='disableIdentityProcessingThreshold']/@value | Attributes/Map/entry[@key='disableIdentityProcessingThreshold']/value/Boolean" />
                                    </xsl:call-template>
                                </xsl:if>
                            </td>
                        </tr>
                        <!-- Refresh logical application links -->
                        <tr>
                            <th class="rowHeader">Refresh logical application links</th>
                            <td>
                                <xsl:if test="Attributes/Map/entry[@key='refreshCompositeApplications']">
                                    <xsl:call-template name="parseTextToBooleanIcon">
                                        <xsl:with-param name="boolVal" select="Attributes/Map/entry[@key='refreshCompositeApplications']/@value | Attributes/Map/entry[@key='refreshCompositeApplications']/value/Boolean" />
                                    </xsl:call-template>
                                </xsl:if>
                            </td>
                        </tr>
                        <!-- Promote managed attributes -->
                        <tr>
                            <th class="rowHeader">Promote managed attributes</th>
                            <td>
                                <xsl:if test="Attributes/Map/entry[@key='promoteManagedAttributes']">
                                    <xsl:call-template name="parseTextToBooleanIcon">
                                        <xsl:with-param name="boolVal" select="Attributes/Map/entry[@key='promoteManagedAttributes']/@value | Attributes/Map/entry[@key='promoteManagedAttributes']/value/Boolean" />
                                    </xsl:call-template>
                                </xsl:if>
                            </td>
                        </tr>
                        <!-- Number of Refresh Threads -->
                        <tr>
                            <th class="rowHeader">Number of Refresh Threads</th>
                            <td>
                                <xsl:if test="Attributes/Map/entry[@key='refreshThreads']/@value">
                                    <xsl:value-of select="Attributes/Map/entry[@key='refreshThreads']/@value" />
                                </xsl:if>
                            </td>
                        </tr>
                        <!-- Always launch the workflow (even if the usual triggers do not apply) -->
                        <tr>
                            <th class="rowHeader">Always launch the workflow (even if the usual triggers do not apply)</th>
                            <td>
                                <xsl:if test="Attributes/Map/entry[@key='forceWorkflow']">
                                    <xsl:call-template name="parseTextToBooleanIcon">
                                        <xsl:with-param name="boolVal" select="Attributes/Map/entry[@key='forceWorkflow']/@value | Attributes/Map/entry[@key='forceWorkflow']/value/Boolean" />
                                    </xsl:call-template>
                                </xsl:if>
                            </td>
                        </tr>
                        <!-- refreshWorkflow -->
                        <xsl:if test="Attributes/Map/entry[@key='refreshWorkflow']">
                            <tr>
                                <th class="rowHeader">Refresh Workflow</th>
                                <td>
                                    <xsl:call-template name="workflowReferenceLink">
                                        <xsl:with-param name="workflowName" select="Attributes/Map/entry[@key='refreshWorkflow']/@value" />
                                    </xsl:call-template>
                                </td>
                            </tr>
                        </xsl:if>
                        <!-- Enable the generation of work items for unmanaged parts of the provisioning plan. -->
                        <tr>
                            <th class="rowHeader">Enable the generation of work items for unmanaged parts of the provisioning plan</th>
                            <td>
                                <xsl:if test="Attributes/Map/entry[@key='doManualActions']">
                                    <xsl:call-template name="parseTextToBooleanIcon">
                                        <xsl:with-param name="boolVal" select="Attributes/Map/entry[@key='doManualActions']/@value | Attributes/Map/entry[@key='doManualActions']/value/Boolean" />
                                    </xsl:call-template>
                                </xsl:if>
                            </td>
                        </tr>
                        <!-- Disable connector lookup of managers that do not correlate -->
                        <tr>
                            <th class="rowHeader">Disable connector lookup of managers that do not correlate</th>
                            <td>
                                <xsl:if test="Attributes/Map/entry[@key='disableManagerLookup']">
                                    <xsl:call-template name="parseTextToBooleanIcon">
                                        <xsl:with-param name="boolVal" select="Attributes/Map/entry[@key='disableManagerLookup']/@value | Attributes/Map/entry[@key='disableManagerLookup']/value/Boolean" />
                                    </xsl:call-template>
                                </xsl:if>
                            </td>
                        </tr>
                        <!-- Enable partitioning -->
                        <tr>
                            <th class="rowHeader">Enable partitioning</th>
                            <td>
                                <xsl:if test="Attributes/Map/entry[@key='enablePartitioning']">
                                    <xsl:call-template name="parseTextToBooleanIcon">
                                        <xsl:with-param name="boolVal" select="Attributes/Map/entry[@key='enablePartitioning']/@value | Attributes/Map/entry[@key='enablePartitioning']/value/Boolean" />
                                    </xsl:call-template>
                                </xsl:if>
                            </td>
                        </tr>
                        <!-- Number of partitions -->
                        <tr>
                            <th class="rowHeader">Number of partitions</th>
                            <td>
                                <xsl:if test="Attributes/Map/entry[@key='partitions']/@value">
                                    <xsl:value-of select="Attributes/Map/entry[@key='partitions']/@value" />
                                </xsl:if>
                            </td>
                        </tr>
                        <!-- Loss Limit -->
                        <tr>
                            <th class="rowHeader">Loss Limit</th>
                            <td>
                                <xsl:if test="Attributes/Map/entry[@key='lossLimit']/@value">
                                    <xsl:value-of select="Attributes/Map/entry[@key='lossLimit']/@value" />
                                </xsl:if>
                            </td>
                        </tr>
                        <!-- Do not schedule retry requests during application maintenance windows -->
                        <tr>
                            <th class="rowHeader">Do not schedule retry requests during application maintenance windows</th>
                            <td>
                                <xsl:if test="Attributes/Map/entry[@key='noMaintenanceWindowRetry']">
                                    <xsl:call-template name="parseTextToBooleanIcon">
                                        <xsl:with-param name="boolVal" select="Attributes/Map/entry[@key='noMaintenanceWindowRetry']/@value | Attributes/Map/entry[@key='noMaintenanceWindowRetry']/value/Boolean" />
                                    </xsl:call-template>
                                </xsl:if>
                            </td>
                        </tr>
                        <!-- preRefreshRule -->
                        <xsl:if test="Attributes/Map/entry[@key='preRefreshRule']">
                            <tr>
                                <th class="rowHeader">Pre-Refresh Rule</th>
                                <td>
                                    <xsl:call-template name="ruleReferenceLink">
                                        <xsl:with-param name="ruleName" select="Attributes/Map/entry[@key='preRefreshRule']/@value" />
                                    </xsl:call-template>
                                </td>
                            </tr>
                        </xsl:if>
                        <!-- refreshRule -->
                        <xsl:if test="Attributes/Map/entry[@key='refreshRule']">
                            <tr>
                                <th class="rowHeader">Refresh Rule</th>
                                <td>
                                    <xsl:call-template name="ruleReferenceLink">
                                        <xsl:with-param name="ruleName" select="Attributes/Map/entry[@key='refreshRule']/@value" />
                                    </xsl:call-template>
                                </td>
                            </tr>
                        </xsl:if>
                    </xsl:if>
                    <!-- Account Aggregation -->
                    <xsl:if test="Parent/Reference/@name='Account Aggregation'">
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
                                    <xsl:call-template name="parseTextToBooleanIcon">
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
                                    <xsl:call-template name="parseTextToBooleanIcon">
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
                                    <xsl:call-template name="parseTextToBooleanIcon">
                                        <xsl:with-param name="boolVal" select="Attributes/Map/entry[@key='enablePartitioning']/@value" />
                                    </xsl:call-template>
                                </td>
                            </tr>
                        </xsl:if>
                        <xsl:if test="Attributes/Map/entry[@key='deltaAggregation']">
                            <tr>
                                <th class="rowHeader">Delta Aggregation</th>
                                <td>
                                    <xsl:call-template name="parseTextToBooleanIcon">
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