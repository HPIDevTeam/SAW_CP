<#macro compress_single_line><#local captured><#nested></#local>${ captured?replace("^\\s+|\\s+$|\\n|\\r", " ", "rm") }</#macro>

<#escape x as x?json_string>

    <#assign writeJson='com.hp.ccue.serviceExchange.adapter.freemarker.WriteJson'?new()/>
    <#assign loadConfig='com.hp.ccue.serviceExchange.adapter.freemarker.LoadConfig'?new()/>
    <#assign findAliasForExtSystem='com.hp.ccue.serviceExchange.adapter.freemarker.caseex.FindAliasForExternalSystem'?new() />
    <#assign sanitize='com.hp.ccue.serviceExchange.adapter.freemarker.StringSanitizer'?new()/>

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
                <#if properties.CompletionCode??>
                ,"CompletionCode": "${sawMapping.Incident.CompletionCodeFromCanonical[properties.CompletionCode]}"
                </#if>
                <#if properties.Solution??>
                ,"Solution": "<@compress_single_line>${sanitize(properties.Solution)}</@compress_single_line>"
                </#if>
            },
            "Comments": [],
            "ext_properties": {
                "ExternalSystem": "${findAliasForExtSystem(context.appContext, linkedEntity.instanceType, linkedEntity.instance, entity.instanceType, entity.instance)}",
                "Operation": "Close",
                "ExternalStatus": "${properties.Status}"
            }
        }
    }
}

</#escape>
