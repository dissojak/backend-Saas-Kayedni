package com.bookify.backendbookify_saas.services.impl;

import com.bookify.backendbookify_saas.services.SmsService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

@Service
public class SmsServiceImpl implements SmsService {

    private static final Logger logger = LoggerFactory.getLogger(SmsServiceImpl.class);

    @Override
    public void sendTwoFactorCode(String phoneNumber, String code) {
        String masked = phoneNumber == null || phoneNumber.length() < 4
                ? "unknown"
                : "***" + phoneNumber.substring(Math.max(0, phoneNumber.length() - 4));

        logger.info("SMS 2FA code requested for {}. Code: {}", masked, code);
    }
}
