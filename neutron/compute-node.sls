neutron:
  pkg.installed:
    - pkgs:
      - openvswitch-switch
      - neutron-plugin-openvswitch-agent

neutron-plugin-openvswitch-agent:
  service.running:
    - watch:
      - file: /etc/neutron/neutron.conf

