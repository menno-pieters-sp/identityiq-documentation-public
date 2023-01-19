<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output omit-xml-declaration="yes" indent="yes" method="html" />

	<xsl:template name="formReferenceLink">
		<xsl:param name="formName"/>
		<xsl:choose>
			<xsl:when test="//Form[@name=$formName]">
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="concat('#Form - ', $formName)"/>
					</xsl:attribute>
					<xsl:value-of select="$formName"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$formName"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="processDefaultValue" match="DefaultValue">
		<xsl:if test="node()">
			<xsl:for-each select="node()">
				<xsl:choose>
					<xsl:when test="name() = 'List'">
						<ul>
							<xsl:for-each select="node()">
								<li><xsl:value-of select="text()"/></li>
							</xsl:for-each>
						</ul>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="text()"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>

	<xsl:template name="processAllowedValues" match="//AllowedValues">
		<xsl:if test="node()">
			<ul>
				<xsl:for-each select="node()">
					<li>
						<xsl:choose>
							<xsl:when test="name() = 'List'">
								<xsl:choose>
									<xsl:when test="count(node()) &gt; 1">
										<xsl:value-of select="node()[2]/text()"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="text()"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="text()"/>
							</xsl:otherwise>
						</xsl:choose>
					</li>
				</xsl:for-each>
			</ul>
		</xsl:if>
	</xsl:template>

	<xsl:template name="processAllowedValuesDefinition" match="//AllowedValuesDefinition">
		<xsl:choose>
			<xsl:when test="Value">
				<xsl:choose>
					<xsl:when test="Value/List">
						<ul>
							<xsl:choose>
								<xsl:when test="Value/List/List/String">
									<xsl:for-each select="Value/List/List">
										<li>
											<xsl:value-of select="concat(String[1], ' (', String[2], ')')"/>
										</li>
									</xsl:for-each>
								</xsl:when>
								<xsl:otherwise>
									<xsl:for-each select="Value/List/node()">
										<li><xsl:value-of select="."/></li>
									</xsl:for-each>
								</xsl:otherwise>
							</xsl:choose>
						</ul>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="Value/text()"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:when test="Script">
				<p><b>Script: </b></p>
				<xsl:for-each select="Script">
					<xsl:call-template name="processScript"/>
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="RuleRef">
				<p><b>Rule: </b></p>
				<xsl:for-each select="RuleRef">
					<xsl:call-template name="ruleReferenceLink">
						<xsl:with-param name="ruleName" select="@name"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="processFormButton" match="//Form/Section/Button | //Form/Button">
		<tr>
			<th colspan="2"><xsl:value-of select="concat('Button ', @name|@label)"/></th>
		</tr>
		<xsl:if test="@action">
			<tr>
				<td><b>Action</b></td>
				<td><xsl:value-of select="@action"/></td>
			</tr>
		</xsl:if>
		<xsl:if test="@label">
			<tr>
				<td><b>Label</b></td>
				<td><xsl:value-of select="@label"/></td>
			</tr>
		</xsl:if>
		<xsl:if test="@value">
			<tr>
				<td><b>Value</b></td>
				<td><xsl:value-of select="@value"/></td>
			</tr>
		</xsl:if>
		<xsl:if test="@readOnly">
			<tr>
				<td><b>Read-Only</b></td>
				<td><xsl:value-of select="@readOnly"/></td>
			</tr>
		</xsl:if>
		<xsl:if test="@parameter">
			<tr>
				<td><b>Parameter</b></td>
				<td><xsl:value-of select="@parameter"/></td>
			</tr>
		</xsl:if>
		<xsl:if test="@skipValidation">
			<tr>
				<td><b>Skip Validation</b></td>
				<td><xsl:value-of select="@skipValidation"/></td>
			</tr>
		</xsl:if>
	</xsl:template>

	<xsl:template name="processFormField" match="//Form/Section/Field | //Form/Field | //Templates/Template/Field">
		<tr>
			<th colspan="2"><xsl:value-of select="concat('Field ', @displayName|@name)"/></th>
		</tr>
		<xsl:if test="@name">
			<tr>
				<td><b>Name</b></td>
				<td><xsl:value-of select="@name"/></td>
			</tr>
		</xsl:if>
		<xsl:if test="@displayName">
			<tr>
				<td><b>Display Name</b></td>
				<td><xsl:value-of select="@displayName"/></td>
			</tr>
		</xsl:if>
		<xsl:if test="Description">
			<tr>
				<td><b>Description</b></td>
				<td><xsl:value-of select="Description/text()"/></td>
			</tr>
		</xsl:if>
		<xsl:if test="@categoryName">
			<tr>
				<td><b>Category</b></td>
				<td><xsl:value-of select="@categoryName"/></td>
			</tr>
		</xsl:if>
		<xsl:if test="@type">
			<tr>
				<td><b>Type</b></td>
				<td><xsl:value-of select="@type"/></td>
			</tr>
		</xsl:if>
		<xsl:if test="@displayType">
			<tr>
				<td><b>Display Type</b></td>
				<td><xsl:value-of select="@displayType"/></td>
			</tr>
		</xsl:if>
		<xsl:if test="@priority">
			<tr>
				<td><b>Priority</b></td>
				<td><xsl:value-of select="@priority"/></td>
			</tr>
		</xsl:if>
		<!-- Type Settings -->
		<xsl:if test="@multi|@multiValued">
			<tr>
				<td><b>Multi-Valued</b></td>
				<td><xsl:value-of select="@multi|@multiValued"/></td>
			</tr>
		</xsl:if>
		<xsl:if test="@required">
			<tr>
				<td><b>Required</b></td>
				<td><xsl:value-of select="@required"/></td>
			</tr>
		</xsl:if>
		<xsl:if test="@postBack">
			<tr>
				<td><b>Refresh on Change</b></td>
				<td><xsl:value-of select="@postBack"/></td>
			</tr>
		</xsl:if>
		<xsl:if test="@reviewRequired">
			<tr>
				<td><b>Review Required</b></td>
				<td><xsl:value-of select="@reviewRequired"/></td>
			</tr>
		</xsl:if>
		<xsl:if test="@authoritative">
			<tr>
				<td><b>Authoritative</b></td>
				<td><xsl:value-of select="@authoritative"/></td>
			</tr>
		</xsl:if>
		<xsl:if test="@displayOnly">
			<tr>
				<td><b>Display Only</b></td>
				<td><xsl:value-of select="@displayOnly"/></td>
			</tr>
		</xsl:if>
		<!-- Value -->
		<xsl:if test="@dynamic">
			<tr>
				<td><b>Dynamic</b></td>
				<td><xsl:value-of select="@dynamic"/></td>
			</tr>
		</xsl:if>
	  <xsl:if test="@value|Value|RuleRef|Script|AppDependency">
			<tr>
				<td><b>Value</b></td>
				<td>
					<xsl:choose>
						<xsl:when test="@value">
							<xsl:call-template name="processScriptlet">
								<xsl:with-param name="scriptlet" select="@value"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="Value">
							<xsl:value-of select="Value/text()"/>
						</xsl:when>
						<xsl:when test="Script">
							<p><b>Script: </b></p>
							<xsl:for-each select="Script">
								<xsl:call-template name="processScript"/>
							</xsl:for-each>
						</xsl:when>
						<xsl:when test="RuleRef">
							<p><b>Rule: </b></p>
							<xsl:for-each select="RuleRef">
								<xsl:call-template name="ruleReferenceLink">
									<xsl:with-param name="ruleName" select="@name"/>
								</xsl:call-template>
							</xsl:for-each>
						</xsl:when>
						<xsl:when test="AppDependency">
							<p><b>Application Dependency</b></p>
							<table class="mapTable">
								<tr>
									<th class="mapTable">Application</th>
									<th class="mapTable">Attribute</th>
								</tr>
								<tr>
									<td class="mapTable">
										<xsl:call-template name="applicationReferenceLink">
											<xsl:with-param name="applicationName" select="AppDependency/@applicationName"/>
										</xsl:call-template>
									</td>
									<td class="mapTable">
										<xsl:value-of select="AppDependency/@schemaAttributeName"/>
									</td>
								</tr>
							</table>
						</xsl:when>
					</xsl:choose>
				</td>
			</tr>
		</xsl:if>
		<xsl:if test="AllowedValues|AllowedValuesDefinition">
			<tr>
				<td><b>Allowed Values</b></td>
				<td>
					<xsl:choose>
						<xsl:when test="AllowedValues">
							<ul>
								<xsl:for-each select="node()">
									<li>
										<xsl:choose>
											<xsl:when test="local-name() = 'List'">
												<!-- combination of value and display value, pick display value only -->
												<xsl:value-of select="node()[2]"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="text()"/>
											</xsl:otherwise>
										</xsl:choose>
									</li>
								</xsl:for-each>
							</ul>
						</xsl:when>
						<xsl:when test="AllowedValuesDefinition">
							<xsl:for-each select="AllowedValuesDefinition">
								<xsl:call-template name="processAllowedValuesDefinition"/>
							</xsl:for-each>
						</xsl:when>
					</xsl:choose>
				</td>
			</tr>
		</xsl:if>
		<xsl:if test="ValidationScript|ValidationRule">
			<tr>
				<xsl:choose>
					<xsl:when test="ValidationScript">
						<td><b>Validation Script</b></td>
						<td>
							<xsl:for-each select="ValidationScript">
								<xsl:call-template name="processScript"/>
							</xsl:for-each>
						</td>
					</xsl:when>
					<xsl:when test="ValidationRule">
						<td><b>Validation Rule</b></td>
						<td>
							<xsl:for-each select="ValidationRule">
								<xsl:call-template name="ruleReferenceLink">
									<xsl:with-param name="ruleName" select="@name"/>
								</xsl:call-template>
							</xsl:for-each>
						</td>
					</xsl:when>
				</xsl:choose>
			</tr>
		</xsl:if>
	</xsl:template>

	<xsl:template name="processFormSection" match="//Form/Section">
		<xsl:if test="FormRef">
			<p><b>Form References</b></p>
			<ul>
				<xsl:for-each select="FormRef">
					<li>
						<xsl:call-template name="formReferenceLink">
							<xsl:with-param name="formName" select="@name"/>
						</xsl:call-template>
					</li>
				</xsl:for-each>
			</ul>
		</xsl:if>
		<tr>
			<th colspan="2"><xsl:value-of select="concat('Section ', @name)"/></th>
		</tr>
		<xsl:if test="@label">
			<tr>
				<td><b>Label</b></td>
				<td><xsl:value-of select="@label"/></td>
			</tr>
		</xsl:if>
		<xsl:if test="Attributes/Map/entry[@key='subtitle']/value">
			<tr>
				<td><b>Subtitle</b></td>
				<td><xsl:value-of select="Attributes/Map/entry[@key='subtitle']/value"/></td>
			</tr>
		</xsl:if>
		<xsl:if test="@type">
			<tr>
				<td><b>Type</b></td>
				<td><xsl:value-of select="@type"/></td>
			</tr>
		</xsl:if>
		<xsl:if test="@priority">
			<tr>
				<td><b>Priority</b></td>
				<td><xsl:value-of select="@priority"/></td>
			</tr>
		</xsl:if>
		<xsl:if test="@columns">
			<tr>
				<td><b>Columns</b></td>
				<td><xsl:value-of select="@columns"/></td>
			</tr>
		</xsl:if>
		<xsl:if test="Attributes/Map/entry[@key='readOnly']">
			<tr>
				<td><b>Read-Only</b></td>
				<td>
					<xsl:choose>
						<xsl:when test="Attributes/Map/entry[@key='readOnly']/@value">
							<xsl:call-template name="processScriptlet">
								<xsl:with-param name="scriptlet" select="Attributes/Map/entry[@key='readOnly']/@value"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="Attributes/Map/entry[@key='readOnly']/value/String">
							<xsl:value-of select="Attributes/Map/entry[@key='readOnly']/value/String/text()"/>
						</xsl:when>
						<xsl:when test="Attributes/Map/entry[@key='readOnly']/value/Boolean">
							<xsl:value-of select="Attributes/Map/entry[@key='readOnly']/value/Boolean/text() | 'false'"/>
						</xsl:when>
						<xsl:when test="Attributes/Map/entry[@key='readOnly']/value/Script">
							<p>Script:</p>
							<xsl:for-each select="Attributes/Map/entry[@key='readOnly']/value/Script">
								<xsl:call-template name="processScript"/>
							</xsl:for-each>
						</xsl:when>
					</xsl:choose>
				</td>
			</tr>
		</xsl:if>
		<xsl:if test="Attributes/Map/entry[@key='hideNulls']">
			<tr>
				<td><b>Hide Nulls</b></td>
				<td>
					<xsl:choose>
						<xsl:when test="Attributes/Map/entry[@key='hideNulls']/@value">
							<xsl:call-template name="processScriptlet">
								<xsl:with-param name="scriptlet" select="Attributes/Map/entry[@key='hideNulls']/@value"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="Attributes/Map/entry[@key='hideNulls']/value/String">
							<xsl:value-of select="Attributes/Map/entry[@key='hideNulls']/value/String/text()"/>
						</xsl:when>
						<xsl:when test="Attributes/Map/entry[@key='hideNulls']/value/Boolean">
							<xsl:value-of select="Attributes/Map/entry[@key='hideNulls']/value/Boolean/text() | 'false'"/>
						</xsl:when>
						<xsl:when test="Attributes/Map/entry[@key='hideNulls']/value/Script">
							<p>Script:</p>
							<xsl:for-each select="Attributes/Map/entry[@key='hideNulls']/value/Script">
								<xsl:call-template name="processScript"/>
							</xsl:for-each>
						</xsl:when>
					</xsl:choose>
				</td>
			</tr>
		</xsl:if>
		<xsl:if test="Attributes/Map/entry[@key='hidden']">
			<tr>
				<td><b>Hidden</b></td>
				<td>
					<xsl:choose>
						<xsl:when test="Attributes/Map/entry[@key='hidden']/@value">
							<xsl:call-template name="processScriptlet">
								<xsl:with-param name="scriptlet" select="Attributes/Map/entry[@key='hidden']/@value"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="Attributes/Map/entry[@key='hidden']/value/String">
							<xsl:value-of select="Attributes/Map/entry[@key='hidden']/value/String/text()"/>
						</xsl:when>
						<xsl:when test="Attributes/Map/entry[@key='hidden']/value/Boolean">
							<xsl:value-of select="Attributes/Map/entry[@key='hidden']/value/Boolean/text() | 'false'"/>
						</xsl:when>
						<xsl:when test="Attributes/Map/entry[@key='hidden']/value/Script">
							<p>Script:</p>
							<xsl:for-each select="Attributes/Map/entry[@key='hidden']/value/Script">
								<xsl:call-template name="processScript"/>
							</xsl:for-each>
						</xsl:when>
					</xsl:choose>
				</td>
			</tr>
		</xsl:if>
		<xsl:if test="Field">
			<tr>
				<td><b>Fields</b></td>
				<td>
					<table class="formFieldsTable">
						<xsl:for-each select="Field">
							<xsl:call-template name="processFormField"/>
						</xsl:for-each>
					</table>
				</td>
			</tr>
		</xsl:if>
		<xsl:if test="Button">
			<tr>
				<td><b>Buttons</b></td>
				<td>
					<table class="formFieldsTable">
						<xsl:for-each select="Button">
							<xsl:call-template name="processFormButton"/>
						</xsl:for-each>
					</table>
				</td>
			</tr>
		</xsl:if>
	</xsl:template>

	<xsl:template name="processSingleForm" match="//Form">
		<table>
			<tr>
				<th class="rowHeader">Name</th>
				<td><xsl:value-of select="@name"/></td>
			</tr>
			<tr>
				<th class="rowHeader">Type</th>
				<td><xsl:value-of select="@type"/></td>
			</tr>
			<tr>
				<th class="rowHeader">Owner</th>
				<td>
					<xsl:call-template name="workgroupOrIdentityLink">
						<xsl:with-param name="identityName" select="Owner/Reference/@name"/>
					</xsl:call-template>
				</td>
			</tr>
			<tr>
				<th class="rowHeader">Hidden</th>
				<td><xsl:value-of select="@hidden"/></td>
			</tr>
			<xsl:if test="@targetUser">
				<tr>
					<th class="rowHeader">Target User</th>
					<td><xsl:value-of select="@targetUser"/></td>
				</tr>
			</xsl:if>
			<xsl:if test="@objectType">
				<tr>
					<th class="rowHeader">Object Type</th>
					<td><xsl:value-of select="@objectType"/></td>
				</tr>
			</xsl:if>
			<xsl:if test="Attributes/Map/entry[@key='pageTitle']">
				<tr>
					<th class="rowHeader">Page Title</th>
					<td><xsl:value-of select="Attributes/Map/entry[@key='pageTitle']/@value | Attributes/Map/entry[@key='pageTitle']/value/text()"/></td>
				</tr>
			</xsl:if>
		</table>

		<xsl:if test="FormRef">
			<p><b>Form References</b></p>
			<ul>
				<xsl:for-each select="FormRef">
					<li>
						<xsl:call-template name="formReferenceLink">
							<xsl:with-param name="formName" select="@name"/>
						</xsl:call-template>
					</li>
				</xsl:for-each>
			</ul>
		</xsl:if>

		<p><b>Form Contents</b></p>
		<table class="FormTable">
			<xsl:for-each select="Section">
				<xsl:call-template name="processFormSection"/>
			</xsl:for-each>
			<xsl:for-each select="Field">
				<xsl:call-template name="processFormField"/>
			</xsl:for-each>
			<xsl:for-each select="Button">
				<xsl:call-template name="processFormButton"/>
			</xsl:for-each>
		</table>

	</xsl:template>

	<xsl:template name="processForms">
		<xsl:if test="/sailpoint/Form">
			<a name="Heading-Forms"/>
			<h1>Forms</h1>
			<xsl:for-each select="/sailpoint/Form">
                <xsl:sort select="@name"/>
				<a>
					<xsl:attribute name="name">
						<xsl:value-of select="concat('Form - ', @name)" />
					</xsl:attribute>
				</a>
				<h2>
					<xsl:value-of select="@name" />
				</h2>
				<xsl:call-template name="processSingleForm"/>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
