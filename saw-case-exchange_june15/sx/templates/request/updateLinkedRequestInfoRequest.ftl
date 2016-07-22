<#escape x as x?json_string>
<#assign writeJson='com.hp.ccue.serviceExchange.adapter.freemarker.WriteJson'?new()/>
<#assign loadConfig='com.hp.ccue.serviceExchange.adapter.freemarker.LoadConfig'?new()/>
<#assign entity=message.args.entity />
<#assign oldEntity=message.oldEntity.entity />
<#assign linkedEntity=message.args.linkedEntity />
<#assign properties=entity.properties />
<#if
    oldEntity.ext_properties.ExternalSystem!=linkedEntity.instanceAlias ||
    oldEntity.ext_properties.ExternalId!=linkedEntity.entityId ||
    oldEntity.ext_properties.ExternalStatus!=linkedEntity.properties.Status
>
{
    "entities": [
        {
            "entity_type": "Request",
            "properties": {
                "Id": "${entity.SourceEntityId}",
                "ExternalProcessReference":"${linkedEntity.entityId}"
            },
            "Comments": [
                    {
			<#assign aDateTime = .now>
                        "CreatedTime": "${aDateTime}",
                        "IsSystem": true,
                        "Body": "${linkedEntity.GSEMErrorMessage}",
                        "PrivacyType": "PUBLIC"
                    }
            ],
            "ext_properties": {
                "ExternalSystem": "${linkedEntity.instanceAlias}",
                "Operation": "Update",
                "ExternalId": "${linkedEntity.entityId}",
                "ExternalEntityType": "${entity.entityType}",
                "ExternalStatus": "${linkedEntity.properties.Status}"
            }
        }
    ]
}
</#if>
</#escape>