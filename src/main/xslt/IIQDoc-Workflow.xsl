<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:iiqdoc="http://iiqdoc.config.data">
    <xsl:output omit-xml-declaration="yes" indent="yes" method="html" />
    <xsl:variable name="boxWidth" select="48" />
    <xsl:variable name="boxHeight" select="48" />
    <xsl:variable name="lineColor" select="'#444444'" />
    <xsl:variable name="lineWidth" select="1" />
    <xsl:template name="workflowReferenceLink">
        <xsl:param name="workflowName" />
        <xsl:choose>
            <xsl:when test="//Workflow[@name=$workflowName]">
                <a>
                    <xsl:attribute name="href">
						<xsl:value-of select="concat('#Workflow - ', $workflowName)" />
					</xsl:attribute>
                    <xsl:value-of select="$workflowName" />
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$workflowName" />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="processWorkflowVariable" match="//Workflow/Variable">
        <xsl:param name="workflowName" />
        <h4>
            <xsl:choose>
                <xsl:when test="@displayName">
                    <xsl:value-of select="@displayName" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="@name" />
                </xsl:otherwise>
            </xsl:choose>
        </h4>
        <xsl:if test="Description">
            <pre class="description">
                <xsl:value-of select="Description" />
            </pre>
        </xsl:if>
        <table class="workflowVariableAttributes">
			<!-- input -->
            <tr>
                <th class="rowHeader">Input</th>
                <td>
                    <xsl:choose>
                        <xsl:when test="@input = 'true'">
                            <xsl:text>Yes</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>No</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </td>
            </tr>
			<!-- output -->
            <tr>
                <th class="rowHeader">Output</th>
                <td>
                    <xsl:choose>
                        <xsl:when test="@output = 'true'">
                            <xsl:text>Yes</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>No</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </td>
            </tr>
			<!-- required -->
            <tr>
                <th class="rowHeader">Required</th>
                <td>
                    <xsl:choose>
                        <xsl:when test="@required = 'true'">
                            <xsl:text>Yes</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>No</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </td>
            </tr>
			<!-- helpKey -->
            <xsl:if test="@helpKey">
                <tr>
                    <th class="rowHeader">Help Key</th>
                    <td>
                        <xsl:value-of select="@helpKey" />
                    </td>
                </tr>
            </xsl:if>
			<!-- multi -->
            <tr>
                <th class="rowHeader">Multi-Valued</th>
                <td>
                    <xsl:choose>
                        <xsl:when test="@multi = 'true'">
                            <xsl:text>Yes</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>No</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </td>
            </tr>
			<!-- type -->
            <xsl:if test="@type">
                <tr>
                    <th class="rowHeader">Type</th>
                    <td>
                        <xsl:value-of select="@type" />
                    </td>
                </tr>
            </xsl:if>
			<!-- transient -->
            <tr>
                <th class="rowHeader">Transient</th>
                <td>
                    <xsl:choose>
                        <xsl:when test="@transient = 'true'">
                            <xsl:text>Yes</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>No</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </td>
            </tr>
			<!-- initializer -->
            <xsl:if test="@initializer|Script">
                <tr>
                    <th class="rowHeader">Initializer</th>
                    <td>
                        <xsl:choose>
                            <xsl:when test="@initializer">
                                <xsl:call-template name="processScriptlet">
                                    <xsl:with-param name="scriptlet" select="@initializer" />
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:when test="Script">
                                <xsl:for-each select="Script">
                                    <xsl:call-template name="processScript" />
                                </xsl:for-each>
                            </xsl:when>
                        </xsl:choose>
                    </td>
                </tr>
            </xsl:if>
			<!-- AllowedValues -->
            <xsl:if test="AllowedValues">
                <xsl:for-each select="AllowedValues">
                    <tr>
                        <th class="rowHeader">Allowed Values</th>
                        <td>
                            <xsl:call-template name="processAllowedValues" />
                        </td>
                    </tr>
                </xsl:for-each>
            </xsl:if>
			<!-- DefaultValue / @DefaultValue -->
            <xsl:if test="@defaultValue|DefaultValue">
                <tr>
                    <th class="rowHeader">Allowed Values</th>
                    <td>
                        <xsl:choose>
                            <xsl:when test="@defaultValue">
                                <xsl:call-template name="processScriptlet">
                                    <xsl:with-param name="scriptlet" select="@defaultValue" />
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:when test="DefaultValue">
                                <xsl:for-each select="DefaultValue">
                                    <xsl:call-template name="processDefaultValue" />
                                </xsl:for-each>
                            </xsl:when>
                        </xsl:choose>
                    </td>
                </tr>
            </xsl:if>
        </table>
    </xsl:template>
    <xsl:template name="processWorkflowStepArg" match="//Arg">
        <tr>
            <td>
                <b>
                    <xsl:value-of select="@name" />
                </b>
            </td>
            <td>
                <xsl:choose>
                    <xsl:when test="@value">
                        <xsl:call-template name="processScriptlet">
                            <xsl:with-param name="scriptlet" select="@value" />
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="value">
                        <xsl:choose>
                            <xsl:when test="value/List">
                                <ul>
                                    <xsl:for-each select="value/List/node()">
                                        <li>
                                            <xsl:value-of select="text()" />
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
    <xsl:template name="processWorkflowStepApproval" match="//Approval">
        <table>
            <xsl:if test="@name">
                <tr>
                    <th class="rowHeader">Name</th>
                    <td>
                        <xsl:value-of select="@name" />
                    </td>
                </tr>
            </xsl:if>
            <xsl:if test="@description">
                <tr>
                    <th class="rowHeader">Description</th>
                    <td>
                        <xsl:value-of select="@description" />
                    </td>
                </tr>
            </xsl:if>
            <xsl:if test="@owner">
                <tr>
                    <th class="rowHeader">Owner</th>
                    <td>
                        <xsl:call-template name="processScriptlet">
                            <xsl:with-param name="scriptlet" select="@owner" />
                        </xsl:call-template>
                    </td>
                </tr>
            </xsl:if>
            <xsl:if test="@renderer">
                <tr>
                    <th class="rowHeader">Renderer</th>
                    <td>
                        <xsl:value-of select="@renderer" />
                    </td>
                </tr>
            </xsl:if>
            <xsl:if test="@mode">
                <tr>
                    <th class="rowHeader">Mode</th>
                    <td>
                        <xsl:value-of select="@mode" />
                    </td>
                </tr>
            </xsl:if>
            <xsl:if test="@send">
                <tr>
                    <th class="rowHeader">Send Variables</th>
                    <td>
                        <xsl:value-of select="@send" />
                    </td>
                </tr>
            </xsl:if>
            <xsl:if test="@return">
                <tr>
                    <th class="rowHeader">Return Variables</th>
                    <td>
                        <xsl:value-of select="@return" />
                    </td>
                </tr>
            </xsl:if>
            <xsl:if test="@validation">
                <tr>
                    <th class="rowHeader">Validation</th>
                    <td>
                        <xsl:value-of select="@validation" />
                    </td>
                </tr>
            </xsl:if>
            <xsl:if test="@validator">
                <tr>
                    <th class="rowHeader">Validator</th>
                    <td>
                        <xsl:value-of select="@validation" />
                    </td>
                </tr>
            </xsl:if>
            <xsl:if test="@workItemDescription">
                <tr>
                    <th class="rowHeader">Work Item Description</th>
                    <td>
                        <xsl:value-of select="@workItemDescription" />
                    </td>
                </tr>
            </xsl:if>
            <xsl:if test="@workItemType">
                <tr>
                    <th class="rowHeader">Work Item Type</th>
                    <td>
                        <xsl:value-of select="@workItemType" />
                    </td>
                </tr>
            </xsl:if>
            <xsl:if test="Attributes">
                <xsl:for-each select="Attributes">
                    <xsl:call-template name="parseAttributes" />
                </xsl:for-each>
            </xsl:if>
            <xsl:if test="Arg">
                <tr>
                    <th class="rowHeader">Arguments</th>
                    <td>
                        <table>
                            <tr>
                                <th>Name</th>
                                <th>Value</th>
                            </tr>
                            <xsl:for-each select="Arg">
                                <xsl:call-template name="processWorkflowStepArg" />
                            </xsl:for-each>
                        </table>
                    </td>
                </tr>
            </xsl:if>
            <xsl:if test="Return">
                <table>
                    <tr>
                        <th>Name</th>
                        <th>To</th>
                        <th>Value</th>
                    </tr>
                    <xsl:for-each select="Return">
                        <tr>
                            <td>
                                <xsl:value-of select="@name" />
                            </td>
                            <td>
                                <xsl:value-of select="@to" />
                            </td>
                            <td>
                                <xsl:choose>
                                    <xsl:when test="@value">
                                        <xsl:call-template name="processScriptlet">
                                            <xsl:with-param name="scriptlet" select="@value" />
                                        </xsl:call-template>
                                    </xsl:when>
                                    <xsl:when test="Script">
                                        <xsl:for-each select="Script">
                                            <xsl:call-template name="processScript" />
                                        </xsl:for-each>
                                    </xsl:when>
                                </xsl:choose>
                            </td>
                        </tr>
                    </xsl:for-each>
                </table>
            </xsl:if>
            <xsl:if test="Approval">
                <tr>
                    <th class="rowHeader">Approval</th>
                    <td>
                        <xsl:for-each select="Approval">
                            <xsl:call-template name="processWorkflowStepApproval" />
                        </xsl:for-each>
                    </td>
                </tr>
            </xsl:if>
            <xsl:if test="Form">
                <tr>
                    <th class="rowHeader">Form</th>
                    <td>
                        <xsl:for-each select="Form">
                            <xsl:call-template name="processSingleForm" />
                        </xsl:for-each>
                    </td>
                </tr>
            </xsl:if>
            <xsl:if test="AfterScript">
                <tr>
                    <th class="rowHeader">After Script</th>
                    <td>
                        <xsl:for-each select="AfterScript">
                            <xsl:call-template name="processScript" />
                        </xsl:for-each>
                    </td>
                </tr>
            </xsl:if>
            <xsl:if test="InterceptorScript">
                <tr>
                    <th class="rowHeader">Interceptor Script</th>
                    <td>
                        <xsl:for-each select="InterceptorScript">
                            <xsl:call-template name="processScript" />
                        </xsl:for-each>
                    </td>
                </tr>
            </xsl:if>
            <xsl:if test="ModeScript">
                <tr>
                    <th class="rowHeader">Mode Script</th>
                    <td>
                        <xsl:for-each select="ModeScript">
                            <xsl:call-template name="processScript" />
                        </xsl:for-each>
                    </td>
                </tr>
            </xsl:if>
            <xsl:if test="OwnerScript">
                <tr>
                    <th class="rowHeader">Owner Script</th>
                    <td>
                        <xsl:for-each select="OwnerScript">
                            <xsl:call-template name="processScript" />
                        </xsl:for-each>
                    </td>
                </tr>
            </xsl:if>
            <xsl:if test="ValidationScript">
                <tr>
                    <th class="rowHeader">Validation Script</th>
                    <td>
                        <xsl:for-each select="ValidationScript">
                            <xsl:call-template name="processScript" />
                        </xsl:for-each>
                    </td>
                </tr>
            </xsl:if>
            <xsl:if test="ValidatorScript">
                <tr>
                    <th class="rowHeader">Validator Script</th>
                    <td>
                        <xsl:for-each select="ValidatorScript">
                            <xsl:call-template name="processScript" />
                        </xsl:for-each>
                    </td>
                </tr>
            </xsl:if>
        </table>
    </xsl:template>
    <xsl:template name="processWorkflowStep" match="//Workflow/Step">
        <xsl:param name="workflowName" />
        <a>
            <xsl:attribute name="name">
				<xsl:value-of select="concat('Workflow - ', $workflowName, ' - Step - ', @name)" />
			</xsl:attribute>
        </a>
        <h4>
            <xsl:value-of select="concat('Step: ', @name)" />
        </h4>
        <table>
            <tr>
                <th class="rowHeader">Action</th>
                <td>
                    <xsl:choose>
                        <xsl:when test="@action">
                            <xsl:call-template name="processScriptlet">
                                <xsl:with-param name="scriptlet" select="@action" />
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="WorkflowRef/Reference">
                            <xsl:text>Workflow: </xsl:text>
                            <xsl:call-template name="workflowReferenceLink">
                                <xsl:with-param name="workflowName" select="WorkflowRef/Reference/@name" />
                            </xsl:call-template>
                            <xsl:if test="Replicator">
                                <table class="mapTable">
                                    <tr>
                                        <th colspan="2" class="mapTable">Step Replicator</th>
                                    </tr>
                                    <tr>
                                        <th class="rowHeader">Items</th>
                                        <td>
                                            <xsl:value-of select="Replicator/@items" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <th class="rowHeader">Variable</th>
                                        <td>
                                            <xsl:value-of select="Replicator/@arg" />
                                        </td>
                                    </tr>
                                </table>
                            </xsl:if>
                        </xsl:when>
                        <xsl:when test="Script[Source]">
                            <xsl:text>Script: </xsl:text>
                            <xsl:for-each select="Script[Source]">
                                <xsl:call-template name="processScript" />
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:when test="Approval[not(Form)]">
                            <xsl:text>Approval</xsl:text>
                        </xsl:when>
                        <xsl:when test="Approval[Form]">
                            <xsl:text>Form</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>None</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </td>
            </tr>
            <xsl:if test="@condition|ConditionScript">
                <tr>
                    <th class="rowHeader">Step Condition</th>
                    <td>
                        <xsl:choose>
                            <xsl:when test="@condition">
                                <xsl:call-template name="processScriptlet">
                                    <xsl:with-param name="scriptlet" select="@condition" />
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:when test="ConditionScript">
                                <xsl:for-each select="ConditionScript">
                                    <xsl:call-template name="processScript" />
                                </xsl:for-each>
                            </xsl:when>
                        </xsl:choose>
                    </td>
                </tr>
            </xsl:if>
            <xsl:if test="@resultVariable">
                <tr>
                    <th class="rowHeader">Result Variable</th>
                    <td>
                        <xsl:value-of select="@resultVariable" />
                    </td>
                </tr>
            </xsl:if>
            <xsl:if test="@background">
                <tr>
                    <th class="rowHeader">Background</th>
                    <td>
                        <xsl:value-of select="@background" />
                    </td>
                </tr>
            </xsl:if>
            <xsl:if test="@wait">
                <tr>
                    <th class="rowHeader">Wait</th>
                    <td>
                        <xsl:value-of select="@wait" />
                        seconds
                    </td>
                </tr>
            </xsl:if>
            <xsl:if test="@catches">
                <tr>
                    <th class="rowHeader">Catches</th>
                    <td>
                        <xsl:value-of select="@catches" />
                    </td>
                </tr>
            </xsl:if>
        </table>
        <xsl:if test="Arg">
            <h5>Arguments</h5>
            <table>
                <tr>
                    <th>Name</th>
                    <th>Value</th>
                </tr>
                <xsl:for-each select="Arg">
                    <xsl:call-template name="processWorkflowStepArg" />
                </xsl:for-each>
            </table>
        </xsl:if>
        <xsl:if test="Return">
            <h5>Return Arguments</h5>
            <table>
                <tr>
                    <th>Name</th>
                    <th>To</th>
                    <th>Value</th>
                </tr>
                <xsl:for-each select="Return">
                    <tr>
                        <td>
                            <xsl:value-of select="@name" />
                        </td>
                        <td>
                            <xsl:value-of select="@to" />
                        </td>
                        <td>
                            <xsl:choose>
                                <xsl:when test="@value">
                                    <xsl:call-template name="processScriptlet">
                                        <xsl:with-param name="scriptlet" select="@value" />
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:when test="Script">
                                    <xsl:for-each select="Script">
                                        <xsl:call-template name="processScript" />
                                    </xsl:for-each>
                                </xsl:when>
                            </xsl:choose>
                        </td>
                    </tr>
                </xsl:for-each>
            </table>
        </xsl:if>
        <xsl:if test="Approval">
            <xsl:choose>
                <xsl:when test="Approval/Form">
                    <h5>Form</h5>
                </xsl:when>
                <xsl:otherwise>
                    <h5>Approval</h5>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:for-each select="Approval">
                <xsl:call-template name="processWorkflowStepApproval" />
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="Transition">
            <h5>Transitions</h5>
            <table>
                <tr>
                    <th>To Step</th>
                    <th>Condition</th>
                </tr>
                <xsl:for-each select="Transition">
                    <tr>
                        <td>
                            <a>
                                <xsl:attribute name="href">
									<xsl:value-of select="concat('#Workflow - ', $workflowName, ' - Step - ', @to)" />
								</xsl:attribute>
                                <xsl:value-of select="@to" />
                            </a>
                        </td>
                        <td>
                            <xsl:choose>
                                <xsl:when test="@when">
                                    <xsl:call-template name="processScriptlet">
                                        <xsl:with-param name="scriptlet" select="@when" />
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:when test="Script">
                                    <xsl:for-each select="Script">
                                        <xsl:call-template name="processScript" />
                                    </xsl:for-each>
                                </xsl:when>
                            </xsl:choose>
                        </td>
                    </tr>
                </xsl:for-each>
            </table>
        </xsl:if>
    </xsl:template>
    <xsl:template name="drawArrowFromBoxToBox">
        <xsl:param name="x1" />
        <xsl:param name="y1" />
        <xsl:param name="w1" />
        <xsl:param name="h1" />
        <xsl:param name="x2" />
        <xsl:param name="y2" />
        <xsl:param name="w2" />
        <xsl:param name="h2" />
        <xsl:param name="color" select="$lineColor" />
    <!-- Sides -->
        <xsl:variable name="sideFrom">
            <xsl:call-template name="closestSide">
                <xsl:with-param name="px1" select="$x1" />
                <xsl:with-param name="py1" select="$y1" />
                <xsl:with-param name="wd1" select="$w1" />
                <xsl:with-param name="ht1" select="$h1" />
                <xsl:with-param name="px2" select="$x2" />
                <xsl:with-param name="py2" select="$y2" />
                <xsl:with-param name="wd2" select="$w2" />
                <xsl:with-param name="ht2" select="$h2" />
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="sideTo">
            <xsl:call-template name="closestSide">
                <xsl:with-param name="px1" select="$x2" />
                <xsl:with-param name="py1" select="$y2" />
                <xsl:with-param name="wd1" select="$w2" />
                <xsl:with-param name="ht1" select="$h2" />
                <xsl:with-param name="px2" select="$x1" />
                <xsl:with-param name="py2" select="$y1" />
                <xsl:with-param name="wd2" select="$w1" />
                <xsl:with-param name="ht2" select="$h1" />
            </xsl:call-template>
        </xsl:variable>
		<!-- Coordinates -->
        <xsl:variable name="sx1">
            <xsl:call-template name="sideCoordinate">
                <xsl:with-param name="px" select="$x1" />
                <xsl:with-param name="py" select="$y1" />
                <xsl:with-param name="wd" select="$w1" />
                <xsl:with-param name="ht" select="$h1" />
                <xsl:with-param name="side" select="$sideFrom" />
                <xsl:with-param name="xy" select="'x'" />
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="sy1">
            <xsl:call-template name="sideCoordinate">
                <xsl:with-param name="px" select="$x1" />
                <xsl:with-param name="py" select="$y1" />
                <xsl:with-param name="wd" select="$w1" />
                <xsl:with-param name="ht" select="$h1" />
                <xsl:with-param name="side" select="$sideFrom" />
                <xsl:with-param name="xy" select="'y'" />
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="sx2">
            <xsl:call-template name="sideCoordinate">
                <xsl:with-param name="px" select="$x2" />
                <xsl:with-param name="py" select="$y2" />
                <xsl:with-param name="wd" select="$w2" />
                <xsl:with-param name="ht" select="$h2" />
                <xsl:with-param name="side" select="$sideTo" />
                <xsl:with-param name="xy" select="'x'" />
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="sy2">
            <xsl:call-template name="sideCoordinate">
                <xsl:with-param name="px" select="$x2" />
                <xsl:with-param name="py" select="$y2" />
                <xsl:with-param name="wd" select="$w2" />
                <xsl:with-param name="ht" select="$h2" />
                <xsl:with-param name="side" select="$sideTo" />
                <xsl:with-param name="xy" select="'y'" />
            </xsl:call-template>
        </xsl:variable>
		<!-- Draw Line -->
        <line marker-end="url(#FilledArrow_Marker)">
            <xsl:attribute name="x1"><xsl:value-of select="$sx1" /></xsl:attribute>
            <xsl:attribute name="y1"><xsl:value-of select="$sy1" /></xsl:attribute>
            <xsl:attribute name="x2"><xsl:value-of select="$sx2" /></xsl:attribute>
            <xsl:attribute name="y2"><xsl:value-of select="$sy2" /></xsl:attribute>
            <xsl:attribute name="style"><xsl:value-of select="concat('stroke:', $color, ';stroke-width:', $lineWidth, ';')" /></xsl:attribute>
        </line>
    </xsl:template>
    <xsl:template name="drawWorkflowSVG" match="//Workflow">
        <xsl:variable name="workflowName" select="@name" />
        <xsl:variable name="width">
            <xsl:for-each select="Step/@posX">
                <xsl:sort data-type="number" order="descending" />
                <xsl:if test="position()=1">
                    <xsl:value-of select="." />
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="gwidth">
            <xsl:choose>
                <xsl:when test="$width = 'NaN' or $width = ''">
                    <xsl:value-of select="number(100)" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="number($width) + 100" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="height">
            <xsl:for-each select="Step/@posY">
                <xsl:sort data-type="number" order="descending" />
                <xsl:if test="position()=1">
                    <xsl:value-of select="." />
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="gheight">
            <xsl:choose>
                <xsl:when test="$height = NaN or $height = ''">
                    <xsl:value-of select="number(100)" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="number($height) + 100" />
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <svg xmlns:xlink="http://www.w3.org/1999/xlink">
            <xsl:attribute name="width">
				<xsl:value-of select="$gwidth" />
			</xsl:attribute>
            <xsl:attribute name="height">
				<xsl:value-of select="$gheight" />
			</xsl:attribute>
            <defs>
                <filter id="dropShadow" x="0" y="0" width="150%" height="150%">
                    <feOffset result="offOut" in="SourceAlpha" dx="5" dy="5" />
                    <feGaussianBlur result="blurOut" in="offOut" stdDeviation="10" />
                    <feBlend in="SourceGraphic" in2="blurOut" mode="normal" />
                </filter>
                <marker orient="auto" overflow="visible" markerUnits="strokeWidth" id="FilledArrow_Marker" stroke-linejoin="miter" stroke-miterlimit="10" viewBox="-1 -3 7 6" markerWidth="7" markerHeight="6">
                    <xsl:attribute name="color">
						<xsl:value-of select="$lineColor" />
					</xsl:attribute>
                    <g>
                        <path d="M -4.8 -1.8 L 0 0 L -4.8 1.8 Z" fill="currentColor" stroke="currentColor" stroke-width="5" />
                    </g>
                </marker>
            </defs>

			<!-- Draw transitions -->
            <xsl:for-each select="Step">
                <xsl:if test="Transition">
                    <xsl:for-each select="Transition">
                        <xsl:variable name="toStep" select="@to" />
                        <xsl:if test="@to">
                            <xsl:call-template name="drawArrowFromBoxToBox">
                                <xsl:with-param name="x1" select="number(../@posX | 0)" />
                                <xsl:with-param name="y1" select="number(../@posY | 0)" />
                                <xsl:with-param name="w1" select="$boxWidth" />
                                <xsl:with-param name="h1" select="$boxHeight" />
                                <xsl:with-param name="x2" select="number(../../Step[@name=$toStep]/@posX | 0)" />
                                <xsl:with-param name="y2" select="number(../../Step[@name=$toStep]/@posY | 0)" />
                                <xsl:with-param name="w2" select="$boxWidth" />
                                <xsl:with-param name="h2" select="$boxHeight" />
                                <xsl:with-param name="color" select="$lineColor" />
                            </xsl:call-template>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:if>
            </xsl:for-each>

			<!-- Draw steps -->
			<!--
		-->
            <xsl:for-each select="Step">
                <xsl:variable name="stepName" select="@name" />
                <xsl:variable name="x">
                    <xsl:choose>
                        <xsl:when test="@posX">
                            <xsl:value-of select="number(@posX)" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="number(0)" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="y">
                    <xsl:choose>
                        <xsl:when test="@posY">
                            <xsl:value-of select="number(@posY)" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="number(0)" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="icon" select="@icon" />
                <xsl:variable name="rounding">
                    <xsl:choose>
                        <xsl:when test="@icon='Start' or @icon='Stop'">
                            <xsl:value-of select="24" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="4" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="borderColor">
                    <xsl:choose>
                        <xsl:when test="@icon='Start'">
                            <xsl:value-of select="'#415364'" />
                        </xsl:when>
                        <xsl:when test="@icon='Stop'">
                            <xsl:value-of select="'#415364'" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'#415364'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="bgColor">
                    <xsl:choose>
                        <xsl:when test="@icon='Start'">
                            <xsl:value-of select="'#93d500'" />
                        </xsl:when>
                        <xsl:when test="@icon='Stop'">
                            <xsl:value-of select="'#ee0000'" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'#f2f5f7'" />
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="stepDescription" select="Description/text()" />
                <xsl:variable name="hbh" select="number($boxHeight div 2)" />
                <xsl:variable name="hbw" select="number($boxWidth div 2)" />
				<!-- Draw step icon -->
				<!--
		-->
                <a>
                    <xsl:attribute name="xlink:href">
						<xsl:value-of select="concat('#Workflow - ', $workflowName, ' - Step - ', $stepName)" />
					</xsl:attribute>
                    <rect>
                        <xsl:attribute name="x">
							<xsl:value-of select="$x" />
						</xsl:attribute>
                        <xsl:attribute name="y">
							<xsl:value-of select="$y" />
						</xsl:attribute>
                        <xsl:attribute name="width">
							<xsl:value-of select="$boxWidth" />
						</xsl:attribute>
                        <xsl:attribute name="height">
							<xsl:value-of select="$boxHeight" />
					  </xsl:attribute>
                        <xsl:attribute name="rx">
							<xsl:value-of select="$rounding" />
						</xsl:attribute>
                        <xsl:attribute name="ry">
							<xsl:value-of select="$rounding" />
						</xsl:attribute>
                        <xsl:attribute name="style">
							<xsl:value-of select="concat('fill:', $bgColor, ';stroke:', $borderColor, ';stroke-width:1;opacity:1.0')" />
						</xsl:attribute>
                        <desc>
                            <xsl:value-of select="$stepDescription" />
                        </desc>
                    </rect>
                    <xsl:choose>
                        <xsl:when test="$icon = 'Start'">
                            <path stroke="white" fill="white">
                                <xsl:attribute name="d">
                                    <xsl:value-of select="concat('M', $x+8, ' ', $y+$hbh - 2, ' L', $x+8, ' ', $y+$hbh+2, ' L', $x+$boxWidth - 14, ' ', $y+$hbh+2, ' L', $x+$boxWidth - 14, ' ', $y+$hbh+6, ' L', $x+$boxWidth - 8, ' ', $y+$hbh, ' L', $x+$boxWidth - 14, ' ', $y+$hbh - 6, ' L', $x+$boxWidth - 14, ' ', $y+$hbh - 2 )" />
                                </xsl:attribute>
                            </path>
                        </xsl:when>
                        <xsl:when test="$icon = 'Stop'">
                            <line style="stroke:white;stroke-width:6">
                                <xsl:attribute name="x1"><xsl:value-of select="$x + 10" /></xsl:attribute>
                                <xsl:attribute name="y1"><xsl:value-of select="$y + 10" /></xsl:attribute>
                                <xsl:attribute name="x2"><xsl:value-of select="$x + $boxWidth - 10" /></xsl:attribute>
                                <xsl:attribute name="y2"><xsl:value-of select="$y + $boxHeight - 10" /></xsl:attribute>
                            </line>
                            <line style="stroke:white;stroke-width:6">
                                <xsl:attribute name="x1"><xsl:value-of select="$x + 10" /></xsl:attribute>
                                <xsl:attribute name="y1"><xsl:value-of select="$y + $boxHeight - 10" /></xsl:attribute>
                                <xsl:attribute name="x2"><xsl:value-of select="$x + $boxWidth - 10" /></xsl:attribute>
                                <xsl:attribute name="y2"><xsl:value-of select="$y + 10" /></xsl:attribute>
                            </line>
                        </xsl:when>
                        <xsl:when test="$icon = 'Audit'">
                            <circle stroke="black" fill="none" stroke-width="2">
                                <xsl:attribute name="cx"><xsl:value-of select="$x + $hbw - 5" /></xsl:attribute>
                                <xsl:attribute name="cy"><xsl:value-of select="$y + $hbh - 5" /></xsl:attribute>
                                <xsl:attribute name="r"><xsl:value-of select="8" /></xsl:attribute>
                            </circle>
                            <line stroke="black" stroke-width="4">
                                <xsl:attribute name="x1"><xsl:value-of select="$x + $hbw + 2" /></xsl:attribute>
                                <xsl:attribute name="y1"><xsl:value-of select="$y + $hbh + 2" /></xsl:attribute>
                                <xsl:attribute name="x2"><xsl:value-of select="$x + $hbw + 10" /></xsl:attribute>
                                <xsl:attribute name="y2"><xsl:value-of select="$y + $hbh + 10" /></xsl:attribute>
                            </line>
                        </xsl:when>
                        <xsl:when test="$icon = 'Analysis'">
                            <rect width="36" height="8" style="fill:#93d500;stroke-width:1;stroke:#415364">
                                <xsl:attribute name="x"><xsl:value-of select="$x + $hbw - 18" /></xsl:attribute>
                                <xsl:attribute name="y"><xsl:value-of select="$y + $hbh - 16" /></xsl:attribute>
                            </rect>
                            <rect width="36" height="24" style="fill:white;stroke-width:1;stroke:#415364">
                                <xsl:attribute name="x"><xsl:value-of select="$x + $hbw - 18" /></xsl:attribute>
                                <xsl:attribute name="y"><xsl:value-of select="$y + $hbh - 8" /></xsl:attribute>
                            </rect>
                            <line stroke="#415364" stroke-width="1">
                                <xsl:attribute name="x1"><xsl:value-of select="$x + $hbw - 18" /></xsl:attribute>
                                <xsl:attribute name="y1"><xsl:value-of select="$y + $hbh" /></xsl:attribute>
                                <xsl:attribute name="x2"><xsl:value-of select="$x + $hbw + 18" /></xsl:attribute>
                                <xsl:attribute name="y2"><xsl:value-of select="$y + $hbh" /></xsl:attribute>
                            </line>
                            <line stroke="#415364" stroke-width="1">
                                <xsl:attribute name="x1"><xsl:value-of select="$x + $hbw - 18" /></xsl:attribute>
                                <xsl:attribute name="y1"><xsl:value-of select="$y + $hbh + 8" /></xsl:attribute>
                                <xsl:attribute name="x2"><xsl:value-of select="$x + $hbw + 18" /></xsl:attribute>
                                <xsl:attribute name="y2"><xsl:value-of select="$y + $hbh + 8" /></xsl:attribute>
                            </line>
                            <line stroke="#415364" stroke-width="1">
                                <xsl:attribute name="x1"><xsl:value-of select="$x + $hbw - 9" /></xsl:attribute>
                                <xsl:attribute name="y1"><xsl:value-of select="$y + $hbh - 16" /></xsl:attribute>
                                <xsl:attribute name="x2"><xsl:value-of select="$x + $hbw - 9" /></xsl:attribute>
                                <xsl:attribute name="y2"><xsl:value-of select="$y + $hbh + 16" /></xsl:attribute>
                            </line>
                            <line stroke="#415364" stroke-width="1">
                                <xsl:attribute name="x1"><xsl:value-of select="$x + $hbw" /></xsl:attribute>
                                <xsl:attribute name="y1"><xsl:value-of select="$y + $hbh - 16" /></xsl:attribute>
                                <xsl:attribute name="x2"><xsl:value-of select="$x + $hbw" /></xsl:attribute>
                                <xsl:attribute name="y2"><xsl:value-of select="$y + $hbh + 16" /></xsl:attribute>
                            </line>
                            <line stroke="#415364" stroke-width="1">
                                <xsl:attribute name="x1"><xsl:value-of select="$x + $hbw + 9" /></xsl:attribute>
                                <xsl:attribute name="y1"><xsl:value-of select="$y + $hbh - 16" /></xsl:attribute>
                                <xsl:attribute name="x2"><xsl:value-of select="$x + $hbw + 9" /></xsl:attribute>
                                <xsl:attribute name="y2"><xsl:value-of select="$y + $hbh + 16" /></xsl:attribute>
                            </line>
                        </xsl:when>
                        <xsl:when test="$icon = 'Approval'">
                            <circle stroke="#93d500" fill="#93d500">
                                <xsl:attribute name="cx"><xsl:value-of select="$x + $hbw" /></xsl:attribute>
                                <xsl:attribute name="cy"><xsl:value-of select="$y + $hbh" /></xsl:attribute>
                                <xsl:attribute name="r"><xsl:value-of select="$hbh - 8" /></xsl:attribute>
                            </circle>
                            <line stroke="white" stroke-width="4">
                                <xsl:attribute name="x1"><xsl:value-of select="$x + $hbw - 8" /></xsl:attribute>
                                <xsl:attribute name="y1"><xsl:value-of select="$y + $hbh" /></xsl:attribute>
                                <xsl:attribute name="x2"><xsl:value-of select="$x + $hbw" /></xsl:attribute>
                                <xsl:attribute name="y2"><xsl:value-of select="$y + $hbh + 10" /></xsl:attribute>
                            </line>
                            <line stroke="white" stroke-width="4">
                                <xsl:attribute name="x1"><xsl:value-of select="$x + $hbw + 8" /></xsl:attribute>
                                <xsl:attribute name="y1"><xsl:value-of select="$y + $hbh - 8" /></xsl:attribute>
                                <xsl:attribute name="x2"><xsl:value-of select="$x + $hbw" /></xsl:attribute>
                                <xsl:attribute name="y2"><xsl:value-of select="$y + $hbh + 10" /></xsl:attribute>
                            </line>
                        </xsl:when>
                        <xsl:when test="$icon = 'Catches'">
                            <image width="40" height="40"
                                href="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAAACXBIWXMAACd1AAAndQHU2lASAAAAGXRFWHRTb2Z0d2FyZQB3d3cuaW5rc2NhcGUub3Jnm+48GgAABbFJREFUWIW9mF1QG1UUx89uPpfEG8gM+QDsB0pK+XDC1AxJKdpGSWC0LZ364vigM06ntX7U4UFfHF/0xfGhw3RGHF90fPBFZ4RhcJx2RFtqqKZJsZUSIEOhRCCplM1mM5Bld68PLUizm4Swmv/jOfec+7u7d889dwlQqNbW1kNtbW1XEELEVjvDMDgYDB4ZGRm5rCQ/qQwPoKam5nw2HAAAQoiwWq3nleZXDGgymZ7M46tVmv+/AER5fI8pza/K5XA6nXXHjh37y+v1fmS1Wp+LRCJfZY/x+/1v7t279wWSlF+nRqMhEELpqampQJaL6Orq+rG7u/vrxsbG93me/yYej9NyOSR7BwCgvb29oaWl5abZbN5cwNLS0tqtW7eOYIxnLBbLd7t3724rLy8nCUI2xaYwxkDTtDg3NxeYmZk5SVHU483NzZerq6sNG7HLy8tCKBRyBgKBPwsCulyuWo/HM7UVbkMcxwFBEKDRaPJC5dLa2hpgjIGiKInv/v37wtWrV+vD4XB0q13ybpxO57gcHACAVqvdMRwAgF6vl4UDADCbzSqXyyV5ghJAs9ms3zGBQiGEdNk2CWAkEhkpDY5U09PT2R+TFHBgYODw4uLiammQ/tXS0lKmv7//mWy7XH0Qx8bGvJlMpgRYD5TJZOD27ds+ABCyfbIFDGM8/b9TPTofpNNp2TnVcsbq6upBnU6yX2UliiLcu3dvNZFIjLAsGyRJMlNWVuaxWq3PVlZWlhWqkwAPvu6amppvQ6HQoW0B7tq1q3U7cCzLipOTk28PDg5+Jufv7Ow83dTU1Gc0GgtS7tmzxyNnl9Q7n8/3Rl1d3YuFVp5Op/H4+Hjz0NDQD7nGRKPRkCAI39tstjM6nS5vQr1eT6hUquU7d+78vtVOuN3utqqqqk8RQg6EkAkhpFarZR/spkRRhGvXrp2+ePHiF3kHPpTf73/L7XZfKLRojuOAZVmeYZgkwzBTs7OzPURPT48o18/lUzweX+vr65M/EnLo7NmzqxaLpahDgGEYTG5nf2RrYWHhl2Jj4vH4cLExRqORKNiNyGl9ff1msTEcx0lOiUIiSXJnDStBEEyxMTzP42JjMMZAYlx0HOh0uqd3EOMueiIAINPpdNGElZWVzxcbY7VajxQbw7IsVpEkeWV1dfWpTCZjIAhCo1ariVwt/IYMBoOWoqjZaDT6x3Ym6uzsfH3fvn0vFdrvgiBAKpUSl5eXU/Pz8xMTExOvSCK8Xu+Z9vb2vkLJGIYRR0dHG0dHRyP5xnV1dT2xf//+KYRQ3lVjjCEQCLx76dKl3q12SdDw8PDnNE2LeekAACFEejye8Y6OjtdyjfH5fK9uBw4AIJlMitlwADnO4lgsFq6oqCj4ITyE/LK2tvZCIpH4ief5YUEQ1BqN5qDFYumw2+2o0HbZ0Nzc3HU5uyzgwsJCt8PhiG2noyFJEux2u9Futx8HgOPbosnS+vo6rKysnJTNL2dUqVS2nZSfnQpjDDzPV8v55ACJhoaGK3p96e5OWq0WmpqafgaZa7AE8OjRoz9WVVWVlYRsi2w2G9Xd3S05ryWA9fX1HaVBksrhcBzOtkkAU6kUVxIaGTEMI5lbAhgMBp256iDHccBxO+fnOA5y3RZpmhZv3LjRkm2XtPyLi4t/a7XawfLy8lMURW1u2kQikQmFQr5YLPZBKpU6TFGUrVAbv6FkMomnp6evRyIRz927dwcMBsPLRqNxs8TRNC2GQiFXIBCQtHE5Jzhw4EC9y+UaM5lMusnJyd/6+/sPAsAjT9bv97/ncrk+yXVFEAQBwuHwh0NDQx8DwNa6RZ44ceJXh8PhpmmaCwaDznA4PCGXo/huNUvnzp3jKyoqZH82raysCL29vfkvOAWk+A8ry7I5m1eappNK8ysGpGk6msc3qTS/YsD5+flTDMNs7s2HxxYkk0kxmUy+ozT/Pw3sLL5KsI2/AAAAAElFTkSuQmCC">
                                <xsl:attribute name="x"><xsl:value-of select="$x + $hbw - 20" /></xsl:attribute>
                                <xsl:attribute name="y"><xsl:value-of select="$y + $hbh - 20" /></xsl:attribute>
                            </image>
                            <circle stroke="red" fill="red">
                                <xsl:attribute name="cx"><xsl:value-of select="$x + $hbw + 10" /></xsl:attribute>
                                <xsl:attribute name="cy"><xsl:value-of select="$y + $hbh + 10" /></xsl:attribute>
                                <xsl:attribute name="r"><xsl:value-of select="10" /></xsl:attribute>
                            </circle>
                            <text fill="white" stroke="none" font-family="Courier" text-anchor="middle" font-size="16px">
                                <xsl:attribute name="x"><xsl:value-of select="$x + $hbw + 10" /></xsl:attribute>
                                <xsl:attribute name="y"><xsl:value-of select="$y + $hbw + 15" /></xsl:attribute>
                                <xsl:text>!</xsl:text>
                            </text>
                        </xsl:when>
                        <xsl:when test="$icon = 'Message'">
                            <path stroke="#415364" stroke-width="2px" fill="grey" d="M36,34 L44,40 L39,32 Z" >
                                <xsl:attribute name="d">
                                    <xsl:value-of select="concat('M', $x + $hbw +11, ',', $y + $hbh + 10, ' L', $x + $hbw +20, ',', $y + $hbh + 16, ' L', $x + $hbw + 14, ',', $y + $hbh + 8)" />
                                </xsl:attribute>
                            </path>
                            <ellipse stroke="#54c0e8" fill="#54c0e8" rx="20" ry="15" >
                                <xsl:attribute name="cx"><xsl:value-of select="$x + $hbw" /></xsl:attribute>
                                <xsl:attribute name="cy"><xsl:value-of select="$y + $hbh" /></xsl:attribute>
                            </ellipse>
                            <circle r="7" stroke="#93d500" fill="#93d500">
                                <xsl:attribute name="cx"><xsl:value-of select="$x + $hbw - 10" /></xsl:attribute>
                                <xsl:attribute name="cy"><xsl:value-of select="$y + $hbh - 11" /></xsl:attribute>
                            </circle>
                            <line stroke="white" stroke-width="3">
                                <xsl:attribute name="x1"><xsl:value-of select="$x + $hbw - 10" /></xsl:attribute>
                                <xsl:attribute name="y1"><xsl:value-of select="$y + $hbh - 15" /></xsl:attribute>
                                <xsl:attribute name="x2"><xsl:value-of select="$x + $hbw - 10" /></xsl:attribute>
                                <xsl:attribute name="y2"><xsl:value-of select="$y + $hbh - 7" /></xsl:attribute>
                            </line>
                            <line stroke="white" stroke-width="3">
                                <xsl:attribute name="x1"><xsl:value-of select="$x + $hbw - 14" /></xsl:attribute>
                                <xsl:attribute name="y1"><xsl:value-of select="$y + $hbh - 11" /></xsl:attribute>
                                <xsl:attribute name="x2"><xsl:value-of select="$x + $hbw - 6" /></xsl:attribute>
                                <xsl:attribute name="y2"><xsl:value-of select="$y + $hbh - 11" /></xsl:attribute>
                            </line>
                        </xsl:when>
                        <xsl:when test="$icon = 'Email'">
                            <path stroke="black" fill="white">
                                <xsl:attribute name="d">
                                    <xsl:value-of select="concat('M', $x+$hbw - 15, ' ', $y+$hbh - 5, ' L', $x+$hbw - 15, ' ', $y+$hbh+15, ' L', $x+$hbw+15, ' ', $y+$hbh+15, ' L', $x+$hbw+15, ' ', $y+$hbh - 5, ' L', $x+$hbw, ' ', $y+$hbh - 15, ' L', $x+$hbw - 15, ' ', $y+$hbh - 5, ' L', $x+$hbw, ' ', $y+$hbh + 5, ' L', $x+$hbw+15, ' ', $y+$hbh - 5, ' L')" />
                                </xsl:attribute>
                            </path>
                        </xsl:when>
                        <xsl:when test="$icon = 'Provision'">
                            <rect width="36" height="8" style="fill:#0071ce;stroke-width:1;stroke:#415364">
                                <xsl:attribute name="x"><xsl:value-of select="$x + $hbw - 18" /></xsl:attribute>
                                <xsl:attribute name="y"><xsl:value-of select="$y + $hbh - 16" /></xsl:attribute>
                            </rect>
                            <rect width="36" height="24" style="fill:white;stroke-width:1;stroke:#415364">
                                <xsl:attribute name="x"><xsl:value-of select="$x + $hbw - 18" /></xsl:attribute>
                                <xsl:attribute name="y"><xsl:value-of select="$y + $hbh - 8" /></xsl:attribute>
                            </rect>
                            <line stroke="black" stroke-width="1">
                                <xsl:attribute name="x1"><xsl:value-of select="$x + $hbw - 16" /></xsl:attribute>
                                <xsl:attribute name="y1"><xsl:value-of select="$y + $hbh - 6" /></xsl:attribute>
                                <xsl:attribute name="x2"><xsl:value-of select="$x + $hbw - 2" /></xsl:attribute>
                                <xsl:attribute name="y2"><xsl:value-of select="$y + $hbh - 6" /></xsl:attribute>
                            </line>
                            <line stroke="black" stroke-width="1">
                                <xsl:attribute name="x1"><xsl:value-of select="$x + $hbw - 16" /></xsl:attribute>
                                <xsl:attribute name="y1"><xsl:value-of select="$y + $hbh - 3" /></xsl:attribute>
                                <xsl:attribute name="x2"><xsl:value-of select="$x + $hbw - 2" /></xsl:attribute>
                                <xsl:attribute name="y2"><xsl:value-of select="$y + $hbh - 3" /></xsl:attribute>
                            </line>
                            <line stroke="black" stroke-width="1">
                                <xsl:attribute name="x1"><xsl:value-of select="$x + $hbw - 16" /></xsl:attribute>
                                <xsl:attribute name="y1"><xsl:value-of select="$y + $hbh" /></xsl:attribute>
                                <xsl:attribute name="x2"><xsl:value-of select="$x + $hbw - 2" /></xsl:attribute>
                                <xsl:attribute name="y2"><xsl:value-of select="$y + $hbh" /></xsl:attribute>
                            </line>
                            <line stroke="black" stroke-width="1">
                                <xsl:attribute name="x1"><xsl:value-of select="$x + $hbw - 16" /></xsl:attribute>
                                <xsl:attribute name="y1"><xsl:value-of select="$y + $hbh + 3" /></xsl:attribute>
                                <xsl:attribute name="x2"><xsl:value-of select="$x + $hbw - 2" /></xsl:attribute>
                                <xsl:attribute name="y2"><xsl:value-of select="$y + $hbh + 3" /></xsl:attribute>
                            </line>
                            <path stroke="black" stroke-width="1" fill="#f1d653">
                                <xsl:attribute name="d">
                                    <xsl:value-of select="concat('M', $x+$hbw, ' ', $y+$hbh +18, ' L', $x+$hbw + 2, ' ', $y+$hbh + 18, ' L', $x+$hbw + 20, ' ', $y+$hbh, ' L', $x+$hbw + 18, ' ', $y+$hbh - 2, ' L', $x+$hbw, ' ', $y+$hbh + 16, ' Z')" />
                                </xsl:attribute>
                            </path>
                            <path stroke="black" stroke-width="1" fill="black">
                                <xsl:attribute name="d">
                                    <xsl:value-of select="concat('M', $x+$hbw, ' ', $y+$hbh +18, ' L', $x+$hbw + 1, ' ', $y+$hbh + 18, ' L', $x+$hbw, ' ', $y+$hbh + 17, ' Z')" />
                                </xsl:attribute>
                            </path>
                            <path stroke="red" stroke-width="1" fill="red">
                                <xsl:attribute name="d">
                                    <xsl:value-of select="concat('M', $x+$hbw + 20, ' ', $y+$hbh, ' L', $x+$hbw + 18, ' ', $y+$hbh - 2, ' L', $x+$hbw + 16, ' ', $y+$hbh, ' L', $x+$hbw + 18, ' ', $y+$hbh +  2, ' Z')" />
                                </xsl:attribute>
                            </path>
                        </xsl:when>
                        <xsl:when test="$icon = 'Task'">
                            <path stroke="black" fill="#f2f5f7">
                                <xsl:attribute name="d">
                                    <xsl:value-of select="concat('M', $x+$hbw - 10, ' ', $y+$hbh - 15, ' q10 -5 20 0 L', $x+$hbw + 10, ' ', $y+$hbh + 15, ' q -10 5 -20 0 L', $x+$hbw - 10, ' ', $y+$hbh - 15)" />
                                </xsl:attribute>
                            </path>
                            <path stroke="black" fill="none">
                                <xsl:attribute name="d">
                                    <xsl:value-of select="concat('M', $x+$hbw - 10, ' ', $y+$hbh - 15, ' q10 5 20 0')" />
                                </xsl:attribute>
                            </path>
                            <path stroke="black" fill="none">
                                <xsl:attribute name="d">
                                    <xsl:value-of select="concat('M', $x+$hbw - 10, ' ', $y+$hbh - 5, ' q10 5 20 0')" />
                                </xsl:attribute>
                            </path>
                            <path stroke="black" fill="none">
                                <xsl:attribute name="d">
                                    <xsl:value-of select="concat('M', $x+$hbw - 10, ' ', $y+$hbh + 5, ' q10 5 20 0')" />
                                </xsl:attribute>
                            </path>
                            <line stroke="#93d500" stroke-width="4">
                                <xsl:attribute name="x1"><xsl:value-of select="$x + $hbw - 10" /></xsl:attribute>
                                <xsl:attribute name="y1"><xsl:value-of select="$y + $hbh + 5" /></xsl:attribute>
                                <xsl:attribute name="x2"><xsl:value-of select="$x + $hbw - 10" /></xsl:attribute>
                                <xsl:attribute name="y2"><xsl:value-of select="$y + $hbh + 13" /></xsl:attribute>
                            </line>
                            <line stroke="#93d500" stroke-width="4">
                                <xsl:attribute name="x1"><xsl:value-of select="$x + $hbw - 14" /></xsl:attribute>
                                <xsl:attribute name="y1"><xsl:value-of select="$y + $hbh + 9" /></xsl:attribute>
                                <xsl:attribute name="x2"><xsl:value-of select="$x + $hbw - 6" /></xsl:attribute>
                                <xsl:attribute name="y2"><xsl:value-of select="$y + $hbh + 9" /></xsl:attribute>
                            </line>
                        </xsl:when>
                        <xsl:otherwise />
                    </xsl:choose>
                    <text text-anchor="middle" font-family="Arial" font-size="10px" stroke="none" fill="black">
                        <xsl:attribute name="x">
							<xsl:value-of select="$x + 24" />
						</xsl:attribute>
                        <xsl:attribute name="y">
							<xsl:value-of select="$y + 60" />
						</xsl:attribute>
                        <xsl:attribute name="style">text-anchor: middle; font-family: "Arial"; font-size: 10px;</xsl:attribute>
                        <xsl:value-of select="@name" />
                    </text>
                </a>
            </xsl:for-each>
        </svg>
    </xsl:template>
    <xsl:template name="processWorkflows">
        <xsl:if test="/sailpoint/Workflow">
            <a name="Heading-Workflows" />
            <h1>Business Processes</h1>
            <xsl:for-each select="/sailpoint/Workflow">
                <xsl:sort select="@name" />
                <xsl:variable name="workflowName" select="@name" />
                <a>
                    <xsl:attribute name="name">
	          <xsl:value-of select="concat('Workflow - ', $workflowName)" />
					</xsl:attribute>
                </a>
                <h2>
                    <xsl:value-of select="@name" />
                </h2>
                <table>
                    <tr>
                        <th class="rowHeader">Type</th>
                        <td>
                            <xsl:value-of select="@type" />
                        </td>
                    </tr>
                    <tr>
                        <th class="rowHeader">Template</th>
                        <td>
                            <xsl:value-of select="@template" />
                        </td>
                    </tr>
                    <tr>
                        <th class="rowHeader">Disabled</th>
                        <td>
                            <xsl:value-of select="@disabled" />
                        </td>
                    </tr>
                    <tr>
                        <th class="rowHeader">Monitored</th>
                        <td>
                            <xsl:value-of select="@monitored" />
                        </td>
                    </tr>
                    <tr>
                        <th class="rowHeader">Libraries</th>
                        <td>
                            <xsl:value-of select="@libraries" />
                        </td>
                    </tr>
                    <tr>
                        <th class="rowHeader">Owner</th>
                        <td>
                            <xsl:call-template name="workgroupOrIdentityLink">
                                <xsl:with-param name="identityName" select="Owner/Reference/@name" />
                            </xsl:call-template>
                        </td>
                    </tr>
                </table>
                <xsl:if test="Description">
                    <h3>Description</h3>
                    <pre class="description">
                        <xsl:value-of select="Description/text()" />
                    </pre>
                </xsl:if>
				<!-- Draw SVG -->
                <xsl:call-template name="drawWorkflowSVG" />
                <xsl:if test="document('IdentityIQ-Documenter-Config.xsl')//iiqdoc:settings/iiqdoc:setting[@key='includeWorkflowDetails']/@value='true'">
					<!-- libraries -->
                    <xsl:if test="RuleLibraries/Reference">
                        <h3>Rule Libraries</h3>
                        <ul>
                            <xsl:for-each select="RuleLibraries/Reference">
                                <li>
                                    <xsl:call-template name="ruleReferenceLink">
                                        <xsl:with-param name="ruleName" select="@name" />
                                    </xsl:call-template>
                                </li>
                            </xsl:for-each>
                        </ul>
                    </xsl:if>
					<!-- Variables -->
                    <xsl:if test="Variable">
                        <h3>Variables</h3>
                        <xsl:for-each select="Variable">
                            <xsl:call-template name="processWorkflowVariable">
                                <xsl:with-param name="workflowName" select="$workflowName" />
                            </xsl:call-template>
                        </xsl:for-each>
                    </xsl:if>
					<!-- Steps -->
                    <xsl:if test="Step">
                        <h3>Steps</h3>
                        <xsl:for-each select="Step">
                            <xsl:call-template name="processWorkflowStep">
                                <xsl:with-param name="workflowName" select="$workflowName" />
                            </xsl:call-template>
                        </xsl:for-each>
                    </xsl:if>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>