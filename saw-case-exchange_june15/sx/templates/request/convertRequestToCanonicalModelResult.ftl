<#-- @ftlvariable name="message" type="java.util.Map" -->
<#-- @ftlvariable name="context" type="java.util.Map" -->
<#-- @ftlvariable name="loadConfig" type="com.hp.ccue.serviceExchange.adapter.freemarker.LoadConfig" -->
<#-- @ftlvariable name="parseJson" type="com.hp.ccue.serviceExchange.adapter.freemarker.ParseJson" -->
<#-- @ftlvariable name="sanitize" type="com.hp.ccue.serviceExchange.adapter.freemarker.StringSanitizer" -->
<#-- @ftlvariable name="findKey" type="com.hp.ccue.serviceExchange.adapter.freemarker.FindKeyForValue" -->
<#-- @ftlvariable name="findExtSystemForAlias" type="com.hp.ccue.serviceExchange.adapter.freemarker.caseex.FindExternalSystemForAlias" -->

<#include "sawRequestUtils.ftl">

<#assign writeJson='com.hp.ccue.serviceExchange.adapter.freemarker.WriteJson'?new()/>
<#assign parseJson='com.hp.ccue.serviceExchange.adapter.freemarker.ParseJson'?new()/>
<#assign loadConfig='com.hp.ccue.serviceExchange.adapter.freemarker.LoadConfig'?new()/>
<#assign findKey='com.hp.ccue.serviceExchange.adapter.freemarker.FindKeyForValue'?new()/>
<#assign findExtSystemForAlias='com.hp.ccue.serviceExchange.adapter.freemarker.caseex.FindExternalSystemForAlias'?new() />
<#assign sanitize='com.hp.ccue.serviceExchange.adapter.freemarker.StringSanitizer'?new()/>

<#assign sawMapping=loadConfig(context.contentStorage, "saw-case-exchange/saw-mappings") />
<#assign hpiMapping=loadConfig(context.contentStorage, "saw-case-exchange/hpi-saw-mappings") />

<#assign entityChange=message.entityChange />
<#assign entityProperties=entityChange.entity.properties />
<#assign attachments=parseJson(entityProperties.IncidentAttachments) />
<#-- Handle the description so that the final result is *not* empty -->
<#assign sanitizedDescription=sanitize(entityProperties.Description) />
<#if sanitizedDescription == "">
    <#assign description=" " />
<#else>
    <#assign description=sanitizedDescription />
</#if>
<#assign entityAssign=message.entityChange.entity.related_properties.AssignedToGroup />
<#assign entityRelated=message.entityChange.entity.related_properties.RequestedForPerson />
<#assign entChangeProperties=message.entityChange.entity.properties />

<#macro compress_single_line><#local captured><#nested></#local>${ captured?replace("^\\s+|\\s+$|\\n|\\r", " ", "rm") }</#macro>

<#escape x as x?json_string>
{
  <#--this does not belong to canonical model! TODO: remove after we have no OO anymore-->
  "event": "${entityChange.changeReason}",

  <#-- *** CANONICAL MODEL BEGIN *** -->
  "entity": {
    "instanceType": "${entityChange.instanceType}",
    "instance": "${entityChange.instance}",
    "entityType": "Request",
    "SourceEntityId": "${entityChange.entityId}",
    "properties": {
        <#-- ${writeJson(entityProperties, true)}, -->
        "Title":"${entityProperties.DisplayLabel}",
        "Description": "<@compress_single_line>${description}</@compress_single_line>",
        "Urgency": "${findKey(sawMapping.Incident.Urgency, entityProperties.Urgency)}",
        "Priority": "${findKey(sawMapping.Request.Priority, entityProperties.Priority)}",      
        "Status": "${getCanonicalModelStatus(entityProperties.Status, entityProperties.PhaseId!"", entityProperties.CompletionCode!"")}",
        "OriginalStatus": "${entityProperties.Status}",
        "Impact": "${findKey(sawMapping.Incident.Impact, entityProperties.ImpactScope)}",
        <#if entityProperties.Solution??>
        "Solution": "<@compress_single_line>${sanitize(entityProperties.Solution!"???")}</@compress_single_line>",
        </#if>
        <#if entityProperties.CompletionCode??>
        "CompletionCode": "${entityProperties.CompletionCode}",
        </#if>
        <#-- CUSTOM MAPPING FIELDS START-->
  	<#if entityAssign.Name??>
  	"AssignmentGroup":"${entityAssign.Name}",
  	</#if>
  	<#if entChangeProperties.PhaseId??>
  	"SAWPhaseID":"${entChangeProperties.PhaseId}",
  	</#if>
 	"GSEMAgentKey":"${hpiMapping.GSEMKeys.GSEMAgentKey}",
  	"GSEMPlatformType":"${hpiMapping.GSEMKeys.GSEMPlatformType}",
  	"GSEMRemoteAgentName":"${hpiMapping.GSEMKeys.GSEMRemoteAgentName}",
  	<#if entChangeProperties.ContractId??>
  	"ContractId":"${entChangeProperties.ContractId}",
  	</#if>	
  	<#if entChangeProperties.Company??>
  	"Company":"${entChangeProperties.Company}",
  	</#if>
  	<#if entChangeProperties.Address??>
  	"AddressLine1":"${entChangeProperties.Address}",
  	</#if>
  	<#if entChangeProperties.City??>
  	"City":"${entChangeProperties.City}",
  	</#if>
  	<#if entChangeProperties.Country??>
  	"Country":"${entChangeProperties.Country}",
  	</#if>
  	<#if entChangeProperties.State??>
  	"State":"${entChangeProperties.State}",
  	</#if>
  	<#if entChangeProperties.ZipCode??>
  	"ZipCode":"${entChangeProperties.ZipCode}",
  	</#if>
  	<#if entChangeProperties.SerialNum??>
  	"SerialNum":"${entChangeProperties.SerialNum}",
  	</#if>
  	<#if entChangeProperties.ProductNum??>
  	"ProductNum":"${entChangeProperties.ProductNum}",
  	</#if>	
  	<#if entityRelated.FirstName??>
  	"PrimaryContactFirstName":"${entityRelated.FirstName}",
  	</#if>
  	<#if entityRelated.LastName??>
  	"PrimaryContactLastName":"${entityRelated.LastName}",
  	</#if>
  	<#if entityRelated.Email??>
  	"PrimaryContactEmail":"${entityRelated.Email}",
  	</#if>
  	<#if entityRelated.HomePhoneNumber??>
  	"PrimaryContactPhone":"${entityRelated.HomePhoneNumber}",
  	</#if>
  	<#-- CUSTOM MAPPING FIELDS END-->

        "Attachments": [
            <#if (attachments.complexTypeProperties)?has_content>
                <#list attachments.complexTypeProperties as attachment>
                <#assign attachmentProperties=attachment.properties/>
                {
                    "@orderBy": "${attachmentProperties.id}",
                    "id": "${attachmentProperties.id}",
                    "name": "${attachmentProperties.file_name}",
                    "type": "${attachmentProperties.mime_type}",
                    "lastModified": ${attachmentProperties.LastUpdateTime?string("0")},
                    "size": ${attachmentProperties.size?string("0")}
                }<#if attachment_has_next>,</#if>
                </#list>
            </#if>
        ],
        <#if (entityChange.entity.Comments)??>
            "Comments": [
            <#assign firstComment = true />
            <#list entityChange.entity.Comments as comment>
                <#if !comment.IsSystem>
                    <#if !firstComment>,</#if>

                    <#assign commentBody = comment.Body />
                    <#assign isCommentExternal = commentBody?matches("\\(\\s([0-9]*).*?\\):( .+)") />
                    <#if isCommentExternal>
                        <#assign commentBody = isCommentExternal?groups[2]?trim />
                        <#assign externalCommentTime = isCommentExternal?groups[1] />
                    </#if>
                    <#assign commentOperator = comment.Submitter.UserId/>
                    <#assign commentOperatorMatch = commentOperator?matches(".*/([0-9]+)")/>
                    <#if commentOperatorMatch>
                        <#assign commentOperator = commentOperatorMatch?groups[1] />
                    </#if>

                <#--"CommentId": "53967416-53c9-48ab-b298-e1bd3cc4692f",-->
                <#--"Submitter": "Person/10016",-->
                <#--"IsSystem": false,-->
                <#--"CreateTime": 1458123073512,-->
                <#--"UpdateTime": 0,-->
                <#--"CommentBody": "( April 24, 2014 5:00 PM PST - John Smith - mpavmsm11 ): Assigned to Central IT.",-->
                <#--"PrivacyType": "PUBLIC",-->
                <#--"ActualInterface": "API",-->
                <#--"CommentFrom": "ExternalServiceDesk"-->

                {
                    "@orderBy": "${comment.Id}",
                    "id": "${comment.Id}",
                    "type": "",
                    "completeDescription": "${comment.Body}",
                    "description": "<@compress_single_line>${sanitize(commentBody)}</@compress_single_line>",
                    "isCustVisible": <#if comment.PrivacyType == "PUBLIC">true<#else>false</#if>,
                    "createdAt": <#if externalCommentTime?has_content>${externalCommentTime}<#elseif comment.CreateTime??>${comment.CreateTime?string["0"]}<#else>""</#if>,
                    "operator": "${commentOperator}"
                }
                    <#assign firstComment = false />
                </#if>
            </#list>
        </#if>
        ]
    }
    <#-- *** CANONICAL MODEL END *** -->
  },

  <#assign alias=findExtSystemForAlias(context.appContext, entityChange.instanceType, entityChange.instance, entityChange.data.externalInstanceAlias)!"" />
  <#if alias?has_content>
  <#-- this section actually drives the initial clone: it determines whether/where the above entity should be cloned to -->
  "linkedEntity": {
      "instanceAlias": "${entityChange.data.externalInstanceAlias}",
      "instanceType": "${alias.targetInstanceType}",
      <#if message.entityChange.ExternalReference.entity_type??>
      "entityType": "request",
      </#if>
      <#if message.entityChange.ExternalReference.properties.ExternalId??>
      "entityId": "${message.entityChange.ExternalReference.properties.ExternalId}",
      </#if>
      <#if message.entityChange.ExternalReference.properties.ExternalStatus??>
      "Status": "${message.entityChange.ExternalReference.properties.ExternalStatus}",
      </#if>
      "instance": "${alias.targetInstance}"
  },
  </#if>

  <#-- clean input message -->
  "entityChange": {}
}
</#escape>