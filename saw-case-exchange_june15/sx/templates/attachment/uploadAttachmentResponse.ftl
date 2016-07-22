<#escape x as x?json_string>

<#-- @ftlvariable name="doc" type="java.util.Map" -->

<#assign result=doc.result />

{
    "attachmentInfo": {
        "id": "${result.guid}",
        "name": "${result.name}",
        "size": "${result.contentLength?string("0")}",
        "mimeType": "${result.contentType}",
        "creator": "${result.creator}",
        "lastModified": "${result.lastModified?string("0")}"
    }
}

</#escape>
