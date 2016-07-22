<#assign writeJson='com.hp.ccue.serviceExchange.adapter.freemarker.WriteJson'?new()/>
<#escape x as x?json_string>
{
  <#if (doc.result.meta.total_count > 0)>
  "oldEntity": {
      "entity": {
             "ext_properties": {
                  "ExternalSystem" : "${doc.result.entities[0].related_properties.ExternalSystem.SystemId!""}",
                  "ExternalId" : "${doc.result.entities[0].properties.ExternalId!""}",
                  "ExternalStatus" : "${doc.result.entities[0].properties.ExternalStatus!""}"
             }
      }
  }
  </#if>
}
</#escape>
