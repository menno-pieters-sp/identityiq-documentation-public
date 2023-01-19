<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:filterOperations="http://filterOperations.data" >
	<xsl:output omit-xml-declaration="yes" indent="yes" method="html" />

	<filterOperations:operations>
		<filterOperations:operation name="EQ" description="equals" />
		<filterOperations:operation name="NE" description="is not equal to" />
		<filterOperations:operation name="LT" description="less than" />
		<filterOperations:operation name="LE" description="less than or equal to" />
		<filterOperations:operation name="GT" description="greater than" />
		<filterOperations:operation name="GE" description="greater than or equal to" />
		<filterOperations:operation name="IN" description="in list" />
		<filterOperations:operation name="CONTAINS_ALL" description="contains all" />
		<filterOperations:operation name="NOTNULL" description="is not null" />
		<filterOperations:operation name="ISNULL" description="is null" />
		<filterOperations:operation name="ISEMPTY" description="is empty" />
		<filterOperations:operation name="JOIN" description="join" />
		<filterOperations:operation name="COLLECTION_CONDITION" description="collection condition" />
		<filterOperations:operation name="LIKE:" description="like" />
		<filterOperations:operation name="LIKE:ANYWHERE" description="contains" />
		<filterOperations:operation name="LIKE:START" description="starts with" />
		<filterOperations:operation name="LIKE:END" description="ends with" />
		<filterOperations:operation name="LIKE:EXACT" description="is exactly" />
	</filterOperations:operations>

	<xsl:template name="translateFilterOperation">
  	<xsl:param name="op"/>
		<xsl:choose>
			<xsl:when test="document('IIQDoc-Filter.xsl')//filterOperations:operations/filterOperations:operation[@name=$op]">
				<xsl:value-of select="document('IIQDoc-Filter.xsl')//filterOperations:operations/filterOperations:operation[@name=$op]/@description"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$op"/>
			</xsl:otherwise>
		</xsl:choose>
  </xsl:template>

	<xsl:template name="printFilterOperation">
		<xsl:param name="operation" />
		<xsl:param name="matchMode" />
		<xsl:variable name="op">
			<xsl:choose>
				<xsl:when test="$operation = 'LIKE'">
					<xsl:value-of select="concat($operation, ':', $matchMode)" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$operation" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:call-template name="translateFilterOperation">
			<xsl:with-param name="op" select="$op"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="processCompositeFilter" match="//CompositeFilter">
		<xsl:param name="lookupManagedAttributeDescription" select="'false'"/>
		<xsl:param name="managedAttributeApplication"/>
		<table class="compositeFilterTable">
			<tr>
				<td>
					<xsl:call-template name="printFilterOperation">
						<xsl:with-param name="operation" select="@operation"/>
						<xsl:with-param name="matchMode" select="@matchMode"/>
					</xsl:call-template>
					<xsl:if test="@ignoreCase = 'true'">
						<xsl:text> [case insensitive]</xsl:text>
					</xsl:if>
				</td>
				<td>
					<xsl:for-each select="CompositeFilter|Filter">
						<xsl:if test="name(.) = 'CompositeFilter'">
							<xsl:call-template name="processCompositeFilter">
								<xsl:with-param name="lookupManagedAttributeDescription" select="$lookupManagedAttributeDescription"/>
								<xsl:with-param name="managedAttributeApplication" select="$managedAttributeApplication"/>
							</xsl:call-template>
						</xsl:if>
						<xsl:if test="name(.) = 'Filter'">
							<xsl:call-template name="processFilter">
								<xsl:with-param name="lookupManagedAttributeDescription" select="$lookupManagedAttributeDescription"/>
								<xsl:with-param name="managedAttributeApplication" select="$managedAttributeApplication"/>
							</xsl:call-template>
						</xsl:if>
					</xsl:for-each>
				</td>
			</tr>
		</table>
	</xsl:template>

	<xsl:template name="processFilter" match="//Filter">
		<xsl:param name="lookupManagedAttributeDescription" select="'false'"/>
		<xsl:param name="managedAttributeApplication"/>
		<xsl:variable name="property" select="@property" />
		<table>
			<tr>
				<td><xsl:value-of select="@property"/></td>
				<td>
					<xsl:call-template name="printFilterOperation">
						<xsl:with-param name="operation" select="@operation"/>
						<xsl:with-param name="matchMode" select="@matchMode"/>
					</xsl:call-template>
					<xsl:if test="@ignoreCase = 'true'">
						<xsl:text> [case insensitive]</xsl:text>
					</xsl:if>
				</td>
				<xsl:if test="@operation = 'EQ' or @operation = 'NE' or @operation = 'LT' or @operation = 'GT' or @operation = 'LE' or @operation = 'GE' or @operation = 'IN' or @operation = 'CONTAINS_ALL' or @operation = 'LIKE'">
					<td>
						<xsl:if test="@value">
							<xsl:choose>
								<xsl:when test="$lookupManagedAttributeDescription = 'true'">
									<xsl:call-template name="getManagedAttributeDisplayName">
										<xsl:with-param name="application" select="$managedAttributeApplication" />
										<xsl:with-param name="attribute" select="$property" />
										<xsl:with-param name="value" select="@value" />
									</xsl:call-template>
								</xsl:when>
								<xsl:otherwise>
							    <xsl:value-of select="@value"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
						<xsl:if test="Value">
							<xsl:choose>
								<xsl:when test="Value/List">
									<ul>
										<xsl:for-each select="Value/List/node()/text()">
											<li>
												<xsl:choose>
													<xsl:when test="$lookupManagedAttributeDescription = 'true'">
														<xsl:call-template name="getManagedAttributeDisplayName">
															<xsl:with-param name="application" select="$managedAttributeApplication" />
															<xsl:with-param name="attribute" select="$property" />
															<xsl:with-param name="value" select="." />
														</xsl:call-template>
													</xsl:when>
													<xsl:otherwise>
														<xsl:value-of select="."/>
													</xsl:otherwise>
												</xsl:choose>
											</li>
										</xsl:for-each>
									</ul>
								</xsl:when>
								<xsl:when test="Value/Boolean">
									<xsl:choose>
										<xsl:when test="Value/Boolean/text() = 'true'">
											<xsl:value-of select="Value/Boolean/text()"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>false</xsl:text>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:when>
								<xsl:otherwise>
									<xsl:choose>
										<xsl:when test="$lookupManagedAttributeDescription = 'true'">
											<xsl:call-template name="getManagedAttributeDisplayName">
												<xsl:with-param name="application" select="$managedAttributeApplication" />
												<xsl:with-param name="attribute" select="$property" />
												<xsl:with-param name="value" select="Value/text()" />
											</xsl:call-template>
										</xsl:when>
										<xsl:otherwise>
							    		<xsl:value-of select="Value/text()"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:if>
					</td>
				</xsl:if>
				<xsl:if test="@joinProperty">
					<td><b><xsl:text>Join Property: </xsl:text></b><xsl:value-of select="@joinProperty"/></td>
				</xsl:if>
				<xsl:if test="@subqueryClass">
					<td><b><xsl:text>Class: </xsl:text></b><xsl:value-of select="@subqueryClass"/></td>
				</xsl:if>
				<xsl:if test="@subqueryProperty">
					<td><b><xsl:text>Property: </xsl:text></b><xsl:value-of select="@subqueryProperty"/></td>
				</xsl:if>
				<xsl:if test="SubqueryFilter">
					<td>
						<xsl:for-each select="SubqueryFilter">
							<table class="subqueryFilterTable">
								<tr>
									<td>
										<xsl:for-each select="CompositeFilter|Filter">
											<xsl:if test="name(.) = 'CompositeFilter'">
												<xsl:call-template name="processCompositeFilter"/>
											</xsl:if>
											<xsl:if test="name(.) = 'Filter'">
												<xsl:call-template name="processFilter"/>
											</xsl:if>
										</xsl:for-each>
									</td>
								</tr>
							</table>
						</xsl:for-each>
					</td>
				</xsl:if>
				<xsl:if test="@subqueryClass">
					<td><b><xsl:text>Join Property: </xsl:text></b><xsl:value-of select="@joinProperty"/></td>
				</xsl:if>
				<xsl:if test="CollectionCondition">
					<td>
						<xsl:for-each select="CollectionCondition/CompositeFilter">
							<xsl:call-template name="processCompositeFilter"/>
						</xsl:for-each>
					</td>
				</xsl:if>
			</tr>
		</table>
	</xsl:template>

</xsl:stylesheet>
