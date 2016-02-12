vagrant ssh -c "sudo /etc/init.d/tomcat7 stop" > /dev/null 2> /dev/null
vagrant ssh -c "sudo rm -r /var/lib/tomcat7/fcrepo4-data/*" > /dev/null 2> /dev/null
vagrant ssh -c "sudo /etc/init.d/tomcat7 start" > /dev/null 2> /dev/null
# sleep 40