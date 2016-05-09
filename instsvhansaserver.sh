#!/bin/bash
urlscript=/etc/init.d
servicename="hansaserver"

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

getServiceName(){
  echo -e $"Ingrese un nombre para el servicio HANSA:"
  echo -e $"Ej: hansaempresa, hansaserver, hansamiempresa, etc"
  
  read servicename
  compressed="$(echo $servicename | sed -e 's/[^[:alnum:]\-]//g')"
  
  while ([ -z "${servicename}" ] || [ "$compressed" != "$servicename" ]); do
    echo -e $"El nombre del servicio es requerido y alphanumerico:"
    
    read servicename
    compressed="$(echo $servicename | sed -e 's/[^[:alnum:]\-]//g')"
  done
  servicenametmp="${servicename}2"
}

getUrlHansa(){
  echo -e $"Ingrese la ruta completa donde se encuentra la aplicacion HANSA:"
  echo -e $"Ej: /home/HANSA"
  read urlhansa
  count=$(countspace)
  while [ ! "${count}" -eq "1" ]; do
    echo -e $"La ruta no puede contener espacios. Ingrese nuevamente:"
    read urlhansa
    count=$(countspace)
  done
  while [ ! -d "${urlhansa}" ]; do
    echo -e $"El directorio ingresado no existe. Ingrese nuevamente:"
    read urlhansa
  done
  while [ ! -f "${urlhansa}/hansa-server" ]; do
    echo -e $"No se encuentra el ejecutable hansa-server en $urlhansa/hansa-server"
  done
}

getPortHansa(){
  echo -e $"Ingrese un numero de puerto:"
  while read porthansa
  do
    NUM=$(( ${porthansa#0} ))
    if [ "${NUM}" -lt 1000 ] || [ "${NUM}" -gt 3000 ]; then
      echo $"Puerto incorrecto, desde el 1000 al 3000:"
    else
      break
    fi
  done
}

# Get service name
getServiceName

# Remove service if exists
servicefile="${urlscript}/${servicename}"
if [ -f "$servicefile" ]; then
  rm -rf "$servicefile"	
fi

# Download service template
touch "${urlscript}/${servicename}"
wget --no-check-certificate https://raw.github.com/matiascarral/hansaserver/master/hansaserver -O "${urlscript}/${servicename}" 
echo -e $"[...] Waiting"
sleep 10

# Verify if template download success
if [ -f "${urlscript}/${servicename}" ]; then  
  
  # Replace url hansa in service template
  namereplace="hansaserver"
  sed -e "s@${namereplace}@${servicename}@g" "${urlscript}/${servicename}" > "${urlscript}/${servicenametmp}"
  mv -f "${urlscript}/${servicenametmp}" "${urlscript}/${servicename}"

  # Get Url hansa application
  getUrlHansa

  # Replace url hansa in service template
  namereplace="urlhansaprogram"
  sed -e "s@${namereplace}@${urlhansa}@g" "${urlscript}/${servicename}" > "${urlscript}/${servicenametmp}"
  mv -f "${urlscript}/${servicenametmp}" "${urlscript}/${servicename}"
  
  # Get hansa port number
  getPortHansa
  
  # Replace hansa port number in service template
  porthansa=$NUM
  namereplace="porthansaprogram"
  sed -e "s@${namereplace}@${porthansa}@g" "${urlscript}/${servicename}" > "${urlscript}/${servicenametmp}"
  mv -f "${urlscript}/${servicenametmp}" "${urlscript}/${servicename}"
  
  # Config runlevel
  chmod ug+x "${urlscript}/${servicename}"
  if [ ! -f "/etc/rc0.d/K09${servicename}" ]; then
    ln -s "${urlscript}/${servicename}" "/etc/rc0.d/K09${servicename}"
  fi
  if [ ! -f "/etc/rc1.d/K09${servicename}" ]; then
    ln -s "${urlscript}/${servicename}" "/etc/rc1.d/K09${servicename}"
  fi
  if [ ! -f "/etc/rc2.d/S91${servicename}" ]; then
    ln -s "${urlscript}/${servicename}" "/etc/rc2.d/S91${servicename}"
  fi
  if [ ! -f "/etc/rc3.d/S91${servicename}" ]; then
    ln -s "${urlscript}/${servicename}" "/etc/rc3.d/S91${servicename}"
  fi  
  if [ ! -f "/etc/rc4.d/S91${servicename}" ]; then
    ln -s "${urlscript}/${servicename}" "/etc/rc4.d/S91${servicename}"
  fi
  if [ ! -f "/etc/rc5.d/S91${servicename}" ]; then
    ln -s "${urlscript}/${servicename}" "/etc/rc5.d/S91${servicename}"
  fi
  if [ ! -f "/etc/rc6.d/K09${servicename}" ]; then
    ln -s "${urlscript}/${servicename}" "/etc/rc6.d/K09${servicename}"
  fi
  service "${servicename}" start
else
  
  echo $"Error al descargar hansaserver, verifique la conexion a internet. \n"
  echo_failure
fi
