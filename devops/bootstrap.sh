#!/usr/bin/env bash

sudo apt-get update -y
sudo apt-get install make language-pack-ru libyaml-dev libsqlite3-dev sqlite3 -y
sudo apt-get install mysql-server mysql-client libmysqld-dev libdbd-sqlite3-perl -y

sudo apt-get install cpanminus -y

cd MovieCatalog
sudo cpanm --installdeps .

# настройка баз данных девелоперской и тестовой
# bash /vagrant/mysql_init.sh

# sudo chown -R vagrant:vagrant /home/vagrant/

exit 0