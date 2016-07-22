<#escape x as x?json_string>

<#macro renderJson object>
    <#if object?is_hash || object?is_hash_ex>
        {
        <#assign first=true>
        <#list object?keys as key>
            <#if object[key]??>
                <#if !first>,</#if>
                <#assign value><@renderJson object=object[key] /></#assign>
                "${key}" : <#noescape>${value?trim}</#noescape>
                <#assign first=false>
            </#if>
        </#list>
        } 
    <#elseif object?is_enumerable>
        [
        <#assign first=true>
        <#list object as item>
            <#if item??>
                <#if !first>,</#if>
                <#assign value><@renderJson object=item /></#assign>
                <#noescape>${value?trim}</#noescape>
                <#assign first=false>
            </#if>
        </#list>
        ] 
    <#else> 
        "${object?trim}"
    </#if> 
</#macro>

</#escape>
