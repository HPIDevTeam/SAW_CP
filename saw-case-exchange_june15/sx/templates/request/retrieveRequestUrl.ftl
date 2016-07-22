<#-- @ftlvariable name="instanceConfig" type="java.util.Map" -->
<#-- @ftlvariable name="message" type="java.util.Map" -->

<#include "ZConstants.ftl"/>

<#assign loadConfig='com.hp.ccue.serviceExchange.adapter.freemarker.LoadConfig'?new()/>
<#assign entitiesMapping=loadConfig(context.configuration, "saw/entities") />
<#assign sawMapping=loadConfig(context.contentStorage, "saw-case-exchange/saw-mappings") />

<#escape x as x?url>
<#noescape>${instanceConfig.endpoint}</#noescape>
/rest/${instanceConfig.organization}/ems/Request/${message.entityChange.entityId}?layout=
${entitiesMapping.request.fieldNames?join(",")},${REQUEST_CUSTOM_FIELD}
</#escape>
