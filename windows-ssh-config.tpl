add-content -path c:/users/YOUR_USERNAME/.ssh/config -value @'

Host ${hostname}
    HostName ${hostname}
    User ${user}
    IdentityFile &{identityfile}
'@