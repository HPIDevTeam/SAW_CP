<#-- @ftlvariable name="instanceConfig" type="java.util.Map" -->
<#-- @ftlvariable name="message" type="java.util.Map" -->
<#escape x as x?url>
<#noescape>${message.entity.GSEMEndPoint}</#noescape>/api/acknowledgeMessage
</#escape>