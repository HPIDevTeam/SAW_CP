<#assign writeJson='com.hp.ccue.serviceExchange.adapter.freemarker.WriteJson'?new()/>
<#escape x as x?json_string>
{
    "entities": <#noescape>${writeJson(doc.result.entities)}</#noescape>,
    "Date": "${doc.resultHeaders.Date}"
}
</#escape>