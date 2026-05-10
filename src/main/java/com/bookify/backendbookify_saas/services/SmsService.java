package com.bookify.backendbookify_saas.services;

public interface SmsService {

    void sendTwoFactorCode(String phoneNumber, String code);
}
