group node['critiquebrainz']['group']

user node['critiquebrainz']['user'] do
  group node['critiquebrainz']['group']
  home node['critiquebrainz']['home']
  supports :manage_home => true
  shell '/bin/bash'
end
