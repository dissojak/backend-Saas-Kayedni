package com.bookify.backendbookify_saas.services;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.warrenstrange.googleauth.GoogleAuthenticator;
import com.warrenstrange.googleauth.GoogleAuthenticatorKey;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.Hashtable;
import java.util.Objects;
import javax.imageio.ImageIO;
import org.springframework.stereotype.Service;

@Service
public class TwoFactorAuthService {

    private static final String ISSUER = "Kayedni";
    private static final int QR_SIZE = 320;
    private final GoogleAuthenticator googleAuthenticator = new GoogleAuthenticator();

    public GoogleAuthenticatorKey createCredentials() {
        return googleAuthenticator.createCredentials();
    }

    public boolean verifyCode(String secret, String code) {
        if (secret == null || secret.isBlank() || code == null || code.isBlank()) {
            return false;
        }

        try {
            int parsedCode = Integer.parseInt(code.trim());
            return googleAuthenticator.authorize(secret, parsedCode);
        } catch (NumberFormatException ex) {
            return false;
        }
    }

    public String buildOtpAuthUri(String accountName, String secret) {
        String normalizedAccountName = Objects.requireNonNullElse(accountName, "user");
        String label = URLEncoder.encode(ISSUER + ":" + normalizedAccountName, StandardCharsets.UTF_8);
        String issuer = URLEncoder.encode(ISSUER, StandardCharsets.UTF_8);
        return "otpauth://totp/" + label + "?secret=" + secret + "&issuer=" + issuer;
    }

    public String buildQrCodeDataUrl(String content) {
        try {
            BitMatrix matrix = new MultiFormatWriter().encode(
                    content,
                    BarcodeFormat.QR_CODE,
                    QR_SIZE,
                    QR_SIZE,
                    new Hashtable<>()
            );

            BufferedImage image = MatrixToImageWriter.toBufferedImage(matrix);
            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
            ImageIO.write(image, "png", outputStream);
            return "data:image/png;base64," + Base64.getEncoder().encodeToString(outputStream.toByteArray());
        } catch (Exception ex) {
            throw new IllegalStateException("Unable to generate 2FA QR code", ex);
        }
    }
}