/// <reference path="../../../.vscode.js"/>

ApplicationCallback.registerCallback('postLogin', guiUser => {
    var userEntry = UM.getEntryByUid(guiUser.login);
    var country = userEntry.get('country');

    if (guiUser.adminRole == 'employee') {
        guiUser.channelLangTags = country;
        guiUser.newsletterTags = country;
        guiUser.userQuery = `entrytype == "s" or entrytype == "c" or (entrytype == "c" and country=${Query.value_quote(country)})`;
        guiUser.setAttributeDefaultValue("c", "country", country);
        guiUser.setAttributeDefaultValue("s", "country", country);
    }
})
