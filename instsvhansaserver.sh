#!/bin/sh
urlscript=/etc/init.d

echo_success(){
  printf "$(tput setaf 2)%155s$(tput sgr0)\n" "[OK]"
}
echo_failure(){
  printf "$(tput setaf 1)%155s$(tput sgr0)\n" "[FAILED]"
}

if [ -f $urlscript/hansaserver ]; then
  rm -rf $urlscript/hansaserver	
fi
wget -P$urlscript/ https://raw.github.com/matiascarral/hansaserver/master/hansaserver
echo $"[...] Waiting \n"
sleep 10
if [ -f $urlscript/hansaserver ]; then
  echo -n $"Ingrese la url donde se encuentra la aplicacion HANSA:\n"
  echo -n $"Ej: /home/HANSA/ \n"
  read urlhansa
  while [ ! -d "$urlhansa" ]; do
    echo -n $"El directorio ingresado no existe. Ingrese nuevamente:\n"
    read urlhansa
  done
  namereplace="urlhansaprogram"
  sed -e 's@'$namereplace'@'$urlhansa'@g' $urlscript/hansaserver > $urlscript/hansaserver2
  mv -f $urlscript/hansaserver2 $urlscript/hansaserver
  echo -n $"Ingrese un numero de puerto entre 1000 y 3000: \n"
  read porthansa
  while [ $(( ${porthansa#0} )) < 1000 && $(( ${porthansa#0} )) > 3000 ]; do
    echo -n $"Puerto ingresado incorrecto, ingrese un numero de puerto valido:\n"
    read porthansa
  done
  namereplace="porthansaprogram"
  sed -e 's@'$namereplace'@'$porthansa'@g' $urlscript/hansaserver > $urlscript/hansaserver2
  mv -f $urlscript/hansaserver2 $urlscript/hansaserver
  chmod ug+x $urlscript/hansaserver
  if [ -f /etc/rc5.d/S30hansaserver ]; then
    ln -s $urlscript/hansaserver /etc/rc5.d/S30hansaserver
  fi
  if [ -f /etc/rc3.d/S30hansaserver ]; then
    ln -s $urlscript/hansaserver /etc/rc3.d/S30hansaserver
  fi
  if [ -f /etc/rc6.d/K05hansaserver ]; then
    ln -s $urlscript/hansaserver /etc/rc6.d/K05hansaserver
  fi  
  if [ -f /etc/rc0.d/K05hansaserver ]; then
    ln -s $urlscript/hansaserver /etc/rc0.d/K05hansaserver
  fi
  service hansaserver start
else
  echo $"Error al descargar hansaserver, verifique la conexion a internet. \n"
  echo_failure
fi
