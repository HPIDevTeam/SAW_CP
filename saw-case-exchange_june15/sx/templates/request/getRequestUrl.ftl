<#-- @ftlvariable name="instanceConfig" type="java.util.Map" -->
<#-- @ftlvariable name="context" type="java.util.Map" -->
<#-- @ftlvariable name="message" type="java.util.Map" -->
<#-- @ftlvariable name="loadConfig" type="com.hp.ccue.serviceExchange.adapter.freemarker.LoadConfig" -->

<#assign loadConfig = 'com.hp.ccue.serviceExchange.adapter.freemarker.LoadConfig'?new()/>
<#assign sawConfig = loadConfig(context.configuration, "saw/entities")/>

<#escape x as x?url>
<#noescape>${instanceConfig.endpoint}</#noescape>
/rest/${instanceConfig.organization}/ces?layout=
${sawConfig.request.fieldNames?join(",")}
&type=Request&system=${message.externalInstanceAlias}
&time=${message.lastUpdateTime?c}
</#escape>