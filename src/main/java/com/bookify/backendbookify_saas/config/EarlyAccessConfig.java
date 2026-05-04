package com.bookify.backendbookify_saas.config;

import lombok.Getter;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
@Getter
public class EarlyAccessConfig {

    @Value("${app.early-access.enabled:false}")
    private boolean enabled;

    @Value("${app.early-access.admin-email:}")
    private String adminEmail;

    @Value("${app.early-access.invite-token-expiry-days:30}")
    private int inviteTokenExpiryDays;

    @Value("${app.early-access.invite-token-default-batch:100}")
    private int inviteTokenDefaultBatch;

}
