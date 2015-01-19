{%- from "neutron/map.jinja" import neutron with context %}

{{ neutron.name }}:
  pkg.installed:
    - refresh: False
    - pkgs: {{ neutron.pkg }}
  service.running:
    - names: {{ neutron.service }}
    - enable: True
    - require:
      - pkg: {{ neutron.name }}

/etc/neutron/neutron.conf:
  file.managed:
    - source: salt://neutron/files/neutron.conf
    - template: jinja

/etc/neutron/api-paste.ini:
  file.managed:
    - source: salt://neutron/files/api-paste.ini
    - template: jinja

/etc/neutron/l3_agent.ini:
  file.managed:
    - source: salt://neutron/files/l3_agent.ini
    - template: jinja

/etc/neutron/plugins/ml2/ml2_conf.ini:
  file.managed:
    - source: salt://neutron/files/ml2.conf
    - template: jinja
