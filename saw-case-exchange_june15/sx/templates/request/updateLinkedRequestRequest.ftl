<#macro compress_single_line><#local captured><#nested></#local>${ captured?replace("^\\s+|\\s+$|\\n|\\r", " ", "rm") }</#macro>

<#escape x as x?json_string>

    <#assign writeJson='com.hp.ccue.serviceExchange.adapter.freemarker.WriteJson'?new()/>
    <#assign loadConfig='com.hp.ccue.serviceExchange.adapter.freemarker.LoadConfig'?new()/>
    <#assign findAliasForExtSystem='com.hp.ccue.serviceExchange.adapter.freemarker.caseex.FindAliasForExternalSystem'?new() />
    <#assign sanitize='com.hp.ccue.serviceExchange.adapter.freemarker.StringSanitizer'?new()/>
    <#assign localize='com.hp.ccue.serviceExchange.adapter.saw.util.SXSAWImplProperties'?new()/>
    <#assign instances=loadConfig(context.configuration, "saw/instances") />

    <#assign entitiesMapping=loadConfig(context.configuration, "saw/entities") />
    <#assign sawMapping=loadConfig(context.contentStorage, "saw-case-exchange/saw-mappings") />
    <#assign hpiMapping=loadConfig(context.contentStorage, "saw-case-exchange/hpi-saw-mappings") />

    <#assign entity=message.args.entity />
    <#assign event=message.args.event/>
    <#assign linkedEntity=message.args.linkedEntity />
    <#assign properties=entity.properties />

{
    "newEntity":{
        "entity":{
            "entity_type": "Request",
            "properties": {
                "Id": "${linkedEntity.entityId}",
                "ExternalProcessReference": "${properties.GSEMproviderId}"
                  <#if properties.Solution?? && event== "requestResolved" >
                  ,"Solution": "<@compress_single_line>${sanitize(properties.Solution!localize(context.targetInstance,instances,"DID_NOT_FILL_SOLUTION"))}</@compress_single_line>"
                  <#elseif event== "requestResolved" >
                  ,"Solution": "${hpiMapping.sol.soldefault}"
                  </#if>
                  <#if properties.GSEMresolutionCode?? && event== "requestResolved" >
                  ,"CompletionCode": "${sawMapping.Request.CompletionCodeFromCanonical[properties.GSEMresolutionCode]}"
                  <#elseif event== "requestResolved">
                   ,"CompletionCode": "${hpiMapping.ccode.ccodedefault}"
                  </#if>
                  
            },
            "Comments": [
                <#if properties.GSEMnotes?? || properties.GSEMinterNotes??>
                {
			<#if properties.GSEMresponseTime??>
                        	"CreatedTime": "${properties.GSEMresponseTime?datetime("yyyy-MM-dd hh:mm:ss")?long?string["0"]}",
                        </#if>                        "IsSystem": true,
                        <#assign commentBody='<b>Notes and Inter Notes from GSEM</b><br>' />
                        <#assign notes='<b>Notes</b>' />
						<#assign interNotes='<b>InterNotes</b>' />
                        <#if properties.GSEMnotes == "" >
							<#assign commentBody="${commentBody} ${notes}: NOT SENT FROM GSEM" />
						<#else> 
							<#assign commentBody="${commentBody} ${notes}: ${properties.GSEMnotes}" />
						</#if> 
						<#if properties.GSEMinterNotes == "" >
							<#assign commentBody="${commentBody} ${interNotes}: NOT SENT FROM GSEM" />
						<#else> 
							<#assign commentBody="${commentBody} ${interNotes}: ${properties.GSEMinterNotes}" />
						</#if>
						"Body":"${commentBody}",
                        "PrivacyType": "PUBLIC"      
                }
                </#if>
            ],
            "ext_properties": {
                "ExternalSystem": "${findAliasForExtSystem(context.appContext, linkedEntity.instanceType, linkedEntity.instance, entity.instanceType, entity.instance)}",
                "Operation": "Update",
                "ExternalStatus": "${linkedEntity.Status}",
                "ExternalId": "${properties.GSEMproviderId}"
            }
        }
    }
}

</#escape>