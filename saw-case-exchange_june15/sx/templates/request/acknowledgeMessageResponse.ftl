<#-- @ftlvariable name="doc" type="java.util.Map" -->
<#-- @ftlvariable name="writeJson" type="com.hp.ccue.serviceExchange.adapter.freemarker.WriteJson" -->
<#-- @ftlvariable name="message" type="java.util.Map" -->
<#assign writeJson = 'com.hp.ccue.serviceExchange.adapter.freemarker.WriteJson'?new()/>
<#assign properties = message.entity.properties />

<#escape x as x?json_string>
{
    "ackResponse":{
        "success": "${properties.Success}",
        "lastErrorCode": "${properties.ErrorCode}",
        "lastErrorMessage": "${properties.ErrorMessage}"
    }    	
}
</#escape>