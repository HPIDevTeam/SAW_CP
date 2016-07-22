<#-- @ftlvariable name="instanceConfig" type="java.util.Map" -->
<#-- @ftlvariable name="message" type="java.util.Map" -->

<#assign loadConfig='com.hp.ccue.serviceExchange.adapter.freemarker.LoadConfig'?new()/>
<#assign entitiesMapping=loadConfig(context.configuration, "saw/entities") />
<#assign sawMapping=loadConfig(context.contentStorage, "saw-case-exchange/saw-mappings") />
<#assign hpiMapping=loadConfig(context.contentStorage, "saw-case-exchange/hpi-saw-mappings") />

<#escape x as x?url>
<#noescape>${instanceConfig.endpoint}</#noescape>
<#if message.entityChange.entity.related_properties.RequestedForPerson.Id??>
/rest/${instanceConfig.organization}/ems/Device?layout=Id,SerialNumber,ProductNum_c&filter=(DeviceUsedByPerson[Id = ${message.entityChange.entity.related_properties.RequestedForPerson.Id}])&meta=totalCount
<#else>
/rest/${instanceConfig.organization}/ems/Device?layout=Id,SerialNumber,ProductNum_c&filter=(DeviceUsedByPerson[Id = ${hpiMapping.devicedefault.devID}])&meta=totalCount
</#if>
</#escape>