<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ppopts="http://ppoptions.data">
	<xsl:output omit-xml-declaration="yes" indent="yes" />

	<xsl:template name="translatePasswordPolicyOptions">
  	<xsl:param name="option"/>
		<xsl:choose>
			<xsl:when test="document('IIQDoc-PasswordPolicy.xsl')//ppopts:options/ppopts:option[@name=$option]">
				<xsl:value-of select="document('IIQDoc-PasswordPolicy.xsl')//ppopts:options/ppopts:option[@name=$option]/@description"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$option"/>
			</xsl:otherwise>
		</xsl:choose>
  </xsl:template>

	<ppopts:options>
		<ppopts:option name="passwordMinLength" description="Minimum number of characters"/>
		<ppopts:option name="passwordMaxLength" description="Maximum number of characters"/>
		<ppopts:option name="checkCaseSensitive" description=" Case Sensitive Check"/>
		<ppopts:option name="checkPasswordAgainstAccountID" description="Validate passwords against account ID"/>
		<ppopts:option name="checkPasswordAgainstDisplayName" description="Validate passwords against the account's display name"/>
		<ppopts:option name="checkPasswordTriviality" description="Triviality check against old password "/>
		<ppopts:option name="checkPasswordsAgainstAccountAttributes" description="Validate passwords against the identity's account attributes"/>
		<ppopts:option name="checkPasswordsAgainstDictionary" description="Validate passwords against the password dictionary"/>
		<ppopts:option name="checkPasswordsAgainstIdentityAttributes" description="Validate passwords against the identity's list of attributes "/>
		<ppopts:option name="minAccountIDUniqueChars" description="Minimum word Length (Account)"/>
		<ppopts:option name="minDisplayNameUniqueChars" description="Minimum word Length (Display Name)"/>
		<ppopts:option name="minHistoryUniqueChars" description="Minimum number of characters by position"/>
		<ppopts:option name="passwordHistory" description="Password history length"/>
		<ppopts:option name="passwordMinAlpha" description="Minimum number of letters"/>
		<ppopts:option name="passwordMinCharType" description="Minimum number of character type constraints to meet"/>
		<ppopts:option name="passwordMinLower" description="Minimum lowercase letters"/>
		<ppopts:option name="passwordMinNumeric" description="Minimum number of digits"/>
		<ppopts:option name="passwordMinSpecial" description="Minimum special characters"/>
		<ppopts:option name="passwordMinUpper" description="Minimum uppercase letters"/>
		<ppopts:option name="passwordRepeatedChar" description="Number of repeated Characters allowed"/>
	</ppopts:options>

	<xsl:template name="processApplicationPasswordPolicies">
		<xsl:param name="policies"/>
		<h3>Password Policies</h3>
		<table class="passwordPolicyTable">
			<tr>
				<th>Policy</th>
				<th>Population</th>
				<xsl:if test="count(//PasswordPolicy) &gt; 0">
					<th>Rules</th>
				</xsl:if>
			</tr>
			<xsl:for-each select="$policies/PasswordPolicyHolder">
				<tr>
					<td>
						<xsl:value-of select="PolicyRef/Reference/@name" />
					</td>
					<td>
						<xsl:choose>
							<xsl:when test="string-length(Selector/IdentitySelector/PopulationRef/Reference/@name) &gt; 0">
								<b>Population:</b>
								<xsl:value-of select="Selector/IdentitySelector/PopulationRef/Reference/@name" />
							</xsl:when>
							<xsl:otherwise>
								All
							</xsl:otherwise>
						</xsl:choose>
					</td>
					<xsl:if test="count(//PasswordPolicy) &gt; 0">
						<td>
							<xsl:variable name="policyName" select="PolicyRef/Reference/@name" />
							<table class="passwordPolicyRulesTable">
								<xsl:for-each select="//PasswordPolicy[@name = $policyName]/PasswordConstraints/Map/entry">
									<tr>
										<td>
											<xsl:call-template name="translatePasswordPolicyOptions">
 												<xsl:with-param name="option" select="@key"/>
											</xsl:call-template>
										</td>
										<td>
											<xsl:choose>
												<xsl:when test="string-length(@value) &gt; 0">
													<xsl:value-of select="@value" />
												</xsl:when>
												<xsl:when test="count(value/Boolean) &gt; 0">
													<xsl:if test="value/Boolean = 'true'">
														&#9745;
													</xsl:if>
												</xsl:when>
												<xsl:when test="count(value/String) &gt; 0">
													<xsl:value-of select="value/String" />
												</xsl:when>
											</xsl:choose>
										</td>
									</tr>
								</xsl:for-each>
							</table>
						</td>
					</xsl:if>
				</tr>
 			</xsl:for-each>
		</table>
	</xsl:template>

</xsl:stylesheet>
