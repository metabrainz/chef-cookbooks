include_recipe 'firewall::default'

ports = node['critiquebrainz']['open_ports']
firewall_rule "open ports #{ports}" do
  port ports
end
