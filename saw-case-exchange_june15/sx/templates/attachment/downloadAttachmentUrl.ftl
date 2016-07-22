<#-- @ftlvariable name="instanceConfig" type="java.util.Map" -->
<#-- @ftlvariable name="message" type="java.util.Map" -->

<#escape x as x?url>
    <#noescape>${instanceConfig.endpoint}</#noescape>
    /rest/${instanceConfig.organization}/frs/file-list/
    ${message.messageArgs.attachment.id}
</#escape>
