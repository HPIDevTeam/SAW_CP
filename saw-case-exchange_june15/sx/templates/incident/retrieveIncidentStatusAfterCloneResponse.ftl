<#escape x as x?json_string>
{
<#if doc.result.entities?? && doc.result.entities[0]?? && doc.result.entities[0].properties.Status?has_content>
  "args": {
    "linkedEntity": {
      "properties": {
        "Status": "${doc.result.entities[0].properties.Status}"
      }
    }
  }
</#if>
}
</#escape>