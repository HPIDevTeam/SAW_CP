<#-- @ftlvariable name="message" type="java.util.Map" -->
<#-- @ftlvariable name="instanceConfig" type="java.util.Map" -->

<#assign attachment=message.messageArgs.attachment />
<#assign attachmentName=attachment.name />
<#assign attachmentType=attachment.type />

<#escape x as x?json_string>
{
    "Cookie": "TENANTID=${instanceConfig.organization}; LWSSO_COOKIE_KEY=${message.authToken}",
    "fs_filename": "${attachmentName}",
    "Content-Type": "${attachmentType}"
}
</#escape>
