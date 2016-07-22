<#assign sanitize='com.hp.ccue.serviceExchange.adapter.freemarker.StringSanitizer'?new()/>
<#assign old = message.oldEntity.entity.properties/>
<#assign new = message.newEntity.entity.properties/>
<#assign oldDescription=sanitize(old.Description!"")?replace("^\\s+|\\s+$|\\n|\\r", " ", "rm")>
<#assign oldSolution=sanitize(old.Solution!"")?replace("^\\s+|\\s+$|\\n|\\r", " ", "rm")>
<#escape x as x?json_string>
{
    <#if
    (new.DisplayLabel?? && old.DisplayLabel!=new.DisplayLabel) ||
    (new.Description?? && oldDescription!=new.Description) ||
    (new.Solution?? && oldSolution!=new.Solution) ||
    (new.CompletionCode?? && old.CompletionCode?? && old.CompletionCode!=new.CompletionCode) ||
    ((new.CompletionCode??) && !(old.CompletionCode??)) ||
    (!(new.CompletionCode??) && (old.CompletionCode??)) ||
    (new.ImpactScope?? && old.ImpactScope!=new.ImpactScope) ||
    (message.newEntity.entity.Comments?? && message.newEntity.entity.Comments?size > 0) ||
    (message.newEntity.entity.ext_properties.ExternalStatus?? && message.newEntity.entity.ext_properties.ExternalStatus=="Closed") ||
    (new.Urgency?? && old.Urgency!=new.Urgency)
    >
    <#else>
    "skipProcessing": true
    </#if>
}
</#escape>
