<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:opts="http://options.data">
	<xsl:output omit-xml-declaration="yes" indent="yes" />

	<xsl:template name="processAttributeRequest" match="//AttributeRequest">
		<tr>
			<td><xsl:value-of select="@name"/></td>
			<td><xsl:value-of select="@op"/></td>
			<td>
				<xsl:choose>
					<xsl:when test="@value">
						<xsl:value-of select="@value"/>
					</xsl:when>
					<xsl:when test="Value">
						<xsl:choose>
							<xsl:when test="Value/List">
								<ul>
									<xsl:for-each select="Value/List">
										<li>
											<xsl:value-of select="."/>
										</li>
									</xsl:for-each>
								</ul>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="value/text()" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
				</xsl:choose>
			</td>
		</tr>
	</xsl:template>

	<xsl:template name="processProvisioningPlan" match="//ProvisioningPlan">
    <xsl:if test="AccountRequest">
			<table class="accountRequestTable">
				<tr>
					<th colspan="2">Account Request</th>
				</tr>
				<xsl:for-each select="AccountRequest">
					<tr>
						<td><b>Application</b></td>
						<td><xsl:value-of select="@application"/></td>
					</tr>
					<xsl:if test="@targetIntegration">
						<tr>
							<td><b>Target Integration</b></td>
							<td><xsl:value-of select="@targetIntegration"/></td>
						</tr>
					</xsl:if>
					<xsl:if test="@nativeIdentity">
						<tr>
							<td><b>Account Name</b></td>
							<td><xsl:value-of select="@nativeIdentity"/></td>
						</tr>
					</xsl:if>
					<xsl:if test="@instance">
						<tr>
							<td><b>Instance</b></td>
							<td><xsl:value-of select="@instance"/></td>
						</tr>
					</xsl:if>
					<xsl:if test="@op">
						<tr>
							<td><b>Operation</b></td>
							<td><xsl:value-of select="@op"/></td>
						</tr>
					</xsl:if>
					<xsl:if test="AttributeRequest">
						<tr>
							<td><b>Attributes</b></td>
							<td>
								<table class="attributeRequestTable">
									<tr>
										<th>Attribute</th>
										<th>Operation</th>
										<th>Value</th>
									</tr>
									<xsl:for-each select="AttributeRequest">
										<xsl:call-template name="processAttributeRequest"/>
									</xsl:for-each>
								</table>
							</td>
						</tr>
					</xsl:if>
				</xsl:for-each>
			</table>
		</xsl:if>

		<!-- Object Request: groups -->
    <xsl:if test="ObjectRequest">
			<table class="objectRequestTable">
				<tr>
					<th colspan="2">Object Request</th>
				</tr>
				<tr>
					<td><b>Application</b></td>
					<td><xsl:value-of select="@application"/></td>
				</tr>
				<xsl:if test="@targetIntegration">
					<tr>
						<td><b>Target Integration</b></td>
						<td><xsl:value-of select="@targetIntegration"/></td>
					</tr>
				</xsl:if>
				<xsl:if test="@nativeIdentity">
					<tr>
						<td><b>Account Name</b></td>
						<td><xsl:value-of select="@nativeIdentity"/></td>
					</tr>
				</xsl:if>
				<xsl:if test="@instance">
					<tr>
						<td><b>Instance</b></td>
						<td><xsl:value-of select="@instance"/></td>
					</tr>
				</xsl:if>
				<xsl:if test="@op">
					<tr>
						<td><b>Operation</b></td>
						<td><xsl:value-of select="@op"/></td>
					</tr>
				</xsl:if>
				<xsl:if test="AttributeRequest">
					<tr>
						<td><b>Attributes</b></td>
						<td>
							<table class="attributeRequestTable">
								<tr>
									<th>Attribute</th>
									<th>Operation</th>
									<th>Value</th>
								</tr>
								<xsl:for-each select="AttributeRequest">
									<xsl:call-template name="processAttributeRequest"/>
								</xsl:for-each>
							</table>
						</td>
					</tr>
				</xsl:if>
			</table>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
