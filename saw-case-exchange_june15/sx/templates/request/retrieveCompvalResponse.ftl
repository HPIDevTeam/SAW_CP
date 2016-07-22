<#assign writeJson='com.hp.ccue.serviceExchange.adapter.freemarker.WriteJson'?new()/>
<#escape x as x?json_string>
{
  <#if (doc.result.meta.total_count > 0)>
  "entityChange": {
    "entity": {
	"properties" : {
        "Company": <#noescape>${writeJson(doc.result.entities[0].properties.DisplayLabel)}</#noescape>
        ,"ContractId": <#noescape>${writeJson(doc.result.entities[0].properties.ContractId_c)}</#noescape>
	}
    }
  }

  </#if>
}
</#escape>