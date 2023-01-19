<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output omit-xml-declaration="yes" indent="yes" method="html" />

	<xsl:template name="emailTemplateReferenceLink">
		<xsl:param name="emailTemplateName"/>
		<xsl:choose>
			<xsl:when test="//EmailTemplate[@name=$emailTemplateName]">
				<a>
					<xsl:attribute name="href">
						<xsl:value-of select="concat('#EmailTemplate - ', $emailTemplateName)"/>
					</xsl:attribute>
					<xsl:value-of select="$emailTemplateName"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
					<xsl:value-of select="$emailTemplateName"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="processEmailTemplates">
		<xsl:if test="/sailpoint/EmailTemplate">
			<a name="Heading-EmailTemplates"/>
			<h1>Email Templates</h1>
			<xsl:for-each select="//EmailTemplate">
                <xsl:sort select="@name"/>
				<a>
				<xsl:attribute name="name">
	                <xsl:value-of select="concat('EmailTemplate - ', @name)" />
				</xsl:attribute>
				</a>
				<h2><xsl:value-of select="@name"/></h2>
				<xsl:if test="Description">
					<p><b>Description:</b><table class="description"><tr><td><pre class="description"><xsl:value-of select="Description"/></pre></td></tr></table></p>
				</xsl:if>

				<xsl:if test="@subject|@to|@cc|@bcc">
					<h3>Email Header Fields</h3>
					<table class="emailTemplateFieldsTable">
						<xsl:if test="@subject">
							<tr>
								<td><b>Subject:</b></td>
								<td><xsl:value-of select="@subject"/></td>
							</tr>
						</xsl:if>
						<xsl:if test="@to">
							<tr>
								<td><b>To:</b></td>
								<td><xsl:value-of select="@to"/></td>
							</tr>
						</xsl:if>
						<xsl:if test="@cc">
							<tr>
								<td><b>Cc:</b></td>
								<td><xsl:value-of select="@cc"/></td>
							</tr>
						</xsl:if>
						<xsl:if test="@bcc">
							<tr>
								<td><b>Bcc:</b></td>
								<td><xsl:value-of select="@bcc"/></td>
							</tr>
						</xsl:if>
					</table>
				</xsl:if>

				<!--  Signature -->
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

				<!-- Body -->
				<xsl:if test="Body">
					<h3>Body</h3>
					<table>
						<tr>
							<td class="sourceCode"><pre><xsl:copy-of select="Body/node()"/></pre></td>
						</tr>
					</table>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
