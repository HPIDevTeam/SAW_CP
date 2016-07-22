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
                "Id": "${linkedEntity.entityId}",
                "CompletionCode": "RequestRejected",
                "Solution": "<@compress_single_line>${sanitize(properties.Solution!localize(context.targetInstance,instances,"DID_NOT_FILL_SOLUTION"))}</@compress_single_line>"
            },
            "Comments": [],
            "ext_properties": {
                "ExternalSystem": "${findAliasForExtSystem(context.appContext, linkedEntity.instanceType, linkedEntity.instance, entity.instanceType, entity.instance)}",
                "ExternalId":"",
                "ExternalEntityType": "",
                "Operation": "Reject",
                "ExternalStatus": ""
            }
        }
    }
}

</#escape>
