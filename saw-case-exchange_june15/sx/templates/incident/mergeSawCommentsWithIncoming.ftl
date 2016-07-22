<#assign sanitize='com.hp.ccue.serviceExchange.adapter.freemarker.StringSanitizer'?new()/>
<#assign findAliasForExtSystem='com.hp.ccue.serviceExchange.adapter.freemarker.caseex.FindAliasForExternalSystem'?new() />

<#function compress_single_line captured><#return captured?replace("^\\s+|\\s+$|\\n|\\r", " ", "rm") ></#function>

<#assign entity=message.args.entity />
<#assign linkedEntity=message.args.linkedEntity />
<#assign properties=entity.properties />

<#escape x as x?json_string>

{

"MergedComments":[

    <#assign firstComment = true />
    <#assign comments = message.args.entity.properties.Comments! />
    <#if comments??>
        <#list comments as comment>

            <#assign isAlreadyInSaw = false />
            <#if doc?? && doc.result?? && doc.result.Comments??>
                <#list doc.result.Comments as cc>
                    <#assign source = findAliasForExtSystem(context.appContext, linkedEntity.instanceType, linkedEntity.instance, entity.instanceType, entity.instance) />
                    <#assign commentDesc = cc.Body!"" />

                    <#assign sawCommentTime = cc.CreatedTime?string["0"] />
                    <#assign isExternalComment = commentDesc?matches("\\(\\s([0-9]*).*?\\):.*") />
                    <#if isExternalComment>
                        <#assign commentDesc = commentDesc?substring(commentDesc?index_of("):") + 2)?trim />
                        <#assign sawCommentTime = isExternalComment?groups[1] />
                    </#if>
                    <#assign commentDesc = commentDesc?trim />

                    <#if compress_single_line(sanitize(commentDesc))?trim == comment.description
                    && comment.createdAt?string["0"] == sawCommentTime >
                        <#assign isAlreadyInSaw = true />
                        <#break />
                    </#if>
                </#list>
            </#if>

            <#if !isAlreadyInSaw>
                <#if !firstComment>,</#if>
            {
            "id": "${comment.id}",
            "type": "${comment.type}",
            "description": "${comment.description}",
            "isCustVisible": ${comment.isCustVisible?c},
            "createdAt": ${comment.createdAt?string["0"]},
            "operator": "${comment.operator}"
            }
                <#assign firstComment = false />
            </#if>
        </#list>
    </#if>
]
}

</#escape>

