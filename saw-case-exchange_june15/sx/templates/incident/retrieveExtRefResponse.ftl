<#assign writeJson='com.hp.ccue.serviceExchange.adapter.freemarker.WriteJson'?new()/>
<#escape x as x?json_string>
{
  <#if (doc.result.meta.total_count > 0)>
  "entityChange": {
    "ExternalReference": <#noescape>${writeJson(doc.result.entities[0])}</#noescape>
  }
  </#if>
}
</#escape>