# Copyright (C) 2017 CERN.
#
# Zenodo is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation; either version 2 of the
# License, or (at your option) any later version.
#
# Zenodo is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Zenodo; if not, write to the Free Software Foundation, Inc.,
# 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA.
#
# In applying this license, CERN does not waive the privileges and immunities
# granted to it by virtue of its status as an Intergovernmental Organization or
# submit itself to any jurisdiction.

cd databags
mv navigation.json navigation_local.json
ln -s navigation_deploy.json navigation.json
cd ..

eval $(ssh-agent -s)
mv content/ content_root/
ln -s content_root/help content

openssl aes-256-cbc -K $encrypted_1c9ebd4878cf_key -iv $encrypted_1c9ebd4878cf_iv -in deploy_keys.tar.enc -out deploy_keys.tar -d
tar xvf deploy_keys.tar

lektor clean --yes
lektor build
ls -l
ssh-add -D
ssh-add ./deploy_key_help
lektor deploy ghpageshelp --key-file ${TRAVIS_BUILD_DIR}/deploy_key_help
rm content

ln -s content_root/about content
lektor clean --yes
lektor build
ssh-add -D
ssh-add ./deploy_key_about
lektor deploy ghpagesabout --key-file ${TRAVIS_BUILD_DIR}/deploy_key_about
rm content

ln -s content_root/blog content
lektor clean --yes
lektor build
ssh-add -D
ssh-add ./deploy_key_blog
lektor deploy ghpagesblog --key-file ${TRAVIS_BUILD_DIR}/deploy_key_blog
rm content

mv content_root/ content/
rm databags/navigation.json
mv databags/navigation_local.json databags/navigation.json
