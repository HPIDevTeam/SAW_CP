<#-- @ftlvariable name="instanceConfig" type="java.util.Map" -->
<#-- @ftlvariable name="message" type="java.util.Map" -->

<#assign loadConfig='com.hp.ccue.serviceExchange.adapter.freemarker.LoadConfig'?new()/>
<#assign entitiesMapping=loadConfig(context.configuration, "saw/entities") />
<#assign sawMapping=loadConfig(context.contentStorage, "saw-case-exchange/saw-mappings") />
<#assign hpiMapping=loadConfig(context.contentStorage, "saw-case-exchange/hpi-saw-mappings") />

<#escape x as x?url>
<#noescape>${instanceConfig.endpoint}</#noescape>
<#if message.entityChange.entity.related_properties.RequestedForPerson.Location??>
/rest/${instanceConfig.organization}/ems/Location?layout=Id,Address,City,Country,State,PostalCode&filter=${"Id='"+message.entityChange.entity.related_properties.RequestedForPerson.Location+"'"}&meta=totalCount
<#else>
/rest/${instanceConfig.organization}/ems/Location?layout=Id,Address,City,Country,State,PostalCode&filter=${"Id='"+hpiMapping.locdefault.locID+"'"}&meta=totalCount
</#if>
</#escape>