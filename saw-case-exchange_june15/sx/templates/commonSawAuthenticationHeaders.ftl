<#escape x as x?json_string>
{
    "Cookie": "TENANTID=${instanceConfig.organization}; LWSSO_COOKIE_KEY=${message.authToken}"
}
</#escape>
