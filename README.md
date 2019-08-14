
## Spring Boot Actuator Micrometer Lab

### Configure your Spring Boot target application

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
         .requestMatchers(EndpointRequest.to("prometheus")).permitAll()
         .anyRequest().authenticated()
         .and()
    .httpBasic();
    ```

-   Run your target Spring Boot application
-   Access [http://localhost:8080/actuator/prometheus](http://localhost:8080/actuator/prometheus) and observe
    that metrics data is now visible in the format
    Prometheus expects
 

### Download, configure, and run Prometheus server (If Docker option above is not working for you)

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

### Generate some traffic to the appliation

-   Using a tool such as [ApacheBench](https://httpd.apache.org/docs/2.4/programs/ab.html), access your target application

    ```
    ab -n 1000000 http://localhost:8080/actuator
    ```

### Access Prometheus UI

-   Using your browser, go to [http://localhost:9090](http://localhost:9090)
-   Select metic you want to monitor from 
    `- insert metric at cursor -` drop-down menu, 
    for example, `http_server_requests_seconds_count` 
    and click `Execute` button
-   Click `Graph` tab and observe that graph represents 
    the traffic

### References

-   [Getting started with Prometheus](https://prometheus.io/docs/prometheus/latest/getting_started/)
-   [Using Micrometer with Spring Boot 2](https://dzone.com/articles/using-micrometer-with-spring-boot-2) 