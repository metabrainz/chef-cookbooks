include_recipe 'apt::default'
include_recipe 'critiquebrainz::install'
include_recipe 'nginx::source'
include_recipe 'critiquebrainz::firewall'
