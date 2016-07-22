<#-- @ftlvariable name="instanceConfig" type="java.util.Map" -->
<#-- @ftlvariable name="message" type="java.util.Map" -->
<#-- @ftlvariable name="context" type="java.util.Map" -->
<#-- @ftlvariable name="loadConfig" type="com.hp.ccue.serviceExchange.adapter.freemarker.LoadConfig" -->

<#assign loadConfig='com.hp.ccue.serviceExchange.adapter.freemarker.LoadConfig'?new()/>
<#assign sawMapping=loadConfig(context.contentStorage, "saw-case-exchange/saw-mappings") />
<#assign sawEntityType=sawMapping.entityType[message.args.linkedEntity.entityType] />
<#assign entityId=message.args.linkedEntity.entityId />

<#escape x as x?url>

<#noescape>${instanceConfig.endpoint}</#noescape>
/rest/${instanceConfig.organization}/ems/${sawEntityType}/${entityId}?layout=${sawEntityType}Attachments

</#escape>
