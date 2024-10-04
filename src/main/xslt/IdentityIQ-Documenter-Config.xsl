<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:iiqdoc="http://iiqdoc.config.data">
    <iiqdoc:settings>
        <iiqdoc:setting key="documentConfiguration" value="true" />
        <iiqdoc:setting key="documentAuditConfig" value="true" />
        <iiqdoc:setting key="documentApplications" value="true" />
        <iiqdoc:setting key="documentEmailTemplates" value="true" />
        <iiqdoc:setting key="documentForms" value="true" />
        <iiqdoc:setting key="documentObjectConfig" value="true" />
        <iiqdoc:setting key="documentBundles" value="true" />
        <iiqdoc:setting key="documentManagedAttributes" value="false" />
        <iiqdoc:setting key="documentTasks" value="true" />
        <iiqdoc:setting key="documentRules" value="true" />
        <iiqdoc:setting key="documentPolicies" value="true" />
        <iiqdoc:setting key="documentQuickLinks" value="true" />
        <iiqdoc:setting key="documentWorkflows" value="true" />
        <iiqdoc:setting key="documentWorkgroups" value="true" />
        <iiqdoc:setting key="documentGroupFactories" value="true" />
        <iiqdoc:setting key="documentPopulations" value="true" />
        <iiqdoc:setting key="documentLifecycleEvents" value="true" />
        <iiqdoc:setting key="documentCertifications" value="false" />
        <iiqdoc:setting key="showExtendedAttributeCategory" value="true" />

		<!-- Applications -->
        <iiqdoc:setting key="applicationStatisticsOnly" value="false" />
        <iiqdoc:setting key="includeApplicationDetails" value="true" />
        <iiqdoc:setting key="includeApplicationSchemas" value="true" />
        <iiqdoc:setting key="includeApplicationConfigurationDetails.DelimitedFile" value="true" />
        <iiqdoc:setting key="includeApplicationConfigurationDetails.ActiveDirectory" value="true" />
        <iiqdoc:setting key="includeApplicationConfigurationDetails.LDAP" value="true" />
        <iiqdoc:setting key="includeApplicationConfigurationDetails.JDBC" value="true" />
        
		<!-- ManagedAttribute (Entitlements) -->
        <iiqdoc:setting key="showManagedAttributeType" value="false" />
        <iiqdoc:setting key="hideManagedAttributeExtendedAttribute">
            <value>
                <List>
                    <String>logiPlexApplication</String>
                </List>
            </value>
        </iiqdoc:setting>

		<!-- Bundles (Roles) -->
        <iiqdoc:setting key="includeBundleDetails" value="true" />
        <iiqdoc:setting key="bundleStatisticsOnly" value="false" />
        <iiqdoc:setting key="bundleModelAnalysis" value="true" />

		<!-- Certifications -->
        <iiqdoc:setting key="includeCertificationDetails" value="true" />

		<!-- Workflows -->
        <iiqdoc:setting key="includeWorkflowDetails" value="true" />

		<!-- Workgroups -->
        <iiqdoc:setting key="includeWorkgroupRights" value="true" />

		<!-- Date and Time Format -->
        <iiqdoc:setting key="defaultDateTimeLong" value="yyyy-MM-dd HH:mm" />
        <iiqdoc:setting key="defaultDateTimeShort" value="yyyy-M-d" />
    </iiqdoc:settings>
</xsl:stylesheet>