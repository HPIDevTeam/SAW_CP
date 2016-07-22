<#macro compress_single_line><#local captured><#nested></#local>${ captured?replace("^\\s+|\\s+$|\\n|\\r", " ", "rm") }</#macro>
<#escape x as x?json_string>

<#assign writeJson='com.hp.ccue.serviceExchange.adapter.freemarker.WriteJson'?new()/>
<#assign findKey='com.hp.ccue.serviceExchange.adapter.freemarker.FindKeyForValue'?new()/>
<#assign findAliasForExtSystem='com.hp.ccue.serviceExchange.adapter.freemarker.caseex.FindAliasForExternalSystem'?new() />
<#assign sanitize='com.hp.ccue.serviceExchange.adapter.freemarker.StringSanitizer'?new()/>
<#assign localize='com.hp.ccue.serviceExchange.adapter.saw.util.SXSAWImplProperties'?new()/>
<#assign loadConfig='com.hp.ccue.serviceExchange.adapter.freemarker.LoadConfig'?new()/>
<#assign instances=loadConfig(context.configuration, "saw/instances") />


<#assign sawMapping=loadConfig(context.contentStorage, "saw-case-exchange/saw-mappings") />

<#assign entity=message.args.entity />
<#assign linkedEntity=message.args.linkedEntity />
<#assign properties=entity.properties />
{
    "entities": [
        {
            "entity_type": "Incident",
            "properties": {
                "DisplayLabel": "${properties.Title}",
                "Description": <#noescape>${writeJson(properties.Description)}</#noescape>,
                <#if message.args.event?? && (message.args.event == "incidentResolved" || message.args.event == "incidentCancelled" || message.args.event == "incidentClosed")>
                    "Solution": "<@compress_single_line>${sanitize(properties.Solution!localize(context.targetInstance,instances,"DID_NOT_FILL_SOLUTION"))}</@compress_single_line>",
                    <#if properties.CompletionCode?? && message.args.event == "incidentResolved" >
                    "CompletionCode": "${sawMapping.Incident.CompletionCodeFromCanonical[properties.CompletionCode]}",
                    </#if>
                    <#if message.args.event == "incidentCancelled" >
                    "CompletionCode": "WithdrawnbyUser",
                    </#if>
                </#if>
                "ImpactScope": "${sawMapping.Incident.Impact[properties.Impact]}",
                "Urgency": "${sawMapping.Incident.Urgency[properties.Urgency]}",
                "RegisteredForActualService": "${instanceConfig.defaultRegisteredForActualService}",
                "Category": "${instanceConfig.defaultCategory}",
                "IncidentAttachments": "{\"complexTypeProperties\":[]}"
        },
            "Comments": [
    <#if message.MergedComments??>
        <#list message.MergedComments as comment>
        {
        "CreatedTime": ${comment.createdAt?string["0"]},
        "IsSystem": true,
        "Body": "${comment.description}",
        "PrivacyType": <#if comment.isCustVisible>"PUBLIC"<#else>"PRIVATE"</#if>
        }
            <#if comment_has_next>,</#if>
        </#list>
    </#if>
            ],
            "ext_properties": {
                "ExternalSystem": "${findAliasForExtSystem(context.appContext, linkedEntity.instanceType, linkedEntity.instance, entity.instanceType, entity.instance)}",
                "Operation": "Create",
                "ExternalId": "${entity.entityId}",
                "ExternalEntityType": "${entity.entityType}",
                "ExternalStatus": "${properties.OriginalStatus!properties.Status}"
            }
        }
    ]
}

</#escape>