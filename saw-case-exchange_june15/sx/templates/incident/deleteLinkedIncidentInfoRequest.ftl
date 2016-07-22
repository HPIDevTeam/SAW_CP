<#escape x as x?json_string>

<#assign writeJson='com.hp.ccue.serviceExchange.adapter.freemarker.WriteJson'?new()/>
<#assign loadConfig='com.hp.ccue.serviceExchange.adapter.freemarker.LoadConfig'?new()/>

<#assign entity=message.args.entity />
<#assign linkedEntity=message.args.linkedEntity />
<#assign properties=entity.properties />
{
    "entities": [
        {
            "entity_type": "Incident",
            "properties": {
                "Id": "${entity.entityId}"
            },
            "Comments": [],
            "ext_properties": {
                "ExternalSystem": "${linkedEntity.instanceAlias}",
                "Operation": "Reject",
                "ExternalId": "",
                "ExternalEntityType": "",
                "ExternalStatus": ""
            }
        }
    ]
}

</#escape>