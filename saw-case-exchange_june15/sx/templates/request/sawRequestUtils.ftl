<#assign sawMapping=loadConfig(context.contentStorage, "saw-case-exchange/saw-mappings") />
<#assign findKey='com.hp.ccue.serviceExchange.adapter.freemarker.FindKeyForValue'?new()/>

<#function getCanonicalModelStatus sawStatus sawPhaseId sawCompletionCode>
    <#if sawStatus == 'Complete' && sawCompletionCode == 'RequestRejected'>
        <#return 'Rejected'/>
    <#elseif sawStatus == 'Complete' && sawPhaseId == 'Close'>
        <#return 'Closed'/>
    <#else>
        <#--no combined status mapping, use simple single-value mapping-->
        <#return findKey(sawMapping.Request.Status, sawStatus)>
    </#if>
</#function>