<#-- @ftlvariable name="message" type="java.util.Map" -->
<#assign gsemMapping=loadConfig(context.contentStorage, "gsem/gsem-cx-mappings") />

<#assign entity = message.entityChange.entity/>
<#assign properties = entity.properties/>
<#escape x as x?json_string>

{
	"messageId":"${properties.GSEMmessageId}",
   	"gsemAgentKey": "${gsemMapping.Request.GSEMKeys.GSEMAgentKey}",
	"gsemPlatformType":"${gsemMapping.Request.GSEMKeys.GSEMPlatformType}",
	"gsemRemoteAgentName":"${gsemMapping.Request.GSEMKeys.GSEMRemoteAgentName}"
}

</#escape>