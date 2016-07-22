<#assign writeJson='com.hp.ccue.serviceExchange.adapter.freemarker.WriteJson'?new()/>

<#escape x as x?json_string>
{
  "entityChange": {
    "entity": <#noescape>${writeJson(doc.result.entities[0])}</#noescape>

  }
}
</#escape>