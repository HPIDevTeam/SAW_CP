<#escape x as x?json_string>
{
    "args": {
        "linkedEntity": {
            "entityType": "Request",
            "entityId": "${message.args.linkedEntity.entityId}",
            "properties": {
                "Status": "RequestStatusComplete"
            }
        }
    }
}
</#escape>
