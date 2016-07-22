<#-- @ftlvariable name="instanceConfig" type="java.util.Map" -->
<#-- @ftlvariable name="message" type="java.util.Map" -->

<#escape x as x?url>
<#if !message.targetAttachmentIdentical>
    <#noescape>${instanceConfig.endpoint}</#noescape>/rest/${instanceConfig.organization}/ces
</#if>
</#escape>
