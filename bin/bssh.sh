#!/bin/bash

cd "/Users/vluther/work/chef-console/"
knife search node "*:*" | awk '$1 ~ /^FQDN/ { lname = $2; }
$1 ~ /^IP/ { names[lname] = $2; }

END {
    for (name in names) {
        if (names[name] != "") {
            print "Host " name
            print "Hostname " names[name]
            print "ForwardAgent yes"

            print ""
        }
    }
}' > ~/ssh_config.txt
