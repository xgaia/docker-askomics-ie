#! /bin/bash

# get user info
username="Galaxy" #FIXME: get the galaxy username
pw_hash="" # no password
salt="" # no salt

# sed the dump tempalate
cp /dump.template.nq /dump.nq
sed -i "s@__USERNAME__@$username@g" /dump.nq
sed -i "s/__EMAIL__/$USER_EMAIL/g" /dump.nq
sed -i "s@__PASSWORD_HASH__@$pw_hash@g" /dump.nq
sed -i "s@__SALT__@$salt@g" /dump.nq

sed -i "s@__ASKOMICS_KEY_ID__@galaxy_5Dvp@g" /dump.nq
sed -i "s@__ASKOMICS_KEY_NAME__@galaxy@g" /dump.nq
sed -i "s@__ASKOMICS_API_KEY__@$ASKOMICS_API_KEY@g" /dump.nq

sed -i "s@__GALAXY_ID__@$galaxy_id@g" /dump.nq
sed -i "s@__GALAXY_URL__@$GALAXY_URL@g" /dump.nq
sed -i "s@__GALAXY_KEY__@$API_KEY@g" /dump.nq

mkdir /data/toLoad
mv /dump.nq /data/toLoad

# Link galaxy uplaoded datasets into askomics upload dir
mkdir -p $ASKOMICS_FILES_DIR/upload
ln -s /import $ASKOMICS_FILES_DIR/upload/$username

# Monitor traffic
chmod +x /monitor_traffic.sh
/monitor_traffic.sh &

# Start Virtuoso
chmod +x /virtuoso.sh
/virtuoso.sh &

# Wait for virtuoso to be up
while ! wget -o /dev/null http://localhost:8890/conductor; do
    sleep 1s
done

# Start AskOmics
${ASKOMICS_DIR}/startAskomics.sh -r -d dev
