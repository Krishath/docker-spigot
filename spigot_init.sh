#!/bin/bash
if [ "$EULA" != "true" ]; then
  echo "*****************************************************************"
  echo "*****************************************************************"
  echo "** To be able to run spigot you need to accept minecrafts EULA **"
  echo "** see https://account.mojang.com/documents/minecraft_eula     **"
  echo "** include -e EULA=true on the docker run command              **"
  echo "*****************************************************************"
  echo "*****************************************************************"
  exit
fi

#only build if jar file does not exist
if [ ! -f $SPIGOT_HOME/spigot.jar ] || [ [ $UPGRADE == [Tt]rue ] ]; then 
  echo "Building spigot jar file, be patient"
  mkdir -p $SPIGOT_HOME/build
  cd $SPIGOT_HOME/build
  wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastStableBuild/artifact/target/BuildTools.jar
  HOME=$SPIGOT_HOME/build java -jar BuildTools.jar $BUILD_ARGS
  cp $SPIGOT_HOME/build/Spigot/Spigot-Server/target/spigot-*.jar $SPIGOT_HOME/spigot.jar
  
  rm -rf $SPIGOT_HOME/build
  
  #accept eula
  echo "eula=true" > $SPIGOT_HOME/eula.txt

fi

cd /$SPIGOT_HOME/
java -Xms$XMS -Xmx$XMX $ADDITIONAL_ARGS -jar spigot.jar

# fallback to root and run shell if spigot don't start/forced exit
bash

