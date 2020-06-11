/// <reference path="../../../.vscode.js"/>

ApplicationCallback.registerCallback('postLogin', guiUser => {
    var userEntry = UM.getEntryByUid(guiUser.login);
    var country = userEntry.get('country');

    if (guiUser.adminRole == 'employee') {
        guiUser.channelLangTags = country;
        guiUser.newsletterTags = country;
        guiUser.userQuery = `entrytype == "shipping_company" or entrytype == "employee" or (entrytype == "customer" and country=${Query.value_quote(country)})`;
        guiUser.setAttributeDefaultValue("customer", "country", country);
        guiUser.setAttributeDefaultValue("shipping_company", "country", country);
    }
})
