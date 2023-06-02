<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output omit-xml-declaration="yes" indent="yes" />
    <xsl:template name="processSystemConfiguration">
        <xsl:if test="/sailpoint/Configuration[@name='SystemConfiguration'] or /sailpoint/ImportAction[@name='merge' or @name='execute']/Configuration[@name='SystemConfiguration']">
			<!-- This should be only 1 -->
            <a name="Heading-SystemConfiguration" />
            <h1>Configuration</h1>
            <h2>IdentityIQ Settings</h2>
            <h3>General</h3>
            <table>
                <tr>
                    <th>Option</th>
                    <th>Value</th>
                </tr>
                <tr>
                    <td>Default Language</td>
                    <td>
                        <xsl:call-template name="getConfigValue">
                            <xsl:with-param name="name" select="'defaultLanguage'" />
                        </xsl:call-template>
                    </td>
                </tr>
                <tr>
                    <td>Supported Languages</td>
                    <td>
                        <xsl:call-template name="getConfigStringBulletList">
                            <xsl:with-param name="name" select="'supportedLanguages'" />
                        </xsl:call-template>
                    </td>
                </tr>
                <tr>
                    <td>LCM Enabled</td>
                    <td>
                        <xsl:call-template name="getConfigBooleanIcon">
                            <xsl:with-param name="name" select="'lcmEnabled'" />
                        </xsl:call-template>
                    </td>
                </tr>
                <tr>
                    <td>Allow IdentityIQ in an iFrame</td>
                    <td>
                        <xsl:call-template name="getConfigBooleanIcon">
                            <xsl:with-param name="name" select="'allowiFrame'" />
                        </xsl:call-template>
                    </td>
                </tr>
                <tr>
                    <td>Asynchronous Cache Refresh</td>
                    <td>
                        <xsl:call-template name="getConfigBooleanIcon">
                            <xsl:with-param name="name" select="'asyncCacheRefresh'" />
                        </xsl:call-template>
                    </td>
                </tr>
            </table>
            <h3>Mail Settings</h3>
            <table>
                <tr>
                    <th>Option</th>
                    <th>Value</th>
                </tr>
                <tr>
                    <td>Email Notification Type</td>
                    <td>
                        <xsl:choose>
                            <xsl:when test="//Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key='emailNotifierType']/@value = 'smtp'">
                                <xsl:text>SMTP</xsl:text>
                            </xsl:when>
                            <xsl:when test="//Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key='emailNotifierType']/@value = 'redirectToEmail'">
                                <xsl:text>Redirect to Email</xsl:text>
                            </xsl:when>
                            <xsl:when test="//Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key='emailNotifierType']/@value = 'redirectToFile'">
                                <xsl:text>Redirect to File</xsl:text>
                            </xsl:when>
                        </xsl:choose>
                    </td>
                </tr>
                <xsl:choose>
                    <xsl:when test="//Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key='emailNotifierType']/@value = 'smtp' or //Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key='emailNotifierType']/@value = 'redirectToEmail'">
                        <tr>
                            <td>SMTP Host</td>
                            <td>
                                <xsl:value-of select="//Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key='defaultEmailHost']/@value" />
                            </td>
                        </tr>
                        <tr>
                            <td>SMTP Port</td>
                            <td>
                                <xsl:value-of select="//Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key='defaultEmailPort']/@value" />
                            </td>
                        </tr>
                        <tr>
                            <td>Encryption</td>
                            <td>
                                <xsl:value-of select="//Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key='smtp_encryptionType']/value/SmtpEncryptionType" />
                            </td>
                        </tr>
                        <tr>
                            <td>Authentication</td>
                            <td>
                                <xsl:if test="//Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key='smtp_username']/@value and //Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key='smtp_password']/@value">
                                    <xsl:text>Yes</xsl:text>
                                </xsl:if>
                            </td>
                        </tr>
                    </xsl:when>
                    <xsl:when test="//Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key='emailNotifierType']/@value = 'redirectToEmail'">
                        <tr>
                            <td>Redirection Email Address</td>
                            <td>
                                <xsl:value-of select="//Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key='redirectingEmailNotifierAddress']/@value" />
                            </td>
                        </tr>
                    </xsl:when>
                    <xsl:when test="//Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key='emailNotifierType']/@value = 'redirectToFile'">
                        <tr>
                            <td>Redirection File Name</td>
                            <td>
                                <xsl:value-of select="//Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key='redirectingEmailNotifierFilename']/@value" />
                            </td>
                        </tr>
                    </xsl:when>
                </xsl:choose>
                <tr>
                    <td>Default From Address</td>
                    <td>
                        <xsl:value-of select="//Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key='defaultEmailFromAddress']/@value" />
                    </td>
                </tr>
            </table>
		<!--
			<h3>Work Items</h3>
			<h3>Identities</h3>
			<h3>Roles</h3>
			<h3>Passwords</h3>
		-->
            <h3>Miscellaneous</h3>
            <h4>Other Object Expirations</h4>
            <table>
                <tr>
                    <th>Option</th>
                    <th>Value</th>
                </tr>
                <tr>
                    <td>Days before snapshot deletion</td>
                    <td>
                        <xsl:call-template name="getConfigNumber">
                            <xsl:with-param name="name" select="'identitySnapshotMaxAge'" />
                        </xsl:call-template>
                    </td>
                </tr>
                <tr>
                    <td>Days before task result deletion</td>
                    <td>
                        <xsl:call-template name="getConfigNumber">
                            <xsl:with-param name="name" select="'taskResultMaxAge'" />
                        </xsl:call-template>
                    </td>
                </tr>
                <tr>
                    <td>Days before certifications are archived</td>
                    <td>
                        <xsl:call-template name="getConfigNumber">
                            <xsl:with-param name="name" select="'certificationMaxAge'" />
                        </xsl:call-template>
                    </td>
                </tr>
                <tr>
                    <td>Days before certification archive deletion</td>
                    <td>
                        <xsl:call-template name="getConfigNumber">
                            <xsl:with-param name="name" select="'certificationArchiveMaxAge'" />
                        </xsl:call-template>
                    </td>
                </tr>
                <tr>
                    <td>Minutes before object locks are released</td>
                    <td>
                        <xsl:call-template name="getConfigNumber">
                            <xsl:with-param name="name" select="'persistentLockTimeout'" />
                        </xsl:call-template>
                    </td>
                </tr>
                <tr>
                    <td>Days before provisioning request logs expire</td>
                    <td>
                        <xsl:call-template name="getConfigNumber">
                            <xsl:with-param name="name" select="'provisioningRequestExpirationDays'" />
                        </xsl:call-template>
                    </td>
                </tr>
            </table>
            <h4>Syslog Settings</h4>
            <table>
                <tr>
                    <th>Option</th>
                    <th>Value</th>
                </tr>
                <tr>
                    <td>Enable Syslog</td>
                    <td>
                        <xsl:call-template name="getConfigBooleanIcon">
                            <xsl:with-param name="name" select="'enableSyslog'" />
                            <xsl:with-param name="default" select="'true'" />
                        </xsl:call-template>
                    </td>
                </tr>
                <tr>
                    <td>Level at which syslog events are stored</td>
                    <td>
                        <xsl:value-of select="//Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key='syslogLevel']/@value | //Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key='syslogLevel']/value/String/text()" />
                    </td>
                </tr>
                <tr>
                    <td>Days before syslog event deletion</td>
                    <td>
                        <xsl:call-template name="getConfigNumber">
                            <xsl:with-param name="name" select="'syslogPurgeAge'" />
                        </xsl:call-template>
                    </td>
                </tr>
            </table>
            <h4>Provisioning Transaction Log</h4>
            <table>
                <tr>
                    <th>Option</th>
                    <th>Value</th>
                </tr>
                <tr>
                    <td>Enable Provisioning Transaction Log</td>
                    <td>
                        <xsl:call-template name="getConfigBooleanIcon">
                            <xsl:with-param name="name" select="'enableProvisioningTransactionLog'" />
                        </xsl:call-template>
                    </td>
                </tr>
                <tr>
                    <td>Maximum Log Level</td>
                    <td>
                        <xsl:value-of select="//Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key='provisioningTransactionLogLevel']/@value | //Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key='provisioningTransactionLogLevel']/value/String/text()" />
                    </td>
                </tr>
                <tr>
                    <td>Days before provisioning transaction event deletion</td>
                    <td>
                        <xsl:call-template name="getConfigNumber">
                            <xsl:with-param name="name" select="'provisioningTransactionLogPruneAge'" />
                        </xsl:call-template>
                    </td>
                </tr>
            </table>
            <h2>Lifecycle Manager Configuration</h2>
            <h3>Business Processes</h3>
            <table>
                <tr>
                    <th>Action</th>
                    <th>Business Process</th>
                </tr>
                <tr>
                    <td>
                        <b>Request Access</b>
                    </td>
                    <td>
                        <xsl:call-template name="workflowReferenceLink">
                            <xsl:with-param name="workflowName">
                                <xsl:value-of select="/sailpoint/ImportAction[@name='merge' or @name='execute']/Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key='workflowLCMAccessRequest']/@value | /sailpoint/Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key='workflowLCMAccessRequest']/@value" />
                            </xsl:with-param>
                        </xsl:call-template>
                    </td>
                </tr>
                <tr>
                    <td>
                        <b>Manage Accounts</b>
                    </td>
                    <td>
                        <xsl:call-template name="workflowReferenceLink">
                            <xsl:with-param name="workflowName">
                                <xsl:value-of select="/sailpoint/ImportAction[@name='merge' or @name='execute']/Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key='workflowLCMAccountsRequest']/@value | /sailpoint/Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key='workflowLCMAccountsRequest']/@value" />
                            </xsl:with-param>
                        </xsl:call-template>
                    </td>
                </tr>
                <tr>
                    <td>
                        <b>Unlock User Account</b>
                    </td>
                    <td>
                        <xsl:call-template name="workflowReferenceLink">
                            <xsl:with-param name="workflowName">
                                <xsl:value-of select="/sailpoint/ImportAction[@name='merge' or @name='execute']/Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key='workflowLCMUnlockAccount']/@value | /sailpoint/Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key='workflowLCMUnlockAccount']/@value" />
                            </xsl:with-param>
                        </xsl:call-template>
                    </td>
                </tr>
                <tr>
                    <td>
                        <b>Manage Passwords</b>
                    </td>
                    <td>
                        <xsl:call-template name="workflowReferenceLink">
                            <xsl:with-param name="workflowName">
                                <xsl:value-of select="/sailpoint/ImportAction[@name='merge' or @name='execute']/Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key='workflowLCMPasswordsRequest']/@value | /sailpoint/Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key='workflowLCMPasswordsRequest']/@value" />
                            </xsl:with-param>
                        </xsl:call-template>
                    </td>
                </tr>
                <tr>
                    <td>
                        <b>Edit Identity</b>
                    </td>
                    <td>
                        <xsl:call-template name="workflowReferenceLink">
                            <xsl:with-param name="workflowName">
                                <xsl:value-of select="/sailpoint/ImportAction[@name='merge' or @name='execute']/Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key='workflowLCMIdentityEditRequest']/@value | /sailpoint/Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key='workflowLCMIdentityEditRequest']/@value" />
                            </xsl:with-param>
                        </xsl:call-template>
                    </td>
                </tr>
                <tr>
                    <td>
                        <b>Create Identity</b>
                    </td>
                    <td>
                        <xsl:call-template name="workflowReferenceLink">
                            <xsl:with-param name="workflowName">
                                <xsl:value-of select="/sailpoint/ImportAction[@name='merge' or @name='execute']/Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key='workflowLCMIdentityCreateRequest']/@value | /sailpoint/Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key='workflowLCMIdentityCreateRequest']/@value" />
                            </xsl:with-param>
                        </xsl:call-template>
                    </td>
                </tr>
                <tr>
                    <td>
                        <b>Self-service Registration</b>
                    </td>
                    <td>
                        <xsl:call-template name="workflowReferenceLink">
                            <xsl:with-param name="workflowName">
                                <xsl:value-of select="/sailpoint/ImportAction[@name='merge' or @name='execute']/Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key='workflowLCMSelfServiceRegistrationRequest']/@value | /sailpoint/Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key='workflowLCMSelfServiceRegistrationRequest']/@value" />
                            </xsl:with-param>
                        </xsl:call-template>
                    </td>
                </tr>
                <tr>
                    <td>
                        <b>Batch Request Access</b>
                    </td>
                    <td>
                        <xsl:call-template name="workflowReferenceLink">
                            <xsl:with-param name="workflowName">
                                <xsl:value-of select="/sailpoint/ImportAction[@name='merge' or @name='execute']/Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key='batchRequestAccountsRequest']/@value | /sailpoint/Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key='batchRequestAccessRequest']/@value" />
                            </xsl:with-param>
                        </xsl:call-template>
                    </td>
                </tr>
                <tr>
                    <td>
                        <b>Batch Manage Accounts</b>
                    </td>
                    <td>
                        <xsl:call-template name="workflowReferenceLink">
                            <xsl:with-param name="workflowName">
                                <xsl:value-of select="/sailpoint/ImportAction[@name='merge' or @name='execute']/Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key='batchRequestAccountsRequest']/@value | /sailpoint/Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key='batchRequestAccessRequest']/@value" />
                            </xsl:with-param>
                        </xsl:call-template>
                    </td>
                </tr>
                <tr>
                    <td>
                        <b>Batch Manage Passwords</b>
                    </td>
                    <td>
                        <xsl:call-template name="workflowReferenceLink">
                            <xsl:with-param name="workflowName">
                                <xsl:value-of select="/sailpoint/ImportAction[@name='merge' or @name='execute']/Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key='batchRequestPasswordsRequest']/@value | /sailpoint/Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key='batchRequestPasswordsRequest']/@value" />
                            </xsl:with-param>
                        </xsl:call-template>
                    </td>
                </tr>
                <tr>
                    <td>
                        <b>Batch Edit Identity</b>
                    </td>
                    <td>
                        <xsl:call-template name="workflowReferenceLink">
                            <xsl:with-param name="workflowName">
                                <xsl:value-of select="/sailpoint/ImportAction[@name='merge' or @name='execute']/Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key='batchRequestIdentityEditRequest']/@value | /sailpoint/Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key='batchRequestIdentityEditRequest']/@value" />
                            </xsl:with-param>
                        </xsl:call-template>
                    </td>
                </tr>
                <tr>
                    <td>
                        <b>Batch Create Identity</b>
                    </td>
                    <td>
                        <xsl:call-template name="workflowReferenceLink">
                            <xsl:with-param name="workflowName">
                                <xsl:value-of select="/sailpoint/ImportAction[@name='merge' or @name='execute']/Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key='batchRequestIdentityCreateRequest']/@value | /sailpoint/Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key='batchRequestIdentityCreateRequest']/@value" />
                            </xsl:with-param>
                        </xsl:call-template>
                    </td>
                </tr>
            </table>
            <h3>Identity Provisioning Policies</h3>
            <table>
                <tr>
                    <th>Type</th>
                    <th>Provisioning Form</th>
                </tr>
                <tr>
                    <td>
                        <b>Create Identity</b>
                    </td>
                    <td>
                        <xsl:call-template name="formReferenceLink">
                            <xsl:with-param name="formName">
                                <xsl:value-of select="/sailpoint/ImportAction[@name='merge' or @name='execute']/Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key='createIdentityForm']/@value | /sailpoint/Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key='createIdentityForm']/@value" />
                            </xsl:with-param>
                        </xsl:call-template>
                    </td>
                </tr>
                <tr>
                    <td>
                        <b>Update Identity</b>
                    </td>
                    <td>
                        <xsl:call-template name="formReferenceLink">
                            <xsl:with-param name="formName">
                                <xsl:value-of select="/sailpoint/ImportAction[@name='merge' or @name='execute']/Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key='updateIdentityForm']/@value | /sailpoint/Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key='updateIdentityForm']/@value" />
                            </xsl:with-param>
                        </xsl:call-template>
                    </td>
                </tr>
                <tr>
                    <td>
                        <b>Self-service Registration</b>
                    </td>
                    <td>
                        <xsl:call-template name="formReferenceLink">
                            <xsl:with-param name="formName">
                                <xsl:value-of select="/sailpoint/ImportAction[@name='merge' or @name='execute']/Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key='registerForm']/@value | /sailpoint/Configuration[@name='SystemConfiguration']/Attributes/Map/entry[@key='registerForm']/@value" />
                            </xsl:with-param>
                        </xsl:call-template>
                    </td>
                </tr>
            </table>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>