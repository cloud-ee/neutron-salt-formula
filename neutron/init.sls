{%- from "neutron/map.jinja" import neutron with context %}

include:
  - .db
  - .keystone

neutron:
  pkg.installed:
    - pkgs:
      - neutron-server
      - neutron-plugin-ml2 
      - python-neutronclient
      - neutron-plugin-openvswitch-agent
      - neutron-dhcp-agent
      - neutron-l3-agent

/etc/neutron/neutron.conf:
  file.managed:
    - source: salt://neutron/files/neutron.conf
    - template: jinja

/etc/neutron/api-paste.ini:
  file.managed:
    - source: salt://neutron/files/api-paste.ini
    - template: jinja


/etc/neutron/plugins/ml2/ml2_conf.ini:
  file.managed:
    - source: salt://neutron/files/ml2.conf
    - template: jinja
