# hansaserver
Service hansaserver install linux

* Download service file hansaserver
	wget https://raw.github.com/matiascarral/hansaserver/master/hansaserver
* Asignated permission in file
	chmod ug+x /etc/init.d/hansaserver
* Add runlevel

```
 ln -s /etc/init.d/hansaserver /etc/rc5.d/S30hansaserver
 ln -s /etc/init.d/hansaserver /etc/rc3.d/S30hansaserver
 ln -s /etc/init.d/hansaserver /etc/rc6.d/K05hansaserver
 ln -l /etc/init.d/hansaserver /etc/rc0.d/K05hansaserver
```

* CommandLine example:
	service hansaserver start
	service hansaserver stop
	service hansaserver restart
	service hansaserver backup
	service hansaserver reimport

OR

* Download install hansaserver https://raw.github.com/matiascarral/hansaserver/master/instsvhansaserver.sh
