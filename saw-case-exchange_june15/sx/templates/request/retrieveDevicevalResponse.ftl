<#assign writeJson='com.hp.ccue.serviceExchange.adapter.freemarker.WriteJson'?new()/>
<#escape x as x?json_string>
{
  <#if (doc.result.meta.total_count > 0)>
  "entityChange": {
    "entity": {
	"properties" : {
        "SerialNum": <#noescape>${writeJson(doc.result.entities[0].properties.SerialNumber)}</#noescape>
        ,"ProductNum": <#noescape>${writeJson(doc.result.entities[0].properties.ProductNum_c)}</#noescape>
        	}
    }
  }

  </#if>
}
</#escape>