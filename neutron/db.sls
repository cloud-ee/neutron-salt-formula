{% set name="neutron" %}

{{ name }}-db:
{% if salt["pillar.get"](name+ ":db:driver") == 'postgresql' %}
  pkg.installed:
    - name: python-psycopg2
  postgres_user.present:
    - name: {{ name }}
    - password: {{ salt["pillar.get"](name + ":db:password") }}
  postgres_database.present:
    - name: {{ name }}
    - owner: {{ name }}
{% else %}
  mysql_database.present:
    - name: {{ name }}
  mysql_user.present:
    - name: {{ name }}
    - host: "{{ salt["pillar.get"](name + ":mysql:host","localhost") }}"
    - password: {{ salt["pillar.get"](name + ":mysql:password") }}
  mysql_grants.present:
    - host: "{{ salt["pillar.get"](name + ":mysql:host","localhost") }}"
    - grant: all privileges
    - database: "{{ name }}.*"
    - user: {{ name }}
{% endif %}
