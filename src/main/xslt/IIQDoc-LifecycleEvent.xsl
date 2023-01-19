<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:iiqdoc="http://iiqdoc.config.data">
	<xsl:output omit-xml-declaration="yes" indent="yes" />

	<xsl:template name="lifecycleEventReferenceLink">
		<xsl:param name="lifecycleEventName"/>
		<xsl:choose>
			<xsl:when test="/sailpoint/IdentityTrigger[@handler='sailpoint.api.WorkflowTriggerHandler' or @handler='sailpoint.api.AsynchronousWorkflowTriggerHandler'] and @name=$lifecycleEventName">
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="concat('#LifecycleEvent - ', @lifecycleEventName)"/>
					</xsl:attribute>
					<xsl:value-of select="lifecycleEventName"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$lifecycleEventName"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="processLifecycleEvents">
		<xsl:if test="/sailpoint/IdentityTrigger[@handler='sailpoint.api.WorkflowTriggerHandler' or @handler='sailpoint.api.AsynchronousWorkflowTriggerHandler']">
			<a name="Heading-LifecycleEvents"/>
			<h1>Lifecycle Events</h1>

			<xsl:for-each select="/sailpoint/IdentityTrigger[@handler='sailpoint.api.WorkflowTriggerHandler' or @handler='sailpoint.api.AsynchronousWorkflowTriggerHandler']">
                <xsl:sort select="@name"/>
				<xsl:variable name="lifecycleEventName"><xsl:value-of select="@name"/></xsl:variable>
				<a>
					<xsl:attribute name="name">
						<xsl:value-of select="concat('LifecycleEvent - ', @name)"/>
					</xsl:attribute>
				</a>
				<h2><xsl:value-of select="@name"/></h2>
				<table class="lifecycleEventTable">
					<xsl:if test="Description">
						<tr>
							<th class="rowHeader">Description</th>
							<td><xsl:value-of select="Description/text()"/></td>
						</tr>
					</xsl:if>
					<tr>
						<th class="rowHeader">Type</th>
						<td><xsl:value-of select="@type"/></td>
					</tr>
					<tr>
						<th class="rowHeader">Disabled</th>
						<td>
							<xsl:call-template name="parseTextToBoolean">
								<xsl:with-param name="boolVal" select="@disabled"/>
							</xsl:call-template>
						</td>
					</tr>
					<xsl:if test="Owner">
						<tr>
							<th class="rowHeader">Owner</th>
							<td>
								<xsl:call-template name="workgroupOrIdentityLink">
									<xsl:with-param name="identityName" select="Owner/Reference/@name" />
								</xsl:call-template>
							</td>
						</tr>
					</xsl:if>
					<xsl:if test="TriggerRule/Reference">
						<tr>
							<th class="rowHeader">Rule</th>
							<td>
								<xsl:call-template name="ruleReferenceLink">
									<xsl:with-param name="ruleName" select="TriggerRule/Reference/@name" />
								</xsl:call-template>
							</td>
						</tr>
					</xsl:if>
					<xsl:if test="@attributeName">
						<tr>
							<th class="rowHeader">Attribute</th>
							<td><xsl:value-of select="@attributeName"/></td>
						</tr>
					</xsl:if>
					<xsl:if test="@oldValueFilter">
						<tr>
							<th class="rowHeader">Previous Value Filter</th>
							<td><xsl:value-of select="@oldValueFilter"/></td>
						</tr>
					</xsl:if>
					<xsl:if test="@newValueFilter">
						<tr>
							<th class="rowHeader">New Value Filter</th>
							<td><xsl:value-of select="@newValueFilter"/></td>
						</tr>
					</xsl:if>
					<xsl:if test="HandlerParameters/Attributes/Map/entry[@key='workflow']/@value">
						<tr>
							<th class="rowHeader">Business process</th>
							<td>
								<xsl:call-template name="workflowReferenceLink">
									<xsl:with-param name="workflowName" select="HandlerParameters/Attributes/Map/entry[@key='workflow']/@value"/>
								</xsl:call-template>
							</td>
						</tr>
					</xsl:if>
					<th class="rowHeader">Included Identities</th>
					<td>
						<xsl:choose>
							<xsl:when test="Selector/IdentitySelector">
								<xsl:for-each select="Selector/IdentitySelector">
									<xsl:call-template name="processSingleIdentitySelector" />
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise><xsl:text>All</xsl:text></xsl:otherwise>
						</xsl:choose>
					</td>
				</table>

			</xsl:for-each>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
