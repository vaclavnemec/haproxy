FROM haproxy:1.6.3

RUN mkdir /home/haproxy

WORKDIR /home/haproxy

ADD generateConfig.sh /home/haproxy/

RUN chmod +x /home/haproxy/generateConfig.sh

EXPOSE 8080

CMD /home/haproxy/generateConfig.sh > /home/haproxy/haproxy.cfg && haproxy -f /home/haproxy/haproxy.cfg
