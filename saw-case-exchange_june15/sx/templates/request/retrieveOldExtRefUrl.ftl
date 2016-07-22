<#-- @ftlvariable name="instanceConfig" type="java.util.Map" -->
<#-- @ftlvariable name="message" type="java.util.Map" -->

<#assign loadConfig='com.hp.ccue.serviceExchange.adapter.freemarker.LoadConfig'?new()/>
<#assign entitiesMapping=loadConfig(context.configuration, "saw/entities") />
<#assign sawMapping=loadConfig(context.contentStorage, "saw-case-exchange/saw-mappings") />

<#escape x as x?url>
<#noescape>${instanceConfig.endpoint}</#noescape>
/rest/${instanceConfig.organization}/ems/ExternalReference?layout=ExternalId,ExternalStatus,ExternalSystem.SystemId&filter=${"EntityId='"+message.args.entity.SourceEntityId+"' and ExternalSystem.SystemId='"+message.args.linkedEntity.instanceAlias+"'"}
</#escape>
