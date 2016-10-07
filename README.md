# omd-docker
Dockerfile for OMD (Open Monitoring Distribution)

1. Pull image from docker hub:
docker pull hieulq/omd:v1.3

2. Run omd container:
docker run -d -p {port1}:5000 -p {port2}:6556 -p {port3}:22 hieulq/omd:v1.3

port1: expose port for accessing omb Web.
port2: expose port of check_mk_agent.
port3: expose port for SSH server.

3. Access omd Web via: http://YOUR_IP:port1/demo/omd
