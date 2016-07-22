<#assign writeJson='com.hp.ccue.serviceExchange.adapter.freemarker.WriteJson'?new()/>
<#escape x as x?json_string>
{
  "entityChange": {
    "entity": {
        "Comments": <#noescape>${writeJson(doc.result.Comments)}</#noescape>
    }
  }
}
</#escape>