include:
  - .db
  - .keystone

neutron:
  pkg.installed:
    - pkgs:
      - neutron-server
      - python-neutronclient

neutron-server:
  service.running:
    - enable: True
    - watch:
      - file: /etc/neutron/neutron.conf

