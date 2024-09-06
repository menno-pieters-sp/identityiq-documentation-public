<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output omit-xml-declaration="yes" indent="yes"/>

	<xsl:template name="processObjectConfigs">
		<xsl:if test="(/sailpoint/ImportAction[@name='execute' or @name='merge']/ObjectConfig or /sailpoint/ObjectConfig)">
			<xsl:variable name="objectConfigName" select="@name"/>
			<a name="Heading-ObjectConfig"/>
			<h1>Object Configuration</h1>
			<p>Below, the configurations for extended attributes are listed for supported object types.</p>
			<xsl:for-each select="/sailpoint/ImportAction[@name='execute' or @name='merge']/ObjectConfig | /sailpoint/ObjectConfig">
				<xsl:sort select="@name"/>
				<a>
					<xsl:attribute name="name">
						<xsl:value-of select="concat('ObjectConfig - ', @name)"/>
					</xsl:attribute>
				</a>
				<h2>
					<xsl:value-of select="concat('ObjectConfig - ', @name)"/>
				</h2>
				<h3>Statistics</h3>
				<table class="objectAttributeStatsTable">
					<tr>
						<th>Number of attributes</th><td><xsl:value-of select="count(ObjectAttribute)"/></td>
					</tr>
					<tr>
						<th>Number of standard attributes</th><td><xsl:value-of select="count(ObjectAttribute[@standard='true'])"/></td>
					</tr>
					<tr>
						<th>Number of system attributes</th><td><xsl:value-of select="count(ObjectAttribute[@system='true'])"/></td>
					</tr>
					<tr>
						<th>Number of silent attributes</th><td><xsl:value-of select="count(ObjectAttribute[@silent='true'])"/></td>
					</tr>
					<tr>
						<th>Number of custom attributes</th><td><xsl:value-of select="count(ObjectAttribute[not(@standard='true' or @system='true' or @silent='true')])"/></td>
					</tr>
					<tr>
						<th>Number of searchable attributes</th><td><xsl:value-of select="count(ObjectAttribute[boolean(@extendedNumber) or @namedColumn='true'])"/></td>
					</tr>
					<tr>
						<th>Number of Group Factory attributes</th><td><xsl:value-of select="count(ObjectAttribute[@groupFactory='true'])"/></td>
					</tr>
					<tr>
						<th>Number of editable attributes</th><td><xsl:value-of select="count(ObjectAttribute[not(@editMode='ReadOnly')])"/></td>
					</tr>
				</table>

				<xsl:if test="Attributes/Map/entry[@key='roleTypeDefinitions']/value/List/RoleTypeDefinition">
					<h3>Role Type Definitions</h3>
					<xsl:for-each select="Attributes/Map/entry[@key='roleTypeDefinitions']/value/List/RoleTypeDefinition">
						<h4><xsl:call-template name="localize"><xsl:with-param name="key" select="@displayName"/></xsl:call-template></h4>
						<xsl:if test="Description">
							<pre><xsl:value-of select="Description/text()"/></pre>
						</xsl:if>
						<table class="objectAttributeStatsTable">
							<tr> <th>Type Name</th><td><xsl:value-of select="@name"/></td> </tr>
							<tr> <th>Display Name</th><td><xsl:call-template name="localize"><xsl:with-param name="key" select="@displayName"/></xsl:call-template></td> </tr>
							<tr>
								<th>Allow inheritance of other roles</th>
								<td>
									<xsl:call-template name="parseTextToNotBoolean">
										<xsl:with-param name="boolVal" select="@noSupers" />
									</xsl:call-template>
								</td>
							</tr>
							<tr>
								<th>Allow other roles from inheriting this role</th>
								<td>
									<xsl:call-template name="parseTextToNotBoolean">
										<xsl:with-param name="boolVal" select="@noSubs" />
									</xsl:call-template>
								</td>
							</tr>
							<tr>
								<th>Allow automatic detection with profiles</th>
								<td>
									<xsl:call-template name="parseTextToNotBoolean">
										<xsl:with-param name="boolVal" select="@noDetection" />
									</xsl:call-template>
								</td>
							</tr>
							<tr>
								<th>Allow automatic detection with profiles only if assigned</th>
								<td>
									<xsl:call-template name="parseTextToNotBoolean">
										<xsl:with-param name="boolVal" select="@noDetectionUnlessAssigned" />
									</xsl:call-template>
								</td>
							</tr>
							<tr>
								<th>Allow entitlement profiles</th>
								<td>
									<xsl:call-template name="parseTextToNotBoolean">
										<xsl:with-param name="boolVal" select="@noProfiles" />
									</xsl:call-template>
								</td>
							</tr>
							<tr>
								<th>Allow automatic assignment with rule</th>
								<td>
									<xsl:call-template name="parseTextToNotBoolean">
										<xsl:with-param name="boolVal" select="@noAutoAssignment" />
									</xsl:call-template>
								</td>
							</tr>
							<tr>
								<th>Allow assignment rule</th>
								<td>
									<xsl:call-template name="parseTextToNotBoolean">
										<xsl:with-param name="boolVal" select="@noAssignmentSelector" />
									</xsl:call-template>
								</td>
							</tr>
							<tr>
								<th>Allow manual assignment</th>
								<td>
									<xsl:call-template name="parseTextToNotBoolean">
										<xsl:with-param name="boolVal" select="@noManualAssignment" />
									</xsl:call-template>
								</td>
							</tr>
							<tr>
								<th>Enable permitted roles list</th>
								<td>
									<xsl:call-template name="parseTextToNotBoolean">
										<xsl:with-param name="boolVal" select="@noPermits" />
									</xsl:call-template>
								</td>
							</tr>
							<tr>
								<th>Allow this role to be on a permitted roles list</th>
								<td>
									<xsl:call-template name="parseTextToNotBoolean">
										<xsl:with-param name="boolVal" select="@notPermittable" />
									</xsl:call-template>
								</td>
							</tr>
							<tr>
								<th>Enable required roles list</th>
								<td>
									<xsl:call-template name="parseTextToNotBoolean">
										<xsl:with-param name="boolVal" select="@noRequirements" />
									</xsl:call-template>
								</td>
							</tr>
							<tr>
								<th>Allow this role to be on a required roles list</th>
								<td>
									<xsl:call-template name="parseTextToNotBoolean">
										<xsl:with-param name="boolVal" select="@notRequired" />
									</xsl:call-template>
								</td>
							</tr>
							<tr>
								<th>Allow the Granting of IdentityIQ User Rights</th>
								<td>
									<xsl:call-template name="parseTextToNotBoolean">
										<xsl:with-param name="boolVal" select="@noIIQ" />
									</xsl:call-template>
								</td>
							</tr>
						</table>
					</xsl:for-each>
				</xsl:if>

				<h3>Extended Attributes</h3>
				<table class="objectAttributeTable">
					<tr>
						<th>Attribute</th>
						<th>Display Name</th>
						<th>Type</th>
						<th>EditMode</th>
						<th>Searchable</th>
						<th>Multi-Valued</th>
						<th>Group Factory</th>
						<th>Required</th>
					</tr>
					<xsl:for-each select="ObjectAttribute">
						<xsl:sort select="@name"/>
						<xsl:variable name="rowspanStr">1<xsl:if test="count(AttributeSource|RuleRef) &gt; 0">1</xsl:if><xsl:if test="count(AttributeTargets/AttributeTarget) &gt; 0">1</xsl:if></xsl:variable>
						<xsl:variable name="rowspan" select="string-length(translate(normalize-space($rowspanStr), ' ',''))"/>
						<xsl:if test="not(@silent = 'true' or @system = 'true')">
							<tr>
								<td class="property">
									<xsl:attribute name="rowspan"><xsl:value-of select="$rowspan"/></xsl:attribute>
									<xsl:value-of select="@name"/>
								</td>
								<td>
									<xsl:call-template name="localize"><xsl:with-param name="key" select="@displayName"/></xsl:call-template>
								</td>
								<td>
									<xsl:value-of select="@type"/>
								</td>
								<td>
									<xsl:value-of select="@editMode"/>
								</td>
								<td>
									<xsl:if test="string-length(@extendedNumber) &gt; 0 or @namedColumn = 'true'">Yes<xsl:if test="string-length(@extendedNumber) &gt; 0"><xsl:text> (</xsl:text><xsl:value-of select="@extendedNumber"/><xsl:text>)</xsl:text></xsl:if></xsl:if>
								</td>
								<td>
									<xsl:if test="multi = 'true'">Yes</xsl:if>
								</td>
								<td>
									<xsl:if test="@groupFactory = 'true'">Yes</xsl:if>
								</td>
								<td>
									<xsl:if test="@required = 'true'">Yes</xsl:if>
								</td>
							</tr>
							<xsl:if test="count(AttributeSource|RuleRef) &gt; 0">
								<tr>
									<td>
										<b>Sources</b>
									</td>
									<td colspan="7">
										<table style="border-style: none; border-width: 0px;" cols="3">
											<xsl:for-each select="AttributeSource|RuleRef">
												<tr>
													<xsl:choose>
														<xsl:when test="local-name() = 'AttributeSource' and count(RuleRef) = 1 and count(ApplicationRef) = 1">
															<td class="attributeSource">
																<b>Application Rule</b>
															</td>
															<td class="attributeSource">
																<xsl:call-template name="applicationReferenceLink">
																	<xsl:with-param name="applicationName" select="ApplicationRef/Reference/@name"/>
																</xsl:call-template>
															</td>
															<td class="attributeSource">
																<tt>
																	<xsl:call-template name="ruleReferenceLink">
																		<xsl:with-param name="ruleName" select="RuleRef/Reference/@name"/>
																	</xsl:call-template>
																</tt>
															</td>
														</xsl:when>
                                                        <xsl:when test="local-name() = 'AttributeSource' and count(RuleRef) = 1 and count(ApplicationRef) = 0">
                                                            <td class="attributeSource">
                                                                <b>Global Rule</b>
                                                            </td>
															<td class="attributeSource" colspan="2">
                                                                <tt>
                                                                    <xsl:call-template name="ruleReferenceLink">
                                                                        <xsl:with-param name="ruleName" select="RuleRef/Reference/@name"/>
                                                                    </xsl:call-template>
                                                                </tt>
                                                            </td>
                                                        </xsl:when>
														<xsl:when test="local-name() = 'AttributeSource' and count(RuleRef) = 0">
															<td class="attributeSource">
																<b>Application Attribute</b>
															</td>
															<td class="attributeSource">
																<xsl:call-template name="applicationReferenceLink">
																	<xsl:with-param name="applicationName" select="ApplicationRef/Reference/@name"/>
																</xsl:call-template>
															</td>
															<td class="attributeSource">
																<tt><xsl:value-of select="@name"/></tt>
															</td>
														</xsl:when>
													</xsl:choose>
												</tr>
											</xsl:for-each>
										</table>
									</td>
								</tr>
							</xsl:if>
							<xsl:if test="count(AttributeTargets/AttributeTarget) &gt; 0">
								<tr>
									<td>
										<b>Targets</b>
									</td>
									<td colspan="6">
										<table style="border-style: none; border-width: 0px;" cols="4">
											<xsl:for-each select="AttributeTargets/AttributeTarget">
												<tr>
													<td class="attributeTarget">
														<xsl:call-template name="applicationReferenceLink">
															<xsl:with-param name="applicationName" select="ApplicationRef/Reference/@name"/>
														</xsl:call-template>
													</td>
													<td class="attributeTarget">
														<tt><xsl:value-of select="@name"/></tt>
													</td>
													<td class="attributeTarget">
														<tt>
															<xsl:call-template name="ruleReferenceLink">
																<xsl:with-param name="ruleName" select="RuleRef/Reference/@name"/>
															</xsl:call-template>
														</tt>
													</td>
													<td class="attributeTarget">
														<xsl:if test="@provisionAllAccounts='true'">All Accounts</xsl:if>
													</td>
												</tr>
											</xsl:for-each>
										</table>
									</td>
								</tr>
							</xsl:if>
						</xsl:if>
					</xsl:for-each>
				</table>

				<xsl:if test="//FullTextIndex[@name='BundleManagedAttribute'] and (@name='Bundle' or @name='ManagedAttribute') and ObjectAttribute[@extendedNumber or @namedColumn='true']">
				    <h4>Searchable Extended Attributes in FullTextIndex</h4>
					<p>If any of these attributes are used in a Request Object Selector Rule for a QuickLink Population, they must be present in the FullTextIndex, too.</p>
					<table class="objectAttributeTable">
						<tr>
							<th>Attribute</th>
							<th>Display Name</th>
							<th>Type</th>
							<th>Analyzed</th>
							<th>Indexed</th>
							<th>Stored</th>
						</tr>
						<xsl:for-each select="ObjectAttribute[extendedNumber or @namedColumn='true']">
							<xsl:sort select="name"/>
							<xsl:variable name="attributeName" select="@name"/>
							<xsl:choose>
								<xsl:when test="not(//FullTextIndex[@name='BundleManagedAttribute']/Attributes/Map/entry[@key='fields']/value/List/FullTextField[@name=$attributeName])">
									<tr>
										<td><xsl:value-of select="@name"/></td>
										<td><xsl:call-template name="localize"><xsl:with-param name="key" select="@displayName"/></xsl:call-template></td>
										<td><xsl:value-of select="@type"/></td>
										<td colspan="3"><xsl:text>&#9888; Not present in FullTextIndex</xsl:text></td>
									</tr>
								</xsl:when>
								<xsl:otherwise>
									<xsl:choose>
										<xsl:when test="@type='sailpoint.object.Identity'">
											<tr>
												<td><xsl:value-of select="concat(@name, '.name')"/></td>
												<td rowspan="2"><xsl:call-template name="localize"><xsl:with-param name="key" select="@displayName"/></xsl:call-template></td>
												<td rowspan="2"><xsl:value-of select="@type"/></td>
												<td>
													<xsl:call-template name="parseTextToBooleanIcon">
														<xsl:with-param name="boolVal" select="//FullTextIndex[@name='BundleManagedAttribute']/Attributes/Map/entry[@key='fields']/value/List/FullTextField[@name=$attributeName]/@analyzed"/>
													</xsl:call-template>
													<xsl:if test="not(//FullTextIndex[@name='BundleManagedAttribute']/Attributes/Map/entry[@key='fields']/value/List/FullTextField[@name=$attributeName]/@analyzed = 'true')">
														<xsl:text>&#9888;</xsl:text>
													</xsl:if>
												</td>
												<td>
													<xsl:call-template name="parseTextToBooleanIcon">
														<xsl:with-param name="boolVal" select="//FullTextIndex[@name='BundleManagedAttribute']/Attributes/Map/entry[@key='fields']/value/List/FullTextField[@name=$attributeName]/@indexed"/>
													</xsl:call-template>
													<xsl:if test="not(//FullTextIndex[@name='BundleManagedAttribute']/Attributes/Map/entry[@key='fields']/value/List/FullTextField[@name=$attributeName]/@indexed = 'true')">
														<xsl:text>&#9888;</xsl:text>
													</xsl:if>
												</td>
												<td>
													<xsl:call-template name="parseTextToBooleanIcon">
														<xsl:with-param name="boolVal" select="//FullTextIndex[@name='BundleManagedAttribute']/Attributes/Map/entry[@key='fields']/value/List/FullTextField[@name=$attributeName]/@stored"/>
													</xsl:call-template>
												</td>
											</tr>
											<tr>
												<td><xsl:value-of select="concat(@name, '.id')"/></td>
												<td>
													<xsl:call-template name="parseTextToBooleanIcon">
														<xsl:with-param name="boolVal" select="//FullTextIndex[@name='BundleManagedAttribute']/Attributes/Map/entry[@key='fields']/value/List/FullTextField[@name=$attributeName]/@analyzed"/>
													</xsl:call-template>
													<xsl:if test="not(//FullTextIndex[@name='BundleManagedAttribute']/Attributes/Map/entry[@key='fields']/value/List/FullTextField[@name=$attributeName]/@analyzed = 'true')">
														<xsl:text>&#9888;</xsl:text>
													</xsl:if>
												</td>
												<td>
													<xsl:call-template name="parseTextToBooleanIcon">
														<xsl:with-param name="boolVal" select="//FullTextIndex[@name='BundleManagedAttribute']/Attributes/Map/entry[@key='fields']/value/List/FullTextField[@name=$attributeName]/@indexed"/>
													</xsl:call-template>
													<xsl:if test="not(//FullTextIndex[@name='BundleManagedAttribute']/Attributes/Map/entry[@key='fields']/value/List/FullTextField[@name=$attributeName]/@indexed = 'true')">
														<xsl:text>&#9888;</xsl:text>
													</xsl:if>
												</td>
												<td>
													<xsl:call-template name="parseTextToBooleanIcon">
														<xsl:with-param name="boolVal" select="//FullTextIndex[@name='BundleManagedAttribute']/Attributes/Map/entry[@key='fields']/value/List/FullTextField[@name=$attributeName]/@stored"/>
													</xsl:call-template>
												</td>
											</tr>
										</xsl:when>
										<xsl:otherwise>
											<tr>
												<td><xsl:value-of select="@name"/></td>
												<td><xsl:call-template name="localize"><xsl:with-param name="key" select="@displayName"/></xsl:call-template></td>
												<td><xsl:value-of select="@type"/></td>
												<td>
													<xsl:call-template name="parseTextToBooleanIcon">
														<xsl:with-param name="boolVal" select="//FullTextIndex[@name='BundleManagedAttribute']/Attributes/Map/entry[@key='fields']/value/List/FullTextField[@name=$attributeName]/@analyzed"/>
													</xsl:call-template>
													<xsl:if test="@type = 'string' and not(//FullTextIndex[@name='BundleManagedAttribute']/Attributes/Map/entry[@key='fields']/value/List/FullTextField[@name=$attributeName]/@analyzed = 'true')">
														<xsl:text>&#9888;</xsl:text>
													</xsl:if>
												</td>
												<td>
													<xsl:call-template name="parseTextToBooleanIcon">
														<xsl:with-param name="boolVal" select="//FullTextIndex[@name='BundleManagedAttribute']/Attributes/Map/entry[@key='fields']/value/List/FullTextField[@name=$attributeName]/@indexed"/>
													</xsl:call-template>
													<xsl:if test="not(//FullTextIndex[@name='BundleManagedAttribute']/Attributes/Map/entry[@key='fields']/value/List/FullTextField[@name=$attributeName]/@indexed = 'true')">
														<xsl:text>&#9888;</xsl:text>
													</xsl:if>
												</td>
												<td>
													<xsl:call-template name="parseTextToBooleanIcon">
														<xsl:with-param name="boolVal" select="//FullTextIndex[@name='BundleManagedAttribute']/Attributes/Map/entry[@key='fields']/value/List/FullTextField[@name=$attributeName]/@stored"/>
													</xsl:call-template>
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</table>
				</xsl:if>
				<hr/>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
