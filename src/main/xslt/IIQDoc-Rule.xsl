<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:iiqdoc="http://iiqdoc.config.data">
	<xsl:output omit-xml-declaration="yes" indent="yes" method="html" />

	<xsl:template name="ruleReferenceLink">
		<xsl:param name="ruleName"/>
		<xsl:choose>
			<xsl:when test="document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='documentRules']/@value='true' and //Rule[@name=$ruleName]">
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="concat('#Rule - ', $ruleName)"/>
					</xsl:attribute>
					<xsl:value-of select="$ruleName"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$ruleName"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="processScriptlet">
		<xsl:param name="scriptlet"/>
		<xsl:choose>
			<xsl:when test="starts-with($scriptlet, 'rule:')">
				<xsl:text>Rule: </xsl:text>
				<tt>
					<xsl:call-template name="ruleReferenceLink">
						<xsl:with-param name="ruleName" select="substring-after($scriptlet, 'rule:')"/>
					</xsl:call-template>
				</tt>
			</xsl:when>
			<xsl:when test="starts-with($scriptlet, 'script:')">
				<xsl:text>Script: </xsl:text><tt><xsl:value-of select="substring-after($scriptlet, 'script:')"/></tt>
			</xsl:when>
			<xsl:when test="starts-with($scriptlet, 'ref:')">
				<xsl:text>Referenced variable: </xsl:text><tt><xsl:value-of select="substring-after($scriptlet, 'ref:')"/></tt>
			</xsl:when>
			<xsl:when test="starts-with($scriptlet, 'call:')">
				<xsl:text>Library call: </xsl:text><tt><xsl:value-of select="substring-after($scriptlet, 'call:')"/></tt>
			</xsl:when>
			<xsl:when test="starts-with($scriptlet, 'string:')">
				<xsl:value-of select="substring-after($scriptlet, 'string:')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$scriptlet"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="processScript" match="//Script|//ValidationScript|//ConditionScript|//AfterScript|//InterceptorScript|//ModeScript|//OwnerScript//ValidatorScript">
		<xsl:if test="Includes/Reference">
			<p>Referenced Rules:</p>
			<ul>
				<xsl:for-each select="Includes/Reference">
					<xsl:call-template name="ruleReferenceLink">
						<xsl:with-param name="ruleName" select="@name"/>
					</xsl:call-template>
				</xsl:for-each>
			</ul>
		</xsl:if>
		<xsl:if test="Source">
			<table>
				<tr>
					<td class="sourceCode"><pre><xsl:copy-of select="Source/node()"/></pre></td>
				</tr>
			</table>
		</xsl:if>
	</xsl:template>

	<xsl:template name="processRules">
		<xsl:if test="/sailpoint/Rule">
			<a name="Heading-Rules"/>
			<h1>Rules</h1>
			<xsl:for-each select="/sailpoint/Rule">
                <xsl:sort select="@name"/>
				<a>
    			<xsl:attribute name="name">
	               <xsl:value-of select="concat('Rule - ', @name)" />
				</xsl:attribute>
				</a>
				<h2><xsl:value-of select="@name"/></h2>
				<p><b>Rule type:</b> <xsl:value-of select="@type"/></p>
				<xsl:if test="Description">
					<p><b>Description:</b><table class="description"><tr><td><pre class="description"><xsl:value-of select="Description"/></pre></td></tr></table></p>
				</xsl:if>
				<!-- Referenced Rules -->
				<xsl:if test="ReferencedRules/Reference">
					<h3>Referenced Rules</h3>
					<ul>
						<xsl:for-each select="ReferencedRules/Reference">
							<li>
								<xsl:call-template name="ruleReferenceLink">
									<xsl:with-param name="ruleName" select="@name"/>
								</xsl:call-template>
							</li>
						</xsl:for-each>
					</ul>
				</xsl:if>
				<xsl:if test="Signature">
					<h3>Signature</h3>
					<xsl:if test="Signature/@returnType"><p>Return type: <xsl:value-of select="Signature/@returnType"/></p></xsl:if>
					<xsl:if test="Signature/Inputs">
						<h4>Inputs</h4>
						<table>
							<tr>
								<th>Name</th><th>Type</th><th>Description</th>
							</tr>
							<xsl:for-each select="Signature/Inputs/Argument">
								<tr>
									<td><xsl:value-of select="@name"/></td>
									<td><xsl:value-of select="@type"/></td>
									<td><xsl:value-of select="Description"/></td>
								</tr>
							</xsl:for-each>
						</table>
					</xsl:if>
					<xsl:if test="Signature/Outputs">
						<h4>Outputs</h4>
						<table>
							<tr>
								<th>Name</th><th>Type</th><th>Description</th>
							</tr>
							<xsl:for-each select="Signature/Outputs/Argument">
								<tr>
									<td><xsl:value-of select="@name"/></td>
									<td><xsl:value-of select="@type"/></td>
									<td><xsl:value-of select="Description"/></td>
								</tr>
							</xsl:for-each>
						</table>
					</xsl:if>
				</xsl:if>
				<h4>Source</h4>
				<table>
					<tr>
						<td class="sourceCode"><pre><xsl:copy-of select="Source/node()"/></pre></td>
					</tr>
				</table>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
