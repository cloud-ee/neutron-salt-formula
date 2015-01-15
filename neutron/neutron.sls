{%- from "neutron/map.jinja" import nova with context %}

include:
  - .base
  - .conf

nova-compute:
  pkg.installed:
    - refresh: False
    - pkgs: {{ neutron.compute_pkgs }}
    - require_in:
      - file: /etc/neutron/neutron.conf
  service.running:
    - enable: True
    - restart: True
    - names: {{ nova.compute_services }}
    - require:
      - pkg: nova-compute
      - file: /etc/neutron/neutron.conf
    - watch:
      - file: /etc/neutron/neutron.conf
