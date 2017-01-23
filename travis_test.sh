set -e
cd databags
mv navigation.json navigation_local.json
ln -s navigation_deploy.json navigation.json
cd ..

mv content/ content_root/
ln -s content_root/help content
lektor clean --yes
lektor build
rm content
ln -s content_root/about content
lektor clean --yes
lektor build
rm content
ln -s content_root/blog content
lektor clean --yes
lektor build
rm content
mv content_root/ content/
rm databags/navigation.json
mv databags/navigation_local.json databags/navigation.json
