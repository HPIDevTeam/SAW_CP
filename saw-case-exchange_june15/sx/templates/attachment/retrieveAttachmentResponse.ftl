<#-- @ftlvariable name="message" type="java.util.Map" -->
<#-- @ftlvariable name="doc" type="java.util.Map" -->
<#-- @ftlvariable name="parseJson" type="com.hp.ccue.serviceExchange.adapter.freemarker.ParseJson" -->
<#-- @ftlvariable name="writeJson" type="com.hp.ccue.serviceExchange.adapter.freemarker.WriteJson" -->

<#assign parseJson='com.hp.ccue.serviceExchange.adapter.freemarker.ParseJson'?new()/>
<#assign writeJson='com.hp.ccue.serviceExchange.adapter.freemarker.WriteJson'?new()/>
<#assign sourceAttachment=message.messageArgs.attachment />
<#assign srcName=sourceAttachment.name />
<#assign srcSize=sourceAttachment.size />
<#assign targetAttachments=parseJson(doc.result.entities[0].properties.IncidentAttachments) />

<#-- Iterate over existing attachments in target system and try to find an attachment matching the source system attachment -->
<#assign targetAttachmentIdentical=false />
<#assign targetAttachmentExists=false />
<#list targetAttachments.complexTypeProperties![] as tgtAttachment>
    <#assign tgtAttachmentProperties=tgtAttachment.properties />
    <#if tgtAttachmentProperties.file_name == srcName>
        <#assign targetAttachmentExists=true />
        <#if tgtAttachmentProperties.size == srcSize>
            <#assign targetAttachmentIdentical=true />
        </#if>
    </#if>
</#list>

<#escape x as x?json_string>
{
    "targetAttachmentExists": ${targetAttachmentExists?c},
    "targetAttachmentIdentical": ${targetAttachmentIdentical?c},
    "targetAttachments": "${writeJson(targetAttachments)}"
}
</#escape>
