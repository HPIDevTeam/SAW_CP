<#assign writeJson='com.hp.ccue.serviceExchange.adapter.freemarker.WriteJson'?new()/>
<#escape x as x?json_string>
{
  <#if (doc.result.meta.total_count > 0)>
  "entityChange": {
    "entity": {
	"properties" : {
        "Address": <#noescape>${writeJson(doc.result.entities[0].properties.Address)}</#noescape>
        ,"City": <#noescape>${writeJson(doc.result.entities[0].properties.City)}</#noescape>
        ,"Country": <#noescape>${writeJson(doc.result.entities[0].properties.Country)}</#noescape>
        ,"State": <#noescape>${writeJson(doc.result.entities[0].properties.State)}</#noescape>
        ,"ZipCode": <#noescape>${writeJson(doc.result.entities[0].properties.PostalCode)}</#noescape>
	}
    }
  }

  </#if>
}
</#escape>