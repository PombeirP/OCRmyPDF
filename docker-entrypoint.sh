#!/bin/sh

SCRIPT_PATH=/home/docker/processfile.sh

useradd -u ${PUID} -g ${PGID} -o -m user

echo "#!/bin/sh" > ${SCRIPT_PATH}
echo "" >> ${SCRIPT_PATH}
echo "cd /hot-folder" >> ${SCRIPT_PATH}
echo "if [ \"\$1\" = \"created\" ]" >> ${SCRIPT_PATH}
echo "then" >> ${SCRIPT_PATH}
echo "    echo \"+ Processing \$1 event on \$2...\"" >> ${SCRIPT_PATH}
echo "    . /appenv/bin/activate" >> ${SCRIPT_PATH}
echo "    /appenv/bin/ocrmypdf "$OCRMYPDF_OPTIONS" \"\$2\" \"/archive/\$2\"" >> ${SCRIPT_PATH}
echo "    if [ -f \"/archive/\$2\" ]" >> ${SCRIPT_PATH}
echo "    then" >> ${SCRIPT_PATH}
echo "        chmod 644 \"/archive/\$2\"" >> ${SCRIPT_PATH}
echo "        chown "${PUID}":"${PGID}" \"/archive/\$2\"" >> ${SCRIPT_PATH}
echo "        rm -f \"\$2\"" >> ${SCRIPT_PATH}
echo "        echo \"- Finished processing \$1 event on \$2\"" >> ${SCRIPT_PATH}
echo "    else" >> ${SCRIPT_PATH}
echo "        echo \"- Failed to process \$2\"" >> ${SCRIPT_PATH}
echo "    fi" >> ${SCRIPT_PATH}
echo "fi" >> ${SCRIPT_PATH}
chmod 755 ${SCRIPT_PATH}
chown ${PUID}:${PGID} ${SCRIPT_PATH}
cat ${SCRIPT_PATH}

. /appenv/bin/activate; \
watchmedo shell-command --patterns="*.pdf" --ignore-directories \
  --command="runuser -l user -c \"${SCRIPT_PATH} '\${watch_event_type}' '\${watch_src_path}'\"" \
  .
