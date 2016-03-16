apt_package [
  "memcached",
]


include_recipe "critiquebrainz::user"

project_home = node['critiquebrainz']['home'] + '/critiquebrainz'

include_recipe 'git::default'
git project_home do
  repository "git://github.com/metabrainz/critiquebrainz.git"
  action :sync
  group node['critiquebrainz']['group']
  user node['critiquebrainz']['user']
end


# Database
include_recipe 'postgresql::server'
include_recipe 'postgresql::contrib'


# Python & its packages
python_runtime 'python' do
  version '2.7'
  options pip_version: true # latest
  options virtualenv_version: true # latest
  options wheel_version: true # latest
end
venv_location = project_home + '/venv'
python_virtualenv venv_location do
  group node['critiquebrainz']['group']
  user node['critiquebrainz']['user']
end
pip_requirements project_home + '/requirements.txt' do
  group node['critiquebrainz']['group']
  user node['critiquebrainz']['user']
end


# Node.js (Less compiler)
include_recipe "nodejs"
nodejs_npm "less"
nodejs_npm "less-plugin-clean-css"


styles_path = 'critiquebrainz/frontend/static/css/'
execute "compile_css" do
  command "lessc --clean-css #{styles_path}main.less > #{styles_path}main.css"
  cwd project_home
  group node['critiquebrainz']['group']
  user node['critiquebrainz']['user']
end
