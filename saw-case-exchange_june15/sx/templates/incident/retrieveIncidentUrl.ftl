<#-- @ftlvariable name="instanceConfig" type="java.util.Map" -->
<#-- @ftlvariable name="message" type="java.util.Map" -->

<#assign loadConfig='com.hp.ccue.serviceExchange.adapter.freemarker.LoadConfig'?new()/>
<#assign entitiesMapping=loadConfig(context.configuration, "saw/entities") />
<#assign sawMapping=loadConfig(context.contentStorage, "saw-case-exchange/saw-mappings") />

<#include "SAW_CUSTOM_FIELD.ftl"/>

<#escape x as x?url>
<#noescape>${instanceConfig.endpoint}</#noescape>
/rest/${instanceConfig.organization}/ems/${sawMapping.entityType[message.entityChange.entityType]}/${message.entityChange.entityId}?layout=
${entitiesMapping.incident.fieldNames?join(",")},${SAW_CUSTOM_FIELD}
</#escape>
