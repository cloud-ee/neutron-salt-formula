neutron-network-node:
  pkg.installed:
    - pkgs:
      - openvswitch-switch
      - neutron-plugin-openvswitch-agent
      - neutron-l3-agent
      - neutron-dhcp-agent
      - neutron-metadata-agent

/etc/network/interfaces:
  file.append:
    - text: source /etc/network/interfaces.d/*.cfg

# generate neurton network interface configuration file
/etc/network/interfaces.d/neutron.cfg:
  file.managed:
    - source: salt://neutron/files/debian-interface.cfg
    - template: jinja
    - owner: root
    - group: root
    - mode: 0644
    - defaults:
      networks: {{ salt['pillar.get']('neutron:plugin:ml2:networks', '{}') }}
    - require:
      - pkg: neutron-network-node
      - file: /etc/network/interfaces

# make sure integration bridge is up and running
br-int:
  cmd.wait:
    - name: ifup --allow=ovs br-int
    - watch:
       - file: /etc/network/interfaces.d/neutron.cfg

# make sure physical network interfaces are up
{% for net in salt['pillar.get']('neutron:plugin:ml2:networks', {}) %}
ifup_br-{{ net.port }}:
  cmd.wait:
    - name: ifup --allow=ovs {{ net.port }}
    - name: ifup --allow=ovs br-{{ net.port }}
    - watch: 
       - file: /etc/network/interfaces.d/neutron.cfg
{% endfor %}

{% for file in ['dhcp_agent.ini', 'l3_agent.ini', 'metadata_agent.ini'] %}
/etc/neutron/{{ file }}:
  file.managed:
    - source: salt://neutron/files/{{ file }}
    - owner: root
    - group: root
    - mode: 0644
    - template: jinja
{% endfor %}

{% for service in ['neutron-plugin-openvswitch-agent', 
                   'neutron-l3-agent', 
                   'neutron-dhcp-agent', 
                   'neutron-metadata-agent'] %}
{{service}}:
  service.running:
    - enable: True
    - watch:
      - file: /etc/neutron/neutron.conf
      - file: /etc/neutron/plugins/ml2/ml2_conf.ini
      - file: /etc/neutron/dhcp_agent.ini
      - file: /etc/neutron/l3_agent.ini
      - file: /etc/neutron/metadata_agent.ini
    - require:
      - pkg: neutron-network-node

{% endfor %}
