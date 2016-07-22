<#escape x as x?json_string>
{
    "args": {
        "linkedEntity": {
            "entityType": "Incident",
            "entityId": "${message.args.linkedEntity.entityId}",
            "properties": {
                "Status": "Complete"
            }
        }
    }
}
</#escape>
