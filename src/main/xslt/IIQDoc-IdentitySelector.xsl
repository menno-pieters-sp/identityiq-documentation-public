<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output omit-xml-declaration="yes" indent="yes" />

	<xsl:template name="processMatchTerm" match="//MatchTerm">
		<tr>
			<xsl:choose>
				<xsl:when test="MatchTerm">
					<td colspan="1">
						<xsl:choose>
							<xsl:when test="@and = 'true'">
								<xsl:text>And</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>Or</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</td>
					<td colspan="2">
						<table columns="3">
							<xsl:for-each select="MatchTerm">
								<xsl:call-template name="processMatchTerm" />
							</xsl:for-each>
						</table>
					</td>
				</xsl:when>
				<xsl:otherwise>
					<td><xsl:value-of select="ApplicationRef/Reference/@name"/></td>
					<td><xsl:value-of select="@name"/></td>
					<td><xsl:value-of select="@value"/></td>
				</xsl:otherwise>
			</xsl:choose>
		</tr>
	</xsl:template>

	<xsl:template name="processMatchExpression" match="//MatchExpression">
		<table columns="3">
			<xsl:for-each select="MatchTerm">
				<xsl:call-template name="processMatchTerm" />
			</xsl:for-each>
		</table>
	</xsl:template>

	<xsl:template name="processCompoundFilter" match="//CompoundFilter" >
		<table columns="2">
			<xsl:if test="Applications/Reference">
				<tr>
					<th>Applications</th>
					<td>
						<ul>
							<xsl:for-each select="Applications/Reference">
								<li><xsl:value-of select="@name" /></li>
							</xsl:for-each>
						</ul>
					</td>
				</tr>
			</xsl:if>
			<tr>
				<td colspan="2">
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
				</td>
			</tr>
		</table>
	</xsl:template>

	<xsl:template name="processSingleIdentitySelector" match="//IdentitySelector">
		<xsl:choose>
			<xsl:when test="MatchExpression">
				<p><b>Match List</b></p>
				<xsl:for-each select="MatchExpression">
					<xsl:call-template name="processMatchExpression" />
				</xsl:for-each>
			</xsl:when>
			<xsl:when test="CompoundFilter">
				<p><b>Filter</b></p>
				<xsl:for-each select="CompoundFilter">
					<xsl:call-template name="processCompoundFilter" />
				</xsl:for-each>
				<pre>
				  <xsl:for-each select="CompoundFilter">
						<xsl:call-template name="nodeToText">
							<xsl:with-param name="indent" select="'  '" />
						</xsl:call-template>
					</xsl:for-each>
				</pre>
			</xsl:when>
			<xsl:when test="Script">
				<p><b>Script</b></p>
				<table>
					<tr>
						<td class="sourceCode"><pre><xsl:copy-of select="Script/Source/node()"/></pre></td>
					</tr>
				</table>
			</xsl:when>
			<xsl:when test="RuleRef">
				<p><b>Rule</b></p>
				<table>
					<tr>
						<td>
							<xsl:call-template name="ruleReferenceLink">
								<xsl:with-param name="ruleName">
									<xsl:value-of select="RuleRef/Reference/@name" />
								</xsl:with-param>
							</xsl:call-template>
						</td>
					</tr>
				</table>
			</xsl:when>
			<xsl:when test="PopulationRef">
				<p><b>Population</b></p>
				<xsl:call-template name="populationReferenceLink">
					<xsl:with-param name="populationName" select="PopulationRef/Reference/@name" />
					<xsl:with-param name="populationId" select="PopulationRef/Reference/@id" />
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<p><b>UNKNOWN SELECTOR</b></p>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
