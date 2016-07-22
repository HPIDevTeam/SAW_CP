<#-- @ftlvariable name="message" type="java.util.Map" -->
<#-- @ftlvariable name="context" type="java.util.Map" -->
<#-- @ftlvariable name="loadConfig" type="com.hp.ccue.serviceExchange.adapter.freemarker.LoadConfig" -->
<#-- @ftlvariable name="parseJson" type="com.hp.ccue.serviceExchange.adapter.freemarker.ParseJson" -->
<#-- @ftlvariable name="sanitize" type="com.hp.ccue.serviceExchange.adapter.freemarker.StringSanitizer" -->
<#-- @ftlvariable name="findKey" type="com.hp.ccue.serviceExchange.adapter.freemarker.FindKeyForValue" -->
<#-- @ftlvariable name="findExtSystemForAlias" type="com.hp.ccue.serviceExchange.adapter.freemarker.caseex.FindExternalSystemForAlias" -->

<#assign writeJson='com.hp.ccue.serviceExchange.adapter.freemarker.WriteJson'?new()/>
<#assign parseJson='com.hp.ccue.serviceExchange.adapter.freemarker.ParseJson'?new()/>
<#assign loadConfig='com.hp.ccue.serviceExchange.adapter.freemarker.LoadConfig'?new()/>
<#assign findKey='com.hp.ccue.serviceExchange.adapter.freemarker.FindKeyForValue'?new()/>
<#assign findExtSystemForAlias='com.hp.ccue.serviceExchange.adapter.freemarker.caseex.FindExternalSystemForAlias'?new() />
<#assign sanitize='com.hp.ccue.serviceExchange.adapter.freemarker.StringSanitizer'?new()/>

<#assign sawMapping=loadConfig(context.contentStorage, "saw-case-exchange/saw-mappings") />

<#assign entityChange=message.entityChange />
<#assign data=entityChange.data />
<#assign entityProperties=data.response.properties />
<#assign extProperties=data.response.ext_properties />

<#assign entChangeProperties=entityChange.entity.properties />
<#assign entityRelated=entityChange.entity.related_properties />

<#assign attachments=parseJson(data.response.properties.IncidentAttachments) />
<#-- Handle the description so that the final result is *not* empty -->
<#assign sanitizedDescription=sanitize(entityProperties.Description) />
<#if sanitizedDescription == "">
    <#assign description=" " />
<#else>
    <#assign description=sanitizedDescription />
</#if>

<#macro compress_single_line><#local captured><#nested></#local>${ captured?replace("^\\s+|\\s+$|\\n|\\r", " ", "rm") }</#macro>

<#escape x as x?json_string>
{
  "event": "${entityChange.changeReason}",

  <#-- *** CANONICAL MODEL BEGIN *** -->
  "entity": {
    "instanceType": "${entityChange.instanceType}",
    "instance": "${entityChange.instance}",
    "entityType": "Incident",
    "entityId": "${entityChange.entityId}",
    "properties": {
        <#-- ${writeJson(entityProperties, true)}, -->
        "Title":"${entityProperties.DisplayLabel}"
        ,"Description": "<@compress_single_line>${description}</@compress_single_line>"
        ,"Urgency": "${findKey(sawMapping.Incident.Urgency, entityProperties.Urgency)}"
        ,"Status": "${findKey(sawMapping.Incident.Status, entityProperties.Status)}"
        ,"OriginalStatus": "${entityProperties.Status}"
        ,"Impact": "${findKey(sawMapping.Incident.Impact, entityProperties.ImpactScope)}"
        <#if entityProperties.Solution??>,"Solution": "<@compress_single_line>${sanitize(entityProperties.Solution!"???")}</@compress_single_line>"</#if>
        <#if entityProperties.CompletionCode??>
        ,"CompletionCode": "${sawMapping.Incident.CompletionCodeToCanonical[entityProperties.CompletionCode]}"
        </#if>
		
		<#-- CUSTOM MAPPING FIELDS START-->
		<#if entityRelated.AssignedGroup.Name??>
        ,"AssignmentGroup":"${entityRelated.AssignedGroup.Name}"
		</#if>
		,"GSEMAgentKey":"GSEMAgentKey"
		,"GSEMPlatformType":"GSEMPlatformType"
		,"GSEMRemoteAgentName":"GSEMRemoteAgentName"
		,"ContractId":"ContractId"
		,"Company":"Company"
		<#if entChangeProperties.Address??>
		,"AddressLine1":"${entChangeProperties.Address}"
		</#if>
		<#if entChangeProperties.City??>
		,"City":"${entChangeProperties.City}"
		</#if>
		<#if entChangeProperties.Country??>
		,"Country":"${entChangeProperties.Country}"
		</#if>
		<#if entChangeProperties.State??>
		,"State":"${entChangeProperties.State}"
		</#if>
		<#if entChangeProperties.ZipCode??>
		,"ZipCode":"${entChangeProperties.ZipCode}"
		</#if>
		,"SerialNum":"SerialNum"
		,"ProductNum":"ProductNum"
		<#if entityRelated.RequestedByPerson.FirstName??>
		,"PrimaryContactFirstName":"${entityRelated.RequestedByPerson.FirstName}"
		</#if>
		<#if entityRelated.RequestedByPerson.LastName??>
		,"PrimaryContactLastName":"${entityRelated.RequestedByPerson.LastName}"
		</#if>
		<#if entityRelated.RequestedByPerson.Email??>
		,"PrimaryContactEmail":"${entityRelated.RequestedByPerson.Email}"
		</#if>
		<#if entityRelated.RequestedByPerson.HomePhoneNumber??>
		,"PrimaryContactPhone":"${entityRelated.RequestedByPerson.HomePhoneNumber}"
		</#if>
		<#-- CUSTOM MAPPING FIELDS END-->
		
        ,"Attachments": [
            <#if attachments.complexTypeProperties?? && attachments.complexTypeProperties?has_content>
                <#list attachments.complexTypeProperties as attachment>
                <#assign attachmentProperties=attachment.properties/>
                {
                    "@orderBy": "${attachmentProperties.id}",
                    "id": "${attachmentProperties.id}",
                    "name": "${attachmentProperties.file_name}",
                    "type": "${attachmentProperties.mime_type}",
                    "size": ${attachmentProperties.size?string("0")}
                }<#if attachment_has_next>,</#if>
                </#list>
            </#if>
        ]
        ,"Comments": [
            <#if entityChange.entity.Comments??>
                <#assign firstComment = true />
                    <#list entityChange.entity.Comments as comment>
                    <#if !comment.IsSystem>
                        <#if !firstComment>,</#if>

                        <#assign commentBody = comment.Body />
                        <#assign isCommentExternal = commentBody?matches("\\(\\s([0-9]*).*?\\):.*") />
                        <#if isCommentExternal>
                            <#assign commentBody = commentBody?substring(commentBody?index_of("):") + 2)?trim />
                            <#assign externalCommentTime = isCommentExternal?groups[1] />
                        </#if>

                    {
                    "@orderBy": "${comment.Id}",
                    "id": "${comment.Id}",
                    "type": "",
                    "completeDescription": "${comment.Body}",
                    "description": "<@compress_single_line>${sanitize(commentBody)}</@compress_single_line>",
                    "isCustVisible": <#if comment.PrivacyType == "PUBLIC">true<#else>false</#if>,
                    "createdAt": <#if isCommentExternal>${externalCommentTime}<#else>${comment.CreatedTime?string["0"]}</#if>,
                    "operator": "${comment.Submitter.UserId}"
                    }
                        <#assign firstComment = false />
                    </#if>
                    </#list>
            </#if>
        ]
    }
    <#-- *** CANONICAL MODEL END *** -->

  },
  "linkedEntity": {
    <#-- "initiator": we-dont-know, -->
    "instanceAlias": "${data.externalInstanceAlias}",
    <#assign alias=findExtSystemForAlias(context.appContext, entityChange.instanceType, entityChange.instance, data.externalInstanceAlias)!"" />
    <#if alias?has_content>
      "instanceType": "${alias.targetInstanceType}",
      "instance": "${alias.targetInstance}",
    </#if>
    <#if extProperties.ExternalEntityType??>"entityType": "${extProperties.ExternalEntityType}",</#if>
    <#if extProperties.ExternalId??>"entityId": "${extProperties.ExternalId}",</#if>
    "properties": {
        "Attachments": []
      <#if entityChange.ExternalReference?? && entityChange.ExternalReference.properties.ExternalStatus??>,"Status": "${entityChange.ExternalReference.properties.ExternalStatus}"</#if>
    }
  },

  <#-- TODO find better way to clean input message -->
  "entityChange": ""
}
</#escape>