
## Spring Boot Actuator Micrometer Lab

### Configure your Spring Boot target application

-   Add `Micrometer Prometheus registry` dependency 

```
		<dependency>
			<groupId>io.micrometer</groupId>
			<artifactId>micrometer-registry-prometheus</artifactId>
		</dependency>
```

-   Add the following the the `application.properties` file

```
endpoints.prometheus.enabled=true
```

-   Run your target Spring Boot application

### Download, configure, and run Prometheus server

-   Download Prometheus from [Prometheus website](https://prometheus.io/download/) 
-   Unzip it as following

```
tar xvfz prometheus-*.tar.gz
cd prometheus-*
```

-   Configure `prometheus.yml` assuming you are running 
    your target application is rinning on port `8080` and
    actuator base path is `actuator`

```
    ...
    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.
    metrics_path: /actuator/prometheus
    static_configs:
    - targets: ['localhost:8080']
```

-   Run Prometheus

```
./prometheus --config.file=prometheus.yml
```

### Generate some traffic to the appliation

-   Using a tool such as [ApacheBench](https://httpd.apache.org/docs/2.4/programs/ab.html), access your target application

```
ab -n 1000000 http://localhost:8080/actuator
```

### Access Prometheus UI

-   Using your browser, go to [http://localhost:9090](http://localhost:9090)
-   Select metic you want to monitor from `- insert metric at curos -` drop-down menu, for example, `http_server_requests_sessions_count` and click `Execute` button
-   Click `Graph` tab and observe that graph represents the traffic

### References

-   [Getting started with Prometheus](https://prometheus.io/docs/prometheus/latest/getting_started/)
-   [Using Micrometer with Spring Boot 2](https://dzone.com/articles/using-micrometer-with-spring-boot-2) 