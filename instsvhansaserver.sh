#!/bin/sh
urlscript=/etc/init.d

echo_success(){
  printf "$(tput setaf 2)%155s$(tput sgr0)\n" "[OK]"
}
echo_failure(){
  printf "$(tput setaf 1)%155s$(tput sgr0)\n" "[FAILED]"
}
countspace(){
  count=0
  export IFS=" "
  for substr in $urlhansa; do
    count=$(( ${count#0}+1 ))
  done

  echo "$count"
}

if [ -f $urlscript/hansaserver ]; then
  rm -rf $urlscript/hansaserver	
fi
wget -P$urlscript/ https://raw.github.com/matiascarral/hansaserver/master/hansaserver
echo $"[...] Waiting \n"
sleep 10
if [ -f $urlscript/hansaserver ]; then
  echo -n $"Ingrese la ruta completa donde se encuentra la aplicacion HANSA:\n"
  echo -n $"Ej: /home/HANSA \n"
  read urlhansa
  count=$(countspace)
  while [ ! "$count" -eq "1" ]; do
    echo -n $"La ruta no puede contener espacios. Ingrese nuevamente:\n"
    read urlhansa
    count=$(countspace)
  done
  while [ ! -d "$urlhansa" ]; do
    echo -n $"El directorio ingresado no existe. Ingrese nuevamente:\n"
    read urlhansa
  done
  while [ ! -f "$urlhansa"/hansa-server ]; do
    echo -n $"No se encuentra el ejecutable hansa-server en $urlhansa/hansa-server \n"
  done
  namereplace="urlhansaprogram"
  sed -e 's@'"$namereplace"'@'"$urlhansa"'@g' $urlscript/hansaserver > $urlscript/hansaserver2
  mv -f $urlscript/hansaserver2 $urlscript/hansaserver
  echo -n $"Ingrese un numero de puerto: \n"
  while read porthansa
  do
    NUM=$(( ${porthansa#0} ))
    if [ "$NUM" -lt 1000 ] || [ "$NUM" -gt 3000 ]; then
      echo $"Puerto incorrecto, desde el 1000 al 3000:"
    else
      break
    fi
  done
  porthansa=$NUM
  namereplace="porthansaprogram"
  sed -e 's@'$namereplace'@'$porthansa'@g' $urlscript/hansaserver > $urlscript/hansaserver2
  mv -f $urlscript/hansaserver2 $urlscript/hansaserver
  chmod ug+x $urlscript/hansaserver
  if [ ! -f /etc/rc0.d/K09hansaserver ]; then
    ln -s $urlscript/hansaserver /etc/rc0.d/K09hansaserver
  fi
  if [ ! -f /etc/rc1.d/K09hansaserver ]; then
    ln -s $urlscript/hansaserver /etc/rc1.d/K09hansaserver
  fi
  if [ ! -f /etc/rc2.d/S91hansaserver ]; then
    ln -s $urlscript/hansaserver /etc/rc2.d/S91hansaserver
  fi
  if [ ! -f /etc/rc3.d/S91hansaserver ]; then
    ln -s $urlscript/hansaserver /etc/rc3.d/S91hansaserver
  fi  
  if [ ! -f /etc/rc4.d/S91hansaserver ]; then
    ln -s $urlscript/hansaserver /etc/rc4.d/S91hansaserver
  fi
  if [ ! -f /etc/rc5.d/S91hansaserver ]; then
    ln -s $urlscript/hansaserver /etc/rc5.d/S91hansaserver
  fi
  if [ ! -f /etc/rc6.d/K09hansaserver ]; then
    ln -s $urlscript/hansaserver /etc/rc6.d/K09hansaserver
  fi
  service hansaserver start
else
  echo $"Error al descargar hansaserver, verifique la conexion a internet. \n"
  echo_failure
fi
