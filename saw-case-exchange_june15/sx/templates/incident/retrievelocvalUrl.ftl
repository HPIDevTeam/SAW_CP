<#-- @ftlvariable name="instanceConfig" type="java.util.Map" -->
<#-- @ftlvariable name="message" type="java.util.Map" -->

<#assign loadConfig='com.hp.ccue.serviceExchange.adapter.freemarker.LoadConfig'?new()/>
<#assign entitiesMapping=loadConfig(context.configuration, "saw/entities") />
<#assign sawMapping=loadConfig(context.contentStorage, "saw-case-exchange/saw-mappings") />

<#escape x as x?url>
<#noescape>${instanceConfig.endpoint}</#noescape>
<#if message.entityChange.entity.related_properties.RequestedByPerson.Location??>
/rest/${instanceConfig.organization}/ems/Location?layout=Address,City,Country,State,PostalCode&filter=${"Id='"+message.entityChange.entity.related_properties.RequestedByPerson.Location+"'"}&meta=totalCount
<#else>
/rest/${instanceConfig.organization}/ems/Location?layout=Address,City,Country,State,PostalCode&filter=${"Id='10001'"}&meta=totalCount
</#if>
</#escape>