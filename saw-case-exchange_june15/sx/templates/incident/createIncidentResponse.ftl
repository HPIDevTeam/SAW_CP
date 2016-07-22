<#assign loadConfig='com.hp.ccue.serviceExchange.adapter.freemarker.LoadConfig'?new()/>
<#assign sawMapping=loadConfig(context.contentStorage, "saw-case-exchange/saw-mappings") />
<#assign findKey='com.hp.ccue.serviceExchange.adapter.freemarker.FindKeyForValue'?new()/>

{
  "args": {
    "linkedEntity": {
      "entityType": "${findKey(sawMapping.entityType, doc.result.entities[0].entity.entity_type)}",
      "entityId": "${doc.result.entities[0].entity.properties.Id}",
      "properties": {
        "Status": "Ready"
      }
    }
  },
  "tmp": {
    "sawEntityType": "${doc.result.entities[0].entity.entity_type}",
    "sawEntityId": "${doc.result.entities[0].entity.properties.Id}"
  }
}