[[ $1 = '' ]] && BRANCH="master" || BRANCH=$1

SSH_KEY_PATH="key.pem"
SERVER="remote_username@remote_host"
DEST_FOLDER="path_to_project_folder"
PARAMS="BRANCH=\"$BRANCH\" DEST_FOLDER=\"$DEST_FOLDER\""

echo ==============================
echo Autodeploy server
echo selected branch $BRANCH
chmod 400 $SSH_KEY_PATH
echo ==============================
echo Connecting to remote server...
ssh -i $SSH_KEY_PATH $SERVER $PARAMS 'bash -i' <<-'ENDSSH'
    #Connected

    cd $DEST_FOLDER

    git stash
    # to stash package-lock.json file changes

    git pull
    git checkout $BRANCH
    git pull origin $BRANCH

    rm -rf node_modules/
    npm install

    pm2 stop app_name
    pm2 start app_name
    pm2 save
    pm2 list

    exit
ENDSSH