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
        String os = System.getProperty("os.name").toLowerCase();

        if (os.contains("win") || os.contains("mac")) {
            // 윈도우, 맥 환경 - 윈도우 경로 기준
            String location = "file:" + (uploadRoot.endsWith("/") ? uploadRoot : uploadRoot + "/");
            String pattern  = (urlPrefix.endsWith("/")) ? (urlPrefix + "**") : (urlPrefix + "/**");

            registry.addResourceHandler(pattern)
                    .addResourceLocations(
                            location,
                            "classpath:/static" + urlPrefix
                    );
        } else {
            // 리눅스 환경 - product 경로만 별도 등록
            registry.addResourceHandler("/uploads/product/**")
                    .addResourceLocations("file:/home/ubuntu/uploads/product/");
        }
    }

}
