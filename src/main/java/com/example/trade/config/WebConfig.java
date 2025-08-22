// com.example.trade.config.WebConfig.java
package com.example.trade.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Value("${app.upload.root}")
    private String uploadRoot;

    @Value("${app.upload.url-prefix}")
    private String urlPrefix;

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 윈도우/맥/리눅스 모두 지원 (file: 절대경로)
        String location = "file:" + (uploadRoot.endsWith("/") ? uploadRoot : uploadRoot + "/");
        String pattern  = (urlPrefix.endsWith("/")) ? (urlPrefix + "**") : (urlPrefix + "/**");

        registry.addResourceHandler(pattern)
                .addResourceLocations(location);
    }
}
