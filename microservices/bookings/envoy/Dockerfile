FROM envoyproxy/envoy:latest

COPY service-envoy.yaml /etc/envoy/service-envoy.yaml
CMD /usr/local/bin/envoy -c /etc/envoy/service-envoy.yaml
