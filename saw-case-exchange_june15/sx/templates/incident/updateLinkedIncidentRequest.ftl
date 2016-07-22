<#macro compress_single_line><#local captured><#nested></#local>${ captured?replace("^\\s+|\\s+$|\\n|\\r", " ", "rm") }</#macro>

<#escape x as x?json_string>

    <#assign writeJson='com.hp.ccue.serviceExchange.adapter.freemarker.WriteJson'?new()/>
    <#assign loadConfig='com.hp.ccue.serviceExchange.adapter.freemarker.LoadConfig'?new()/>
    <#assign findAliasForExtSystem='com.hp.ccue.serviceExchange.adapter.freemarker.caseex.FindAliasForExternalSystem'?new() />
    <#assign sanitize='com.hp.ccue.serviceExchange.adapter.freemarker.StringSanitizer'?new()/>
    <#assign localize='com.hp.ccue.serviceExchange.adapter.saw.util.SXSAWImplProperties'?new()/>
    <#assign instances=loadConfig(context.configuration, "saw/instances") />

    <#assign entitiesMapping=loadConfig(context.configuration, "saw/entities") />
    <#assign sawMapping=loadConfig(context.contentStorage, "saw-case-exchange/saw-mappings") />

    <#assign entity=message.args.entity />
    <#assign linkedEntity=message.args.linkedEntity />
    <#assign properties=entity.properties />

{
    "newEntity":{
        "entity":{
            "entity_type": "Incident",
            "properties": {
                "Id": "${linkedEntity.entityId}"
                <#if properties.Title??>
                ,"DisplayLabel": "${properties.Title}"
                </#if>
                ,"Description": "<@compress_single_line>${sanitize(properties.Description)}</@compress_single_line>"
                <#if message.args.event?? && (message.args.event == "incidentResolved" || message.args.event == "incidentCancelled")>
                  ,"Solution": "<@compress_single_line>${sanitize(properties.Solution!localize(context.targetInstance,instances,"DID_NOT_FILL_SOLUTION"))}</@compress_single_line>"
                  <#if properties.CompletionCode?? && message.args.event == "incidentResolved" >
                  ,"CompletionCode": "${sawMapping.Incident.CompletionCodeFromCanonical[properties.CompletionCode]}"
                  </#if>
                  <#if message.args.event == "incidentCancelled" >
                  ,"CompletionCode": "WithdrawnbyUser"
                  </#if>
                </#if>
                <#if properties.Impact??>
                ,"ImpactScope": "${sawMapping.Incident.Impact[properties.Impact]}"
                </#if>
                <#if properties.Urgency??>
                ,"Urgency": "${sawMapping.Incident.Urgency[properties.Urgency]}"
                </#if>
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
                "Operation": "Update",
                "ExternalStatus": "${properties.Status}"
            }
        }
    }
}

</#escape>
