<#-- @ftlvariable name="instanceConfig" type="java.util.Map" -->
<#-- @ftlvariable name="message" type="java.util.Map" -->

<#assign loadConfig='com.hp.ccue.serviceExchange.adapter.freemarker.LoadConfig'?new()/>
<#assign entitiesMapping=loadConfig(context.configuration, "saw/entities") />
<#assign sawMapping=loadConfig(context.contentStorage, "saw-case-exchange/saw-mappings") />
<#assign hpiMapping=loadConfig(context.contentStorage, "saw-case-exchange/hpi-saw-mappings") />

<#escape x as x?url>
<#noescape>${instanceConfig.endpoint}</#noescape>
<#if message.entityChange.entity.related_properties.RequestedForPerson.Company??>
/rest/${instanceConfig.organization}/ems/Company?layout=DisplayLabel,ContractId_c&filter=${"Id='"+message.entityChange.entity.related_properties.RequestedForPerson.Company+"'"}&meta=totalCount
<#else>
/rest/${instanceConfig.organization}/ems/Company?layout=DisplayLabel,ContractId_c&filter=${"Id='"+hpiMapping.compdefault.compID+"'"}&meta=totalCount
</#if>
</#escape>