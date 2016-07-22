<#assign decrypt='com.hp.ccue.serviceExchange.adapter.freemarker.Decrypt'?new()/>
<#-- @ftlvariable name="instanceConfig" type="java.util.Map" -->
<#escape x as x?url>
<#noescape>${instanceConfig.endpoint}</#noescape>
/auth/authentication-endpoint/authenticate/login?login=${instanceConfig.user.loginName}&password=${decrypt(instanceConfig.user.password)}
</#escape>
