{%- from "neutron/map.jinja" import neutron with context %}

neutron-common:
  pkg.installed:
    - pkgs:
      - neutron-common
      - neutron-plugin-ml2

{% for file in ['neutron.conf', 'api-paste.ini'] %}
/etc/neutron/{{ file }}:
  file.managed:
    - source: salt://neutron/files/{{ file }}
    - template: jinja
    - owner: root
    - group: root
    - mode: 0644
    - require:
      - pkg: neutron-common
{% endfor %}

/etc/neutron/plugins/ml2/ml2_conf.ini:
  file.managed:
    - source: salt://neutron/files/ml2_conf.ini
    - template: jinja
    - owner: root
    - group: root
    - mode: 0644
    - require:
      - pkg: neutron-common

