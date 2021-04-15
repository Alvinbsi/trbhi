TASK2:

1. Run docker_install.sh file
	* It is used to install docker and docker-compose on ubuntu server
	* The default operating system limits on mmap counts is likely to be too low, which may result in out of memory exceptions. On Linux, you can increase the limits by running the following command as root:
		'sysctl -w vm.max_map_count=262144' but this I already mentioned in that script file(docker_install.sh).

2. Run docker compose file using below command
	* docker compose up
	* This Docker Compose file brings up a two-nodes Elasticsearch cluster & kibana.
	* kibana is the default choice for visualizing data stored in Elasticsearch

3. Execute below command to check the Health check
	curl <ip>:9200/_cat/health