
# Spring Boot Actuator Micrometer Lab

## Configure your Spring Boot target application

-   Add `Micrometer Prometheus registry` dependency to either
    `pom.xml` or `build.gradle`

    ```
    <dependency>
	    <groupId>io.micrometer</groupId>
	    <artifactId>micrometer-registry-prometheus</artifactId>
    </dependency>
    ```
    
    ```
    compile 'io.micrometer:micrometer-registry-prometheus'
    ```
    
-   If your endpoints are secured, give access permission 
    to the `actuator/prometheus` endpoint 

    ```
    http.authorizeRequests()
             .requestMatchers(EndpointRequest.to("health", "info", "prometheus")).permitAll()
             .requestMatchers(EndpointRequest.to("conditions")).hasRole("ADMIN")
             .requestMatchers(EndpointRequest.toAnyEndpoint()).hasRole("ACTUATOR")
             .anyRequest().authenticated()
             .and()
        .httpBasic();
    ```

-   Run your target Spring Boot application
-   Access [http://localhost:8080/actuator/prometheus](http://localhost:8080/actuator/prometheus) and observe
    that metrics data is now visible in the format
    Prometheus expects
 

## Download, configure, and run Prometheus server (If Docker option above is not working for you)

-   Download Prometheus from [Prometheus website](https://prometheus.io/download/) 
-   Unzip it as following

    ```
    tar xvfz prometheus-*.tar.gz
    cd prometheus-<version>-<arch>
    ```

-   Configure `prometheus.yml` assuming  
    your target application is running on port `8080` and
    actuator base path is the default `actuator`

    ```
    ...
    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.
    metrics_path: /actuator/prometheus
    static_configs:
    - targets: ['localhost:8080']
    ```

-   Run Prometheus server

    ```
    ./prometheus --config.file=prometheus.yml
    ```

## Generate some traffic to the appliation

-   Using a tool such as [ApacheBench](https://httpd.apache.org/docs/2.4/programs/ab.html), access your target application

    ```
    ab -n 1000000 http://localhost:8080/actuator
    ```
    
    ```
    ab -n 1000000 -A admin:admin http://localhost:8080/accounts
    ```
    
    ```
    ab -n 1000000 -A admin:admin http://localhost:8080/accounts/1
    ```

## Access Prometheus UI

-   Using your browser, go to [http://localhost:9090](http://localhost:9090)
-   Select metic you want to monitor from 
    `- insert metric at cursor -` drop-down menu, 
    for example, `http_server_requests_seconds_count` 
    and click `Execute` button
-   Click `Graph` tab and observe that graph represents 
    the traffic
-   Add another query with `account_fetch_total`

## Run Prometheus and Grafana as Docker apps

-   Run scripts/prometheus/prometheus.sh ro run Prometheus
-   Run scripts/prometheus/grafana.sh to run Grafana
-   Access Grafana app via http://localhost:3030
-   Use admin/admin as credentials

## References

-   [Getting started with Prometheus](https://prometheus.io/docs/prometheus/latest/getting_started/)
-   [Using Micrometer with Spring Boot 2](https://dzone.com/articles/using-micrometer-with-spring-boot-2) 

# Grafana

```
rate(account_fetch_total{type="fromCode"}[1m])
```

```
sum(rate(http_server_requests_seconds_bucket{le=~"0\\.[0-4]\\d+|\\+Inf"}[1m])) by (le)
```

```
jvmgc-dashboard.json:          "expr": "avg(jvm_memory_used_bytes) by (instance, id)",
jvmgc-dashboard.json:          "expr": "jvm_gc_live_data_size_bytes",
jvmgc-dashboard.json:          "expr": "jvm_gc_max_data_size_bytes",
jvmgc-dashboard.json:          "expr": "jvm_gc_live_data_size_bytes/jvm_gc_max_data_size_bytes",
jvmgc-dashboard.json:          "expr": "rate(jvm_gc_memory_allocated_bytes_total[1m])",
jvmgc-dashboard.json:          "expr": "rate(jvm_gc_memory_promoted_bytes_total[1m])",
jvmgc-dashboard.json:          "expr": "avg(rate(jvm_gc_pause_seconds_sum[1m])) by (cause)",
jvmgc-dashboard.json:          "expr": "sum(rate(jvm_gc_pause_seconds_sum[1m])/rate(jvm_gc_pause_seconds_count[1m])) by (action)",
jvmgc-dashboard.json:          "expr": "max(jvm_gc_pause_seconds_max) by (cause)",
jvmgc-dashboard.json:          "expr": "jvm_gc_live_data_size_bytes",
jvmgc-dashboard.json:          "expr": "jvm_gc_max_data_size_bytes",
jvmgc-dashboard.json:          "expr": "jvm_gc_live_data_size_bytes / jvm_gc_max_data_size_bytes",
latency-dashboard.json:          "expr": "sum(rate(http_server_requests_seconds_count[1m]))by (uri,method)",
latency-dashboard.json:          "expr": "holt_winters(instance:http_server_requests_seconds_count:rate1m[1m], 0.5, 0.2) * 0.7",
latency-dashboard.json:          "expr": "sum(rate(http_server_requests_seconds_count[1m])) by (instance)",
latency-dashboard.json:          "expr": "(sum(rate(http_server_requests_seconds_count[1m])) by (instance)) - (holt_winters(instance:http_server_requests_seconds_count:rate1m[1m], 0.5, 0.2) * 0.7)",
latency-dashboard.json:          "expr": "sum(rate(http_server_requests_seconds_bucket{le=~\"0\\\\.[0-4]\\\\d+|\\\\+Inf\"}[1m])) by (le)",
latency-dashboard.json:          "expr": "max(http_server_requests_seconds_max) by (uri,method,instance)",
latency-dashboard.json:          "expr": "histogram_quantile(0.99, rate(http_server_requests_seconds_bucket[1m]))",
processor-dashboard.json:          "expr": "system_cpu_usage",
```