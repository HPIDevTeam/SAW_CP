<#-- @ftlvariable name="message" type="java.util.Map" -->
<#-- @ftlvariable name="context" type="java.util.Map" -->
<#-- @ftlvariable name="loadConfig" type="com.hp.ccue.serviceExchange.adapter.freemarker.LoadConfig" -->
<#-- @ftlvariable name="findAliasForExtSystem" type="com.hp.ccue.serviceExchange.adapter.freemarker.caseex.FindAliasForExternalSystem" -->
<#-- @ftlvariable name="writeJson" type="com.hp.ccue.serviceExchange.adapter.freemarker.WriteJson" -->
<#-- @ftlvariable name="parseJson" type="com.hp.ccue.serviceExchange.adapter.freemarker.ParseJson" -->

<#setting number_format="0">

<#assign findAliasForExtSystem='com.hp.ccue.serviceExchange.adapter.freemarker.caseex.FindAliasForExternalSystem'?new() />
<#assign loadConfig='com.hp.ccue.serviceExchange.adapter.freemarker.LoadConfig'?new()/>
<#assign writeJson='com.hp.ccue.serviceExchange.adapter.freemarker.WriteJson'?new()/>
<#assign parseJson='com.hp.ccue.serviceExchange.adapter.freemarker.ParseJson'?new()/>
<#assign sawMapping=loadConfig(context.contentStorage, "saw-case-exchange/saw-mappings") />
<#assign entity=message.args.entity />
<#assign linkedEntity=message.args.linkedEntity />
<#assign attachmentInfo=message.attachmentInfo />
<#assign attachmentName=attachmentInfo.name />
<#assign attachmentExtension=attachmentName?substring(attachmentName?last_index_of(".") + 1) />
<#assign attachmentLastModified=attachmentInfo.lastModified />
<#assign attachmentSize=attachmentInfo.size />
<#assign existingAttachments=parseJson(message.targetAttachments).complexTypeProperties![] />
<#assign newAttachment={
    "properties": {
        "id": attachmentInfo.id,
        "file_name": attachmentName,
        "file_extension": attachmentExtension,
        "size": attachmentSize,
        "mime_type": attachmentInfo.mimeType,
        "Creator": attachmentInfo.creator,
        "LastUpdateTime": attachmentLastModified
    }
} />
<#assign newAttachments=[] />
<#if message.targetAttachmentExists>
    <#list existingAttachments as existingAttachment>
        <#if existingAttachment.properties.file_name == attachmentName>
            <#-- Replace the original attachment corresponding to the processed one with up-to-date information -->
            <#assign newAttachments=newAttachments + [newAttachment] />
        <#else>
            <#assign newAttachments=newAttachments + [existingAttachment] />
        </#if>
    </#list>
<#else>
    <#assign newAttachments=existingAttachments + [newAttachment] />
</#if>

<#escape x as x?json_string>
{
    "entities": [{
        "entity_type": "Incident",
        "properties": {
            "Id": "${linkedEntity.entityId}",

            <#--noinspection FtlReferencesInspection-->
            "IncidentAttachments":<@compress single_line=true>
                "{\"complexTypeProperties\":[
                <#list newAttachments as newAttachment>
                    <#assign attachmentProps=newAttachment.properties />
                    {
                        \"properties\": {
                            \"id\": \"${attachmentProps.id}\",
                            \"file_name\": \"${attachmentProps.file_name}\",
                            \"file_extension\": \"${attachmentProps.file_extension}\",
                            \"size\": ${attachmentProps.size?string},
                            \"mime_type\": \"${attachmentProps.mime_type}\",
                            \"Creator\": \"${attachmentProps.Creator}\",
                            \"LastUpdateTime\": ${attachmentProps.LastUpdateTime?string}
                        }
                    }<#if newAttachment_has_next>,</#if>
                </#list>
                ]}"
            </@compress>
        },
        "ext_properties": {
            "ExternalSystem":"${findAliasForExtSystem(context.appContext, linkedEntity.instanceType, linkedEntity.instance, entity.instanceType, entity.instance)}",
            "Operation": "Update"
        }
    }]
}
</#escape>
